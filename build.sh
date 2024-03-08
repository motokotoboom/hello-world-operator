#!/bin/bash

function build_help(){
  echo Builds and pushes docker image and helm chart for module
  echo Requirements: /Dockerfile and /helm/ in module subdirectory
  echo Usage: ./build.sh your_app 1.0.1
}

REPO=nexus.example.com/charts/
DOCKER_REGISTRY=motokotoboom
if [ "$1" != "" ]; then
  APP=$1
else
  build_help
  exit
fi

if [ "$2" != "" ]; then
  VERSION=$2
else
  build_help
  exit
fi

echo =========================  Building image $DOCKER_REGISTRY/$APP:$VERSION
pushd $APP
docker build . -t $DOCKER_REGISTRY/$APP:$VERSION
docker push $DOCKER_REGISTRY/$APP:$VERSION
echo =========================  Building helm chart $APP-$VERSION

yq e -i ".image.repository = \"${DOCKER_REGISTRY}"/"${APP}\"" helm/values.yaml
yq e -i ".image.tag = \"${VERSION}\"" helm/values.yaml
yq e -i ".version = \"${VERSION}\"" helm/Chart.yaml
yq e -i ".name = \"${APP}\"" helm/Chart.yaml
yq e -i ".appVersion = \"${VERSION}\"" helm/Chart.yaml

helm package helm --version $VERSION --app-version $VERSION -d ..
retVal=$?
if [ $retVal -ne 0 ]
  then
    echo "Error creating helm chart!"
    return 1
fi
popd


