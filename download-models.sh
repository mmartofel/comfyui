#!/bin/bash

source configure.sh

MODEL_ID=$1

# Function to download and verify a file
download_and_verify() {
    local file_name="$1"
    local expected_hash="$2"
    local download_url="$3"
    local cur_model_id="$4"

    if [ -n "$MODEL_ID" ] && [[ "$cur_model_id" != "$MODEL_ID"* ]]; then
        # Perform your action here
        return
    fi

    # Check if the file exists
    if [ -e "$file_name" ]; then
        # Calculate the actual hash of the file
        actual_hash=$(sha256sum "$file_name" | awk '{print $1}')

        # Compare the actual hash with the expected hash
        if [ "$actual_hash" == "$expected_hash" ]; then
            echo "File $file_name already exists and hash matches. No need to download."
            return
        else
            echo "Hash mismatch for $file_name. Downloading..."
        fi
    else
        echo "File $file_name does not exist. Downloading..."
    fi

    # Download the file using wget
    wget "$download_url" -O "$file_name"

    # Verify the downloaded file's hash
    downloaded_hash=$(sha256sum "$file_name" | awk '{print $1}')

    # Check if the downloaded hash matches the expected hash
    if [ "$downloaded_hash" == "$expected_hash" ]; then
        echo "File $file_name downloaded successfully and hash matches."
    else
        echo "Error: Downloaded file $file_name hash does not match the expected hash."
        # You may want to handle this error case accordingly
    fi
}


#######
# LORAs
#######

mkdir -p $OUTER_FOLDER/models/loras
cd $OUTER_FOLDER/models/loras

# Standard LCM LORA
# https://huggingface.co/latent-consistency/lcm-lora-sdxl/blob/main/pytorch_lora_weights.safetensors
download_and_verify "lcm-lora-sdxl.safetensors" "a764e6859b6e04047cd761c08ff0cee96413a8e004c9f07707530cd776b19141" "https://huggingface.co/latent-consistency/lcm-lora-sdxl/resolve/main/pytorch_lora_weights.safetensors" "lora01"

# Werewolf LORA
# https://civitai.com/models/46487/werewolf-lora-15sdxl
download_and_verify "werewolf-sdxl.safetensors" "59f8eeb6d6f9df9e6dcc6dd361b2ec7de7b08ca4f41e417c5715cb925292fc88" "https://civitai.com/api/download/models/212047" "lora02"


#############
# Checkpoints
#############

mkdir -p $OUTER_FOLDER/models/checkpoints
cd $OUTER_FOLDER/models/checkpoints

# Albedobase XL (https://civitai.com/models/140737/albedobase-xl?modelVersionId=238308)
download_and_verify "albedobaseXL_v13.safetensors" "a40d817f46acc25c88ee0b6f6efa474004cea3fa1868e09a13192342c5bf4df9" "https://civitai.com/api/download/models/238308" "ch01"

# Dreamshaper XL (https://civitai.com/models/112902/dreamshaper-xl)
download_and_verify "dreamshaperXL_turboDpmppSDEKarras.safetensors" "676f0d60c8e860146d5e8a0d802599cadd04e7cadf85c283f189f41f01c9e359" "https://civitai.com/api/download/models/251662" "ch02"

# Illuminati Diffusion (https://civitai.com/models/11193/illuminati-diffusion-v11)
download_and_verify "illuminatiDiffusionV1_v11.safetensors" "cae1bee30e67339dd931925f98c12d2b86fe9f4786795137040e4956f4bfcffe" "https://civitai.com/api/download/models/13259" "ch03"

#PiXL (https://civitai.com/models/260599/pixl-animecartooncomic-style)
download_and_verify "pixlAnimeCartoonComic_v10.safetensors" "c6b91b7c3b7743e1d7635bf2f30c22597d137dc86f519eda80ba551cf9428550" "https://civitai.com/api/download/models/293933" "ch04"

############
# Embeddings
############

mkdir -p $OUTER_FOLDER/models/embeddings
cd $OUTER_FOLDER/models/embeddings

# Illuminati Diffusion
# https://civitai.com/models/13515/nfixer-for-illuminati-diffusion-v11
download_and_verify "nfixer.pt" "aa5a14f467a8cb8660e92e97ca647ab90ef3aa00dc6da842ab735170347f78c7" "https://civitai.com/api/download/models/15921" "em1-1"
# https://civitai.com/models/13518/nartfixer-for-illuminati-diffusion-v11
download_and_verify "nartfixer.pt" "a0504f05844290ac4d2de41d0338fb642548fb18efd8c6de7bb571ab1d60af89" "https://civitai.com/api/download/models/15926" "em1-2"
# https://civitai.com/models/13519/nrealfixer-for-illuminati-diffusion-v11
download_and_verify "nrealfixer.pt" "d1193a5ecddb3b5b052f5efb1a74062dcd130a4060884eed439a605b9731c0ad" "https://civitai.com/api/download/models/15927" "em1-3"


############
# ClipVision
############

mkdir -p $OUTER_FOLDER/models/clip_vision
cd $OUTER_FOLDER/models/clip_vision

mkdir -p SD1.5
cd SD1.5
download_and_verify "model.safetensors" "6ca9667da1ca9e0b0f75e46bb030f7e011f44f86cbfb8d5a36590fcd7507b030" "https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors?download=true" "cv1"


#########
# Upscale
#########

mkdir -p $OUTER_FOLDER/models/upscale_models
cd $OUTER_FOLDER/models/upscale_models

download_and_verify "4x_NMKD-Superscale-SP_178000_G.pth" "1d1b0078fe71446e0469d8d4df59e96baa80d83cda600d68237d655830821bcc" "https://huggingface.co/gemasai/4x_NMKD-Superscale-SP_178000_G/resolve/main/4x_NMKD-Superscale-SP_178000_G.pth" "up1"


############
# ControlNET
############

mkdir -p $OUTER_FOLDER/models/controlnet
cd $OUTER_FOLDER/models/controlnet

download_and_verify "control-lora-openposeXL2-rank256.safetensors" "8afa079285bf9384eaf8f6322884cb4f24bbe405da490f91f5540d3bff585e75" "https://huggingface.co/thibaud/controlnet-openpose-sdxl-1.0/resolve/main/control-lora-openposeXL2-rank256.safetensors?download=true" "cn1"
download_and_verify "control-lora-canny-rank256.safetensors" "21f79f7368eff07f57bcd507ca91c0fc89070d7da182960ff24ed1d58310c3a7" "https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-canny-rank256.safetensors?download=true" "cn2"
download_and_verify "control-lora-depth-rank256.safetensors" "559d2468951bf254c13bacd9c5d05d01ad67b060f6a73e8131d26ebf459c1c79" "https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-depth-rank256.safetensors?download=true" "cn3"
download_and_verify "control-lora-sketch-rank256.safetensors" "cf741a672fc3f753956260cb16101250f16c3c5bb3690a3d736bef66eafa7515" "https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-sketch-rank256.safetensors?download=true" "cn4"

#################
# IP Adapter plus
#################

mkdir -p $OUTER_FOLDER/models/IP_Adapter_Plus_Models
cd $OUTER_FOLDER/models/IP_Adapter_Plus_Models

download_and_verify "ip-adapter_sdxl_vit-h.safetensors" "ebf05d918348aec7abb02a5e9ecef77e0aaea6914a5c4ea13f50d45eb1681831" "https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl_vit-h.safetensors" "ip1"

