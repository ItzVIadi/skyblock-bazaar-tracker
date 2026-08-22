# SkyBlock Bazaar Tracker

## Commands
```
pip install -r requirements.txt
python bazaar_tracker.py
```
No API key needed — uses Hypixel's public `/v2/skyblock/bazaar` endpoint only.

## Architecture
Single script (`bazaar_tracker.py`): fetches all Bazaar products, filters/scores each by
`spread_percent()`, then prints the top `TOP_N` by instant buy/sell spread %. No tests, no
config files, no other modules.

## Gotchas
- Ranks by `quick_status.buyPrice`/`sellPrice` (Hypixel's volume-weighted averages), not the
  raw `buy_summary`/`sell_summary` top-of-book entries — those can be dominated by a single
  stale 1-unit leftover order.
- Filters out low-liquidity noise via `MIN_WEEKLY_VOLUME` (1000) and `MIN_ACTIVE_ORDERS` (5);
  also caps spreads at `MAX_REASONABLE_SPREAD` (500%) to drop unrealistic outliers (e.g. dumped
  enchant books) that would otherwise dominate the ranking.
- No API key or auth required — do not add Hypixel API key handling despite the parent folder name.
