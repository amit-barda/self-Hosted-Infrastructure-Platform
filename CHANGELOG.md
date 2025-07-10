# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project setup
- Docker Compose configuration for all services
- Traefik reverse proxy with Let's Encrypt
- Portainer container management
- Gitea Git server
- Vaultwarden password manager
- Whoami test service
- Setup script for easy initialization
- Makefile for common operations
- Comprehensive documentation
- Security policy and guidelines
- Contributing guidelines

### Security
- Automatic HTTPS with Let's Encrypt
- Security headers middleware
- Basic authentication for Traefik dashboard
- Proper file permissions
- Environment variable configuration

## [1.0.0] - 2024-01-01

### Added
- Initial release
- Complete self-hosted infrastructure platform
- All core services configured and tested
- Production-ready configuration
- Comprehensive documentation

### Services Included
- **Traefik v2.10** - Reverse proxy with automatic SSL
- **Portainer CE** - Container management UI
- **Gitea** - Self-hosted Git server
- **Vaultwarden** - Password manager (Bitwarden compatible)
- **Whoami** - Test service for debugging

### Features
- Automatic SSL certificate generation
- Security headers and middleware
- Container isolation and networking
- Data persistence for all services
- Easy setup and management scripts
- Backup and restore capabilities 