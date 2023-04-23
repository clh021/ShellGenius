#!/usr/bin/env bash
# leehom Chen clh021@gmail.com
# 获取脚本的绝对路径
SHELL_GENUIS_PATH="$(cd "$(dirname "$0")" >/dev/null 2>&1 && pwd)"
export SHELL_GENIUS_PATH=$SHELL_GENUIS_PATH
# 生成自动完成的提示
export SHELL_GENIUS_COMPLETION=$SHELL_GENIUS_PATH/core/completion.sh $@

# 生成缓存
# 只有在以下两种情形发生时才需要更新(重新生成缓存),修改命令脚本或扩充了子命令不需要更新缓存
# - 没有发现命令(新增的，或删除的)
# - 修改了配置目录
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
