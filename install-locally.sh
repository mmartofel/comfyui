#!/bin/bash

source configure.sh

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata

# needed for libGL.so.1
sudo apt install -y ffmpeg libsm6 libxext6

sudo apt install -y nano mc python3 python3-pip git wget

pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121

git clone https://github.com/comfyanonymous/ComfyUI.git $COMFYUI_FOLDER
cp copy_to_container/start-comfyui-cpu.sh $COMFYUI_FOLDER
cp copy_to_container/start-comfyui-gpu.sh $COMFYUI_FOLDER
pip install -r $COMFYUI_FOLDER/requirements.txt

# Alternative default workflow
cp copy_to_container/defaultGraph.js $COMFYUI_FOLDER/web/scripts

#######################
# Prepare model folders
#######################

mkdir -p $OUTER_FOLDER/models

ln -s $COMFYUI_FOLDER/models/loras $OUTER_FOLDER/models
ln -s $COMFYUI_FOLDER/models/checkpoints $OUTER_FOLDER/models
ln -s $COMFYUI_FOLDER/models/embeddings $OUTER_FOLDER/models
ln -s $COMFYUI_FOLDER/models/clip_vision $OUTER_FOLDER/models
ln -s $COMFYUI_FOLDER/models/upscale_models $OUTER_FOLDER/models
ln -s $COMFYUI_FOLDER/models/controlnet $OUTER_FOLDER/models 

#####################
# The following is the optional installation of additional plugins and workflows. Comment the ones you don't need.
#####################

pip install gitpython

cd $COMFYUI_FOLDER

# Install ComfyUI Manager
python3 -c "import git; git.Repo.clone_from('https://github.com/ltdrdata/ComfyUI-Manager', './custom_nodes/ComfyUI-Manager')"

# Install Efficiency Nodes
pip install simpleeval
python3 -c "import git; git.Repo.clone_from('https://github.com/jags111/efficiency-nodes-comfyui', './custom_nodes/efficiency-nodes-comfyui')"

# Install pythongosssss custom scripts
python3 -c "import git; git.Repo.clone_from('https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git', './custom_nodes/ComfyUI-Custom-Scripts')"

# Aspect ratio node can be found in image->SDXL Aspect Ratio
wget -P custom_nodes https://raw.githubusercontent.com/throttlekitty/SDXLCustomAspectRatio/main/SDXLAspectRatio.py

# SDXl Prompt Styler, for easier access to prompts that create certain styles
python3 -c "import git; git.Repo.clone_from('https://github.com/twri/sdxl_prompt_styler.git', './custom_nodes/sdxl_prompt_styler')"

# TAESD models, used for high-quality previews in nodes
wget -P models/vae_approx https://github.com/madebyollin/taesd/raw/main/taesdxl_decoder.pth
wget -P models/vae_approx https://github.com/madebyollin/taesd/raw/main/taesdxl_encoder.pth
wget -P models/vae_approx https://github.com/madebyollin/taesd/raw/main/taesd_decoder.pth
wget -P models/vae_approx https://github.com/madebyollin/taesd/raw/main/taesd_encoder.pth

# These are needed by Krita plugin
python3 -c "import git; git.Repo.clone_from('https://github.com/Acly/comfyui-tooling-nodes.git', './custom_nodes/comfyui-tooling-nodes')"
python3 -c "import git; git.Repo.clone_from('https://github.com/cubiq/ComfyUI_IPAdapter_plus.git', './custom_nodes/ComfyUI_IPAdapter_plus')"
python3 -c "import git; git.Repo.clone_from('https://github.com/Fannovel16/comfyui_controlnet_aux', './custom_nodes/comfyui_controlnet_aux')"
sed -i '/trimesh/c\trimesh' custom_nodes/comfyui_controlnet_aux/requirements.txt # for some reason `trimesh[easy]` won't install, but `trimesh` will.
pip install -r custom_nodes/comfyui_controlnet_aux/requirements.txt
git clone https://github.com/ssitu/ComfyUI_UltimateSDUpscale --recursive ./custom_nodes/ComfyUI_UltimateSDUpscale
ln -s $COMFYUI_FOLDER/custom_nodes/ComfyUI_IPAdapter_plus/models $OUTER_FOLDER/models/IP_Adapter_Plus_Models

# ComfyUI-Impact-Pack - contains SAM (Segment Anything) and face fixing tools
python3 -c "import git; git.Repo.clone_from('https://github.com/ltdrdata/ComfyUI-Impact-Pack.git', './custom_nodes/ComfyUI-Impact-Pack')"
