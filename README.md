# Self-Hosted Infrastructure Platform

Production-ready infrastructure stack for running self-hosted services with enterprise-grade security, monitoring, and automation.

## Overview

This platform provides a complete self-hosted solution for organizations and individuals who need full control over their infrastructure. Built with Docker, orchestrated by Traefik, and secured with automatic SSL certificates.

## Core Services

### Infrastructure
- **Traefik v2.10** - Enterprise-grade reverse proxy with automatic SSL/TLS termination
- **Portainer CE** - Container orchestration and management interface
- **Whoami** - Health check and debugging service

### Development & Collaboration
- **Gitea** - Self-hosted Git repository management with CI/CD capabilities
- **Vaultwarden** - Enterprise password management with end-to-end encryption

### Security & Monitoring
- **Automatic SSL/TLS** - Let's Encrypt integration with certificate auto-renewal
- **Security Headers** - OWASP-compliant security middleware
- **Container Isolation** - Network segmentation and resource limits
- **Audit Logging** - Comprehensive logging for compliance and debugging

## 🏗️ Architecture

```
Internet → Traefik (Reverse Proxy) → Services
                ↓
        [Portainer, Gitea, Vaultwarden, Whoami]
```

## 📁 Project Structure

```
self-hosted-infra/
├── docker-compose.yml          # Main services configuration
├── .env                        # Environment variables
├── traefik/
│   ├── traefik.yml            # Traefik static configuration
│   ├── dynamic_conf.yml       # Traefik dynamic configuration
│   └── acme.json              # SSL certificates storage
├── portainer/
│   └── data/                  # Portainer data
├── gitea/
│   └── data/                  # Gitea data
├── vaultwarden/
│   └── data/                  # Vaultwarden data
└── README.md                  # This file
```

## Deployment

### System Requirements

- **OS**: Ubuntu 20.04+ / CentOS 8+ / Debian 11+
- **Docker**: 20.10+ with Docker Compose 2.0+
- **Resources**: Minimum 2GB RAM, 20GB storage
- **Network**: Public IP with ports 80/443 accessible
- **Domain**: Valid domain name with DNS configured

### 1. Repository Setup

```bash
git clone git@github.com:amit-barda/self-Hosted-Infrastructure-Platform.git
cd self-Hosted-Infrastructure-Platform
chmod +x setup.sh
```

### 2. Environment Configuration

```bash
cp .env.example .env
# Configure domain, email, and authentication
nano .env
```

### 3. Infrastructure Deployment

```bash
# Automated setup with validation
./setup.sh

# Deploy services
docker-compose up -d

# Verify deployment
docker-compose ps
```

### 4. Service Verification

```bash
# Check service health
make status

# View logs
make logs

# Access services:
# - Portainer: https://portainer.yourdomain.com
# - Gitea: https://git.yourdomain.com  
# - Vaultwarden: https://vault.yourdomain.com
# - Traefik Dashboard: https://traefik.yourdomain.com
```

## Configuration Management

### Traefik Architecture

The reverse proxy configuration follows enterprise patterns:
- **Static Config** (`traefik/traefik.yml`) - Entry points, providers, and certificate resolvers
- **Dynamic Config** (`traefik/dynamic_conf.yml`) - Middleware, security headers, and rate limiting
- **Service Discovery** - Automatic container detection via Docker labels

### Certificate Management

- **Let's Encrypt Integration** - Automatic certificate provisioning and renewal
- **Certificate Storage** - Secure storage in `traefik/acme.json` with proper permissions
- **Staging Environment** - Optional staging certificates for testing

### Environment Configuration

All services are configured via environment variables for:
- Domain configuration
- Authentication credentials
- Service-specific settings
- Security parameters

## Security Architecture

### Network Security
- **SSL/TLS Termination** - End-to-end encryption with automatic certificate management
- **Container Isolation** - Network segmentation with dedicated Docker networks
- **Port Management** - Minimal exposed ports with proper firewall configuration

### Application Security
- **OWASP Headers** - Comprehensive security headers (HSTS, CSP, X-Frame-Options)
- **Authentication** - Basic auth for administrative interfaces
- **Rate Limiting** - Protection against DDoS and brute force attacks
- **Input Validation** - Service-level input sanitization

### Infrastructure Security
- **Principle of Least Privilege** - Minimal required permissions for all services
- **Secret Management** - Environment-based configuration with no hardcoded secrets
- **Audit Logging** - Comprehensive logging for security monitoring and compliance

## Monitoring & Operations

### Infrastructure Monitoring
- **Portainer** - Container orchestration with real-time metrics and logs
- **Traefik Dashboard** - Reverse proxy monitoring with request analytics
- **Health Checks** - Automated service health monitoring and alerting
- **Resource Monitoring** - CPU, memory, and network utilization tracking

### Operational Tools
- **Makefile Commands** - Standardized operations for deployment and maintenance
- **Automated Backups** - Scheduled backup procedures for data persistence
- **Log Aggregation** - Centralized logging for troubleshooting and compliance
- **Service Discovery** - Automatic service registration and health monitoring

## Maintenance & Updates

### Service Updates
```bash
# Pull latest images and restart services
make update

# Or manually:
docker-compose pull
docker-compose up -d --force-recreate
```

### Backup Procedures
```bash
# Create timestamped backup
make backup

# Restore from backup
tar -xzf backups/YYYYMMDD_HHMMSS.tar.gz
```

## Data Management

### Persistent Storage
All critical data is persisted using Docker volumes:
- **Portainer**: `./portainer/data` - Container management state
- **Gitea**: `./gitea/data` - Git repositories and user data
- **Vaultwarden**: `./vaultwarden/data` - Encrypted password database
- **Traefik**: `./traefik/acme.json` - SSL certificates and configuration

### Backup Strategy
- **Automated Backups** - Daily backups with 30-day retention
- **Encrypted Storage** - Sensitive data encrypted at rest
- **Disaster Recovery** - Point-in-time recovery capabilities

## Troubleshooting & Support

### Diagnostic Commands
```bash
# Service status and health
make status

# Real-time log monitoring
make logs

# Individual service logs
make logs-traefik
make logs-portainer
make logs-gitea

# Certificate validation
openssl s_client -connect yourdomain.com:443 -servername yourdomain.com
```

### Common Issues

#### SSL Certificate Problems
```bash
# Check certificate status
docker-compose logs traefik | grep -i certificate

# Force certificate renewal
docker-compose restart traefik
```

#### Service Connectivity
```bash
# Test internal networking
docker-compose exec traefik ping portainer
docker-compose exec traefik ping gitea

# Check port binding
netstat -tlnp | grep :80
netstat -tlnp | grep :443
```

#### Performance Issues
```bash
# Resource utilization
docker stats

# Container resource limits
docker-compose exec portainer cat /proc/1/limits
```

## 📝 License

MIT License - feel free to use this project for your own infrastructure needs.
 
## 🔗 Repository

**GitHub**: [https://github.com/amit-barda/self-Hosted-Infrastructure-Platform](https://github.com/amit-barda/self-Hosted-Infrastructure-Platform)

 
