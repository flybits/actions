FROM alpine:3.20

LABEL "repository"="https://github.com/flybits/actions"
LABEL "homepage"="https://github.com/flybits/actions/tree/master/semver"
LABEL "maintainer"="Milad Irannejad <milad.irannejad@flybits.com>"

RUN apk add --no-cache bash git jq

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
