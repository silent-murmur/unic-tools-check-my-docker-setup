#!/bin/bash
HOSTS=(
    suvsp-igr-drup1.p.unic24.net
    suvsp-prd-drup1.p.unic24.net
    grfcw-igr-drup1.p.unic24.net
    grfcw-prd-drup1.p.unic24.net
    cascw-igr-drup1.p.unic24.net
    cascw-igr-drup1.p.unic24.net
    cascw-prd-drup1.p.unic24.net
    kwscw-igr-drup1.p.unic24.net
    kwscw-igr-drup1.p.unic24.net
    kwscw-prd-drup1.p.unic24.net
    procw-igr-drup1.p.unic24.net
    procw-prd-drup1.p.unic24.net
    suvsp-igr-drup1.p.unic24.net
    suvsp-prd-drup1.p.unic24.net
    olma-igr-drup.p.unic24.net
    olma-prd-drup.p.unic24.net
    thocw-igr-drup1.p.unic24.net
    thocw-prd-drup1.p.unic24.net
);

for HOST in ${HOSTS[@]}; do
    echo "Checking $HOST ...";
    host $HOST;
    SUBNET=`host $HOST | awk '/has address/ { print $4 }'| awk 'match($0, /[0-9]{1,3}\.[0-9]{1,3}/) { print substr($0, RSTART, RLENGTH) }'`;
    echo "Subnet: " $SUBNET;
    MATCHES=`docker network ls -q | xargs docker network inspect --format '{{.Name}};{{range .IPAM.Config }}{{ print .Subnet }},{{end}}' | grep $SUBNET`;
    for MATCH in ${MATCHES[@]}; do
        NAME=`echo $MATCH | cut -d ";" -f 1`
        echo "Docker network $NAME conflicts with $HOST. Subnet: $SUBNET";
    done;
    echo "";
done;