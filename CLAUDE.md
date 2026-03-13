# CLAUDE.md — CLIProxy Gateway

## Purpose
Unified OpenAI-compatible API gateway on Hetzner for BidDeed.AI agents.
Routes Gemini (FREE) + DeepSeek (ULTRA_CHEAP) + future providers through single endpoint.

## Architecture
- CLIProxyAPI v6.8.37 running in Docker on Hetzner (everest-dispatch, 87.99.129.125)
- Bound to localhost:8317 ONLY — access via SSH tunnel
- Consumers: cli-anything harnesses, ZoneWise Scraper V4, LangGraph agents

## CRITICAL RULES
- **NO CLAUDE TOKENS** — Claude stays on Max plan official CLI
- Config changes: edit config.yaml → docker compose restart
- New providers: add to openai-compatibility section → hot-reload
- Secrets in /opt/cliproxy-gateway/.env.generated (chmod 600)

## Deployment
- Push to main → GitHub Actions auto-deploys via SSH
- Manual: ssh root@87.99.129.125 "cd /opt/cliproxy-gateway && git pull && docker compose up -d"

## Monitoring
- Health: curl http://127.0.0.1:8317/v1/models -H "Authorization: Bearer $KEY"
- Logs: docker logs biddeed-cliproxy --tail 50
- Restart: docker compose restart
