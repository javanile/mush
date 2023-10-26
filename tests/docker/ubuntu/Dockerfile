FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl git tree

RUN useradd -m -s /bin/bash testuser

USER testuser
