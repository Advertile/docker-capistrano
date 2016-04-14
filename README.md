# Docker Image with Capistrano

As the base image [`ruby:2.3.0`](https://hub.docker.com/r/library/ruby/tags/) is used.

[![](https://badge.imagelayers.io/advertile/docker-capistrano:latest.svg)](https://imagelayers.io/?images=advertile/docker-capistrano:latest 'Get your own badge on imagelayers.io')

## Usage Example

`Dockerfile`:

```
# Copy .ssh directory required to deploy over SSH
# This direcotry might contain:
# - config
# - known_hosts
COPY ./config/.ssh /root/.ssh

# Copy required project files
COPY ./.git /usr/src/app/.git
COPY ./config /usr/src/app/config
COPY ./Capfile /usr/src/app/Capfile

# Add deploy script
COPY ./scripts/deploy.sh /usr/bin/deploy
```

An example `scripts/deploy.sh` script used for continous integration is presented below:

```bash
#!/bin/bash

# Check if the CI_BRANCH environment variable is set
if [ -z $CI_BRANCH ]; then
  echo 'No CI_BRANCH environment variable specified'
  # Specify to which environment capistrano should deploy
  capistrano_deployment_environment='staging'
  echo "Fall back to default value: $capistrano_deployment_environment"
else
  capistrano_deployment_environment=$CI_BRANCH
  echo "Using specified environment value: $capistrano_deployment_environment"
fi

# Create default ssh key from variable
mkdir -p "$HOME/.ssh"
echo -e $CAPISTRANO_PRIVATE_SSH_KEY > $HOME/.ssh/id_rsa
chmod 600 $HOME/.ssh/id_rsa

# Start the ssh-agent
# Required because we use a jump host
eval $(ssh-agent) > /dev/null

# Add the ~/.ssh/rd_rsa key to the agent
# Required because we use a jump host
ssh-add > /dev/null 2>&1

# Copy the shared build to project directory
cp -r /project_name /usr/src/app/build

# Deploy application
cap $capistrano_deployment_environment deploy

```
