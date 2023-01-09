class jboss::install {
  Exec {
    path => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'], 
    environment => ['http_proxy=http://172.22.0.51:3128',
        'https_proxy=http://172.22.0.51:3128',
        'ftp_proxy=http://172.22.0.51:3128',
        'JAVA_HOME="/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64/bin/java"']}

  ensure_packages(['apt-transport-https', 'ca-certificates', 'wget', 'dirmngr', 'gnupg', 'software-properties-common'])

  file { '/usr/local/java':
    ensure => 'directory'
  } ->
  exec { 'download-java':
    command => 'wget -O /usr/local/java/java.tar.gz https://javadl.oracle.com/webapps/download/AutoDL?BundleId=247127_10e8cce67c7843478f41411b7003171c',
    creates => '/usr/local/java/java.tar.gz'
  } ->
  exec { 'extract-java':
    command => 'tar -xvf java.tar.gz',
    cwd => '/usr/local/java',
    creates => '/usr/local/java/jre1.8.0_351'
  } ->
  exec { 'change-java-install-dir-permissions':
    command => 'chmod -R 755 /usr/local/java',
  } ->
  exec { 'update-java-location':
    command => 'sudo update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/jre1.8.0_351/bin/java" 1',
  } ->
  exec { 'download-jboss':
    command => 'wget https://download.jboss.org/jbossas/6.1/jboss-as-distribution-6.1.0.Final.zip',
    cwd => '/opt',
    creates => '/opt/jboss-as-distribution-6.1.0.Final.zip',
  } ->
  exec { 'unzip-jboss':
    command => 'unzip jboss-as-distribution-6.1.0.Final.zip',
    cwd => '/opt',
    creates => '/opt/jboss-6.1.0.Final/bin'
  } ->
  exec { 'set-listening-interface':
    command => 'echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> /opt/jboss-6.1.0.Final/bin/run.conf; mkdir /opt/made-interface',
    creates => '/opt/made-interface'
  } ->
  exec { 'change-permissions':
    command => 'chmod a+x /opt/jboss-6.1.0.Final',
  } ->
  file { '/etc/systemd/system/jboss.service':
    source => 'puppet:///modules/jboss/jboss.service'
  } ->
  exec { 'enable-jboss-service-using-systemd':
    command => 'systemctl enable --now jboss'
  }
}
