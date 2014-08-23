# LogStash Centos 5 RPMS

I did this because the official logstash RPMs do not work on CentOS 5. 
They are signed in a way which only works >=6, while they *could* be signed
in a way which works in 5 and >=6 they currently (23/08/2014) are not.

The guts of this is from the pkg/ dir of the main logstash source, but is 
reduced to the bare minimum to build a rpm for centos. 

This ought to work for future versions as long as they continue to ship a 
.tar.gz and don't revert to a .jar. For a new version just change $VERSION
and increment $EPOCH

To use this you need to grab a logstash .tar.gz (tested with 1.4.2) and put 
it in the same directory as the build.sh
