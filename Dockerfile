FROM finchsec/kali:base as builder
# hadolint ignore=DL3008
RUN apt-get update && \
        apt-get install git -y wget gcc python3-pip --no-install-recommends
RUN git clone https://github.com/D3Ext/WEF/
WORKDIR /WEF/
RUN bash src/setup.sh

FROM finchsec/kali:base
LABEL org.opencontainers.image.authors="thomas@finchsec.com"
ENV DISPLAY :0

# Copy files from builder
COPY --from=builder /opt/wef /opt/wef
COPY --from=builder /WEF/wef /opt/wef/wef
COPY wef.sh /usr/local/sbin/wef
RUN chmod +x /usr/local/sbin/wef && \
    chmod +x /opt/wef/wef

# hadolint ignore=DL3008,DL3015,SC2046,DL3005
RUN apt-get update && \
    apt-get dist-upgrade -y && \
	echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/force-unsafe-io && \
    apt-get install hcxdumptool dnsmasq php hashcat-utils hcxtools pixiewps bully \
                    mdk4 aircrack-ng hostapd wget reaver moreutils lshw \
                    xterm macchanger pciutils usbutils kmod john hostapd-wpe \
                    hashcat pocl-opencl-icd lighttpd iptables python3-jinja2 \
                    isc-dhcp-server curl bsdextrautils jq psmisc systemctl \
                    airgraph-ng -y && \
        ln -s /usr/lib/hashcat-utils/cap2hccapx.bin /usr/bin/cap2hccapx && \
        apt-get autoremove -y && \
		apt-get autoclean && \
		rm -rf /var/lib/dpkg/status-old /etc/dpkg/dpkg.cfg.d/force-unsafe-io /var/lib/apt/lists/*