# == Class: porttest::params
#
# Private class
#
# === Authors
#
# Fabian Dammekens <fabian.dammekens@cegeka.com>
#
# === Copyright
#
# Copyright 2015 Bryan Andrews <bryanandrews@gmail.com>, unless otherwise noted.
#

class porttest::params {

  $prefix = '/usr/local/bin'
  $store  = '/var/local/porttest'
  $owner  = 'root'
  $group  = 'root'
  $mode   = '0755'

}
