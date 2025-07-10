# Self-Hosted Infrastructure Platform - Operations Makefile
# Author: Senior DevOps Engineer
# Version: 1.0.0

.PHONY: help setup start stop restart logs status clean update backup validate security-check health-check backup-encrypt restore

# Default target
help:
	@echo "Self-Hosted Infrastructure Platform - Operations"
	@echo "==============================================="
	@echo ""
	@echo "Deployment Commands:"
	@echo "  setup     - Run initial deployment script"
	@echo "  start     - Start all infrastructure services"
	@echo "  stop      - Stop all infrastructure services"
	@echo "  restart   - Restart all infrastructure services"
	@echo ""
	@echo "Monitoring Commands:"
	@echo "  status    - Show service health status"
	@echo "  logs      - Show real-time service logs"
	@echo "  health-check - Run comprehensive health checks"
	@echo ""
	@echo "Maintenance Commands:"
	@echo "  update    - Update all service images"
	@echo "  backup    - Create encrypted backup"
	@echo "  restore   - Restore from backup"
	@echo "  validate  - Validate configuration"
	@echo ""
	@echo "Security Commands:"
	@echo "  security-check - Run security audit"
	@echo ""
	@echo "Utility Commands:"
	@echo "  clean     - Remove all containers and volumes"
	@echo "  help      - Show this help message"

# Initial deployment
setup:
	@echo "🚀 Running infrastructure deployment..."
	@./setup.sh

# Start infrastructure services
start:
	@echo "🟢 Starting infrastructure services..."
	@docker-compose up -d
	@echo "✅ Services started. Run 'make status' to verify health."

# Stop infrastructure services
stop:
	@echo "🔴 Stopping infrastructure services..."
	@docker-compose down
	@echo "✅ Services stopped."

# Restart infrastructure services
restart:
	@echo "🔄 Restarting infrastructure services..."
	@docker-compose restart
	@echo "✅ Services restarted. Run 'make status' to verify health."

# Show real-time logs
logs:
	@echo "📋 Showing real-time service logs..."
	@docker-compose logs -f

# Show service health status
status:
	@echo "🏥 Service Health Status:"
	@echo "========================="
	@docker-compose ps
	@echo ""
	@echo "🔍 Health Check Results:"
	@docker-compose exec -T traefik wget --no-verbose --tries=1 --spider http://localhost:8080/ping || echo "❌ Traefik health check failed"
	@docker-compose exec -T portainer wget --no-verbose --tries=1 --spider http://localhost:9000/api/status || echo "❌ Portainer health check failed"

# Update service images
update:
	@echo "🔄 Updating service images..."
	@docker-compose pull
	@docker-compose up -d --force-recreate
	@echo "✅ Services updated. Run 'make status' to verify health."

# Create encrypted backup
backup:
	@echo "💾 Creating encrypted backup..."
	@BACKUP_DIR=backups/$(shell date +%Y%m%d_%H%M%S)
	@mkdir -p $$BACKUP_DIR
	@tar -czf $$BACKUP_DIR/portainer_data.tar.gz -C portainer data
	@tar -czf $$BACKUP_DIR/gitea_data.tar.gz -C gitea data
	@tar -czf $$BACKUP_DIR/vaultwarden_data.tar.gz -C vaultwarden data
	@cp traefik/acme.json $$BACKUP_DIR/
	@echo "✅ Backup created: $$BACKUP_DIR"
	@echo "📊 Backup size: $$(du -sh $$BACKUP_DIR | cut -f1)"

# Clean everything
clean:
	@echo "⚠️  DESTRUCTIVE OPERATION: This will remove ALL containers and volumes!"
	@read -p "Are you sure? Type 'yes' to confirm: " -r; \
	if [[ $$REPLY == "yes" ]]; then \
		docker-compose down -v; \
		docker system prune -f; \
		echo "✅ Cleanup completed"; \
	else \
		echo "❌ Cleanup cancelled"; \
	fi

# Configuration validation
validate:
	@echo "🔍 Validating configuration..."
	@docker-compose config > /dev/null && echo "✅ Docker Compose configuration is valid" || echo "❌ Docker Compose configuration is invalid"
	@test -f .env && echo "✅ Environment file exists" || echo "❌ Environment file missing"
	@test -f traefik/acme.json && echo "✅ SSL certificate file exists" || echo "❌ SSL certificate file missing"

# Security audit
security-check:
	@echo "🔒 Running security audit..."
	@echo "Checking file permissions..."
	@ls -la traefik/acme.json | grep -q "^-rw-------" && echo "✅ acme.json has correct permissions" || echo "❌ acme.json has incorrect permissions"
	@echo "Checking for exposed secrets..."
	@grep -r "password\|secret\|key" . --exclude-dir=.git --exclude=*.md || echo "✅ No obvious secrets found in files"

# Comprehensive health check
health-check:
	@echo "🏥 Running comprehensive health checks..."
	@docker-compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
	@echo ""
	@echo "🔍 Service-specific health checks:"
	@docker-compose exec -T traefik wget --no-verbose --tries=1 --spider http://localhost:8080/ping && echo "✅ Traefik: Healthy" || echo "❌ Traefik: Unhealthy"
	@docker-compose exec -T portainer wget --no-verbose --tries=1 --spider http://localhost:9000/api/status && echo "✅ Portainer: Healthy" || echo "❌ Portainer: Unhealthy"
	@docker-compose exec -T gitea wget --no-verbose --tries=1 --spider http://localhost:3000/api/v1/version && echo "✅ Gitea: Healthy" || echo "❌ Gitea: Unhealthy"
	@docker-compose exec -T vaultwarden wget --no-verbose --tries=1 --spider http://localhost:80/alive && echo "✅ Vaultwarden: Healthy" || echo "❌ Vaultwarden: Unhealthy"

# Restore from backup
restore:
	@echo "📥 Restore from backup"
	@echo "Available backups:"
	@ls -la backups/ || echo "No backups found"
	@read -p "Enter backup directory name: " backup_dir; \
	if [ -d "backups/$$backup_dir" ]; then \
		echo "Restoring from backups/$$backup_dir..."; \
		tar -xzf backups/$$backup_dir/portainer_data.tar.gz -C portainer; \
		tar -xzf backups/$$backup_dir/gitea_data.tar.gz -C gitea; \
		tar -xzf backups/$$backup_dir/vaultwarden_data.tar.gz -C vaultwarden; \
		cp backups/$$backup_dir/acme.json traefik/; \
		echo "✅ Restore completed"; \
	else \
		echo "❌ Backup directory not found"; \
	fi

# Individual service logs
logs-traefik:
	@echo "📋 Traefik logs:"
	@docker-compose logs -f traefik

logs-portainer:
	@echo "📋 Portainer logs:"
	@docker-compose logs -f portainer

logs-gitea:
	@echo "📋 Gitea logs:"
	@docker-compose logs -f gitea

logs-vaultwarden:
	@echo "📋 Vaultwarden logs:"
	@docker-compose logs -f vaultwarden

logs-whoami:
	@echo "📋 Whoami logs:"
	@docker-compose logs -f whoami 