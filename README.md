# FusionAuth_app_arm64


## Containers! Containers! Containers!

FusionAuth loves containers, even on Arm64!

This is the Fusionauth Application for Arm64, Not officially supported but maintained by @jerryhopper.

the source for this container is available in this repo : https://github.com/jerryhopper/fusionauth_app_arm64

More info & documentation on the original product :  [fusionauth.io](https://fusionauth.io)




## Credits
- [@robotdan](https://github.com/robotdan) Thank you for the initial x64 docker-container and feedback.
- [@arslanakhtar61](https://github.com/arslanakhtar61) Thank you for initial testing.

<br>

## Docker


### Docker Compose

The reference [docker-compose.yml](https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/docker-compose.yml) defaults to use the database as the User search engine.

In order to install with Elasticsearch as the User search engine, include the reference  [docker-compose.override.yml](https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/docker-compose.override.yml).

Review our [Docker Install Guide](https://fusionauth.io/docs/v1/tech/installation-guide/docker) for additional assistance.

```bash
curl -o docker-compose.yml https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/docker-compose.yml
# Uncomment the following line to install and configure Elasticsearch as the User search engine
# curl -o docker-compose.override.yml https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/docker-compose.override.yml
curl -o .env https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/.env
docker-compose up
```

### Docker Images

Docker images are available on [Docker Hub](https://hub.docker.com/u/jerryhopper/)

FusionAuth App
```bash
docker pull jerryhopper/fusionauth-app
```

<br>
