#!/bin/bash -e

echo 'Getting the bridge...'
cd /workspace/
git clone https://github.com/Haidra-Org/AI-Horde-Worker
cd AI-Horde-Worker && pip install -r requirements-scribe.txt

echo 'Getting the engine...'
pip install aphrodite-engine
mkdir /workspace/models
pip install pyyaml
pip install -U prometheus-client

#echo 'Starting Bridge...'
#cd /workspace/AI-Horde-Worker && python bridge_scribe.py 

echo 'Starting Aphrodite Engine API server...'
CMD="python3 -m aphrodite.endpoints.openai.api_server
             --host 0.0.0.0
             ${PORT:+--port $PORT}
             --download-dir /workspace/models
             ${MODEL_NAME:+--model $MODEL_NAME}
             ${REVISION:+--revision $REVISION}
             ${DATATYPE:+--dtype $DATATYPE}
             ${KVCACHE:+--kv-cache-dtype $KVCACHE}
             ${CONTEXT_LENGTH:+--max-model-len $CONTEXT_LENGTH}
             ${NUM_GPUS:+--tensor-parallel-size $NUM_GPUS}
             ${GPU_MEMORY_UTILIZATION:+--gpu-memory-utilization $GPU_MEMORY_UTILIZATION}
             ${QUANTIZATION:+--quantization $QUANTIZATION}
             ${ENFORCE_EAGER:+--enforce-eager}
             ${KOBOLD_API:+--launch-kobold-api}
             ${CMD_ADDITIONAL_ARGUMENTS}"

# set umask to ensure group read / write at runtime
umask 002

set -x

exec $CMD


