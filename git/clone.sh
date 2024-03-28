#!/bin/bash

# 检查传入的参数是否为文件，如果是则使用该文件作为输入源，否则使用参数作为 Git 仓库地址
if [ -f "$1" ]; then
    input_file="$1"
else
    input_file="temp_project.txt"
    echo "$1" > temp_project.txt
fi

# 逐行读取文件内容，根据每个 Git 仓库地址的层级创建文件夹并执行 git clone
while IFS= read -r repo_url
do
    # 解析仓库地址的文件夹结构
    repo_path=$(echo "$repo_url" | cut -d':' -f2)
    repo_path=${repo_path#*/}
    
    # 创建对应的目录结构
    IFS='/' read -r -a folders <<< "$repo_path"
    current_dir=""
    for folder in "${folders[@]}"
    do
        if [[ "$folder" != *".git" ]]; then
            mkdir -p ".$current_dir/$folder"
            current_dir="$current_dir/$folder"
        fi
    done
    
    # 进入最深层级的文件夹并执行 git clone
    (cd ".$current_dir" && git clone "$repo_url")
done < "$input_file"

# 如果是临时文件，则删除
if [ "$input_file" == "temp_project.txt" ]; then
    rm temp_project.txt
fi

