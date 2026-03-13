# TODO — CLIProxy Gateway

## Setup ✅ COMPLETE
- [x] Create repo breverdbidder/cliproxy-gateway
- [x] Hardened Dockerfile (non-root, EST, health check)
- [x] docker-compose.yml with security (read-only, no-new-privileges)
- [x] Config template with Gemini + DeepSeek providers
- [x] GitHub Actions deploy workflow (SSH + password dual auth)
- [x] GitHub Actions weekly health check (Sundays 9AM EST)
- [x] GitHub Actions initial setup workflow
- [x] GitHub secrets (HETZNER_IP, SSH_KEY, PASSWORD, API_TOKEN, CLIPROXY_API_KEY)
- [x] Hetzner server: Docker + CLIProxyAPI built and running
- [x] CLAUDE.md + SECURITY.md
- [x] Gateway: biddeed-cliproxy container on 127.0.0.1:8317

## Next: Add Real API Keys
- [ ] SSH to server: add Gemini API keys to /opt/cliproxy-gateway/config.yaml
- [ ] SSH to server: add DeepSeek API key to config.yaml
- [ ] docker compose restart
- [ ] Verify: curl http://127.0.0.1:8317/v1/models shows real providers
- [ ] Update cli-anything .env with gateway URL + key
- [ ] Update ZoneWise Scraper V4 Gemini endpoint to gateway
- [ ] Test LangGraph SSH tunnel from GitHub Actions
- [ ] Add TELEGRAM_BOT_TOKEN + TELEGRAM_CHAT_ID to repo secrets
- [ ] Add to cli-anything weekly health suite

## Credentials (on server)
- Config: /opt/cliproxy-gateway/config.yaml
- Secrets: /opt/cliproxy-gateway/.env.generated (chmod 600)
- Gateway key: biddeed-gw-77dc6c9df0e5088057c28d1f94d3fef791961fbb409da85f
