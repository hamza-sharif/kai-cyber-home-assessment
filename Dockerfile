
FROM golang:1.23-alpine

RUN apk add build-base

RUN mkdir /app

WORKDIR /app

ADD . /app

RUN GO111MODULE=on

COPY go.mod .

COPY go.sum .

RUN go build  cmd/main.go

CMD ["./main"]
