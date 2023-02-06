# Wireless Exploitation Framework (WEF)

Docker for https://github.com/D3Ext/WEF using Kali as a base. Rebuilt daily.

## Pulling

### DockerHub

[![Docker build and upload](https://github.com/FinchSec/WEF-docker/actions/workflows/docker.yml/badge.svg?event=push)](https://github.com/FinchSec/WEF-docker/actions/workflows/docker.yml)

URL: https://hub.docker.com/r/finchsec/wef

`sudo docker pull finchsec/wef`

## Running

`sudo docker run --rm -it --privileged --net=host --pid=host -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix finchsec/wef`
