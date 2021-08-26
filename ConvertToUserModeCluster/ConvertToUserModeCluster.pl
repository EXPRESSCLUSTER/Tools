use strict;

# Convert lankhb to lanhb
my $ret = `grep "<lankhb name=" clp.conf | wc -l`;
`sed -i -e 's/<lankhb name="lankhb/<lanhb name="lanhb/g' clp.conf`;
`sed -i -e 's/<\\/lankhb>/<\\/lanhb>/g' clp.conf`;
`sed -i -e 's/<types name="lankhb"\\/>/<types name="lanhb"\\/>/g' clp.conf`;
if ($ret > 0) {
    print "Converted lankhb to lanhb.\n";
}

# Convert keepalive to softdog
$ret = `xmlstarlet sel -t -v "count(/root/monitor/userw)" clp.conf`;
if ($ret == 0) {
    exit(0);
}

$ret = `xmlstarlet sel -t -v "count(/root/monitor/userw/parameters)" clp.conf`;
if ($ret == 0) {
        `xmlstarlet ed --subnode "/root/monitor/userw" --type elem -n parameters clp.conf 1<> clp.conf`;
        `xmlstarlet ed --subnode "/root/monitor/userw/parameters" --type elem -n method -v "softdog" clp.conf 1<> clp.conf`;
        print "Converted keepalive to softdog.\n";
} else {
        $ret = `xmlstarlet sel -t -v "/root/monitor/userw/parameters/method" clp.conf`;
        if ($ret eq "keepalive") {
                `sed -i -e 's/<method>keepalive/<method>softdog/g' clp.conf`;
                print "Converted keepalive to softdog.\n";
        }
}