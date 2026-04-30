---

---


# Linux 系统排查 Skill

## 概述

系统化 Linux 故障排查方法。从症状到根因，逐步缩小范围。

**核心原则**: 先看全局，再钻细节。性能问题优先看资源使用率。

## 排查流程

```
问题报告 → 收集信息 → 假设验证 → 定位根因 → 修复验证
```

## 系统健康检查

### 一键诊断

```bash
# 系统概览
uptime                    # 负载 & 运行时间
free -h                   # 内存
df -h                     # 磁盘
top -bn1 | head -20       # CPU/进程快照
iostat -x 1 3             # 磁盘 I/O
```

### CPU 问题

```bash
# CPU 使用率
top
htop
mpstat -P ALL 1 5

# 负载分析
uptime
cat /proc/loadavg

# 找出 CPU 占用最高的进程
ps aux --sort=-%cpu | head -10

# 系统调用分析
strace -c -p <pid>
perf top

# CPU 上下文切换过高
vmstat 1 10
```

### 内存问题

```bash
# 内存使用
free -h
cat /proc/meminfo | head -20

# OOM Killer 记录
dmesg -T | grep -i oom
journalctl -k | grep -i oom

# 内存泄漏排查
ps aux --sort=-%mem | head -10
cat /proc/<pid>/smaps | awk '/Rss/{sum+=$2} END{print sum/1024 "MB"}'

# Swap 使用
vmstat 1 5
swapon --show
```

### 磁盘问题

```bash
# 磁盘空间
df -h
df -i                    # inode 使用

# 大文件定位
find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null | head -20
du -sh /* 2>/dev/null | sort -rh | head -20

# 磁盘 I/O 瓶颈
iostat -x 1 10
iotop

# 打开的文件
lsof | head -50
lsof | grep deleted      # 已删除但仍被占用的文件

# 磁盘健康
smartctl -a /dev/sda
```

### 网络问题

```bash
# 网络接口
ip addr
ip link
ifconfig

# 路由
ip route
traceroute <target>

# DNS
dig <domain>
nslookup <domain>

# 连接数
ss -tunap | head -50
ss -s                    # 统计

# 端口占用
ss -tlnp
netstat -tlnp

# 网络延迟
ping -c 10 <target>
mtr <target>

# TCP 连接状态
ss -tan | awk 'NR>1{print $1}' | sort | uniq -c | sort -rn
```

### 进程问题

```bash
# 僵死进程
ps aux | awk '$8 == "Z"'

# 进程树
pstree -p

# 进程打开的文件
lsof -p <pid>

# 进程环境变量
cat /proc/<pid>/environ | tr '\0' '\n'

# 进程打开的网络连接
ss -tunap | grep <pid>
```

## 常见故障模式

### 服务起不来

```bash
# 1. 检查服务状态
systemctl status <service>

# 2. 查看日志
journalctl -u <service> -n 100 --no-pager

# 3. 检查端口冲突
ss -tlnp | grep <port>

# 4. 检查依赖服务
systemctl list-dependencies <service>

# 5. 检查配置语法
# Nginx: nginx -t
# SSH: sshd -t
```

### 系统响应慢

```bash
# 1. 检查负载
uptime
vmstat 1 10

# 2. 检查 I/O 等待
iostat -x 1 5

# 3. 检查 swap
free -h

# 4. 检查文件系统
df -h
lsblk

# 5. 检查网络
ping -c 3 8.8.8.8
traceroute <target>
```

### 磁盘满了

```bash
# 1. 快速定位
df -h

# 2. 找大目录
du -sh /* 2>/dev/null | sort -rh | head -10

# 3. 找大文件
find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null | sort -k5 -rh

# 4. 清理日志
find /var/log -name "*.log" -exec truncate -s 0 {} \;

# 5. 清理包缓存
apt-get clean    # Debian
yum clean all    # CentOS

# 6. 找已删除但仍占用的文件
lsof | grep deleted
```

## 性能基准参考

| 指标 | 正常 | 警告 | 严重 |
|------|------|------|------|
| 负载 (1m) | < CPU核心数 | CPU核心数~2x | > 2x |
| 内存使用 | < 80% | 80%-95% | > 95% |
| 磁盘使用 | < 70% | 70%-90% | > 90% |
| 磁盘 I/O wait | < 5% | 5%-20% | > 20% |
| TCP 连接数 | < 1000 | 1000-10000 | > 10000 |

## Red Flags

| 想法 | 现实 |
|------|------|
| "肯定是网络问题" | 先看 CPU、内存、磁盘，网络只是可能性之一 |
| "重启就好了" | 重启前先保存现场，否则下次还会出问题 |
| "没看到错误就是没问题" | 用性能指标判断，不是只看错误日志 |
