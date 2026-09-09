FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# Install prerequisites
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    rm -rf /var/lib/apt/lists/*

# Add Anthropic's Claude Desktop apt repository
RUN curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc \
      https://downloads.claude.ai/claude-desktop/key.asc && \
    echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" \
      > /etc/apt/sources.list.d/claude-desktop.list

# Install Claude Desktop
RUN apt-get update && \
    apt-get install -y claude-desktop && \
    rm -rf /var/lib/apt/lists/*

# webtop's base image already exposes port 3000 (HTTP/noVNC) and 3001 (HTTPS)
