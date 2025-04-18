#!/bin/bash

# 初始化 Python 命令变量为空
PYTHON_CMD=""

# 检查系统中是否存在 python3 命令
if command -v python3 &>/dev/null; then
    PYTHON_CMD="python3"
# 如果没有 python3，则检查是否有 python 命令
elif command -v python &>/dev/null; then
    PYTHON_CMD="python"
else
    echo "错误: 系统中未找到 Python。请安装 Python 3.10 或更高版本。"
    exit 1
fi

# 获取 Python 版本
PYTHON_VERSION=$($PYTHON_CMD -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")

# 比较版本号
if (( $(echo "$PYTHON_VERSION >= 3.10" | bc -l) )); then
    echo "Python 版本检查通过: $PYTHON_VERSION"
else
    echo "错误: 需要 Python 3.10 或更高版本，但找到的是 $PYTHON_VERSION"
    exit 1
fi

# 如果版本检查通过，继续执行后续操作
echo "开始执行主程序..."
# 这里添加你的主要代码
# 例如: $PYTHON_CMD app.py
$PYTHON_CMD -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py