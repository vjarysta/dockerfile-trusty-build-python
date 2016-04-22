FROM infopen/jenkins-slave-ubuntu-trusty-build-deb:0.2.0
MAINTAINER Alexandre Chaussier <a.chaussier@infopen.pro>

# Install packages to manage python jobs
RUN apt-get update && \
    apt-get install -y  python3 \
                        python-pip \
                        python-virtualenv \
                        libpython2.7-dev \
                        libpython3.4-dev
