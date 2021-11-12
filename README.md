# jwks-merge

- [Introduction](#introduction)
- [Usage](#usage)
  * [Kubernetes](#kubernetes)
  * [Docker](#docker)
  * [Locally](#locally)
- [Notes](#notes)

## Introduction

`jwks-merge` can merge multiple [JSON Web Key Set](https://datatracker.ietf.org/doc/html/rfc7517#section-5) (JWKS) files into a single JWKS.

If an application needs to verify a JWT that was issued by one of many trusted authorization servers, then `jwks-merge` can simplify the process by providing a single JWKS.

## Usage

The application expects two environment variables:

| Env         | Description                                 | Examples                                                                                        |
|-------------|---------------------------------------------|-------------------------------------------------------------------------------------------------|
| `JWKS_URLS` | Space-separated list of JWKS URLs           | `https://vitorbari-test.eu.auth0.com/.well-known/jwks.json https://appleid.apple.com/auth/keys` |
| `DEST_JWKS` | Destination path for the produced JWKS file | `/dev/stdout`, `/var/local/jwks.json`                                                           |

### Kubernetes

By combining `jwks-merge` with a webserver such as Nginx, you can easily serve the merged JWKS via an URL.

<!-- TODO Helm Charts -->

Example configuration files are located on `./k8s`.

```
$ git clone git@github.com:vitorbari/jwks-merge.git
$ cd jwks-merge/k8s
$ kubectl apply -f deployment.yaml -f config-map.yaml -f service.yaml
```

Testing the service:

`$ kubectl run temp --image busybox --restart=Never -it --command -- wget jwks-merge.default.svc.cluster.local/.well-known/jwks.json -O -`

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

## Notes

The script is based on [curl](https://curl.se/) and [jq](https://stedolan.github.io/jq/).
