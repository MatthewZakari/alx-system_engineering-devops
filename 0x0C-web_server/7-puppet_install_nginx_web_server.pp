# Manifest to install and configure Nginx

# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Allow HTTP traffic for Nginx
firewall { '100 Allow nginx HTTP':
  port   => 80,
  proto  => 'tcp',
  action => 'accept',
}

# Define the Nginx server configuration
file_line { 'install':
  ensure  => 'present',
  path	  => '/etc/nginx/sites-enabled/default',
  after   => 'listen 80 default_server',
  line    => 'rewrite ^/redirect_me https://github.com/MatthewZakari permanent',
}

# Define the index.html file
file { '/var/www/html/index.html':
  content => 'Hello World!',
}

# Define the Nginx service
service { 'nginx':
  ensure  => running,
  require => Package['nginx'],
}

