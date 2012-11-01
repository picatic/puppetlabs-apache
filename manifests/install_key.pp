# Definition: apache::vhost
#
# This class installs Apache Virtual Hosts
#
# Parameters:
# - The $port to configure the host on
# - The $docroot provides the DocumentationRoot variable
# - The $serveradmin will specify an email address for Apache that it will
#   display when it renders one of it's error pages
# - The $configure_firewall option is set to true or false to specify if
#   a firewall should be configured.
# - The $ssl option is set true or false to enable SSL for this Virtual Host
# - The $ssl_cert_file option specifies which cert to use for this virtual host
# - The $ssl_cert_key_file option specifies which cert key to use for this virtual host
# - The $template option specifies whether to use the default template or
#   override
# - The $priority of the site
# - The $servername is the primary name of the virtual host
# - The $serveraliases of the site
# - The $options for the given vhost
# - The $override for the given vhost (array of AllowOverride arguments)
# - The $vhost_name for name based virtualhosting, defaulting to *
# - The $logroot specifies the location of the virtual hosts logfiles, default
#   to /var/log/<apache log location>/
# - The $ensure specifies if vhost file is present or absent.
#
# Actions:
# - Install Apache Virtual Hosts
#
# Requires:
# - The apache class
#
# Sample Usage:
#  apache::vhost { 'site.name.fqdn':
#    priority => '20',
#    port => '80',
#    docroot => '/path/to/docroot',
#  }
#
define apache::install_key(
		$domain							= false,
    $ssl_cert_file      = false,
    $ssl_cert_key_file  = false,
		$ssl_cert_ca_file		= false,
    $ensure             = 'present'
  ) {

  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present' and 'absent'.")

  include apache

	if $ssl_cert_key_file {
		file { "${apache::params::ssl_path}/private/${domain}.key":
			ensure => file,
			source => $ssl_cert_key_file,
			owner => root,
			group => 'ssl-cert',
			mode => 0640
		}
	} else {
		alert("Missing key for ${domain}")
	}

	if $ssl_cert_file {
		file { "${apache::params::ssl_path}/certs/${domain}.crt":
			ensure => file,
			source => $ssl_cert_file,
			owner => root,
			group => root,
			mode => 0644
		}
	} else {
		alert("Missing crt for ${domain}")
	}

	if $ssl_cert_ca_file {
		file { "${apache::params::ssl_path}/certs/${domain}.cabundle":
			ensure => file,
			source => $ssl_cert_ca_file,
			owner => root,
			group => root,
			mode => 0644
		}
	}
}

