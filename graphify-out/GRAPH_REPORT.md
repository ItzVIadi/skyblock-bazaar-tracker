# Graph Report - skyblock-bazaar-tracker für API Key  (2026-08-30)

## Corpus Check
- Corpus is ~563 words - fits in a single context window. You may not need a graph.

## Summary
- 13 nodes · 16 edges · 4 communities (2 shown, 2 thin omitted)
- Extraction: 75% EXTRACTED · 25% INFERRED · 0% AMBIGUOUS · INFERRED: 4 edges (avg confidence: 0.9)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Bazaar Fetch & CLI Entry
- Spread Scoring & Filters
- Public API / No-Auth Constraint
- Flip-Spread Ranking Concept

## God Nodes (most connected - your core abstractions)
1. `spread_percent()` - 6 edges
2. `fetch_products()` - 4 edges
3. `main()` - 4 edges
4. `Bazaar flip buy/sell spread ranking` - 3 edges
5. `SkyBlock Bazaar Tracker (tool)` - 2 edges
6. `Hypixel public /v2/skyblock/bazaar endpoint (no API key)` - 2 edges
7. `Prints the top Hypixel SkyBlock Bazaar items by instant buy/sell spread. Uses…` - 1 edges
8. `Volume-weighted buyPrice/sellPrice basis (not raw top-of-book)` - 1 edges
9. `Low-liquidity noise filter (MIN_WEEKLY_VOLUME / MIN_ACTIVE_ORDERS)` - 1 edges
10. `MAX_REASONABLE_SPREAD outlier cap (dumped enchant books)` - 1 edges

## Surprising Connections (you probably didn't know these)
- `Hypixel public /v2/skyblock/bazaar endpoint (no API key)` --conceptually_related_to--> `fetch_products()`  [INFERRED]
  README.md → bazaar_tracker.py
- `Bazaar flip buy/sell spread ranking` --conceptually_related_to--> `spread_percent()`  [INFERRED]
  README.md → bazaar_tracker.py
- `Bazaar flip buy/sell spread ranking` --conceptually_related_to--> `main()`  [INFERRED]
  README.md → bazaar_tracker.py
- `requests (HTTP dependency)` --shares_data_with--> `fetch_products()`  [INFERRED]
  requirements.txt → bazaar_tracker.py
- `Low-liquidity noise filter (MIN_WEEKLY_VOLUME / MIN_ACTIVE_ORDERS)` --rationale_for--> `spread_percent()`  [EXTRACTED]
  CLAUDE.md → bazaar_tracker.py

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Spread-scoring liquidity/outlier filters** — claude_low_liquidity_noise_filter, claude_max_reasonable_spread_cap, claude_volume_weighted_price_basis, bazaar_tracker_spread_percent [EXTRACTED 0.80]

## Communities (4 total, 2 thin omitted)

### Community 0 - "Bazaar Fetch & CLI Entry"
Cohesion: 0.50
Nodes (4): fetch_products(), main(), Prints the top Hypixel SkyBlock Bazaar items by instant buy/sell spread. Uses…, requests (HTTP dependency)

### Community 1 - "Spread Scoring & Filters"
Cohesion: 0.50
Nodes (4): spread_percent(), Low-liquidity noise filter (MIN_WEEKLY_VOLUME / MIN_ACTIVE_ORDERS), MAX_REASONABLE_SPREAD outlier cap (dumped enchant books), Volume-weighted buyPrice/sellPrice basis (not raw top-of-book)

## Knowledge Gaps
- **3 isolated node(s):** `Low-liquidity noise filter (MIN_WEEKLY_VOLUME / MIN_ACTIVE_ORDERS)`, `MAX_REASONABLE_SPREAD outlier cap (dumped enchant books)`, `requests (HTTP dependency)`
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `spread_percent()` connect `Spread Scoring & Filters` to `Bazaar Fetch & CLI Entry`, `Flip-Spread Ranking Concept`?**
  _High betweenness centrality (0.465) - this node is a cross-community bridge._
- **Why does `fetch_products()` connect `Bazaar Fetch & CLI Entry` to `Public API / No-Auth Constraint`?**
  _High betweenness centrality (0.439) - this node is a cross-community bridge._
- **Why does `main()` connect `Bazaar Fetch & CLI Entry` to `Spread Scoring & Filters`, `Flip-Spread Ranking Concept`?**
  _High betweenness centrality (0.192) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `fetch_products()` (e.g. with `Hypixel public /v2/skyblock/bazaar endpoint (no API key)` and `requests (HTTP dependency)`) actually correct?**
  _`fetch_products()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `Bazaar flip buy/sell spread ranking` (e.g. with `main()` and `spread_percent()`) actually correct?**
  _`Bazaar flip buy/sell spread ranking` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Low-liquidity noise filter (MIN_WEEKLY_VOLUME / MIN_ACTIVE_ORDERS)`, `MAX_REASONABLE_SPREAD outlier cap (dumped enchant books)`, `requests (HTTP dependency)` to the rest of the system?**
  _3 weakly-connected nodes found - possible documentation gaps or missing edges._