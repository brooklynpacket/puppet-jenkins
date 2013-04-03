class jenkins::repo::debian {

  include 'jenkins::repo'

  apt::key { "jenkins":
    key        => "D50582E6",
    key_source => "http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key",
  }
  
  if $jenkins::repo::lts == 0 {
    apt::source { 'jenkins':
      location    => 'http://pkg.jenkins-ci.org/debian',
      release     => 'binary/',
      repos       => '',
      include_src => false,
    }
  }
  elsif $jenkins::repo::lts == 1 {
    apt::source { 'jenkins':
      location    => 'http://pkg.jenkins-ci.org/debian-stable',
      release     => 'binary/',
      repos       => '',
      include_src => false,
    }
  }

}
