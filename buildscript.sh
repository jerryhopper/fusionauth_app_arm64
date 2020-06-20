#!/bin/bash



REMOTEVERSION="$(curl -s 'https://hub.docker.com/v2/repositories/fusionauth/fusionauth-app/tags/?page_size=25&page=1' | jq -r '.results[1].name')"

if [ ! -f /tmp/fusionauth.build.version ]; then
  REMOTEVERSION="1.17.2"
else
  LOCALVERSION="$(</tmp/fusionauth.build.version)"
fi



if [ "$REMOTEVERSION" == "$LOCALVERSION" ] ; then
  echo "remote ($REMOTEVERSION) local ($LOCALVERSION) equal."
  exit
else
  echo "remote ($REMOTEVERSION) & local ($LOCALVERSION) not equal."
fi

docker system prune -a -f

docker build --build-arg FUSIONAUTH_VERSION=$REMOTEVERSION https://github.com/jerryhopper/fusionauth_app_arm64.git -t jerryhopper/fusionauth-app-arm64:$REMOTEVERSION

#docker tag fusionauth-app-arm64:latest jerryhopper/fusionauth-app-arm64:$REMOTEVERSION
docker push jerryhopper/fusionauth-app-arm64:$REMOTEVERSION

docker build --build-arg FUSIONAUTH_VERSION=$REMOTEVERSION https://github.com/jerryhopper/fusionauth_app_arm64.git -t jerryhopper/fusionauth-app-arm64:latest
#docker tag fusionauth-app-arm64:$REMOTEVERSION jerryhopper/fusionauth-app-arm64:latest
docker push jerryhopper/fusionauth-app-arm64:latest

echo "$REMOTEVERSION">/tmp/fusionauth.build.version









