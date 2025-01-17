#!/bin/bash

# Install fail2ban
echo "Installing fail2ban..."
sudo apt update && sudo apt install -y fail2ban

# Configure fail2ban for SSH brute force protection
cat <<EOF | sudo tee /etc/fail2ban/jail.local
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 3600
findtime = 600
EOF

# Restart fail2ban service
sudo systemctl restart fail2ban
