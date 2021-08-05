#! /usr/bin/env bash

docker login

# push the container to the dockerhub
docker push alecbrown/rust-flatbuffers
