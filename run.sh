#!/bin/bash

# 将工作目录切换到脚本所在的目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR" || { echo "切换目录失败"; read -p "按回车键退出..."; exit 1; }
echo "已切换到脚本所在目录: $SCRIPT_DIR"

# 检测操作系统类型
OS_TYPE="unknown"
if [[ "$(uname)" == "Darwin" ]]; then
    OS_TYPE="macos"
elif [[ "$(uname)" == "Linux" ]]; then
    OS_TYPE="linux"
    # 检测常见的 Linux 发行版
    if [[ -f /etc/debian_version ]]; then
        DISTRO="debian"
    elif [[ -f /etc/redhat-release ]]; then
        DISTRO="redhat"
    elif [[ -f /etc/arch-release ]]; then
        DISTRO="arch"
    else
        DISTRO="unknown"
    fi
fi

echo "检测到操作系统: $OS_TYPE"
if [[ "$OS_TYPE" == "linux" ]]; then
    echo "Linux 发行版: $DISTRO"
fi

# 检查是否安装了 ffmpeg
echo "检查是否安装了 ffmpeg..."
if ! command -v ffmpeg &>/dev/null; then
    echo "ffmpeg 未安装，准备安装..."

    if [[ "$OS_TYPE" == "macos" ]]; then
        echo "在 macOS 上安装 ffmpeg..."
        # 检查 Homebrew 是否安装
        if ! command -v brew &>/dev/null; then
            echo "Homebrew 未安装，准备安装..."
            # 使用中国大陆可用的软件源
            echo "使用中国大陆镜像源安装 Homebrew..."
            /bin/bash -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"

            if ! command -v brew &>/dev/null; then
                echo "安装 Homebrew 失败，请手动安装: https://brew.sh/"
                read -p "按回车键退出..."
                exit 1
            fi
            echo "Homebrew 安装完成"
        fi

        # 使用 Homebrew 安装 ffmpeg
        echo "使用 Homebrew 安装 ffmpeg..."
        brew install ffmpeg
        if [[ $? -ne 0 ]]; then
            echo "安装 ffmpeg 失败"
            read -p "按回车键退出..."
            exit 1
        fi

    elif [[ "$OS_TYPE" == "linux" ]]; then
        if [[ "$DISTRO" == "debian" ]]; then
            echo "在 Debian/Ubuntu 上安装 ffmpeg..."
            sudo apt-get update
            sudo apt-get install -y ffmpeg
        elif [[ "$DISTRO" == "redhat" ]]; then
            echo "在 RHEL/CentOS/Fedora 上安装 ffmpeg..."
            sudo yum install -y epel-release
            sudo yum install -y ffmpeg ffmpeg-devel
        elif [[ "$DISTRO" == "arch" ]]; then
            echo "在 Arch Linux 上安装 ffmpeg..."
            sudo pacman -S ffmpeg
        else
            echo "不支持的 Linux 发行版，请手动安装 ffmpeg"
            read -p "按回车键退出..."
            exit 1
        fi

        if [[ $? -ne 0 ]]; then
            echo "安装 ffmpeg 失败"
            read -p "按回车键退出..."
            exit 1
        fi
    else
        echo "不支持的操作系统，请手动安装 ffmpeg"
        read -p "按回车键退出..."
        exit 1
    fi

    echo "ffmpeg 安装完成"
else
    echo "检测到 ffmpeg 已安装"
fi

# 检查 uv 是否安装
if ! command -v uv &>/dev/null; then
    echo "uv 未安装，准备安装..."
    python3 -m pip install -U uv || pip install -U uv
    if ! command -v uv &>/dev/null; then
        echo "uv 安装失败，请手动安装: https://github.com/astral-sh/uv"
        read -p "按回车键退出..."
        exit 1
    fi
    echo "uv 安装完成"
else
    echo "检测到 uv 已安装"
fi

# 运行前下载模型
uv run tools/download_files.py
if [[ $? -ne 0 ]]; then
    echo "模型下载失败，请检查 tools/download_files.py 脚本"
    read -p "按回车键退出..."
    exit 1
fi


# 安装依赖（自动读取 pyproject.toml）
uv sync --all-extras
if [[ $? -ne 0 ]]; then
    echo "错误: 安装依赖失败"
    read -p "按回车键退出..."
    exit 1
fi

echo "依赖安装完成，开始启动应用程序..."
uv run webui.py
app_exit_code=$?

if [[ $app_exit_code -ne 0 ]]; then
    echo "应用程序已退出，退出码: $app_exit_code"
    read -p "按回车键退出..."
fi
