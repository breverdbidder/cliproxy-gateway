# CLAUDE CODE HANDOFF: CLIProxyAPI Consumer Wiring

## Context
CLIProxyAPI gateway is LIVE on Hetzner (87.99.129.125:8317, localhost only).
3 Gemini API keys + 1 DeepSeek V3.2 routing through single OpenAI-compatible endpoint.
Gateway key in /opt/cliproxy-gateway/.env.generated on server.

## Task 1: cli-anything-biddeed
Repo: breverdbidder/cli-anything-biddeed

### What to do:
1. In any harness that calls Gemini (e.g., cli_anything_zonewise.py, cli_anything_spatial.py):
   - Add SSH tunnel setup at harness init if CLIPROXY_BASE_URL is set
   - Route Gemini calls through gateway instead of direct API
   - Fallback: if tunnel fails, use direct Gemini API key as before

2. Update HARNESS.md Phase 2 (Configuration) to document gateway option:
   ```
   # Optional: Route through CLIProxyAPI gateway (Hetzner)
   CLIPROXY_BASE_URL=http://127.0.0.1:8317/v1
   CLIPROXY_API_KEY=<from cliproxy-gateway .env.generated>
   ```

3. Config already pushed: config/cliproxy.env.template
4. SSH tunnel action already pushed: .github/actions/cliproxy-tunnel/action.yml

### Integration pattern (Python):
```python
import os, openai

base_url = os.getenv("CLIPROXY_BASE_URL", "https://generativelanguage.googleapis.com/v1beta")
api_key = os.getenv("CLIPROXY_API_KEY", os.getenv("GEMINI_API_KEY"))

client = openai.OpenAI(base_url=base_url, api_key=api_key)
response = client.chat.completions.create(
    model="gemini-2.5-flash",  # or "deepseek-v3"
    messages=[{"role": "user", "content": prompt}]
)
```

## Task 2: zonewise-scraper-v4
Repo: breverdbidder/zonewise-scraper-v4

### What to do:
1. In the Firecrawl→Gemini→Claude waterfall, update Gemini step:
   - Check for CLIPROXY_BASE_URL env var
   - If set, route through gateway (gets round-robin across 3 keys)
   - If not set, use direct GEMINI_API_KEY as before

2. Config already pushed: config/cliproxy.env.template
3. Secrets already set: CLIPROXY_BASE_URL, CLIPROXY_API_KEY, HETZNER_IP, HETZNER_SSH_KEY, HETZNER_PASSWORD

### GHA workflow update:
Add SSH tunnel step before scraper run:
```yaml
- name: Open gateway tunnel
  run: |
    mkdir -p ~/.ssh
    echo "${{ secrets.HETZNER_SSH_KEY }}" > ~/.ssh/hetzner
    chmod 600 ~/.ssh/hetzner
    sshpass -p "${{ secrets.HETZNER_PASSWORD }}" ssh -fNL 8317:127.0.0.1:8317 \
      -o StrictHostKeyChecking=no root@${{ secrets.HETZNER_IP }} || true
  env:
    CLIPROXY_BASE_URL: http://127.0.0.1:8317/v1
    CLIPROXY_API_KEY: ${{ secrets.CLIPROXY_API_KEY }}
```

## Task 3: LangGraph agents
Any GHA workflow using LangGraph that needs Gemini/DeepSeek:
- Add the same SSH tunnel step above
- Set OPENAI_API_BASE and OPENAI_API_KEY env vars
- Models available: gemini-2.5-pro, gemini-2.5-flash, deepseek-v3, deepseek-r1

## CRITICAL RULES
- NO CLAUDE TOKENS through gateway. Ever.
- Claude stays on Max plan official CLI.
- Gateway is localhost:8317 only — always needs SSH tunnel from GHA runners.
- If tunnel fails, fall back to direct API keys.
