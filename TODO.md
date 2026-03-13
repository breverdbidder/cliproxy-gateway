# TODO — CLIProxy Gateway

## Setup
- [x] Create repo breverdbidder/cliproxy-gateway
- [x] Hardened Dockerfile (non-root, EST, health check)
- [x] docker-compose.yml with security (read-only, no-new-privileges)
- [x] Config template with Gemini + DeepSeek providers
- [x] Server setup script (cloud-init)
- [x] GitHub Actions deploy workflow
- [x] GitHub Actions weekly health check
- [x] GitHub secrets (HETZNER_IP, SSH_KEY, API_TOKEN)
- [x] Rebuild Hetzner server with cloud-init
- [x] CLAUDE.md + SECURITY.md

## Post-Deploy (needs API keys)
- [ ] Add real Gemini API keys to config.yaml
- [ ] Add real DeepSeek API key to config.yaml
- [ ] Restart: docker compose restart
- [ ] Verify models endpoint returns real providers
- [ ] Update cli-anything .env with gateway URL + key
- [ ] Update ZoneWise Scraper V4 endpoint
- [ ] Test LangGraph SSH tunnel from GitHub Actions
- [ ] Add TELEGRAM_BOT_TOKEN + TELEGRAM_CHAT_ID secrets
- [ ] Staleness check: add to cli-anything weekly health suite
