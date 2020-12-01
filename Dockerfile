FROM ubuntu:18.04

### 2. Get Java, Python and all required system libraries (version control etc)
ENV JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk"
#ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN apt-get update && apt-get install -y software-properties-common && apt-get upgrade -y \
 && apt-get install -y software-properties-common \
  build-essential git \
  openjdk-8-jre openjdk-8-jdk

VOLUME /data

ENV WORKSPACE=/opt/VFB
ENV SERVER=http://192.168.0.1:8080
ENV RDF4J_VERSION=3.4.4
ENV RDF4J_SDK_DIR=${WORKSPACE}/rdf4j
ENV RDF4J_SDK=https://www.eclipse.org/downloads/download.php?file=/rdf4j/eclipse-rdf4j-${RDF4J_VERSION}-sdk.zip\&r=1

ENV BUILD_OUTPUT=${WORKSPACE}/build.out

RUN apt-get -qq update && apt-get -qq -y install curl wget zip unzip
RUN mkdir ${WORKSPACE}
RUN wget ${RDF4J_SDK} -O ${WORKSPACE}/rdf4j-sdk.zip && unzip -d ${WORKSPACE}/rdf4j-sdk ${WORKSPACE}/rdf4j-sdk.zip
RUN ls -l ${WORKSPACE} && mv ${WORKSPACE}/rdf4j-sdk/eclipse-rdf4j-${RDF4J_VERSION} ${RDF4J_SDK_DIR}
RUN ls -l ${RDF4J_SDK_DIR}
COPY process.sh /opt/VFB/process.sh
COPY rdf4j_vfb.txt /opt/VFB/rdf4j_vfb.txt

RUN chmod +x /opt/VFB/*.sh

CMD ["/opt/VFB/process.sh"]
