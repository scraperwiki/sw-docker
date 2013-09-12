Docker from scraperwiki
-----------------------

Minimal instructions:

 0. (First time) Run ./init.sh
 1. Run ./run.sh

If it's working, you'll drop into a container by ssh'ing to it.

What does it do?
----------------

There are two images: 

* `sw-base` which is intended to be reasonably pure: just a set of packages
  installed onto a base image which we need for scraperwiki operations.

* `sw` is a personalized image which you can ssh into as you, and you're able
  to man-in-the-middle it with your own CA certificates to make HTTP(s)
  operations faster by caching them.

How does it work?
-----------------

Docker has the notion of a `Dockerfile`, which `docker build` turns into an
image you can start processes in.

There are two images:

 * `imgs/sw-base/Dockerfile.in` (base)
 * `imgs/sw/Dockerfile.in` (your personalization)

They are called `.in` because these files are "sh-templated", that is, they're
eval'ed by bash so that various things (such as the hostname, certificates and
authorized keys) can be personalized.

Transparent http(s) man-in-the-middle cache
-------------------------------------------

You may be interested in directing all http(s) traffic to
[httpcache](http://github.com/pwaller/httpcache).

Note: this will MITM all docker containers.

```
sudo iptables -t nat -A PREROUTING -i docker0 -p tcp --dport 80 -j REDIRECT --to-port 3128
sudo iptables -t nat -A PREROUTING -i docker0 -p tcp --dport 443 -j REDIRECT --to-port 3192
```
