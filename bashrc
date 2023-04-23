#!/usr/bin/env bash
# leehom Chen clh021@gmail.com
# 获取脚本的绝对路径
SHELL_GENUIS_PATH="$(cd "$(dirname "$0")" >/dev/null 2>&1 && pwd)"
export SHELL_GENIUS_PATH=$SHELL_GENUIS_PATH
shell_genius_update_cache() {
  $SHELL_GENIUS_PATH/core/update_cache.sh
}

for f in $SHELL_GENIUS_PATH/cache/*; do
  file_type=$(file -b "$f")
  # 判断文件是否是 shell 脚本
  if echo "$file_type" | grep -q "shell script"; then
    source "$f"
  fi
done