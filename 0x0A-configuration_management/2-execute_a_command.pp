# Puppet manifest to execute a command

exec { 'killmenow':
  command => '/alx-system_engineering-devops/0x0A-configuration_management/killmenow',
  onlyif  => '/bin/true',           # Ensures that the command is always executed
  path    => '/bin:/usr/bin',       # Set the path environment variable if needed
  timeout     => 0,                     # Set timeout to 0 to disable it
  logoutput   => true,                  # Log output for debugging purposes
}

