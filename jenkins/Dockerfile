# Jenkins LTS that is ready to use right after start:
#  - Docker CLI inside, so the pipeline can run docker commands
#    (the Docker daemon is the one on the host, see /var/run/docker.sock in docker-compose.yml)
#  - plugins are installed during the image build
#  - the job Zhumakan_Zhanadil_DevOps is created from job-config.xml
FROM jenkins/jenkins:lts-jdk21

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl procps \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
       > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce-cli docker-buildx-plugin \
    && rm -rf /var/lib/apt/lists/*

# Pipeline, Git and two views of the pipeline stages
RUN jenkins-plugin-cli --plugins workflow-aggregator git pipeline-stage-view pipeline-graph-view

# files from /usr/share/jenkins/ref are copied to JENKINS_HOME on the first start
COPY job-config.xml /usr/share/jenkins/ref/jobs/Zhumakan_Zhanadil_DevOps/config.xml

# no setup wizard: plugins and the job are already prepared above
# (local lab only, Jenkins opens without a login)
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
