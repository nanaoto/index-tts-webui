import os
import shutil

from faster_whisper import WhisperModel

def asr_and_rename_files(input_dir,output_dir,device='cpu',precision='float32'):
    """
    使用语音识别模型为音频文件命名，并保存到指定目录
    """
    model_path = "tools/asr/models/faster-whisper-large-v3"  # 模型路径
    model = WhisperModel(
        model_size_or_path=model_path, device=device, local_files_only=True,
        compute_type=precision)
    for file_name in os.listdir(input_dir):
        file_path = os.path.join(input_dir, file_name)
        segments, info = model.transcribe(
            audio=file_path,
            beam_size=5,
            vad_filter=True,
            vad_parameters=dict(min_silence_duration_ms=700),
            language=None)
        text = ''
        if info.language == "zh":
            print("检测为中文文本, 转 FunASR 处理")
            if ("only_asr" not in globals()):
                from tools.asr.funasr_asr import only_asr  # 如果用英文就不需要导入下载模型
            text = only_asr(file_path, language=info.language.lower())

        if text == '':
            for segment in segments:
                text += segment.text
        ori_name = file_name.split('.')[0]
        output_file_name = f"{ori_name}-{text[:20]}.wav"
        output_file_path = os.path.join(output_dir, output_file_name)
        shutil.copy(file_path, output_file_path)

if __name__ == "__main__":
    # from modelscope import snapshot_download
    #
    # model_dir = snapshot_download('keepitsimple/faster-whisper-large-v3',local_dir='tools/asr/models')
    input_dir = "WORKSPACE/input"  # 输入目录
    output_dir = "WORKSPACE/output"  # 输出目录
    device = "cpu"  # 使用的设备
    precision = "float32"  # 精度
    asr_and_rename_files(input_dir, output_dir, device, precision)