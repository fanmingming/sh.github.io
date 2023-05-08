#!/bin/bash

function show_menu {
  clear
  echo "主菜单"
  echo "1. 安装ffmpeg"
  echo "2. 开始推流"
  echo "3. 停止推流"
}

function install_ffmpeg {
  echo "即将安装ffmpeg，是否继续？(yes/no)"
  read confirmation
  if [ "$confirmation" == "yes" ]; then
    echo "正在安装ffmpeg..."
    # 安装ffmpeg命令
    sudo apt-get update
    sudo apt-get install -y ffmpeg
    echo "ffmpeg安装完成"
    read -n 1 -s -r -p "按任意键继续..."
  fi
}

function start_stream {
  read -p "请输入拉流地址：" rtsp_address
  read -p "请输入输出路径地址(不能包含空格)：" stream_path
  # 推流命令
  ffmpeg -i "$rtsp_address" -c:v copy -c:a copy -f hls -hls_time 10 -hls_list_size 10 -hls_segment_filename "$stream_path/%03d.ts" "$stream_path/index.m3u8"
  echo "开始推流：$rtsp_address -> $stream_path/index.m3u8"
  read -n 1 -s -r -p "按任意键继续..."
}

function stop_stream {
  # 停止推流命令
  pkill ffmpeg
  echo "停止所有推流"
  read -n 1 -s -r -p "按任意键继续..."
}

show_menu

while true; do
  read -p "请输入选项：" choice
  case $choice in
    1) install_ffmpeg ;;
    2) start_stream ;;
    3) stop_stream ;;
    *) echo "无效的选项" ;;
  esac
  show_menu
done
