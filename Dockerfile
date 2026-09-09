FROM lscr.io/linuxserver/webtop:ubuntu-xfce

LABEL maintainer="you"
LABEL description="Browser-accessible Ubuntu XFCE desktop with Claude Desktop and Claude Code preinstalled"

# ---- Prerequisites ----
RUN apt-get update && \
    apt-get install -y curl gnupg ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# ---- Claude Desktop (official Anthropic apt repo) ----
RUN curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc \
      https://downloads.claude.ai/claude-desktop/key.asc && \
    echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" \
      > /etc/apt/sources.list.d/claude-desktop.list && \
    apt-get update && \
    apt-get install -y claude-desktop && \
    rm -rf /var/lib/apt/lists/*

# ---- Node.js + Claude Code (CLI) ----
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g @anthropic-ai/claude-code && \
    rm -rf /var/lib/apt/lists/*

# ---- Baked-in performance defaults (override anytime via Railway/compose env vars) ----
# Clamp the virtual display so it isn't rendered at a wasteful 16K by default,
# use a fast/low-latency encoder, and cap framerate for smoother mobile streaming.
ENV PUID=1000 \
    PGID=1000 \
    TZ=Asia/Tehran \
    MAX_RES=1920x1080 \
    SELKIES_ENCODER=x264enc-striped \
    SELKIES_FRAMERATE=30 \
    SELKIES_H264_CRF=28

# webtop's base image already exposes:
#   3000 -> HTTP (noVNC / Selkies web UI)
#   3001 -> HTTPS
