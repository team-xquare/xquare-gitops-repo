#!/bin/bash

SERVICE_NAME=$1
ENVIRONMENT=$2
REPOSITORY=$3

cd /home/go/xquare-gitops-repo && git pull

helm template \
  $SERVICE_NAME \
  templates/server \
  -f ./pipelines/$ENVIRONMENT/$SERVICE_NAME/values.yaml \
  --set image_name=$REPOSITORY \
  > ./pipelines/$ENVIRONMENT/$SERVICE_NAME/resource/manifest.yaml

kubectl apply -f ./pipelines/$ENVIRONMENT/$SERVICE_NAME/resource/manifest.yaml

git pull
git add ./pipelines/$ENVIRONMENT/$SERVICE_NAME/resource/manifest.yaml
git commit -m "record :: $SERVICE_NAME-$ENVIRONMENT kubernetes manifest"
git push --set-upstream origin v2
