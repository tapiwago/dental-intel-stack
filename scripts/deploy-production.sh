#!/bin/bash

# Dental Intel Stack - Production Deployment Script
# Usage: ./scripts/deploy-production.sh

set -e

echo "🚀 Dental Intel Stack - Production Deployment"
echo "=============================================="

# Configuration
SERVER_IP="206.81.11.59"
PRIVATE_IP="10.116.0.2"
DEPLOY_USER="root"
REMOTE_DIR="/opt/dental-intel"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed"
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        log_error "Git is not installed"
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Build and package
build_and_package() {
    log_info "Building and packaging application..."
    
    # Create deployment package
    tar -czf dental-intel-stack.tar.gz \
        --exclude='.git' \
        --exclude='node_modules' \
        --exclude='dist' \
        --exclude='*.log' \
        .
    
    log_success "Application packaged successfully"
}

# Deploy to server
deploy_to_server() {
    log_info "Deploying to server $SERVER_IP..."
    
    # Upload package
    scp -o PreferredAuthentications=password dental-intel-stack.tar.gz $DEPLOY_USER@$SERVER_IP:/tmp/
    
    # Deploy on server
    ssh -o PreferredAuthentications=password $DEPLOY_USER@$SERVER_IP << EOF
        set -e
        
        # Create deployment directory
        sudo mkdir -p $REMOTE_DIR
        cd $REMOTE_DIR
        
        # Backup current deployment if exists
        if [ -d "current" ]; then
            sudo mv current backup-\$(date +%Y%m%d-%H%M%S) 2>/dev/null || true
        fi
        
        # Extract new deployment
        sudo mkdir -p current
        cd current
        sudo tar -xzf /tmp/dental-intel-stack.tar.gz
        sudo chown -R $DEPLOY_USER:$DEPLOY_USER .
        
        # Copy environment file if exists
        if [ -f ../backup-*/current/.env ]; then
            cp ../backup-*/current/.env .env
        else
            cp .env.example .env
            echo "⚠️  Please update .env file with production values"
        fi
        
        # Install Docker if not present
        if ! command -v docker &> /dev/null; then
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            sudo usermod -aG docker $DEPLOY_USER
        fi
        
        # Install Docker Compose if not present
        if ! command -v docker-compose &> /dev/null; then
            sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-\$(uname -s)-\$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
        fi
        
        # Stop existing containers
        docker-compose -f docker-compose.prod.yml down 2>/dev/null || true
        
        # Start new deployment
        docker-compose -f docker-compose.prod.yml up -d --build
        
        # Wait for services to be ready
        echo "⏳ Waiting for services to start..."
        sleep 30
        
        # Health check
        if curl -f http://$PRIVATE_IP:5000/health > /dev/null 2>&1; then
            echo "✅ API health check passed"
        else
            echo "❌ API health check failed"
            exit 1
        fi
        
        if curl -f http://localhost:80 > /dev/null 2>&1; then
            echo "✅ Frontend health check passed"
        else
            echo "❌ Frontend health check failed"
            exit 1
        fi
        
        # Cleanup
        rm -f /tmp/dental-intel-stack.tar.gz
        
        echo "🎉 Deployment completed successfully!"
        echo "🌐 Frontend: http://$SERVER_IP"
        echo "🔌 API: http://$PRIVATE_IP:5000"
EOF
    
    log_success "Deployment completed successfully"
}

# Cleanup local files
cleanup() {
    log_info "Cleaning up local files..."
    rm -f dental-intel-stack.tar.gz
    log_success "Cleanup completed"
}

# Main deployment process
main() {
    echo "Starting deployment process..."
    echo "Target server: $SERVER_IP"
    echo "Private IP: $PRIVATE_IP"
    echo ""
    
    check_prerequisites
    build_and_package
    deploy_to_server
    cleanup
    
    echo ""
    log_success "🎉 Dental Intel Stack deployed successfully!"
    echo ""
    echo "Access points:"
    echo "  Frontend: http://$SERVER_IP"
    echo "  API: http://$PRIVATE_IP:5000"
    echo "  Health: http://$PRIVATE_IP:5000/health"
    echo ""
    echo "To monitor:"
    echo "  docker-compose -f docker-compose.prod.yml logs -f"
}

# Run main function
main "$@"
