FROM docker.io/library/golang:1.11.2 AS builder
RUN  curl https://glide.sh/get | sh
WORKDIR /go/src/github.com/saidie/speedtest_exporter
RUN git clone https://github.com/saidie/speedtest_exporter -b prototype .
RUN export CGO_ENABLED=0 GOOS=linux \
 && sed '/oracle/d' -i Makefile \
 && go get -d github.com/dchest/uniuri \
 && make init build \
 && install -m 0755 -o 0 -g 0 speedtest_exporter /bin/speedtest_exporter

FROM scratch
COPY --from=builder /bin/speedtest_exporter /bin/speedtest_exporter
ENTRYPOINT ["speedtest_exporter"]
CMD ["-log.level=debug"]
