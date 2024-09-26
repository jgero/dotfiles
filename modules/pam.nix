{ pkgs, ... }: {
  security.pam.u2f.authFile = pkgs.writeText "u2f_keys" "jgero:f8ZjVEI5BMdom3LpGJOqKXqLo4rkOD+lUb4jMjXepMAQLypKfsHPQaER1nCbWeQ95pIgk3nFFnkh/+SriGICIdKxBiYIJSJk+w9i+r9K5kH5YW8aGQ0e+4F+FROiP49/,2ZFnW8ZKLcUfH+X1A6Dozq+fCHfPcqNY4TPn7cgAVv0xvuI9UNkue3XMIpy7My3TdnIr/pbSvgHJXFfIvnGwvQ==,es256,+presence";
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}


