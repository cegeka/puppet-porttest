# == Class: porttest::tcp
#
# TCP port test
#
# === Parameters
#
# [*target*]
#   Target IP and hostname.
#
# [*timeout*]
#   seconds before giving up and returning a fail
#
# === Examples
# porttest::tcp { 'test stuff ':
#   target  => [ 'google.com:80', 'google.de:80' ],
#   timeout => '5',
# }
#
# porttest::tcp { 'test tcp 80 to google.com':
#   target =>  [ 'google.com:443' ],
#   timeout   => '2',    
# }
#
# === Authors
#
# - Bryan Andrews <bryanandrews@gmail.com>
# and
# - Andy McDade
#
# === Copyright
#
# Copyright 2015 Bryan Andrews <bryanandrews@gmail.com>, unless otherwise noted.
#

define porttest::tcp (

  $target,
  $timeout,

) {

  include porttest::install
  $prefix = $porttest::install::prefix
  $store  = $porttest::install::store
  
  $hosts = $target
  $hosts.each |String $target| {
    exec { "Test ${target} tcp ${port}":
      require => File["${prefix}/portTest.py"],
      path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin/' ],
      command => "portTest.py ${target} ${timeout} && touch ${store}/${target}-${port}.verified",
      creates => "${store}/${target}-${port}.verified",
    }
  }
}
