#!/bin/bash

ENVIRONMENT=$1
SERVICE_NAME=$2

REPO_NAME=${SERVICE_NAME}-${ENVIRONMENT}
RANDOM_TAG=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
IMAGE_TAG="${ENVIRONMENT}-${RANDOM_TAG}"
IMAGE_REGISTRY="786584124104.dkr.ecr.ap-northeast-2.amazonaws.com"

ls

docker build -t "${IMAGE_REGISTRY}/${REPO_NAME}:${IMAGE_TAG}" .

docker push "${IMAGE_REGISTRY}/${REPO_NAME}:${IMAGE_TAG}"

echo "export ${SERVICE_NAME}_REPOSITORY=${IMAGE_REGISTRY}/${REPO_NAME}:${IMAGE_TAG}" > build_result.env