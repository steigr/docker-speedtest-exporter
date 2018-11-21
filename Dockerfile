FROM docker.io/library/golang:1.11.2 AS builder
RUN go get -d github.com/nlamirault/speedtest_exporter
WORKDIR /go/src/github.com/nlamirault/speedtest_exporter
ENV CGO_ENABLED=1 GOOS=linux GOARCH=x86_64
RUN go get github.com/nlamirault/speedtest_exporter

FROM scratch
COPY --from=builder /go/bin/speedtest_exporter /bin/speedtest_exporter
ENTRYPOINT ["speedtest_exporter"]
CMD ["-log.level=debug"]
