# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyterhub/jupyterhub-onbuild:0.7.2

# Install dockerspawner and its dependencies
RUN /opt/conda/bin/pip install \
    oauthenticator==0.5.* \
    dockerspawner==0.7.*

# install docker on the jupyterhub container
RUN wget https://get.docker.com -q -O /tmp/getdocker && \
    chmod +x /tmp/getdocker && \
    sh /tmp/getdocker

CMD jupyterhub -f /srv/jupyterhub/jupyterhub_config.py
