#!/bin/bash

BASE_PATH="pipelines"
CHART_PATH="templates/gocd"
ENVIRONMENTS=("prod" "stag")

for ENV in "${ENVIRONMENTS[@]}"; do
  for SERVICE in $(ls "$BASE_PATH/$ENV"); do
    pwd
    VALUES_FILE="./$BASE_PATH/$ENV/$SERVICE/values.yaml"
    OUTPUT_FILE="./$BASE_PATH/$ENV/$SERVICE/$SERVICE-$ENV-pipeline.gocd.yaml"

    helm template $SERVICE $CHART_PATH -f $VALUES_FILE > $OUTPUT_FILE
  done
done