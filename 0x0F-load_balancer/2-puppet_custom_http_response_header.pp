# Update package repositories
package { 'nginx':
  ensure => latest,
}

# Install Nginx
service { 'nginx':
  ensure => running,
  enable => true,
  require => Package['nginx'],
}

# Create index.html page
file { '/var/www/html/index.html':
  ensure  => present,
  content => 'Hello World!',
  require => Service['nginx'],
}

# Configure Nginx for 301 redirection and custom HTTP header
file { '/etc/nginx/sites-available/default':
  ensure  => present,
  content => @(EOS)
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }

    location /redirect_me {
        return 301 https://github.com/besthor;
    }
}

add_header X-Served-By $hostname;
EOS
  notify  => Service['nginx'],
}

# Configure custom HTTP response header for Nginx
file { '/etc/nginx/conf.d/custom_headers.conf':
  ensure  => present,
  content => "add_header X-Served-By $::hostname;",
  require => Service['nginx'],
}

# Restart Nginx to apply changes
exec { 'restart_nginx':
  command     => '/bin/systemctl restart nginx',
  refreshonly => true,
}

# Install and configure HAProxy
package { 'haproxy':
  ensure => installed,
}

file { '/etc/haproxy/haproxy.cfg':
  ensure  => present,
  content => @(EOS)
global
    log /dev/log    local0
    log /dev/log    local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000

frontend MatthewZakari_frontend
    bind *:80
    mode http
    default_backend MatthewZakari_backend

backend MatthewZakari_backend
    balance roundrobin
    server 471510-web-01 100.26.233.11:80 check
    server 471510-web-02 52.201.212.59:80 check
EOS
  require => Package['haproxy'],
}

# Enable HAProxy init script
file { '/etc/default/haproxy':
  ensure  => present,
  content => 'ENABLED=1',
  require => Package['haproxy'],
}

# Test HAProxy configuration
exec { 'test_haproxy_config':
  command     => '/usr/sbin/haproxy -c -f /etc/haproxy/haproxy.cfg',
  refreshonly => true,
  notify      => Service['haproxy'],
}
