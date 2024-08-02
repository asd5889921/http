#!/bin/bash

# 安装必要的软件包
sudo apt update
sudo apt install -y socat iptables

# 创建 HTTP 代理
PORT=20000
USERNAME="httpuser"
PASSWORD="passwdhttp"

# 创建代理服务
sudo socat TCP4-LISTEN:$PORT,fork,reuseaddr PROXY:localhost:$PORT,proxyport=$PORT &

# 设置 IP 地址屏蔽规则（此示例使用的是 IP 地址段，需要根据实际情况配置）
# 请确保你已经获取了需要屏蔽的 IP 地址段（例如从中国的 IP 段）
# 以下规则是一个示例，需要根据实际 IP 地址段进行调整
CHINA_IP_RANGES="100.0.0.0/8 101.0.0.0/8"

# 添加 iptables 规则以屏蔽来自中国的流量
for range in $CHINA_IP_RANGES; do
    sudo iptables -A INPUT -p tcp -s $range --dport $PORT -j DROP
done

# 打印代理服务信息
echo "HTTP 代理已在端口 $PORT 上启动"
echo "用户名: $USERNAME"
echo "密码: $PASSWORD"
