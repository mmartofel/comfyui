./build-image.sh

podman tag localhost/comfyui quay.io/mmartofe/comfyui:base

podman run -d -p 8188:8188 --name comfyui quay.io/mmartofe/comfyui:base