#!/bin/bash
# This script pushes current version to the application cloud.

usage="$(basename "$0") [-h] [-s n] -- push the demo application to the app cloud
where:
    -h  show this help text
    -t  set the target value public or private (default: public)"

target='public'
while getopts ':ht:' option; do
    case "$option" in
        h) echo "$usage"
           exit
           ;;
        t) target=$OPTARG
           ;;
        :) printf "missing argument for -%s\n" "$OPTARG" >&2
           echo "$usage" >&2
           exit 1
           ;;
        \?) printf "illegal option: -%s\n" "$OPTARG" >&2
            echo "$usage" >&2
            exit 1
            ;;
    esac
done

if [ "$target" = "private" ]; then
    echo "Deploying to the private app cloud..."
    # unset http and https proxoy
    unset http_proxy
    unset https_proxy
    cf login -a https://api.scapp-console.swisscom.com -u guillermo.barrenetxeakobas@swisscom.com -o ENT-DES-DIL_SDL -s Development --sso
else
    echo "Deploying to the public app cloud..."
    # Internal app cloud
    cf login -a https://api.lyra-836.appcloud.swisscom.com -u guillermo.barrenetxeakobas@swisscom.com -o SDL -s Development
fi

echo 'Pushing application'
cd src
cf push sdl_demo -m 64M
cd ..

if [ "$target" = "private" ]; then
    echo 'Exporting http proxy variables'
    export http_proxy=http://clientproxy.corproot.net:8079
    export https_proxy=https://clientproxy.corproot.net:8079
fi
