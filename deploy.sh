#!/bin/bash
# This script pushes current version to the application cloud.

# unset http and https proxoy
unset http_proxy
unset https_proxy


cf login -a https://api.scapp-console.swisscom.com -u guillermo.barrenetxeakobas@swisscom.com -o ENT-DES-DIL_SDL -s Development --sso

echo 'Pushing application'
cd src
cf push sdl_demo -m 64M
cd ..

echo 'Exporting http proxy variables'
export http_proxy=http://clientproxy.corproot.net:8079
export https_proxy=https://clientproxy.corproot.net:8079
