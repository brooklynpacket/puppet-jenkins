define jenkins::plugin($version=0) {
  $plugin            = "${name}.hpi"
  $plugins_parent_dir = $jenkins::params::jenkins_dir
  $plugin_dir = $jenkins::params::jenkins_plugin_dir

  if ($version != 0) {
    $base_url = "http://updates.jenkins-ci.org/download/plugins/${name}/${version}/"
  }
  else {
    $base_url   = 'http://updates.jenkins-ci.org/latest/'
  }

  if (!defined(File[$plugin_dir])) {
    file {
      [$plugin_parent_dir, $plugin_dir]:
        ensure  => directory,
        owner   => 'jenkins',
        group   => 'jenkins',
        require => [Group['jenkins'], User['jenkins']];
    }
  }

  if (!defined(Group['jenkins'])) {
    group {
      'jenkins' :
        ensure => present;
    } 
  }

  if (!defined(User['jenkins'])) {
    user {
      'jenkins' :
        ensure => present;
    }
  }

  exec {
    "download-${name}" :
      command    => "wget --no-check-certificate ${base_url}${plugin}",
      cwd        => $plugin_dir,
      require    => File[$plugin_dir],
      path       => ['/usr/bin', '/usr/sbin',],
      unless     => "test -f ${plugin_dir}/${plugin}",
  }

  file {
    "$plugin_dir/$plugin" :
      require => Exec["download-${name}"],
      owner   => 'jenkins',
      mode    => 644,
      notify  => Service['jenkins']
  }
}
