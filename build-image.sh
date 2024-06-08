#!/bin/bash

# docker build -t comfyui --build-arg USERNAME=$USER --build-arg USERID=$(id -u) .
podman build -t comfyui --build-arg USERNAME=$USER --build-arg USERID=$(id -u) .

exit 0
