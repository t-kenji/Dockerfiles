#
# Dockerfile for Nginx Container.
#

# Pull base image.
FROM nginx:mainline-alpine

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root
ENV LANG=en_US.utf8

# Install packages.
RUN apk update
RUN apk add --no-cache \
            vim \
            bash \
            $NULL

# Define working directory.
WORKDIR $HOME

# Port forwarding target.
EXPOSE 80 443

# Define default command.
CMD ["nginx", "-g", "daemon off;"]
