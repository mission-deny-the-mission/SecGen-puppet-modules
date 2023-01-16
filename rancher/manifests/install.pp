class rancher::install {
  Exec {
    path => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'],
    environment => ['http_proxy=http://172.22.0.51:3128',
      'https_proxy=http://172.22.0.51:3128',
      'ftp_proxy=http://172.22.0.51:3128'] }

  ensure_packages(['apt-transport-https', 'ca-certificates', 'curl', 'gnupg2', 'software-properties-common', 'python3-pip'])

  exec {'download-and-install-apt-key-for-docker-repo':
    command => 'curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -',
  } ->
  exec {'add-docker-repo':
    command => 'add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"',
  } ->
  exec {'run-apt-update':
    command => 'apt-get update',
  } ->
  exec {'install-docker':
    command => 'apt-get install -y docker-ce',
  } ->
  exec {'launch-rancher':
    command => 'docker run -d --restart=unless-stopped -p 8080:8080 rancher/server',
  } ->
  exec {'install-selenium':
    command => 'pip install selenium',
  }
}
