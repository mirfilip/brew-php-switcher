#!/bin/bash
php_array=("php53" "php54" "php55")
php_version="php$1"
apache_conf_path="/etc/apache2/httpd.conf"
php_opt_path="\/usr\/local\/opt\/"
php_lib_path="\/libexec\/apache2\/libphp5.so"
php_mod_path="$php_opt_path$php_version$php_lib_path"
if [[ " ${php_array[*]} " == *"$php_version"* ]]
then
  echo "Switching to $php_version"
  echo "Switching your shell"
  for i in ${php_array[@]}
  do
    brew unlink $i
  done
  brew link "$php_version"
  echo "You will need sudo power from now on"
  echo "Switching your apache conf"
  for j in ${php_array[@]}
  do
    sudo sed -i.bak "s/^LoadModule[ \t]php5_module[ \t]$php_opt_path$j$php_lib_path/\#LoadModule php5_module $php_opt_path$j$php_lib_path/g" $apache_conf_path
  done
  sudo sed -i.bak "s/^\#LoadModule[ \t]php5_module[ \t]$php_mod_path/LoadModule php5_module $php_mod_path/g" $apache_conf_path
  echo "Restarting apache"
  sudo apachectl restart
  echo "All done!"
else
  echo "Unknown version of PHP. PHP Switcher can only handle arguements of 53,54,55"
fi