# Tor via docker

## Building the image

```sh
docker build -t exherbo-tor .
```

## Configuration

There is no way to pass configuration, except mounting in the `torrc` into
the container like so: `-v /etc/torrc:/etc/torrc`. The tor process only
reads `/etc/torrc` inside the container.

An alias to the default network ip address docker gives to the container
is added to `/etc/hosts` as `tor`, so you might want to set `SocksPort tor:9050`
in your `torrc`.

By default, port `9050` is exposed.

## Running

First, create the container, e.g.:

```sh
docker run -d \
	--rm \
	--name tor \
	-v /etc/torrc:/etc/torrc \
	hasufell/exherbo-tor
```

You shouldn't use `-p 9050:9050` or similar, which partly defeats
the purpose of this image. Instead, connect to the docker interface directly.
Get the container ip like so:

```sh
docker inspect --type container --format '{{ .NetworkSettings.IPAddress }}' tor
```
