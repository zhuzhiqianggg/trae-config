---

---


# Sealos 运维 Skill

## 概述

Sealos 是基于 Kubernetes 的云原生操作系统。本 skill 提供 Sealos 集群部署、运维、故障排查的指导。

**核心原则**: 先读状态，再动手。每次操作前确认影响范围。

## Sealos 基础

### 集群信息

```bash
# 查看集群状态
sealos status

# 查看节点
kubectl get nodes -o wide

# 查看所有资源
kubectl api-resources | sort
```

### Sealos 核心概念

- **ClusterFile**: 集群配置文件，`Clusterfile.yaml`
- **App**: Sealos 应用市场应用
- **Desktop**: Sealos 桌面环境
- **Lifecycle**: 应用生命周期管理

## 常用操作

### 部署应用

```bash
# 通过 sealos run 安装
sealos run labring/kubernetes:v1.28.0 --nodes 192.168.0.100

# 通过应用市场
# 访问 Sealos Desktop -> App Store -> 选择应用 -> 安装

# 查看已安装应用
kubectl get app -A
```

### 集群管理

```bash
# 添加节点
sealos add --nodes 192.168.0.101

# 删除节点
sealos delete --nodes 192.168.0.101

# 升级集群
sealos run labring/kubernetes:v1.29.0
```

### 查看日志

```bash
# Sealos 日志
journalctl -u sealos -f

# 容器运行时日志
journalctl -u containerd -f

# 应用日志
kubectl logs <pod-name> -n <namespace> --tail=200
```

## 故障排查流程

### 集群不可用

```bash
# 1. 检查节点状态
kubectl get nodes

# 2. 检查核心组件
kubectl get pods -n kube-system

# 3. 检查 etcd 健康
etcdctl endpoint health --endpoints=https://127.0.0.1:2379

# 4. 检查网络
kubectl get svc -A
kubectl get endpoints -A
```

### Pod 异常

```bash
# 查看 Pod 详情
kubectl describe pod <pod-name> -n <namespace>

# 查看日志
kubectl logs <pod-name> -n <namespace> --previous

# 进入容器
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh
```

### Sealos Desktop 无法访问

```bash
# 检查 desktop 服务
kubectl get svc -n sealos-system

# 检查 ingress
kubectl get ingress -n sealos-system

# 重启 desktop
kubectl rollout restart deployment/sealos-desktop -n sealos-system
```

## Red Flags

| 想法 | 现实 |
|------|------|
| "直接重装集群" | 先尝试诊断，数据丢失代价更大 |
| "kubectl 报错就是集群挂了" | 可能是 kubeconfig 问题，先确认上下文 |
| "Pod 起不来就是镜像问题" | 90% 是配置/资源问题，先看 describe |

## 最佳实践

1. **备份 etcd** — 定期备份集群数据
2. **监控告警** — 部署 Prometheus + Grafana
3. **版本锁定** — 生产环境不要随意升级
4. **最小权限** — 使用 RBAC 控制访问
5. **命名空间隔离** — 不同业务用不同 namespace
