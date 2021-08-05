#! /usr/bin/env bash

# Make sure we start with the latest
docker pull rust:latest

# Build the rust-flatbuffers Dockerfile
docker build -t alecbrown/rust-flatbuffers .
