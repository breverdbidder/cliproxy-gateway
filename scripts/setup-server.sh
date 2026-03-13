#!/bin/bash
set -euo pipefail

# CLIProxyAPI — BidDeed.AI Server Setup
# Run once on fresh Ubuntu 24.04 (Hetzner CPX21)

echo "╔══════════════════════════════════════╗"
echo "║  BidDeed.AI CLIProxyAPI Setup        ║"
echo "║  Hetzner everest-dispatch            ║"
echo "╚══════════════════════════════════════╝"

export DEBIAN_FRONTEND=noninteractive
export TZ=America/New_York

# 1. System basics
echo "[1/7] System update..."
apt-get update -qq && apt-get upgrade -y -qq
apt-get install -y -qq curl wget git jq ufw fail2ban unattended-upgrades

# 2. Timezone
echo "[2/7] Timezone → EST..."
timedatectl set-timezone America/New_York

# 3. Firewall
echo "[3/7] Firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment "SSH"
# Port 8317 NOT exposed — localhost only
ufw --force enable

# 4. Docker
echo "[4/7] Docker..."
if ! command -v docker &>/dev/null; then
  curl -fsSL https://get.docker.com | sh
  systemctl enable docker
  systemctl start docker
fi

# 5. Clone repos
echo "[5/7] Cloning repos..."
mkdir -p /opt
cd /opt

# Clone our gateway config repo
if [ ! -d "/opt/cliproxy-gateway" ]; then
  git clone https://github.com/breverdbidder/cliproxy-gateway.git
fi

# Clone CLIProxyAPI source
if [ ! -d "/opt/cliproxy-gateway/CLIProxyAPI" ]; then
  cd /opt/cliproxy-gateway
  git clone https://github.com/router-for-me/CLIProxyAPI.git
fi

# 6. Generate secrets if not present
echo "[6/7] Generating secrets..."
cd /opt/cliproxy-gateway

if [ ! -f "config.yaml" ]; then
  GATEWAY_KEY="biddeed-gw-$(openssl rand -hex 24)"
  MGMT_SECRET=$(openssl rand -hex 32)
  
  cp config.yaml.template config.yaml
  sed -i "s/GATEWAY_KEY_PLACEHOLDER/$GATEWAY_KEY/" config.yaml
  sed -i "s/MGMT_SECRET_PLACEHOLDER/$MGMT_SECRET/" config.yaml
  
  # Save the gateway key for reference
  echo "CLIPROXY_API_KEY=$GATEWAY_KEY" > /opt/cliproxy-gateway/.env.generated
  echo "MGMT_SECRET=$MGMT_SECRET" >> /opt/cliproxy-gateway/.env.generated
  chmod 600 /opt/cliproxy-gateway/.env.generated
  
  echo ""
  echo "════════════════════════════════════════"
  echo "  GATEWAY API KEY (save this!):"
  echo "  $GATEWAY_KEY"
  echo "════════════════════════════════════════"
  echo ""
fi

# 7. Build and start
echo "[7/7] Building and starting CLIProxyAPI..."
cd /opt/cliproxy-gateway
docker compose build 2>&1 | tail -5
docker compose up -d

# Verify
sleep 5
echo ""
echo "=== Health Check ==="
GATEWAY_KEY=$(grep CLIPROXY_API_KEY .env.generated 2>/dev/null | cut -d= -f2)
if curl -sf http://127.0.0.1:8317/v1/models -H "Authorization: Bearer $GATEWAY_KEY" | jq '.data | length' 2>/dev/null; then
  echo "✅ CLIProxyAPI is LIVE on localhost:8317"
else
  echo "⚠️ Service starting... check: docker logs biddeed-cliproxy"
fi

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  Setup complete!                     ║"
echo "║  Gateway: http://127.0.0.1:8317/v1  ║"
echo "║  Config: /opt/cliproxy-gateway/      ║"
echo "║                                      ║"
echo "║  NEXT: Add real API keys to          ║"
echo "║  config.yaml and restart:            ║"
echo "║  docker compose restart              ║"
echo "╚══════════════════════════════════════╝"
