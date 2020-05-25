#!/bin/bash

# Required ENV vars
if [ -z $PLUGIN_REPO ]; then
    echo "REPO is required"
    exit 1
fi
if [ -z $PLUGIN_TAGS ]; then
    echo "TAGS is required"
    exit 1
fi

# Optional ENV vars
CREDS=""
if [ ! -z $PLUGIN_USERNAME ]; then
    if [ -z $PLUGIN_PASSWORD ]; then
        CREDS="--creds $PLUGIN_USERNAME"
    else
        CREDS="--creds $PLUGIN_USERNAME:$PLUGIN_PASSWORD"
    fi
fi
TARGET=""
if [ ! -z $PLUGIN_TARGET ]; then
    TARGET="--target $PLUGIN_TARGET"
fi
DOCKERFILE="Dockerfile"
if [ ! -z $PLUGIN_DOCKERFILE ]; then
    DOCKERFILE=$PLUGIN_DOCKERFILE
fi
INSECURE=""
if [ ! -z $PLUGIN_INSECURE ]; then
    INSECURE="--tls-verify=false"
fi
if [ ! -z $PLUGIN_AUTOTAG ]; then
    PLUGIN_TAGS="$PLUGIN_TAGS,$DRONE_SEMVER"
fi

IFS=', ' read -r -a TAGS <<< $PLUGIN_TAGS
IFS=', ' read -r -a ARGS <<< $PLUGIN_ARGS

export BUILDAH_LAYERS=true
for tag in ${TAGS[@]}; do
    REPO="$PLUGIN_REPO:$tag"
    buildah bud $CREDS $TARGET $INSECURE -t $REPO ${ARGS[@]} $DOCKERFILE
    buildah push $CREDS $INSECURE $REPO
done
