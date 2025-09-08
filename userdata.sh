#!/bin/bash

set -euxo pipefail

dnf -y update
amazon-linux-extras disable docker

DNF="dnf -y --setopt=install_weak_deps=False --best"
$DNF install nginx jq

# Simple Site
cat >/usr/share/nginx/html/index.html <<'HTML'
<!doctype html>
<html>
  <head><meta charset="utf-8"><title>Week 4 – Private EC2 behind ALB</title></head>
  <body style="font-family: sans-serif;">
    <h1>It works! </h1>
    <p>This page is served from an EC2 instance in a <strong>private subnet</strong> via an <strong>ALB</strong> in public subnets.</p>
    <p>Hostname: $(hostname -f)</p>
  </body>
</html>
HTML

systemctl enable --now nginx