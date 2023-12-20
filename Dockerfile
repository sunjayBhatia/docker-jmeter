# inspired by https://github.com/hauptmedia/docker-jmeter  and
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile
FROM alpine:3.12

ARG JMETER_VERSION="5.5"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_CUSTOM_PLUGINS_FOLDER /plugins
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

RUN apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre curl unzip bash \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

# cmd runner and plugin manager
ENV CMD_RUNNER_URL https://repo1.maven.org/maven2/kg/apc/cmdrunner/2.2.1/cmdrunner-2.2.1.jar
RUN cd /opt/apache-jmeter-${JMETER_VERSION}/lib && \
    curl -L -O ${CMD_RUNNER_URL}

ENV PLUGIN_MANAGER_URL https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/1.6/jmeter-plugins-manager-1.6.jar
RUN cd /opt/apache-jmeter-${JMETER_VERSION}/lib/ext && \
    curl -L -O ${PLUGIN_MANAGER_URL}

# install plugin
RUN cd /opt/apache-jmeter-${JMETER_VERSION}/lib && \
    java -jar cmdrunner-2.2.1.jar --tool org.jmeterplugins.repository.PluginManagerCMD install jpgc-casutg

# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /

WORKDIR	${JMETER_HOME}

ENTRYPOINT ["/entrypoint.sh"]
