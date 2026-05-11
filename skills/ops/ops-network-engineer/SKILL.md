---
name: ops-network-engineer
description: Network engineering: DNS, TCP/IP, load balancing, firewall, VPN, CDN configuration
tags: [network, dns, tcp, load-balancer, cdn, infrastructure]
---

# Network Engineer

Network infrastructure patterns for cloud and on-prem environments.

## DNS Configuration

```bash
# Record types
# A:        domain → IPv4
# AAAA:     domain → IPv6
# CNAME:    alias → domain (can't be apex)
# ALIAS/ANAME:  alias → domain (can be apex)
# MX:       mail exchange
# TXT:      verification, SPF, DKIM

# Common setup
example.com.     A     203.0.113.10
www.example.com. CNAME example.com.
api.example.com. CNAME lb.example.com.
_mx.example.com. MX 10 mail.example.com.

# DNS propagation check
dig +short example.com
nslookup example.com
```

## Load Balancing

### Layer 4 (TCP/UDP)

```yaml
# AWS NLB / GCP TCP LB / HAProxy TCP mode
# Good for: raw TCP, WebSocket, gRPC
# No header inspection, no SSL termination
```

### Layer 7 (HTTP/HTTPS)

```yaml
# AWS ALB / GCP HTTP LB / NGINX / Traefik
# Good for: HTTP apps, path-based routing, SSL termination
```

### NGINX Reverse Proxy

```nginx
upstream backend {
    least_conn;
    server 10.0.1.10:8080 max_fails=3 fail_timeout=30s;
    server 10.0.1.11:8080 max_fails=3 fail_timeout=30s;
}

server {
    listen 443 ssl;
    server_name api.example.com;

    ssl_certificate /etc/ssl/certs/example.pem;
    ssl_certificate_key /etc/ssl/private/example.key;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

## Firewall Rules

```bash
# iptables example
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -s 10.0.0.0/8 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -j DROP

# Cloud security groups
# AWS: allow inbound on 443 from 0.0.0.0/0
#       allow inbound on 22 from office-IP/32
#       allow inbound on 3000 from internal-sg
```

## CDN Configuration

```yaml
# Cloudflare / CloudFront / Fastly
# - Cache static assets (images, JS, CSS) at edge
# - Proxy dynamic API calls (no cache)
# - DDoS protection at edge
# - WAF rules for SQL injection, XSS, bot blocking

# Cache headers
Cache-Control: public, max-age=31536000, immutable  # versioned assets
Cache-Control: private, no-cache                      # authenticated content
Cache-Control: no-store                              # sensitive data
```

## TCP Tuning

```bash
# sysctl - sysctl.conf
net.core.somaxconn = 65535
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_time = 300
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
```

## Troubleshooting

```bash
# Connectivity
ping <target>
traceroute -n <target>
mtr <target>

# DNS
dig +trace example.com

# TLS
openssl s_client -connect example.com:443 -servername example.com

# HTTP
curl -vI https://example.com

# Bandwidth
iperf3 -c <server>

# Packet capture
tcpdump -i eth0 port 443 -w capture.pcap
```

## Red Flags

- TTL set too low (< 300) for production DNS records
- No health checks on load balancer targets
- SSL/TLS using old protocols (TLS < 1.2)
- No rate limiting on public endpoints
- HAProxy/NGINX `maxconn` not tuned for traffic
- Security groups too permissive (`0.0.0.0/0` on SSH)
