class thumbor::service {
  systemd::unit_file { 'thumbor@.service':
    ensure  => $thumbor::ensure,
    content => template('thumbor/thumbor.systemd.erb'),
  }
  $thumbor::ports.each |$port| {
    $service_name = sprintf('thumbor@%d', $port)
    service { $service_name:
      enable  => true,
      require => Systemd::Unit_file['thumbor@.service'],
    }
    exec { "start ${service_name}":
      command     => "systemctl start ${service_name}",
      refreshonly => true,
      subscribe   => Service[$service_name],
    }
  }
}
