# jupyterhub-deploy-docker

This is just another explanation for deployment of jupyterhub using prebuilt docker image [wiserain/jupyterhub](https://hub.docker.com/r/wiserain/jupyterhub/). You should first read the original [README](https://github.com/jupyterhub/jupyterhub-deploy-docker) before proceeding.

You can create a docker container by

```yml
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# JupyterHub docker-compose configuration file
version: "2"

services:
  <your-jupyterhub-service-name>:
    image: wiserain/jupyterhub:latest
    container_name: <your-jupyterhub-container-name>
    volumes:
      # Bind Docker socket on the host so we can connect to the daemon from
      # within the container
      - "/var/run/docker.sock:/var/run/docker.sock:rw"
      # Bind Docker volume on host for JupyterHub database and cookie secrets
      - "data:${DATA_VOLUME_CONTAINER}"
      - "</your/docker/jupyterhub>:/srv/jupyterhub"
    ports:
      - "443:443"
    environment:
      # All containers will join this network
      DOCKER_NETWORK_NAME: ${DOCKER_NETWORK_NAME}
      # JupyterHub will spawn this Notebook image for users
      DOCKER_NOTEBOOK_IMAGE: ${DOCKER_NOTEBOOK_IMAGE}
      # Notebook directory inside user image
      DOCKER_NOTEBOOK_DIR: ${DOCKER_NOTEBOOK_DIR}
      # Using this run command (optional)
      DOCKER_SPAWN_CMD: ${DOCKER_SPAWN_CMD}
      # Required to authenticate users using GitHub OAuth
      GITHUB_CLIENT_ID: <github_client_id>
      GITHUB_CLIENT_SECRET: <github_client_secret>
      OAUTH_CALLBACK_URL: https://<myhost.mydomain>/hub/oauth_callback
      # SSL certificates
      SSL_CERT: /srv/jupyterhub/secrets/jupyterhub.crt
      SSL_KEY: /srv/jupyterhub/secrets/jupyterhub.key

volumes:
  data:
    external:
      name: ${DATA_VOLUME_HOST}

networks:
  default:
    external:
      name: ${DOCKER_NETWORK_NAME}
```

only if the followings are prepared:

### [Setup GitHub Authentication](https://github.com/jupyterhub/jupyterhub-deploy-docker#setup-github-authentication)

```
GITHUB_CLIENT_ID=<github_client_id>
GITHUB_CLIENT_SECRET=<github_client_secret>
OAUTH_CALLBACK_URL=https://<myhost.mydomain>/hub/oauth_callback
```

### Create an isolated docker network/volume

```bash
docker network inspect $(DOCKER_NETWORK_NAME) >/dev/null 2>&1 || docker network create $(DOCKER_NETWORK_NAME)
docker volume inspect $(DATA_VOLUME_HOST) >/dev/null 2>&1 || docker volume create --name $(DATA_VOLUME_HOST)
```

### [Pull your Jupyter Notebook Image](https://github.com/jupyterhub/jupyterhub-deploy-docker#prepare-the-jupyter-notebook-image)

### User configuration files

```bash
/your/docker/jupyterhub/secrets/jupyterhub.crt
/your/docker/jupyterhub/secrets/jupyterhub.key
/your/docker/jupyterhub/userlist
/your/docker/jupyterhub/jupyterhub_config.py
```

All settings (volume mountings and port mappings) and variables should be consistent in both ```docker-compose.yml``` and ```jupyterhub_config.py```.
