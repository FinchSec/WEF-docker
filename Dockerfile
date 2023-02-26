FROM finchsec/kali:base as builder
# hadolint ignore=DL3008
RUN apt-get update && \
        apt-get install git -y wget gcc python3-pip --no-install-recommends
RUN git clone https://github.com/D3Ext/WEF/
WORKDIR /WEF/
RUN bash setup.sh && \
        rm /opt/wef/update.sh /opt/wef/uninstaller.sh

FROM finchsec/kali:base
LABEL org.opencontainers.image.authors="thomas@finchsec.com"
ENV DISPLAY :0

# Copy files from builder
COPY --from=builder /WEF/requirements.txt /opt/wef/
COPY --from=builder /opt/wef /opt/wef
COPY wef.sh /usr/local/sbin/wef
RUN chmod +x /usr/local/sbin/wef

# Install python
# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install python3-venv python3-pip -y --no-install-recommends && \
	rm -rf /var/lib/dpkg/status-old /var/lib/apt/lists/*

# Add python venv
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# hadolint ignore=DL3008,DL3015
RUN apt-get update && \
	echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/force-unsafe-io && \
    apt-get install hcxdumptool dnsmasq php hashcat-utils hcxtools pixiewps bully \
                    mdk4 aircrack-ng hostapd wget reaver libbluetooth-dev moreutils \
                    xterm macchanger crackle python3-bluez pciutils usbutils kmod \
			        $([ "$(uname -m)" = "x86_64" ] && echo intel-opencl-icd) \
                    echo hashcat pocl-opencl-icd -y && \
        ln -s /usr/lib/hashcat-utils/cap2hccapx.bin /usr/bin/cap2hccapx && \
        grep -v -E '^pybluez$' /opt/wef/requirements.txt > /tmp/requirements.txt && \
        pip install -r /tmp/requirements.txt && \
		apt-get autoclean && \
		rm -rf /var/lib/dpkg/status-old /etc/dpkg/dpkg.cfg.d/force-unsafe-io /var/lib/apt/lists/*