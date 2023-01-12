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

define porttest::port(
  Array $target,
  $hosts = $target,
  Integer $timeout = 1,
  Enum['absent', 'present'] $ensure = 'present',
  Enum['curl','python'] $type = 'curl',
  Enum['tcp','udp'] $protocol = 'tcp',
) {

  include porttest
  $prefix = $porttest::prefix
  $store  = $porttest::store

  $hosts.each |String $target| {
    $values = split($target, /:/)
    $verified = "${values[0]}-${values[1]}-${protocol}.verified"

    case $type {
      'python': {
        $command = "portTest.py ${values[0]} ${values[1]} ${timeout} ${protocol} && touch ${store}/${verified}"
        $require = File["${prefix}/portTest.py"]
      }
      'curl': {
        if ($protocol == 'tcp') {
          $command = "echo 1 | curl -sk --connect-timeout ${timeout} telnet://${target} && touch ${store}/${verified}"
          $require = []
        } else {
          fail("[Porttest::Port] It's not possible to check UDP ports with curl")
        }
      }
      default: { fail("[Porttest::Port] Unsupported check type") }
    }

    exec { "${target}-${protocol}":
      require => $require,
      path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin/' ],
      command => "echo 1 | curl -sk --connect-timeout ${timeout} telnet://${target} && touch ${store}/${verified}",
      creates => "${store}/${verified}",
    }
  }
}
