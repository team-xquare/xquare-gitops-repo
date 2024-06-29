#!/bin/bash

SERVICE_NAME=$1
ENVIRONMENT=$2
REPOSITORY=$3

git clone https://github.com/team-xquare/xquare-gitops-repo
cd xquare-gitops-repo
git checkout v2

helm template \
  $SERVICE_NAME \
  templates/server \
  -f ./pipelines/$ENVIRONMENT/$SERVICE_NAME/values.yaml \
  --set repository=$REPOSITORY \
  > manifast.yaml

kubectl apply -f manifast.yaml

#git pull
#git add ./pipelines/$ENVIRONMENT/$SERVICE_NAME/resource/manifest.yaml
#git commit -m "record :: $SERVICE_NAME-$ENVIRONMENT kubernetes manifest"
#git push