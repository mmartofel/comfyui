# ComfyUI-docker

Just a quick way to launch your own ComfyUI docker container

Tested on Ubuntu 20.04 host and Nvidia GTX 1050Ti.

## Configure

First, `cp configure.sh.example configure.sh`, and set the variables in the resulting file as you want them.

## In Docker

### Building container

Run `build-image.sh`

### Running ComfyUI

Run `run-container.sh`

Inside, run `start-comfyui-gpu.sh`. If you want it to run on CPU, run `start-comfyui-cpu.sh` instead.

## Without container

Useful if you need to deploy it on a temporary server without Docker.

Run `install-locally.sh`.

## Downloading models

Run `download-models.sh`

## Artists lists

See `docs/e621_artists.txt` for list of artists understood by some SD1.5 models.
