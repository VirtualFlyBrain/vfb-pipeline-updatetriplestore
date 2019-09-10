#!/bin/bash

set -e

echo "Set up VFB"
VFBSETUP=${WORKSPACE}/rdf4j_vfb.txt
RDF4J=/opt/eclipse-rdf4j-${RDF4J_VERSION}
RDF4JSERVER=${SERVER}/rdf4j-server
DATA=/data

echo 'Waiting for RDF4J server..'
until $(curl --output /dev/null --silent --head --fail ${RDF4JSERVER}); do
    printf '.'
    sleep 5
done

echo "connect "${RDF4JSERVER}|cat - ${VFBSETUP} > /tmp/out && mv /tmp/out ${VFBSETUP}
cat ${VFBSETUP}
cat ${VFBSETUP} | sh ${RDF4J}/bin/console.sh

ls -l $DATA

cd $DATA

# The following for loop writes the load commands into the RDF4J setup script
for i in *.ttl.gz; do
    [ -f "$i" ] || break
    #arg="load "$DATA/$i" into ns:"$i
    echo $i
    #awk -v line="$arg" '/open vfb/ { print; print line; next }1' $WS/rdf4j.txt > $WS/tmp.txt
    #cp $WS/tmp.txt $WS/rdf4j.txt
    echo "curl -v --retry 5 --retry-delay 10 -X POST -H \"Content-type: text/turtle\" --data-binary @$i ${RDF4JSERVER}/repositories/vfb/statements?context=_:$i"
    curl -v --retry 5 --retry-delay 10 -X POST -H "Content-type: text/turtle" --data-binary @$i ${RDF4JSERVER}/repositories/vfb/statements?context=_:$i || exit 1
  sleep 5
done

echo "process complete"
