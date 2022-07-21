FROM registry.access.redhat.com/ubi8/ubi:latest as builder 

RUN dnf install -y openscap-scanner

ENV SUMMARY="A small script converting the OpenShift Compliance Operator raw results in HTML/web reports"

LABEL summary="${SUMMARY}"

COPY ./gen-html-reports.sh /

RUN chmod +x /gen-html-reports.sh

ENTRYPOINT ["/gen-html-reports.sh"]
