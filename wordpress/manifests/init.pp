
exec {'apt-get update' : 
		path => ['/usr/bin','/usr/sbin']
		}

package {'apache2':
		ensure => present}

service {'apache2' :
		ensure => running}

$packagenames = ['mysql-server', 'mysql-client', 'php', 'libapache2-mod-php', 'php-mcrypt', 'php-mysql']

$packagenames.each |String $package| {
package {"${package}":   
    ensure => latest,
  }
}

exec {'mysqladmin -u root password rootpassword':
		path => '/usr/bin'}

exec {'wget https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/mysqlcommands':
		path => '/usr/bin',
		cwd => '/tmp/'}

exec {'mysql -uroot -prootpassword < /tmp/mysqlcommands':
		path => '/usr/bin'}

exec {'wget https://wordpress.org/latest.zip':
		path => '/usr/bin',
		cwd => '/tmp/'}

package {'unzip':
		ensure => present}

exec {'sudo unzip /tmp/latest.zip -d /var/www/html':
		path => '/usr/bin'}

exec {'wget https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/wp-config-sample.php':
		path => '/usr/bin',
		cwd => '/var/www/html/wordpress/'
		}

exec {'mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php':
		path =. '/usr/bin'}

file {"/var/www/html/wordpress":
		recurse => true,
		mode => '0775',
		owner => 'www-data',
		group => 'www-data',
		}

exec {'service apache2 restart': 
		path => ['/usr/sbin','/usr/bin','/bin','/sbin']}

