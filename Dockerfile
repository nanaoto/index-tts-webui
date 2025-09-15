ARG CUDA_VERSION=11.8
ARG TORCH_VERSION=2.4.1

FROM pytorch/pytorch:${TORCH_VERSION}-cuda${CUDA_VERSION}-cudnn9-devel

ENV DEBIAN_FRONTEND=noninteractive
ENV WORK_DIR="/workspace/index-tts"
ENV PATH="${PATH}:/root/.local/bin"

ENV TORCH_VERSION=${TORCH_VERSION}
ENV CUDA_VERSION=${CUDA_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    git-lfs \
    ffmpeg \
    wget \
    vim \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR ${WORK_DIR}

COPY . ${WORK_DIR}
RUN pip install -U uv

ADD ./Docker/pyproject-pytorch${TORCH_VERSION}-cuda${CUDA_VERSION}.toml ${WORK_DIR}/pyproject.toml

RUN cd ${WORK_DIR} && uv sync --all-extras

RUN uv tool install "modelscope" && \
    uv tool install "huggingface_hub[cli]"

CMD ["/bin/bash"]
