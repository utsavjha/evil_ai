FROM python:2.7-slim-stretch

RUN apt-get update && \
    apt-get install -y build-essential \
      unzip

# Set up samples

WORKDIR /samples

COPY samples/ .

RUN unzip -P infected666s CLEAN_PDF_9000_files.zip; exit 0
RUN unzip -P infected666s MALWARE_PDF_CVEsorted_173_files.zip; exit 0      

# Install Sophos
WORKDIR /tmp

COPY install/ install/

RUN install/install.sh /sophos --automatic --acceptlicence --autostart=true --enableOnBoot=true --update-free=True; exit 0

WORKDIR /sophos

RUN ./bin/savupdate

CMD bash
