# THIS SHOULD HAVE THE ANTIVIRUS PACKAGE ALONG WITH PDF-CHECKER
FROM python:2.7

RUN apt-get update && \
    apt-get install curl perl && \
    apt-get clean

RUN mkdir -p mimicus && \
    mkdir -p pdf_malware_parser

COPY . .

RUN /startup.sh

CMD ["sleep", "50000"]
