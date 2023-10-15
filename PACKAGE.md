# Package instructions

1. cd ./repo
1. helm package -u -d mariadb      ../src/mariadb
1. helm package -u -d postfix      ../src/postfix
1. helm package -u -d amavis       ../src/amavis
1. helm package -u -d opendkim     ../src/opendkim
1. helm package -u -d postfixadmin ../src/postfixadmin
1. helm package -u -d roundcube    ../src/roundcube
1. helm repo index .
1. git add .
1. git commit -a -m "Release base packages"
1. git push
1. helm repo update
1. helm package -u -d mailserver   ../src/mailserver
1. helm repo index .
1. git add .
1. git commit -a -m "Release mailserver package"
1. git push

