#!/bin/bash

set -e

echo "process started"
echo "Start: vfb-pipeline-updatetriplestore"
echo "VFBTIME:"
date

## get remote configs
echo "Sourcing remote config"
source ${CONF_DIR}/config.env

VFBSETUP=${CONF_DIR}/rdf4j_vfb.txt
RDF4J=/opt/eclipse-rdf4j-${RDF4J_VERSION}
RDF4JSERVER=${SERVER}/rdf4j-server
DATA=/data

if [ `ls $DATA/*.ttl.gz | wc -l` -lt 1 ]; then echo "ERROR: No data in data directory! Aborting.. " && exit 1; fi
if [ "$EXPORT_KB_TO_OWL" = true ]; then
  if [ ! -f "$DATA/kb.owl.ttl.gz" ]; then echo "ERROR: KB is not among files to ingest! Aborting.. " && exit 1; fi
fi

echo 'Waiting for RDF4J server..'
until $(curl --output /dev/null --silent --head --fail ${RDF4JSERVER}); do
    printf '.'
    sleep 5
done

echo "connect "${RDF4JSERVER}|cat - ${VFBSETUP} > /tmp/out && mv /tmp/out ${VFBSETUP}
cat ${VFBSETUP}
cat ${VFBSETUP} | sh ${RDF4J}/bin/console.sh

ls -lh $DATA


echo "VFBTIME:"
date

cd $DATA

# The following for loop writes the load commands into the RDF4J setup script
for i in *.ttl.gz; do
    [ -f "$i" ] || break
    #arg="load "$DATA/$i" into ns:"$i
    echo $i
    #awk -v line="$arg" '/open vfb/ { print; print line; next }1' $WS/rdf4j.txt > $WS/tmp.txt
    #cp $WS/tmp.txt $WS/rdf4j.txt
    URI="%3Chttp%3A%2F%2Fvirtualflybrain.org%2Fdata%2FVFB%2FOWL%2F${i}%3E"
    echo "curl -v --retry 5 --retry-delay 10 -X POST -H \"Content-type: text/turtle\" --data-binary @$i ${RDF4JSERVER}/repositories/${REPO_NAME}/statements?context=${URI}"
    curl -v --retry 5 --retry-delay 10 -X POST -H "Content-type: text/turtle" --data-binary @$i ${RDF4JSERVER}/repositories/${REPO_NAME}/statements?context=${URI} || exit 1
    echo "VFBTIME:"
    date
    sleep 5
done


echo "End: vfb-pipeline-updatetriplestore"
echo "VFBTIME:"
date
echo "process complete"
