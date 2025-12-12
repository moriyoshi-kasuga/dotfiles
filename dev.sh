#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/docker"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Determine docker compose command
if docker compose version &> /dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
elif command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

case "${1:-}" in
    build)
        print_info "Building Docker image..."
        $DOCKER_COMPOSE build
        print_info "Build complete!"
        ;;
    
    start)
        print_info "Starting development environment..."
        $DOCKER_COMPOSE up -d
        print_info "Container started! Attaching to shell..."
        docker exec -it dotfiles-dev /home/dev/.nix-profile/bin/zsh
        ;;
    
    exec)
        print_info "Attaching to running container..."
        docker exec -it dotfiles-dev /home/dev/.nix-profile/bin/zsh
        ;;
    
    stop)
        print_info "Stopping development environment..."
        $DOCKER_COMPOSE down
        print_info "Stopped!"
        ;;
    
    *)
        echo "Usage: $0 {build|start|exec|stop}"
        echo ""
        echo "Commands:"
        echo "  build    - Build the Docker image"
        echo "  start    - Start container and attach to shell"
        echo "  exec     - Attach to running container"
        echo "  stop     - Stop the container"
        echo ""
        echo "Examples:"
        echo "  $0 build    # Build image first time"
        echo "  $0 start    # Start container and attach"
        echo "  $0 exec     # Attach to running container"
        echo "  $0 stop     # Stop container"
        exit 1
        ;;
esac
