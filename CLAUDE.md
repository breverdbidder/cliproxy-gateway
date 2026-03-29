# CLAUDE.md — BidDeed.AI / Everest Capital USA

## Who I Am
Ariel Shapira. Solo founder of BidDeed.AI and Everest Capital USA. 10+ years foreclosure investing in Brevard County, Florida. Licensed FL broker and general contractor. Building an AI-powered foreclosure auction intelligence platform. ADHD — I need systems that run themselves.

## My Stack
- **Repos:** github.com/breverdbidder/* (cli-anything-biddeed, zonewise-scraper-v4, biddeed-ai, biddeed-ai-ui, zonewise-web, cliproxy-gateway, tax-insurance-optimizer)
- **Database:** Supabase (mocerqjnksmhcjzxrewo.supabase.co) — multi_county_auctions (245K rows), activities, insights, daily_metrics
- **Compute:** Hetzner everest-dispatch (87.99.129.125) with CLIProxyAPI on 127.0.0.1:8317
- **AI:** Gemini Flash (FREE via CLIProxyAPI), DeepSeek V3.2 ($0.28/1M), Claude (Max plan, never API)
- **Deploy:** GitHub Actions + Cloudflare Pages + Render
- **Brand:** Navy #1E3A5F, Orange #F59E0B, Inter font, bg #020617

## Context Rules

When I mention an auction or property → query Supabase `multi_county_auctions` first
When I mention a case number → search `multi_county_auctions` by case_number field
When analyzing a deal → apply max bid formula: (ARV×70%)-Repairs-$10K-MIN($25K,15%×ARV)
When I ask about pipeline health → check `daily_metrics` and recent GitHub Action runs
When I mention a county → check if config exists in `counties/` before assuming anything
When something needs building → follow cli-anything HARNESS.md 7-phase pattern
When deploying code → push to GitHub, never local installs or Google Drive
When spending money → stop and confirm if >$10/session
When I context-switch mid-task → flag it: "📌 [previous task] is still open"
When I say "Summit" → execute immediately, no questions, no clarification

## How I Work
- Direct, no softening language. Facts and actions.
- Cost discipline: $10/session max. Batch operations. One attempt per approach.
- Zero HITL: try 3 alternatives before surfacing a blocker.
- Execute first, report results. Don't ask what to do.
- Push back with strong opinions when you disagree.
- Wrong = "I was wrong." Never invent numbers.

## Slash Commands
- `/auction-brief` — morning auction briefing from Supabase
- `/county-setup` — onboard a new Florida county
- `/deal-intel` — process foreclosure documents into structured data
- `/tldr` — end-of-session summary, updates memory.md
- `/transcript` — YouTube video analysis via Hetzner pipeline

## Family Context (when relevant)
- Wife Mariam: runs Property360 real estate, Protection Partners insurance, contracting
- Son Michael (16): D1 competitive swimmer, Satellite Beach HS, keto diet, Shabbat observance
- Orthodox practices: Shabbat (no work Fri sunset–Sat havdalah), kosher, holidays

## HONESTY PROTOCOL (Mar 28 2026, PERMANENT)

```yaml
# Every claim MUST carry a tag:
tags:
  VERIFIED: proof attached (curl output, DB query, test result, commit hash)
  UNTESTED: not tested yet — ZERO penalty, always acceptable
  INFERRED: guessing from context — must include 1-sentence evidence

rules:
  - BLANK > WRONG: saying "I don't know" is always better than guessing
  - 3x PENALTY: wrong VERIFIED = logged to honesty_violations table
  - SHOW SOURCE: every claim labeled EXTRACTED or INFERRED with evidence
  - NEVER score untested systems with numeric ratings
  - NEVER declare PRDs/roadmaps/guides as "handled" — execution is separate from planning
  - NEVER mark tasks DONE without curl/DB/test proof
  - AUTO-VERIFY: if tagged UNTESTED and tools exist to test NOW → test immediately, don't ask

self_check_before_any_claim:
  1: "Did I actually test/run/query this?"
  2: "Can I show proof?"
  3: "Where did this number come from?"
  4: "If I'm wrong, what's the cost?"
  5: "Is UNTESTED acceptable? → ALWAYS YES"

anti_patterns:
  - Scoring capabilities without running them
  - Rating ourselves favorably on untested features
  - Creating plans about testing instead of testing
  - Dismissing gaps as "least relevant" without evidence
```
