
<div align="center">
<img src='assets/index_icon.png' width="250"/>
</div>


<h2><center>IndexTTS批量语音克隆工具</h2>

<p align="center">
<a href='https://arxiv.org/abs/2502.05512'><img src='https://img.shields.io/badge/ArXiv-2502.05512-red'></a>

## Usage Instructions
详细步骤可以点击链接查看教程视频：（）
### Environment Setup
1. Download this repository:
```bash
git clone https://github.com/nanaoto/index-tts-webui.git
cd index-tts-webui
```
### 运行webui
#### MacOS
双击`run.sh.command`脚本，或在终端中运行以下命令：
```bash
bash run.sh
=======
2. Install dependencies:

Create a new conda environment and install dependencies:
 
```bash
conda create -n index-tts python=3.10
conda activate index-tts
apt-get install ffmpeg
# or use conda to install ffmpeg
conda install -c conda-forge ffmpeg
```

Install [PyTorch](https://pytorch.org/get-started/locally/), e.g.:
```bash
pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu118
```

> [!NOTE]
> If you are using Windows you may encounter [an error](https://github.com/index-tts/index-tts/issues/61) when installing `pynini`:
`ERROR: Failed building wheel for pynini`
> In this case, please install `pynini` via `conda`:
> ```bash
> # after conda activate index-tts
> conda install -c conda-forge pynini==2.1.6
> pip install WeTextProcessing --no-deps
> ```

Install `IndexTTS` as a package:
```bash
cd index-tts
pip install -e .
>>>>>>> origin/main
```
#### Linux
在终端中运行以下命令：
```bash
<<<<<<< HEAD
bash run.sh
```
#### Windows
双击`run.bat`脚本，或在git bash中运行以下命令：
```bash
bash run.sh
```

#### 已测试环境
|OS| Python  | CUDA | GPU                       |RAM|
|---|---------|------|---------------------------|---|
|Linux| 3.10.12 | 12.4 | NVIDIA GeForce RTX 4090   |-|
|MacOS|3.10.12|-| Apple M1                  |16GB|
|MacOS|3.10.12|-| Apple M2                  |16GB|
|MacOS|3.10.12|-| Apple M3                  |16GB|
|MacOS|3.10.12|-| Apple M4                  |16GB|
|Windows 11|3.10.12|-| NVIDIA GeForce RTX 3060Ti |-|
=======
huggingface-cli download IndexTeam/IndexTTS-1.5 \
  config.yaml bigvgan_discriminator.pth bigvgan_generator.pth bpe.model dvae.pth gpt.pth unigram_12000.vocab \
  --local-dir checkpoints
```

Recommended for China users. 如果下载速度慢，可以使用镜像：
```bash
export HF_ENDPOINT="https://hf-mirror.com"
```

Or by `wget`:

```bash
wget https://huggingface.co/IndexTeam/IndexTTS-1.5/resolve/main/bigvgan_discriminator.pth -P checkpoints
wget https://huggingface.co/IndexTeam/IndexTTS-1.5/resolve/main/bigvgan_generator.pth -P checkpoints
wget https://huggingface.co/IndexTeam/IndexTTS-1.5/resolve/main/bpe.model -P checkpoints
wget https://huggingface.co/IndexTeam/IndexTTS-1.5/resolve/main/dvae.pth -P checkpoints
wget https://huggingface.co/IndexTeam/IndexTTS-1.5/resolve/main/gpt.pth -P checkpoints
wget https://huggingface.co/IndexTeam/IndexTTS-1.5/resolve/main/unigram_12000.vocab -P checkpoints
wget https://huggingface.co/IndexTeam/IndexTTS-1.5/resolve/main/config.yaml -P checkpoints
```

> [!NOTE]
> If you prefer to use the `IndexTTS-1.0` model, please replace `IndexTeam/IndexTTS-1.5` with `IndexTeam/IndexTTS` in the above commands.


4. Run test script:


```bash
# Please put your prompt audio in 'test_data' and rename it to 'input.wav'
python indextts/infer.py
```

5. Use as command line tool:

```bash
# Make sure pytorch has been installed before running this command
indextts "大家好，我现在正在bilibili 体验 ai 科技，说实话，来之前我绝对想不到！AI技术已经发展到这样匪夷所思的地步了！" \
  --voice reference_voice.wav \
  --model_dir checkpoints \
  --config checkpoints/config.yaml \
  --output output.wav
```

Use `--help` to see more options.
```bash
indextts --help
```

#### Web Demo
```bash
pip install -e ".[webui]" --no-build-isolation
python webui.py

# use another model version:
python webui.py --model_dir IndexTTS-1.5
```

Open your browser and visit `http://127.0.0.1:7860` to see the demo.


#### Sample Code
```python
from indextts.infer import IndexTTS
tts = IndexTTS(model_dir="checkpoints",cfg_path="checkpoints/config.yaml")
voice="reference_voice.wav"
text="大家好，我现在正在bilibili 体验 ai 科技，说实话，来之前我绝对想不到！AI技术已经发展到这样匪夷所思的地步了！比如说，现在正在说话的其实是B站为我现场复刻的数字分身，简直就是平行宇宙的另一个我了。如果大家也想体验更多深入的AIGC功能，可以访问 bilibili studio，相信我，你们也会吃惊的。"
tts.infer(voice, text, output_path)
```