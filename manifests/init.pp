# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile_mysql_replica
class profile_mysql_replica (
  Hash $directories,
  Hash $subnets,
  Hash $yumrepos,
) {

  # SETUP YUM REPO
  ensure_resources('yumrepo', $yumrepos, )

  # SETUP CUSTOM DIRECTORIES - FROM HIERA
  File {
    ensure => 'directory',
    group => 'mysql',
    mode => '0755',
    owner => 'mysql',
  }
  ensure_resources('file', $directories, )

  include ::mysql::server

  #Yumrepo['repo.mysql.com'] -> Anchor['mysql::server::start']
  #Yumrepo['repo.mysql.com'] -> Package['mysql_client']
  #create_resources(mysql::db, hiera('mysql::server::db', {}))

  # LIMIT ROOT ACCESS -- IDEALLY FROM HIERA
  #mysql_user{ '[root@127.0.0.1]':       
  #  ensure        => present,       
  #  password_hash => mysql::password($mysql::server::root_password),           
  #}    
  #mysql_user{ 'root@::1':       
  #  ensure        => present,       
  #  password_hash => mysql::password($mysql::server::root_password),    
  #} 
  # SETUP REPLICATION USERS - FROM HIERA
  # SETUP FIREWALL - FROM HIERA

  include ::mysql_orchestrator::client
  # CONFIGURE orchestrator CLIENT SCRIPTS, & CRON

}
