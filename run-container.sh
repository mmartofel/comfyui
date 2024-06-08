#!/bin/bash

source configure.sh

mkdir -p $OUTER_FOLDER/output
mkdir -p $OUTER_FOLDER/models/checkpoints
mkdir -p $OUTER_FOLDER/models/embeddings
mkdir -p $OUTER_FOLDER/models/controlnet
mkdir -p $OUTER_FOLDER/models/loras
mkdir -p $OUTER_FOLDER/models/clip_vision
mkdir -p $OUTER_FOLDER/models/upscale_models
mkdir -p $OUTER_FOLDER/models/IP_Adapter_Plus_Models
mkdir -p $OUTER_FOLDER/models/controlnet_aux_checkpoints

docker run -it --rm -u $(id -u ${USER}) --gpus all \
-v $OUTER_FOLDER/models/checkpoints:/home/$USER/ComfyUI/models/checkpoints \
-v $OUTER_FOLDER/models/embeddings:/home/$USER/ComfyUI/models/embeddings \
-v $OUTER_FOLDER/models/controlnet:/home/$USER/ComfyUI/models/controlnet \
-v $OUTER_FOLDER/models/loras:/home/$USER/ComfyUI/models/loras \
-v $OUTER_FOLDER/models/clip_vision:/home/$USER/ComfyUI/models/clip_vision \
-v $OUTER_FOLDER/models/upscale_models:/home/$USER/ComfyUI/models/upscale_models \
-v $OUTER_FOLDER/models/IP_Adapter_Plus_Models:/home/$USER/ComfyUI/custom_nodes/ComfyUI_IPAdapter_plus/models \
-v $OUTER_FOLDER/models/controlnet_aux_checkpoints:/home/$USER/ComfyUI/custom_nodes/comfyui_controlnet_aux/ckpts \
-v $OUTER_FOLDER/output:/home/$USER/ComfyUI/output \
-p 8188:8188 comfyui bash

exit 0
