class netcore8{

# Add the .NET repository
file { '/etc/apt/sources.list.d/microsoft-dotnet.list':
  content => 'deb [arch=amd64] https://packages.microsoft.com/repos/dotnet/debian/ $(lsb_release -sc) main',
  ensure  => 'present',
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

# Add the Microsoft signing key
exec { 'apt-add-microsoft-key':
  command => "wget -q -O - https://packages.microsoft.com/keys/microsoft-dotnet-debian.asc | apt-key add -",
  path    => ['/usr/bin'],
  unless  => 'apt-key list | grep \'Microsoft Corporation\'',
  creates => '/root/.apt_key.md5',
}

# Update the apt cache
exec { 'apt-get update':
  command => 'apt-get update',
  path    => ['/usr/bin'],
  unless  => 'apt-get update -y',
  creates => '/root/.apt_cache.md5',
}

# Install the .NET 8 SDK
package { 'dotnet-sdk-8.0':
  ensure => 'present',
}
}
