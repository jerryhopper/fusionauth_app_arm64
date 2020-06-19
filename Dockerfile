
FROM arm64v8/debian:buster-slim as fusionauthbuild

ARG FUSIONAUTH_VERSION
RUN echo "FusionAuth version :  $FUSIONAUTH_VERSION"


###### Install stuff we need and then cleanup cache #################
RUN apt update && apt install unzip curl -y

###### Get and install FusionAuth App Bundle ########################
#ENV FUSIONAUTH_VERSION=1.17.2
RUN curl -Sk --progress-bar https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth/${FUSIONAUTH_VERSION}/fusionauth-app-${FUSIONAUTH_VERSION}.zip -o fusionauth-app.zip \
  && mkdir -p /usr/local/fusionauth/fusionauth-app \
  && unzip -nq fusionauth-app.zip -d /usr/local/fusionauth






FROM arm64v8/debian:buster-slim

COPY --from=javabuild /jlinked /opt/openjdk

RUN groupadd fusionauth
RUN useradd -r -s /bin/sh -g fusionauth -u 1001 fusionauth

COPY --chown=fusionauth:fusionauth --from=jerryhopper/fusionauth-java-arm64 /usr/local/fusionauth /usr/local/fusionauth


ENV JAVA_HOME=/opt/openjdk/
ENV PATH=$PATH:$JAVA_HOME/bin

###### Start FusionAuth App #########################################
LABEL description="Create an image running FusionAuth App. Installs FusionAuth App"
LABEL maintainer="FusionAuth-community <hopper.jerry@gmail.com>"
EXPOSE 9011
USER fusionauth
ENV FUSIONAUTH_USE_GLOBAL_JAVA=1
CMD ["/usr/local/fusionauth/fusionauth-app/apache-tomcat/bin/catalina.sh", "run"]
