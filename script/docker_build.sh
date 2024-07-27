#!/bin/bash

ENVIRONMENT=$1
SERVICE_NAME=$2

REPO_NAME=${SERVICE_NAME}-${ENVIRONMENT}
RANDOM_TAG=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
IMAGE_TAG="${ENVIRONMENT}-${RANDOM_TAG}"
IMAGE_REGISTRY="786584124104.dkr.ecr.ap-northeast-2.amazonaws.com"

ls

REPO_EXISTS=$(aws ecr describe-repositories --repository-names "${REPO_NAME}" --region ap-northeast-2 2>&1 || echo "RepositoryNotFoundException")

if [[ ${REPO_EXISTS} == *"RepositoryNotFoundException"* ]]; then
  echo "Repository ${REPO_NAME} does not exist. Creating it now..."
  aws ecr create-repository --repository-name "${REPO_NAME}" --region ap-northeast-2
else
  echo "Repository ${REPO_NAME} already exists."
fi

docker build -t "${IMAGE_REGISTRY}/${REPO_NAME}:${IMAGE_TAG}" .

aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin ${IMAGE_REGISTRY}

docker push "${IMAGE_REGISTRY}/${REPO_NAME}:${IMAGE_TAG}"

echo "export ${SERVICE_NAME}-repository=${IMAGE_REGISTRY}/${REPO_NAME}:${IMAGE_TAG}" > build_result.env
