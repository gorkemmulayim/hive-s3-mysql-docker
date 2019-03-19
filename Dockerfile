FROM ubuntu

RUN apt-get update
RUN apt-get install -y wget openjdk-8-jre

ARG HADOOP_VERSION=3.2.0
ARG HIVE_VERSION=3.1.1
ARG MYSQL_CONNECTOR_VERSION=8.0.15

RUN wget http://ftp.itu.edu.tr/Mirror/Apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
RUN mkdir /hadoop
RUN tar -xvzf hadoop-${HADOOP_VERSION}.tar.gz -C /hadoop --strip-components 1
RUN rm hadoop-${HADOOP_VERSION}.tar.gz

RUN wget http://ftp.itu.edu.tr/Mirror/Apache/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz
RUN mkdir /hive
RUN tar -xvzf apache-hive-${HIVE_VERSION}-bin.tar.gz -C /hive --strip-components 1
RUN rm apache-hive-${HIVE_VERSION}-bin.tar.gz

RUN wget http://central.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar
RUN mv mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar /hive/lib

COPY hive-site.xml /hive/conf
COPY hive-log4j2.properties /hive/conf

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/hadoop
ENV HIVE_HOME=/hive
ENV PATH=$PATH:$HADOOP_HOME/bin
ENV PATH=$PATH:$HIVE_HOME/bin
ENV HIVE_CONF_DIR=/hive/conf

VOLUME /hive/logs
EXPOSE 9083
EXPOSE 10000
EXPOSE 10002

CMD hive --service metastore & hive --service hiveserver2
