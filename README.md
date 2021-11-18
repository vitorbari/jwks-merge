# jwks-merge

![publish-docker-image](https://github.com/vitorbari/jwks-merge/actions/workflows/publish-docker-image.yml/badge.svg)

- [Introduction](#introduction)
- [Usage](#usage)
  * [Kubernetes](#kubernetes)
  * [Docker](#docker)
  * [Locally](#locally)
- [Limitations](#limitations)
- [Notes](#notes)

## Introduction

[JWKS](https://datatracker.ietf.org/doc/html/rfc7517#section-5) is a set of keys containing the public keys that should be used to verify any JWT issued by an authorization server.

If an application needs to verify a JWT that was issued by **one of many** trusted authorization servers, then `jwks-merge` can simplify the process by merging and providing a single JWKS.

## Usage

The best usage of `jwks-merge` is when exposing the merged JWKS file via a webserver, this is especially easy in Kubernetes with the provided [helm-charts](#kubernetes).

If you just need to merge some JWKS but do not care about exposing the file, you can probably just run the [script locally](#locally), or just see [how it is done](./src/jwks-merge.sh).

The application expects two environment variables:

| Env         | Description                                 | Examples                                                                                        |
|-------------|---------------------------------------------|-------------------------------------------------------------------------------------------------|
| `JWKS_URLS` | Space-separated list of JWKS URLs           | `https://vitorbari-test.eu.auth0.com/.well-known/jwks.json https://appleid.apple.com/auth/keys` |
| `DEST_JWKS` | Destination path for the produced JWKS file | `/dev/stdout`, `/var/local/jwks.json`                                                           |

### Kubernetes

```bash
$ helm repo add jwks-merge https://vitorbari.github.io/jwks-merge/
$ helm install my-jwks-merge jwks-merge/jwks-merge --set jwksUrls="http://list-of http://jwks"
```

There are also some Kubernetes example configuration files are located under `./k8s`.

```bash
$ git clone git@github.com:vitorbari/jwks-merge.git
$ cd jwks-merge/k8s
$ kubectl apply -f deployment.yaml -f configmap.yaml -f service.yaml
```

Testing the service:

`$ kubectl run temp --image busybox --restart=Never -it --command -- wget jwks-merge.default.svc.cluster.local/jwks.json -O -`

Please see the [limitations section](#limitations).

### Docker

```bash
$ docker run \
    --env JWKS_URLS="https://vitorbari-test.eu.auth0.com/.well-known/jwks.json https://appleid.apple.com/auth/keys" \
    --env DEST_JWKS="/dev/stdout" \
    vitorbari/jwks-merge
```

### Locally

Requires [curl](https://curl.se/) and [jq](https://stedolan.github.io/jq/).

```bash
$ git clone git@github.com:vitorbari/jwks-merge.git
$ cd jwks-merge
$ JWKS_URLS="https://vitorbari-test.eu.auth0.com/.well-known/jwks.json https://appleid.apple.com/auth/keys" \
     DEST_JWKS=/tmp/foo.json \
     ./src/jwks-merge.sh
```

## Limitations

- When exposing the merged JWKS file via a webserver, the file does not auto-refresh. Changes on one of the original JWKS will only be reflected on the merged JWKS after a restart. (This behavior should be easy to change if the auto-refresh is needed).

## Notes

The script is based on [curl](https://curl.se/) and [jq](https://stedolan.github.io/jq/).
