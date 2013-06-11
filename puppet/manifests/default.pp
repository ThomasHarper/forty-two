$fortytwo_databases = ['fortytwo_development', 'fortytwo_test']
$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'
$fortytwo      = '/vagrant/'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt-get -y update':
    unless => "test -e ${home}/.rvm"
  }

  include locales
}

class { 'apt_get_update':
  stage => preinstall
}

# --- SQLite -------------------------------------------------------------------

package { ['sqlite3', 'libsqlite3-dev']:
  ensure => installed;
}

# --- PostgreSQL ---------------------------------------------------------------

class install_postgres {
  class { 'postgresql': }

  class { 'postgresql::server': }

  pg_database { $fortytwo_databases:
    ensure   => present,
    encoding => 'UTF8',
    owner    => 'fortytwo',
    require  => [ Class['postgresql::server'], Pg_user['fortytwo']]
  }

  pg_user { 'vagrant':
    ensure    => present,
    superuser => true,
    require   => Class['postgresql::server']
  }

  pg_user { 'fortytwo':
    ensure    => present,
    superuser => true,
    password  => 'password',
    require   => Class['postgresql::server']
  }

  package { 'libpq-dev':
    ensure => installed
  }
}
class { 'install_postgres': }

# --- Memcached ----------------------------------------------------------------

class { 'memcached': }

# --- Packages -----------------------------------------------------------------

# OpenJDK 6
package { 'openjdk-6-jre':
  ensure => installed
}

package { 'curl':
  ensure => installed
}

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

# Nokogiri dependencies.
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

# ExecJS runtime.
package { 'nodejs':
  ensure => installed
}

# --- Ruby ---------------------------------------------------------------------

exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
  creates => "${home}/.rvm",
  require => Package['curl']
}

exec { 'install_ruby':
  command => "${as_vagrant} '${home}/.rvm/bin/rvm install 2.0.0 --autolibs=3 --latest-binary && rvm --fuzzy alias create default 2.0.0'",
  creates => "${home}/.rvm/bin/ruby",
  timeout => 800,
# require => [ Package['libyaml-dev'], Exec['install_rvm'] ]
  require => Exec['install_rvm']
}

exec { 'install_bundler':
  command => "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'",
  creates => "${home}/.rvm/bin/bundle",
  require => Exec['install_ruby']
}

# --- Heroku --------------------------------------------------------------------

exec { "install_heroku_toolbelt":
    command => "wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh",
    cwd    => "${fortytwo}"
}

# --- fortytwo --------------------------------------------------------------------

# Install project gems
exec { 'bundle_update':
  command => "${as_vagrant} 'bundle update'",
  cwd => "${fortytwo}",
  timeout => 600,
  require => [ Exec['install_bundler'], Package['git-core'] ]
}

# Migrate development database
#exec { 'migrate_development_database':
#  command => "${as_vagrant} 'rake db:migrate'",
#  cwd => "${fortytwo}",
#  require => [ Exec['bundle_update'], Class['install_postgres'] ]
#}

# Launch Thin webserver : foreman start
# exec { 'launch_webserver':
#  command => "foreman start &",
#  cwd => "${fortytwo}",
#  require => Exec['migrate_development_database']
#}

# Create & migrate test database
#exec { 'prepare_test_database':
#  command => "${as_vagrant} 'rake db:test:prepare'",
#  cwd => "${fortytwo}",
#  require => [ Exec['bundle_update'], Class['install_postgres'], Exec['migrate_development_database'] ]
#}

# To do:
# - Populate development database
# - Launch spork : spork
# - Launch cucumber : spork cucumber
# - Launch autotest : autotest
