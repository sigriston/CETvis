#!/bin/sh

# Add R packages repo
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
cat >> /etc/apt/sources.list <<EOF
deb http://www.vps.fmvz.usp.br/CRAN/bin/linux/ubuntu precise/
EOF
apt-get update

# Install R
apt-get -y install r-base libcurl4-openssl-dev

# Install Shiny
R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"

# Install ggmap
R -e "install.packages('ggmap', repos='http://cran.rstudio.com/')"

# Install gridExtra
R -e "install.packages('gridExtra', repos='http://cran.rstudio.com/')"

# Install devtools
R -e "install.packages('devtools', repos='http://cran.rstudio.com/')"

# Install rCharts
R -e "options(repos=structure(c(CRAN='http://cran.rstudio.com/')));devtools::install_github('ramnathv/rCharts')"

# Install Shiny Server
SHINY_PKG='shiny-server-1.0.0.42-amd64.deb'
SHINY_URL="http://download3.rstudio.org/ubuntu-12.04/x86_64/${SHINY_PKG}"
apt-get -y install gdebi-core
mkdir -p /tmp/shiny-server
wget "${SHINY_URL}" -P /tmp/shiny-server
gdebi -n "/tmp/shiny-server/${SHINY_PKG}"

# Configure Shiny Server
service shiny-server stop
cp /tmp/shiny-default.config /opt/shiny-server/config/default.config
service shiny-server start
