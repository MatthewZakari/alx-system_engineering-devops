# Puppet manifest to install Flask version 2.1.0 using pip3

# Ensure the package is installed
package { 'flask':
  ensure   => '2.1.0',
  provider => 'pip3',
}

# Ensure the correct version of Werkzeug is installed
package { 'werkzeug':
  ensure   => '2.1.1',
  provider => 'pip3',
}

