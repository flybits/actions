FROM alpine:3.10

LABEL "repository"="https://github.com/flybits/actions"
LABEL "homepage"="https://github.com/flybits/actions/tree/master/shellcheck"
LABEL "maintainer"="Milad Irannejad <milad.irannejad@flybits.com>"

# Install shellcheck (https://github.com/koalaman/shellcheck)
RUN wget -q -O shellcheck.tar.xz https://storage.googleapis.com/shellcheck/shellcheck-stable.linux.x86_64.tar.xz && \
    tar --strip-components=1 -C /usr/local/bin/ --xz -xvf shellcheck.tar.xz shellcheck-stable/shellcheck && \
    rm -rf shellcheck.tar.xz && \
    shellcheck --version

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
