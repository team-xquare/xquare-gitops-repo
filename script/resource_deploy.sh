#!/bin/bash

set -e

SERVICE_NAME=$1
ENVIRONMENT=$2
REPOSITORY=$3

# GitOps 리포지토리로 이동하여 최신 변경 사항을 가져오기
cd /home/go/xquare-gitops-repo
git checkout v2
git pull

# 리소스 디렉토리가 존재하는지 확인
RESOURCE_DIR="./pipelines/$ENVIRONMENT/$SERVICE_NAME/resource"
if [ ! -d "$RESOURCE_DIR" ]; then
  mkdir -p "$RESOURCE_DIR"
fi

# Helm을 사용하여 Kubernetes 매니페스트 생성
helm template \
  $SERVICE_NAME \
  templates/server \
  -f ./pipelines/$ENVIRONMENT/$SERVICE_NAME/values.yaml \
  --set image_name=$REPOSITORY \
  > $RESOURCE_DIR/manifest.yaml

# Kubernetes 매니페스트 적용
kubectl apply -f $RESOURCE_DIR/manifest.yaml

# 매니페스트를 Git 리포지토리에 커밋하고 푸시
git pull
git add $RESOURCE_DIR/manifest.yaml
git commit -m "record :: $SERVICE_NAME-$ENVIRONMENT kubernetes manifest"
git push --set-upstream origin v2
