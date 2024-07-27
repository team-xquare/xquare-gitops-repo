#!/bin/bash

SERVICE_NAME=$1
ENVIRONMENT=$2
REPOSITORY=$3

cd /home/go/xquare-gitops-repo && git pull

RESOURCE_DIR="./pipelines/$ENVIRONMENT/$SERVICE_NAME/resource"
if [ ! -d "$RESOURCE_DIR" ]; then
  mkdir -p "$RESOURCE_DIR"
fi

helm template \
  $SERVICE_NAME \
  templates/server \
  -f ./pipelines/$ENVIRONMENT/$SERVICE_NAME/values.yaml \
  --set image_name=$REPOSITORY \
  > $RESOURCE_DIR/manifest.yaml

kubectl apply -f $RESOURCE_DIR/manifest.yaml

git pull
git add $RESOURCE_DIR/manifest.yaml
git commit -m "record :: $SERVICE_NAME-$ENVIRONMENT kubernetes manifest"
git push --set-upstream origin v2
