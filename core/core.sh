#!/usr/bin/env bash
# leehom Chen clh021@gmail.com
# 编写一个 shell script 脚本，检查用户输入的参数个数
# 要求函数使用者至少提供一个参数，最多可以支持9个参数
# 第一个参数作为目录路径，用户一定传递，否则函数退出
# 所有参数使用如下逻辑，根据用户输入的参数，一级一级查找同名目录下的路径。如果路径是存在的文件夹，则列举下面的文件夹；如果查找到的路径是文件，则输出文件的内容。将每一次查找的路径都打印出来。
# 检查参数个数是否至少为1，否则退出脚本

# set -x
# 检查参数个数是否至少为1，否则退出脚本
if [ $# -lt 1 ]; then
    echo "错误：必须至少传递一个目录路径参数。"
    exit 1
fi

# 获取第一个参数作为目录路径
path=""
# 如果第一个参数不是以 / 开头，则将 path 赋值为 "./"
if [[ "$1" != /* ]]; then
  path="."
fi

# echo $path;

# 迭代剩余的参数，构造最终路径，并依次查找路径
while [ $# -gt 0 ]; do
    path="$path/$1"
    # echo "路径：$path"
    # if [ ! -e "$path" ]; then
    #     echo "错误：路径 $path 不存在。"
    #     exit 1
    #el
    if [ -f "$path" ]; then
        # 如果找到的是文件，检查文件权限并执行
        if [ ! -x "$path" ]; then
          # 如果文件没有可执行权限，则赋予可执行权限
          chmod +x "$path"
        fi
        # 判断文件类型
        file_type=$(file -b "$path")
        # 判断文件是否是 shell 脚本
        if echo "$file_type" | grep -q "shell script"; then
          shift
          # 执行文件
          "$path" "$@"
        else
          echo "Just support shell script."
        fi
    # elif [ -d "$path" ]; then
        # 如果找到的是文件夹，列举其下所有文件夹
        # echo "文件夹：$path"
        # for folder in "$path"/*/; do
        #     echo "${folder%/}"
        # done
    # else
    #     echo "错误：路径 $path 不是文件夹或文件。"
    #     exit 1
    fi
    shift
done
