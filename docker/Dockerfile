FROM nixos/nix:latest

# Enable flakes and nix-command
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

# Create dev user manually
RUN echo "dev:x:1000:1000:Developer:/home/dev:/bin/sh" >> /etc/passwd && \
    echo "dev:x:1000:" >> /etc/group && \
    mkdir -p /home/dev && \
    mkdir -p /nix/var/nix/profiles/per-user/dev && \
    chown -R 1000:1000 /nix/var/nix/profiles/per-user/dev

# Copy dotfiles as root first
COPY . /home/dev/dotfiles

# Create vars.nix for Docker environment
RUN cat > /home/dev/dotfiles/vars.nix <<'EOF'
{
  catppuccinFlavor = "mocha";
  username = "dev";
  homeDirectory = "/home/dev";
  system = "x86_64-linux";
  dotfilesDir = "/home/dev/dotfiles";
  gitIncludes = [];
  askAI = "gemini";
  rustypasteServer = "";
}
EOF

# Run init.sh as root to setup Home Manager for dev user
RUN export USER=dev HOME=/home/dev && cd /home/dev/dotfiles && ./init.sh flake

# Fix ownership of home directory
RUN chown -R 1000:1000 /home/dev

# Switch to dev user
USER dev
WORKDIR /home/dev

# Set default shell to zsh
ENV SHELL=/home/dev/.nix-profile/bin/zsh

# Start zsh by default
CMD ["/home/dev/.nix-profile/bin/zsh"]
