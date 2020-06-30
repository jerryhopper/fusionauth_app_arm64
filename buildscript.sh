#!/bin/bash


# grab latest version
REMOTEVERSION="$(curl -s 'https://hub.docker.com/v2/repositories/fusionauth/fusionauth-app/tags/?page_size=25&page=1' | jq -r '.results[1].name')"

# if no local version available, set one.
if [ ! -f /root/fusionauth.build.version ]; then
  REMOTEVERSION="1.17.2"
else
  LOCALVERSION="$(</root/fusionauth.build.version)"
fi


# VersionCheck
if [ "$REMOTEVERSION" == "$LOCALVERSION" ] ; then
  echo "remote ($REMOTEVERSION) local ($LOCALVERSION) equal."
  exit
else
  echo "remote ($REMOTEVERSION) & local ($LOCALVERSION) not equal."
fi

# Clean the local docker image, so we have everything fresh.
docker system prune -a -f

# Build the container from git
docker build --build-arg FUSIONAUTH_VERSION=$REMOTEVERSION https://github.com/jerryhopper/fusionauth_app_arm64.git -t jerryhopper/fusionauth-app-arm64:$REMOTEVERSION


# Stop if fusionauth-app-test container is running.
docker stop fusionauth-app-test
# Remove if fusionauth-app-test container exists.
docker rm  fusionauth-app-test
# Run the container
docker run -d -p 9011:9011 --name fusionauth-app-test jerryhopper/fusionauth-app-arm64:$REMOTEVERSION
sleep 20

# Check if FA is running.
RES="$(curl -sL http://localhost:9011/api/status|grep 'title>Maintenance')"
if [ "$RES" == "" ]; then
  echo "test failed"
  docker stop fusionauth-app-test
  docker rm  fusionauth-app-test
  exit
fi

#curl -sL http://localhost:9011/api/status|grep  'js?version='
docker stop fusionauth-app-test
docker rm  fusionauth-app-test



# Push the container to dockerhub
docker push jerryhopper/fusionauth-app-arm64:$REMOTEVERSION

# Build again, but latest version.
docker build --build-arg FUSIONAUTH_VERSION=$REMOTEVERSION https://github.com/jerryhopper/fusionauth_app_arm64.git -t jerryhopper/fusionauth-app-arm64:latest
# Push the latest tag to dockerhub 
docker push jerryhopper/fusionauth-app-arm64:latest

# Write the version to local file.
echo "$REMOTEVERSION">/root/fusionauth.build.version


