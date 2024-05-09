# Manifest to install and configure Nginx

# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Allow HTTP traffic for Nginx
#firewall { '100 Allow nginx HTTP':
#  port   => 80,
#  proto  => 'tcp',
#  action => 'accept',
#}

# Define the Nginx server configuration
#file_line { 'install':
#  ensure  => 'present',
#  path    => '/etc/nginx/sites-available/default',
#  line    => 'error_page 404 /404.html;',
#}

file_line { 'activate':
  ensure  => 'present',
  path    => '/etc/nginx/sites-enabled/default',
  line    => 'rewrite ^/redirect_me https://github.com/MatthewZakari permanent;',
  require => File_line['install'],
}

# Define the index.html file
file { '/var/www/html/index.html':
  ensure  => 'present',
  content => 'Hello World!',
}

# Define the Nginx service
service { 'nginx':
  ensure  => running,
  require => Package['nginx'],
}

