#!/bin/bash

# 接受命令行参数作为路径
path=$1

# 检查是否存在 project.txt 文件，如果存在则删除
if [ -f "project.txt" ]; then
  rm project.txt
fi

# 定义函数来递归查找 Git 项目并执行 git push，并将仓库地址输出到 project.txt
function git_push {
  for d in "$1"/*; do
    if [ -d "$d/.git" ]; then
      echo "pull in $d"
      (cd "$d" && git pull)
      echo "$(cd "$d" && git remote get-url origin)" >> project.txt
    elif [ -d "$d" ]; then
      git_push "$d"
    fi
  done
}

# 在指定路径下执行递归查找、git push 和保存仓库地址
git_push "$path"

