class jenkins {
  # Agregar el repositorio de Jenkins
  file { '/etc/yum.repos.d/jenkins.repo':
    ensure => file,
    source => 'puppet:///modules/jenkins/jenkins.repo',
  }

  # Importar la clave GPG de Jenkins
  exec { 'import-jenkins-key':
    command => '/usr/bin/rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key',
    path    => ['/bin', '/usr/bin'],
    unless  => '/usr/bin/rpm -qa | grep jenkins',
  }

  # Instalar Jenkins
  package { 'jenkins':
    ensure  => installed,
    require => [File['/etc/yum.repos.d/jenkins.repo'], Exec['import-jenkins-key']],
  }

  # Iniciar y habilitar el servicio de Jenkins
  service { 'jenkins':
    ensure  => running,
    enable  => true,
    require => Package['jenkins'],
  }
}
