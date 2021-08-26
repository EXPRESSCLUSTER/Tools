# Convert lankhb to lanhb
ret=`grep "<lankhb name=" clp.conf | wc -l`
`sed -i -e 's/<lankhb name="lankhb/<lanhb name="lanhb/g' clp.conf`
`sed -i -e 's/<\\/lankhb>/<\\/lanhb>/g' clp.conf`
`sed -i -e 's/<types name="lankhb"\\/>/<types name="lanhb"\\/>/g' clp.conf`
if [ $ret != 0 ]; then
    echo "Converted lankhb to lanhb."
fi

# Convert keepalive to softdog in userw
xmllint --xpath /root/monitor/userw clp.conf &> /dev/null
if [ $? != 0 ]; then
    exit 0
fi

ret=`xmllint --xpath "/root/monitor/userw/parameters/method/text()" clp.conf 2> /dev/null`
./clpcfset add monparam userw userw parameters/method softdog
./clpcfset add monparam userw userw parameters/action RESET
if [ "$ret" != "softdog" ]; then
    echo "Converted userw monitoring method to softdog."
fi

# Convert keepalive to softdog in Shutdown Monitor
ret=`xmllint --xpath "/root/haltp/method/text()" clp.conf 2> /dev/null`
./clpcfset add clsparam haltp/method softdog
./clpcfset add clsparam haltp/action RESET
if [ "$ret" != "softdog" ]; then
    echo "Converted Shutdown Monitor method to softdog."
fi

xmllint --format --output clp.conf clp.conf