FROM alpine:3.14

RUN apk add --no-cache curl jq

COPY ./src/jwks-merge.sh jwks-merge.sh

RUN chmod +x ./jwks-merge.sh

CMD ["./jwks-merge.sh"]
