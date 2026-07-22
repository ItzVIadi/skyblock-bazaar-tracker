"""Prints the top Hypixel SkyBlock Bazaar items by instant buy/sell spread.

Uses only Hypixel's public Bazaar endpoint (https://api.hypixel.net/v2/skyblock/bazaar),
which requires no API key.
"""

import requests

BAZAAR_URL = "https://api.hypixel.net/v2/skyblock/bazaar"
TOP_N = 15
MIN_WEEKLY_VOLUME = 1000  # filters out barely-traded items with meaningless spreads
MIN_ACTIVE_ORDERS = 5  # a lone leftover order at a stale price can otherwise skew the average
MAX_REASONABLE_SPREAD = 500  # some items (e.g. dumped enchant books) show a real but uncapturable spread


def fetch_products() -> dict:
    response = requests.get(BAZAAR_URL, timeout=15)
    response.raise_for_status()
    data = response.json()
    if not data.get("success"):
        raise RuntimeError(f"Hypixel API reported failure: {data.get('cause', 'unknown')}")
    return data["products"]


def spread_percent(product: dict) -> float | None:
    quick_status = product.get("quick_status") or {}
    if quick_status.get("buyMovingWeek", 0) < MIN_WEEKLY_VOLUME:
        return None
    if quick_status.get("sellMovingWeek", 0) < MIN_WEEKLY_VOLUME:
        return None
    if quick_status.get("buyOrders", 0) < MIN_ACTIVE_ORDERS:
        return None
    if quick_status.get("sellOrders", 0) < MIN_ACTIVE_ORDERS:
        return None

    # buyPrice/sellPrice are Hypixel's own volume-weighted average prices, unlike
    # the raw top-of-book buy_summary/sell_summary entries -- those can be a
    # single 1-unit leftover order sitting at a wildly stale price, which would
    # otherwise dominate the ranking despite the item trading normally overall.
    instant_buy_price = quick_status.get("buyPrice", 0)
    instant_sell_price = quick_status.get("sellPrice", 0)
    if instant_sell_price <= 0:
        return None
    spread = (instant_buy_price - instant_sell_price) / instant_sell_price * 100

    # A few items (e.g. players dumping excess max-tier enchant books as
    # near-worthless sell offers) show a real but practically uncapturable
    # spread that would dominate and skew the ranking -- not worth showing.
    if spread > MAX_REASONABLE_SPREAD:
        return None
    return spread


def main() -> None:
    products = fetch_products()
    ranked = []
    for product_id, product in products.items():
        spread = spread_percent(product)
        if spread is not None:
            ranked.append((product_id, spread))

    ranked.sort(key=lambda item: item[1], reverse=True)

    print(f"Top {TOP_N} SkyBlock Bazaar items by instant buy/sell spread:\n")
    for product_id, spread in ranked[:TOP_N]:
        print(f"{product_id:35s} {spread:6.2f}%")


if __name__ == "__main__":
    main()
