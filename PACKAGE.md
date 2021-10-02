# Package instructions

1. cd ./repo
1. helm package -d mariadb      ../src/mariadb
1. helm package -d postfix      ../src/postfix
1. helm package -d amavis       ../src/amavis
1. helm package -d opendkim     ../src/opendkim
1. helm package -d postfixadmin ../src/postfixadmin
1. helm package -d roundcube    ../src/roundcube
1. helm repo index .
1. git add .
1. git commit -m "Release base packages"
1. git push
1. helm repo update
1. helm package -d mailserver   ../src/mailserver
1. helm repo index .
1. git add .
1. git commit -m "Release mailserver package"
1. git push

