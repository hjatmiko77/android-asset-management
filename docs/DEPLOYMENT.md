# Deployment Guide - Ubuntu Server

## System Requirements

- Ubuntu 24.04 LTS
- 4GB RAM minimum
- 20GB storage
- Docker & Docker Compose installed
- SSL Certificate (Let's Encrypt)

## Step 1: Server Preparation

```bash
# Update system
sudo apt update
sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add user to docker group
sudo usermod -aG docker $USER
```

## Step 2: Clone Repository

```bash
cd /opt
sudo git clone https://github.com/hjatmiko77/android-asset-management.git
cd android-asset-management
```

## Step 3: Configure Environment

```bash
cd backend
sudo cp .env.example .env
sudo nano .env
```

Update with production values:

```env
DEBUG=False
DATABASE_URL=postgresql://asset_user:strong_password@postgres:5432/asset_management
SECRET_KEY=your-production-secret-key-here
CORS_ORIGINS=https://your-domain.com
ALLOWED_HOSTS=your-domain.com,www.your-domain.com
```

## Step 4: SSL Certificate (Let's Encrypt)

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Generate certificate
sudo certbot certonly --standalone -d your-domain.com -d www.your-domain.com

# Copy certificates
sudo mkdir -p ssl
sudo cp /etc/letsencrypt/live/your-domain.com/fullchain.pem ssl/cert.pem
sudo cp /etc/letsencrypt/live/your-domain.com/privkey.pem ssl/key.pem
```

## Step 5: Update NGINX Configuration

Edit `nginx.conf`:

```nginx
server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    # ... rest of configuration
}

server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    return 301 https://$server_name$request_uri;
}
```

## Step 6: Start Services

```bash
cd /opt/android-asset-management
sudo docker-compose up -d

# Check status
sudo docker-compose ps
```

## Step 7: Database Backup

```bash
# Create backup script
sudo nano /opt/backup-db.sh
```

```bash
#!/bin/bash
BACKUP_DIR="/opt/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR
sudo docker exec asset_db pg_dump -U asset_user -d asset_management > $BACKUP_DIR/asset_db_$DATE.sql

# Keep only last 7 days
find $BACKUP_DIR -type f -mtime +7 -delete
```

```bash
# Make executable
sudo chmod +x /opt/backup-db.sh

# Add to crontab (daily at 2 AM)
sudo crontab -e
0 2 * * * /opt/backup-db.sh
```

## Step 8: Monitoring & Logs

```bash
# View logs
sudo docker-compose logs -f backend

# Check database
sudo docker exec asset_db psql -U asset_user -d asset_management -c "SELECT COUNT(*) FROM assets;"
```

## Step 9: Firewall Configuration

```bash
# Enable UFW
sudo ufw enable

# Allow SSH
sudo ufw allow 22/tcp

# Allow HTTP/HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Check status
sudo ufw status
```

## Step 10: Auto-Renewal SSL Certificate

```bash
# Test renewal
sudo certbot renew --dry-run

# Add to crontab (weekly)
sudo crontab -e
0 3 * * 0 certbot renew --quiet
```

## Troubleshooting

### Port Already in Use

```bash
sudo lsof -i :443
sudo kill -9 <PID>
```

### View Container Logs

```bash
sudo docker-compose logs nginx
sudo docker-compose logs backend
sudo docker-compose logs postgres
```

### Restart Services

```bash
sudo docker-compose restart backend
sudo docker-compose restart nginx
```

### Check System Resources

```bash
sudo docker stats
```

## Maintenance

### Update Application

```bash
cd /opt/android-asset-management
sudo git pull origin main
sudo docker-compose restart
```

### View Production Logs

```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```
