FROM yyz1989/rdf4j

VOLUME /data

# from compose args
ARG CONF_REPO
ARG CONF_BRANCH

ENV CONF_BASE=/opt/conf_base
ENV CONF_DIR=${CONF_BASE}/config/updatetriplestore

ENV WORKSPACE=/opt/VFB

ENV BUILD_OUTPUT=${WORKSPACE}/build.out

RUN apt-get -qq update || apt-get -qq update && \
apt-get -qq -y install git

RUN mkdir $CONF_BASE

###### REMOTE CONFIG ######
ARG CONF_BASE_TEMP=${CONF_BASE}/temp
RUN mkdir $CONF_BASE_TEMP
RUN cd "${CONF_BASE_TEMP}" && git clone --quiet ${CONF_REPO} && cd $(ls -d */|head -n 1) && git checkout ${CONF_BRANCH}
# copy inner project folder from temp to conf base
RUN cd "${CONF_BASE_TEMP}" && cd $(ls -d */|head -n 1) && cp -R . $CONF_BASE && cd $CONF_BASE && rm -r ${CONF_BASE_TEMP}

COPY process.sh /opt/VFB/process.sh
# COPY rdf4j_vfb.txt /opt/VFB/rdf4j_vfb.txt

RUN chmod +x /opt/VFB/*.sh

CMD ["/opt/VFB/process.sh"]
