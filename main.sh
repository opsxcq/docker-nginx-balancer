#!/bin/bash

if [ -z "$NODES" ]
then
    echo '[-] Please inform the nodes that you want to balance via NODES variable'
    return -1
fi


# Create nginx configuration
cat > /nginx.conf << EOF

worker_processes 8;

events { worker_connections 1024; }

http {

        upstream web-balancer {
              least_conn;
$(for NODE in $NODES; do
                    echo "                server ${NODE} weight=10 max_fails=3 fail_timeout=30s;"
                done
              )
        }
         
        server {
              listen 80;
         
              location / {
                proxy_pass http://web-balancer;
                proxy_http_version 1.1;
                proxy_set_header Upgrade \$http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host \$host;
                proxy_cache_bypass \$http_upgrade;
              }
        }
}

EOF

# Start nginx

nginx -c /nginx.conf
