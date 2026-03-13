# Security — CLIProxy Gateway

## Access Control
- Gateway bound to 127.0.0.1:8317 (localhost only)
- API key required for all requests
- Management API disabled (disable-control-panel: true)
- SSH key auth only (password auth disabled post-setup)

## Credentials
- Gateway API key: /opt/cliproxy-gateway/.env.generated (chmod 600)
- Gemini API keys: in config.yaml (not committed to git)
- DeepSeek API key: in config.yaml (not committed to git)
- config.yaml.template committed (no secrets)

## Docker Hardening
- Non-root user (biddeed:1000)
- Read-only rootfs
- no-new-privileges
- Resource limits (1 CPU, 512M RAM)
- Health checks every 30s

## Network
- UFW: only port 22 open externally
- Port 8317: localhost only
- Access via SSH tunnel or WireGuard

## NOT proxied (by design)
- Claude Max plan OAuth tokens
- Claude API keys
- Any Anthropic credentials
