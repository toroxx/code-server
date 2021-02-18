#!/bin/bash
sudo chown -R coder:coder /home/coder/.local/share/code-server
java --version
php -v
node -v
composer -v 
/usr/bin/code-server --cert --bind-addr 0.0.0.0:8080
