#!/bin/bash

cp /provisioning/datasources/* /etc/grafana/provisioning/datasources
cp /provisioning/dashboards/* /etc/grafana/provisioning/dashboards
cp /provisioning/dashboards/node-export-full/* /var/lib/grafana/dashboards

exec "$@"