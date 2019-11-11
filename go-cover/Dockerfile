FROM golang:1.13

LABEL "repository"="https://github.com/flybits/actions"
LABEL "homepage"="https://github.com/flybits/actions/tree/master/go-cover"
LABEL "maintainer"="Milad Irannejad <milad.irannejad@flybits.com>"

# Install Code Climate test-reporter
RUN wget -q -O /usr/local/bin/test-reporter https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 && \
    chmod 755 /usr/local/bin/test-reporter

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
