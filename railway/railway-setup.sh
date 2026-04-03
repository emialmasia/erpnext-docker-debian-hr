#!/bin/bash
set -e

sudo /usr/local/bin/railway-entrypoint.sh

echo "-> Create common site config"
echo '{"socketio_port": 9000}' > /home/frappe/bench/sites/common_site_config.json

echo "-> Create new site with ERPNext"
bench new-site ${RFP_DOMAIN_NAME} \
  --admin-password ${RFP_SITE_ADMIN_PASSWORD} \
  --no-mariadb-socket \
  --db-root-password ${RFP_DB_ROOT_PASSWORD} \
  --install-app erpnext

echo "-> Install HRMS"
bench --site ${RFP_DOMAIN_NAME} install-app hrms

echo "-> Migrate site"
bench --site ${RFP_DOMAIN_NAME} migrate

bench use ${RFP_DOMAIN_NAME}

echo "-> Enable scheduler"
bench enable-scheduler
