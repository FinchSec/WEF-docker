# hadolint ignore=DL3007
FROM kalilinux/kali-rolling:latest as builder
# hadolint ignore=DL3005,DL3008
RUN apt-get update && \
    apt-get dist-upgrade -y && \
        apt-get install git -y wget gcc python3-pip --no-install-recommends
RUN git clone https://github.com/D3Ext/WEF/
WORKDIR /WEF/
RUN bash setup.sh && \
        rm /opt/wef/update.sh /opt/wef/uninstaller.sh

# hadolint ignore=DL3007
FROM kalilinux/kali-rolling:latest
LABEL org.opencontainers.image.authors="thomas@finchsec.com"
ENV LANG en_US.UTF-8
ENV DISPLAY :0
# hadolint ignore=DL3005,DL3008,DL3015,DL4006
RUN apt-get update && \
	echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/force-unsafe-io && \
	apt-get dist-upgrade -y && \
		apt-get install locales -y && \
		echo "${LANG}" | tr '.' ' ' > /etc/locale.gen && locale-gen && \
		DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata && \
		apt-get install debconf-utils -y && \
		echo "locales locales/default_environment_locale select ${LANG}" | debconf-set-selections && \
		echo "locales locales/locales_to_be_generated multiselect ${LANG} UTF-8" | debconf-set-selections && \
		DEBIAN_FRONTEND=noninteractive apt-get install -y locales && \
		apt-get purge debconf-utils -y && \
		apt-get autoclean && \
		rm -rf /var/lib/dpkg/status-old /etc/dpkg/dpkg.cfg.d/force-unsafe-io /var/lib/apt/lists/*

COPY --from=builder /WEF/requirements.txt /opt/wef/
COPY --from=builder /opt/wef /opt/wef
COPY wef.sh /usr/local/sbin/wef
RUN chmod +x /usr/local/sbin/wef
# hadolint ignore=DL3008,DL3015
RUN apt-get update && \
	echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/force-unsafe-io && \
    apt-get dist-upgrade -y && \
    apt-get install hashcat hcxdumptool dnsmasq hostapd php hashcat-utils hcxtools pixiewps bully \
                    mdk4 aircrack-ng hostapd wget reaver libbluetooth-dev moreutils net-tools \
                    xterm macchanger crackle -y && \
        ln -s /usr/lib/hashcat-utils/cap2hccapx.bin /usr/bin/cap2hccapx && \
		apt-get autoclean && \
		rm -rf /var/lib/dpkg/status-old /etc/dpkg/dpkg.cfg.d/force-unsafe-io /var/lib/apt/lists/*
RUN apt-get update && \
	echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/force-unsafe-io && \
    apt-get install python3 python3-pip python3-bluez python3-requests python3-serial python3-crcmod \
                python3-halo python3-wrapt python3-intelhex python3-ecdsa python3-pycryptodome \
                python3-pwntools python3-spinners python3-termcolor python3-six python3-tqdm \
                python3-click -y && \
        grep -v -E '^(pycryptodome|pyserial|pybluez|requests|pwntools)$' /opt/wef/requirements.txt > /tmp/requirements.txt && \
        pip3 install -r /tmp/requirements.txt && \
        apt-get remove python3-pip -y && \
        apt-get autoremove -y && \
        apt-get autoclean && \
		rm -rf /var/lib/dpkg/status-old /etc/dpkg/dpkg.cfg.d/force-unsafe-io /var/lib/apt/lists/*