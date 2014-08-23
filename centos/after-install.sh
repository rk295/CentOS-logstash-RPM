/sbin/chkconfig --add logstash

chown -R logstash:logstash /opt/logstash
chown logstash /var/log/logstash
chown logstash:logstash /var/lib/logstash
chown logstash:logstash /var/run/logstash
chown logstash:logstash /etc/logstash
