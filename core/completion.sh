#!/usr/bin/env bash
# leehom Chen clh021@gmail.com
# 生成自动完成的提示

# 编写一个 shell 脚本：
# 进入到脚本当前所在目录，获取用户提供的可选参数若干个，
# 所有参数使用如下逻辑，根据用户输入的参数，一级一级查找同名目录下的路径。
# 如果是文件，则获取文件的文件名和文件的第二行内容(去除前面可能存在的#和空格)，以"${filebasename}:${secondContent}"的格式输出；
# 如果是文件夹，则检查文件夹下是否存在README.md 文件，
# 不存在的跳过，
# 存在该文件的，则获取文件夹名称和该README.md文件的第二行内容(去除前面可能存在的#和空格)，以"${filebasename}:${secondContent}"的格式输出；
# 脚本最后要恢复工作目录，使工作目录切换到运行脚本之前

# 获取当前脚本的文件名（不包括路径）
SCRIPT_NAME=$(basename "$0")
if [ -n "$LH_DEBUG" ]; then
  # 指定日志文件名为脚本名加上后缀 .log
  LOG_FILE="${SCRIPT_NAME%.*}.log"
  LOG="`date +%Y-%m-%d_%H:%M:%S` $*"
  SCRIPT=$(readlink -f $0)
  SCRIPT_NAME=$(basename $SCRIPT)
  SCRIPT_NAME=$(basename $0)
  SCRIPT_COMMAND="$0 $*"
  USER_NAME=$(whoami)
  USER_ID=$(id -u)
  {
    echo $LOG
    echo "\$0     : $0"
    echo "command: $SCRIPT_COMMAND"
    echo "\$@     : $@"
    echo "user   : $USER_NAME $USER_ID"
  } >> $LOG_FILE
fi

# 保存当前工作目录
CURRENT_DIR=$(pwd)

# 进入脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${1}" )" && pwd )"
cd "$SCRIPT_DIR"
shift

cmdName="$(basename "${SCRIPT_DIR}")"
# 判断第一个参数是否为命令本身，是则跳过
if [ "$1" = "$cmdName" ]; then
  shift
fi

# 获取用户传递的文件夹参数
for arg in "$@"
do
    if [ -d "$arg" ]; then
      cd "$arg"
      shift
    fi
done


# 扫描文件夹下的所有文件和文件夹
for ITEM in *; do
  if [ -f "$ITEM" ]; then
    # 如果扫描到文件，则获取文件名和第二行内容
    if [ "${ITEM:0:2}" == "--" ]; then
      FILE_BASENAME="./${ITEM}"
    else
      FILE_BASENAME="$ITEM"
    fi
    # 如果扫描到 README.md 则跳过
    if [ "$FILE_BASENAME" == "README.md" ]; then
      continue
    fi
    # 如果扫描到 functions.sh 则跳过
    if [ "$FILE_BASENAME" == "functions.sh" ]; then
      continue
    fi
    # 获取文件第二行的内容，并取消开头的 #和空格
    if [ $(head -n 1 "$FILE_BASENAME" | grep -c "^#") -eq 0 ]; then
      continue
    fi
    SECOND_CONTENT=$(sed -n '2p' "$FILE_BASENAME" | sed 's/^#* *//')
    echo "$(basename "$FILE_BASENAME"):${SECOND_CONTENT}"
  elif [ -d "$ITEM" ]; then
    # 如果扫描到文件夹，则查找README.md文件
    if [ ! -f "$ITEM/README.md" ]; then
      continue
    fi
    FOLDER_BASENAME="$ITEM"
    SECOND_CONTENT=$(sed -n '2p' "$FOLDER_BASENAME/README.md" | sed 's/^#* *//')
    echo "$(basename "$FOLDER_BASENAME"):[+]${SECOND_CONTENT}"
  fi
done

cd "$CURRENT_DIR" # 返回原本的工作目录