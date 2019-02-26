FROM arm32v7/ubuntu:xenial

RUN sh -c "apt-get update && \
           apt-get install -y wget bzip2 && \
           rm -rf /var/lib/apt/lists/* "

COPY ./update.sh /
CMD ["/bin/bash"]
