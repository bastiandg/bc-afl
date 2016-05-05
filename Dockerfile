# graphviz build
#

FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq && apt-get install --no-install-recommends -y texinfo build-essential ca-certificates automake autoconf byacc flex wget
RUN adduser --uid 1000 builder
COPY start.sh /home/builder/start.sh
COPY entry.sh /entry.sh
RUN chmod +x /entry.sh /home/builder/start.sh
RUN mkdir /tmp/afl
RUN wget -O /tmp/afl/afl.tgz http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
RUN tar xvzf /tmp/afl/afl.tgz -C /tmp/afl/
RUN rm /tmp/afl/afl.tgz
RUN cd /tmp/afl/afl* && make && make install

ENTRYPOINT ["/entry.sh"]
CMD ["bc"]
