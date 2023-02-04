# WEF-Docker-private

Docker for https://github.com/D3Ext/WEF using Kali as a base. Rebuilt daily.

## Running

`sudo docker run --rm -it --privileged --net=host --pid=host -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix finchsec/wef`
