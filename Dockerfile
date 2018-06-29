FROM yyz1989/rdf4j

VOLUME /data

ENV WORKSPACE=/opt/VFB
ENV SERVER=http://192.168.0.1:8080

ENV BUILD_OUTPUT=${WORKSPACE}/build.out

COPY process.sh /opt/VFB/process.sh
COPY rdf4j_vfb.txt /opt/VFB/rdf4j_vfb.txt

RUN chmod +x /opt/VFB/*.sh

CMD ["/opt/VFB/process.sh"]
