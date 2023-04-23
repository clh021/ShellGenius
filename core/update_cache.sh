#!/usr/bin/env bash
# leehom Chen clh021@gmail.com
# 编写一个shell脚本
# 准备好一个WORK_PATH的变量，默认值为$HOME目录下的ShellGenuisWorkSpace，
# 然后$HOME/.ShellGenuisWorkPath文件是否存在，
#   如果存在则读取其中的内容，将内容视为一个全路径，检查这个全路径是否存在且是一个文件夹，
#     如果是则更新变量的值，存储这个全路径。

if [[ -z "${SHELL_GENIUS_PATH}" ]]; then
  SHELL_GENUIS_PATH="$(cd "$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")" && pwd)"
fi
WORK_PATH=${WORK_PATH:-$HOME/ShellGenuisWorkSpace}

if [[ -e "$HOME/.ShellGenuisWorkPath" ]]; then
  NEW_PATH=$(cat "$HOME/.ShellGenuisWorkPath")
  if [[ -d "$NEW_PATH" ]]; then
    WORK_PATH="$NEW_PATH"
  fi
fi

generate_completion_set() {
  # 替换文本中的字符串
  sed "s/lzc\.test\.sh/${1}/g" <<EOF
#compdef lzc.test.sh
if command -v lzc.test.sh >/dev/null 2>&1; then
  ###-begin-lzc.test.sh-completions-###
  #
  # yargs command completion script
  #
  # Installation: lzc.test.sh --generate-zsh-completion >> ~/.zshrc
  #    or lzc.test.sh --generate-zsh-completion >> ~/.zprofile on OSX.
  #
  _lzc.test.sh_yargs_completions()
  {
    local reply
    local si=\$IFS
    IFS=$'
  ' reply=(\$(COMP_CWORD="\$((CURRENT-1))" COMP_LINE="\$BUFFER" COMP_POINT="\$CURSOR" lzc.test.sh --get-yargs-completions "\${words[@]}"))
    IFS=\$si
    _describe 'values' reply
  }
  compdef _lzc.test.sh_yargs_completions lzc.test.sh
  ###-end-lzc.test.sh-completions-###
fi
EOF
}
generate_aliases_set() {
sed "s/lzc-clh/${1}/g" <<EOF
lzc-clh() {
  LHCMD=lzc-clh $SHELL_GENIUS_PATH/core/core.sh $WORK_PATH/lzc-clh "\$@"
}
EOF
}

# 编写一个shell脚本
# 准备好一个WORK_PATH的变量，变量内容视为一个全路径。
# 检查该路径是否存在，且是否是一个文件夹。
# 如果条件均成立，则扫描该目录下的所有文件夹，输出文件夹的名字。

# 检查 WORK_PATH 是否存在且为一个文件夹
if [[ -d "$WORK_PATH" ]]; then
  {
    echo "#!/usr/bin/env bash"
  } > $SHELL_GENIUS_PATH/cache/completion
  {
    echo "#!/usr/bin/env bash"
  } > $SHELL_GENIUS_PATH/cache/aliases
  # 如果 WORK_PATH 是一个文件夹，扫描该目录下的所有文件夹并输出它们的名字
  for dir in "$WORK_PATH"/*/; do
    # 使用 basename 命令获取文件夹名字，然后输出
    commandName=$(basename "$dir")
    echo "Command '$commandName' has been recognized or set."
    generate_completion_set $(basename "$dir") >> $SHELL_GENIUS_PATH/cache/completion
    generate_aliases_set $(basename "$dir") >> $SHELL_GENIUS_PATH/cache/aliases
  done
  echo >> $SHELL_GENIUS_PATH/cache/completion
  echo >> $SHELL_GENIUS_PATH/cache/aliases
  echo "Open a new terminal window and enjoy!"
else
  # 如果 WORK_PATH 不存在或不是一个文件夹，输出错误信息
  echo "Error : $WORK_PATH does not exist or is not a directory."
  echo "Notice: You can write fullPath into ~/.ShellGenuisWorkPath to set WORKSPACE."
fi
