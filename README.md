# Wireless Exploitation Framework (WEF)

Docker for https://github.com/D3Ext/WEF using Kali as a base. Rebuilt daily.

## DockerHub

DockerHub: https://hub.docker.com/r/finchsec/wef

## Running

`sudo docker run --rm -it --privileged --net=host --pid=host -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix finchsec/wef`
