FROM ubuntu:latest

RUN <<EOF
apt-get update
apt-get -y upgrade
apt-get -y install net-tools curl jq yq wget gpg iputils-ping iputils-tracepath ethtool dnsutils iperf iperf3 htop iftop nmap ncat tcpdump traceroute tcptraceroute krb5-user krb5-pkinit msktutil tshark 
EOF

RUN <<EOF
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg
curl https://packages.microsoft.com/config/ubuntu/24.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB3E94ADBE1229CF
apt-get update
ACCEPT_EULA=Y apt-get -y install mssql-tools18 unixodbc-dev
EOF

COPY files/tcping /usr/local/bin/tcping

ENV HOSTNAME=sqlcmd
ENV PATH="$PATH:/opt/mssql-tools18/bin"
USER root
WORKDIR /root

# Fix permissions for OpenShift and tshark
RUN chmod -R g=u /root

CMD ["bash"]