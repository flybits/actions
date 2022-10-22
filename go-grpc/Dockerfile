FROM golang:1.19

LABEL "repository"="https://github.com/flybits/actions"
LABEL "homepage"="https://github.com/flybits/actions/tree/master/go-grpc"
LABEL "maintainer"="Milad Irannejad <milad.irannejad@flybits.com>"

# Install required tools
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      ca-certificates bash make git curl jq unzip && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Install protoc
RUN protoc_release=${protoc_release:-$(curl -s https://api.github.com/repos/protocolbuffers/protobuf/releases/latest | jq -r '.tag_name')} && \
    protoc_version=${protoc_release#v} && \
    curl -fsSL "https://github.com/protocolbuffers/protobuf/releases/download/${protoc_release}/protoc-${protoc_version}-linux-x86_64.zip" -o protoc.zip && \
    unzip -o protoc.zip -d /usr/local bin/protoc && \
    unzip -o protoc.zip -d /usr/local 'include/*' && \
    rm -f protoc.zip

# Install gRPC tools for Go
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
