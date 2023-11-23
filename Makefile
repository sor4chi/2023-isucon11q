all: rotate-all app-deploy

NGINX_ACCESS_LOG:=/var/log/nginx/access.ndjson
NGINX_CONF:=/etc/nginx
MYSQL_SLOW_LOG:=/var/log/mysql/mysql-slow.log
MYSQL_CONF:=/etc/mysql
APP:=/home/isucon/webapp/go
SERVICE:=isucondition.go.service

.PHONY: rotate-all
rotate-all: rotate-access-log rotate-slow-log

.PHONY: rotate-access-log
rotate-access-log:
	echo "Rotating access log"
	sudo mv $(NGINX_ACCESS_LOG) $(NGINX_ACCESS_LOG).$(shell date +%Y%m%d)
	sudo systemctl restart nginx

.PHONY: rotate-slow-log
rotate-slow-log:
	echo "Rotating slow log"
	sudo mv $(MYSQL_SLOW_LOG) $(MYSQL_SLOW_LOG).$(shell date +%Y%m%d)
	sudo systemctl restart mysql

.PHONY: alp
alp:
	alp json --config alp-config.yml

.PHONY: pt
pt:
	sudo pt-query-digest $(MYSQL_SLOW_LOG)

.PHONY: pprof
pprof:
	go tool pprof -seconds 60 -http=localhost:1080 http://localhost:6060/debug/pprof/profile

.PHONY: nginx-conf-deploy-s1
nginx-conf-deploy-s1:
	echo "nginx conf deploy"
	sudo cp -r etc/s1/nginx/* $(NGINX_CONF)
	sudo nginx -t
	sudo systemctl restart nginx

.PHONY: mysql-conf-deploy-s1
mysql-conf-deploy-s1:
	echo "mysql conf deploy"
	sudo cp -r etc/s1/mysql/* $(MYSQL_CONF)
	sudo systemctl restart mysql

.PHONY: app-deploy
app-deploy:
	echo "app deploy"
	cd $(APP) && go build -o isucondition
	sudo systemctl restart $(SERVICE)
