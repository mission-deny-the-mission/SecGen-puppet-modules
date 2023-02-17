class pandora::install {
  Exec {
    path => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin']
  }

  ensure_packages(['snmp', 'snmpd', 'libsocket6-perl', 'libxml-simple-perl', 'libxml-twig-perl', 'libnetaddr-ip-perl', 'libdbi-perl', 'libnetaddr-ip-perl', 'libhtml-parser-perl', 'xprobe2', 'snmp-mibs-downloader', 'geoip-bin', 'libgeoip2-perl'])

  file {'/root/pandorafms_server-7.0NG.742_FIX_PERL2020.tar.gz':
    source => "puppet:///modules/pandora/pandorafms_server-7.0NG.742_FIX_PERL2020.tar.gz",
  } ->
  exec {'extract-pandora-installer':
    command => 'tar -xvf pandorafms_server-7.0NG.742_FIX_PERL2020.tar.gz; rm pandorafms_server-7.0NG.742_FIX_PERL2020.tar.gz',
    cwd => '/root',
    creates => '/root/pandora_server'
  } ->
  exec {'install-perl-packages':
    command => 'cpan install Geo::IP IO::Socket::INET6 JSON'
  }
  exec {'install-pandora':
    command => './pandora_server_installer --install',
    cwd => '/root/pandora_server'
  }
}
