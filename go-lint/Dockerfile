FROM golang:1.13

LABEL "repository"="https://github.com/flybits/actions"
LABEL "homepage"="https://github.com/flybits/actions/tree/master/go-lint"
LABEL "maintainer"="Milad Irannejad <milad.irannejad@flybits.com>"

# Install golangci-lint (https://github.com/golangci/golangci-lint)
RUN wget -qO - https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s latest

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
