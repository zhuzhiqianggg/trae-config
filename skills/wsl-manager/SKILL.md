---
name: "wsl-manager"
description: "Comprehensive WSL2 management skill for troubleshooting network issues, configuring distributions, maintenance tasks, and optimizing WSL performance. Invoke when user has WSL problems, needs to configure WSL settings, or wants to manage WSL distributions."
---

# WSL Manager Skill

This skill provides comprehensive WSL2 (Windows Subsystem for Linux) management capabilities including troubleshooting, configuration, maintenance, and optimization.

## When to Invoke

- User reports WSL network connectivity issues (npm, git, curl not working)
- User needs to configure default user for WSL distribution
- User wants to manage WSL distributions (install, remove, backup)
- User needs to troubleshoot WSL performance issues
- User wants to optimize WSL settings
- User reports DNS resolution problems in WSL
- User needs to reset or repair WSL

## Core Commands Reference

### Distribution Management
```powershell
# List all distributions
wsl -l -v

# Set default distribution
wsl --set-default <DistributionName>

# Set default user for distribution
<DistributionName> config --default-user <username>
# Example: ubuntu2404 config --default-user root

# Terminate specific distribution
wsl --terminate <DistributionName>

# Unregister (delete) distribution
wsl --unregister <DistributionName>

# Export distribution to tar file
wsl --export <DistributionName> <FileName.tar>

# Import distribution from tar file
wsl --import <DistributionName> <InstallLocation> <FileName.tar>
```

### WSL Global Management
```powershell
# Shutdown all WSL
wsl --shutdown

# Update WSL
wsl --update

# Check WSL status
wsl --status

# WSL version
wsl --version
```

## Common Issues and Solutions

### Issue 1: Network/DNS Problems

**Symptoms:**
- npm, git, curl, wget not working
- DNS resolution fails
- Can ping IP but cannot resolve hostnames
- HTTPS connections timeout

**Diagnosis Steps:**
```bash
# Check DNS configuration
cat /etc/resolv.conf

# Test DNS resolution
getent hosts github.com
nslookup github.com

# Test connectivity
ping -c 4 8.8.8.8
curl -v https://github.com

# Check routing table
ip route
ip addr

# Check for VPN interference
# Look for routes like 0.0.0.0/1 via 198.18.x.x
```

**Common Causes:**
1. VPN software (Clash, V2Ray, Surge, etc.) hijacking DNS and routes
2. systemd-resolved overriding DNS settings
3. Corporate network restrictions
4. WSL configuration issues

**Solutions:**

#### Solution A: Fix DNS (Temporary)
```bash
# Stop systemd-resolved
systemctl stop systemd-resolved

# Create static resolv.conf
rm -f /etc/resolv.conf
cat > /etc/resolv.conf << 'EOF'
nameserver 223.5.5.5
nameserver 223.6.6.6
nameserver 8.8.8.8
nameserver 114.114.114.114
EOF
```

#### Solution B: Fix VPN Routes
```bash
# Delete VPN hijack routes
ip route del 0.0.0.0/1 via 198.18.0.2 dev eth4 2>/dev/null
ip route del 128.0.0.0/1 via 198.18.0.2 dev eth4 2>/dev/null

# Verify default route is correct
ip route | grep default
```

#### Solution C: Permanent Fix (Create Service)
```bash
# Create fix script
cat > /usr/local/bin/fix-wsl-network.sh << 'EOF'
#!/bin/bash
echo '[WSL Network Fix] Starting...'

# Remove VPN routes
ip route del 0.0.0.0/1 via 198.18.0.2 dev eth4 2>/dev/null
ip route del 128.0.0.0/1 via 198.18.0.2 dev eth4 2>/dev/null

# Fix DNS if needed
if ! grep -q '223.5.5.5' /etc/resolv.conf 2>/dev/null; then
    rm -f /etc/resolv.conf
    cat > /etc/resolv.conf << 'DNSEOF'
nameserver 223.5.5.5
nameserver 223.6.6.6
nameserver 8.8.8.8
nameserver 114.114.114.114
DNSEOF
fi

echo '[WSL Network Fix] Done'
EOF

chmod +x /usr/local/bin/fix-wsl-network.sh

# Create systemd service
cat > /etc/systemd/system/wsl-network-fix.service << 'EOF'
[Unit]
Description=Fix WSL2 Network Routes and DNS
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/fix-wsl-network.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable wsl-network-fix.service
```

#### Solution D: Configure WSL.conf
```bash
# Create /etc/wsl.conf
cat > /etc/wsl.conf << 'EOF'
[boot]
systemd=true

[network]
generateHosts = true
generateResolvConf = false

[user]
default=root
EOF

# Shutdown WSL to apply
wsl --shutdown
```

### Issue 2: Permission/User Issues

**Set Default User:**
```powershell
# Method 1: Using distribution command
ubuntu2404 config --default-user root

# Method 2: In wsl.conf
cat > /etc/wsl.conf << 'EOF'
[user]
default=root
EOF
```

**Reset User Password:**
```powershell
# From Windows PowerShell (as Administrator)
wsl -u root
passwd username
```

### Issue 3: Disk Space and Cleanup

```bash
# Inside WSL - clean package cache
apt-get clean
apt-get autoremove

# Compact WSL virtual disk (from PowerShell)
# Must run as Administrator
wsl --shutdown
diskpart
# In diskpart:
# select vdisk file="C:\Users\<username>\AppData\Local\Packages\<distro-package>\LocalState\ext4.vhdx"
# attach vdisk readonly
# compact vdisk
# detach vdisk
# exit
```

### Issue 4: WSL Performance Optimization

**wsl.conf optimization:**
```bash
cat > /etc/wsl.conf << 'EOF'
[boot]
systemd=true

[interop]
enabled = false
appendWindowsPath = false

[memory]
memory=8GB
processors=4

[network]
localhostForwarding=true

[automount]
enabled = true
mountFsTab = true
root = /mnt/
options = "metadata,umask=22,fmask=11"
EOF
```

**Windows .wslconfig (in %USERPROFILE%):**
```ini
[wsl2]
memory=8GB
processors=4
localhostForwarding=true
kernelCommandLine = "cgroup_enable=memory"
```

## Diagnostic Script Template

```bash
#!/bin/bash
echo "=== WSL Network Diagnostics ==="
echo ""
echo "--- 1. WSL Version ---"
wsl.exe --version 2>/dev/null || echo "WSL version command not available"
echo ""
echo "--- 2. Distribution Info ---"
cat /etc/os-release | head -5
echo ""
echo "--- 3. DNS Configuration ---"
cat /etc/resolv.conf
echo ""
echo "--- 4. Network Interfaces ---"
ip addr
echo ""
echo "--- 5. Routing Table ---"
ip route
echo ""
echo "--- 6. DNS Resolution Test ---"
getent hosts github.com || echo "DNS resolution FAILED"
echo ""
echo "--- 7. Connectivity Test ---"
ping -c 2 8.8.8.8 || echo "Ping FAILED"
echo ""
echo "--- 8. HTTP Test ---"
curl -s -o /dev/null -w "HTTP Code: %{http_code}\n" --max-time 10 https://github.com || echo "HTTPS connection FAILED"
echo ""
echo "--- 9. Check for VPN Routes ---"
ip route | grep -E "198\.18\|0\.0\.0\.0/1\|128\.0\.0\.0/1" && echo "WARNING: VPN routes detected" || echo "No VPN routes found"
echo ""
echo "=== Diagnostics Complete ==="
```

## Best Practices

1. **Always backup before major changes:**
   ```powershell
   wsl --export Ubuntu-24.04 C:\backups\ubuntu-backup.tar
   ```

2. **Use static DNS in enterprise environments:**
   - Configure company DNS servers in /etc/resolv.conf
   - Set generateResolvConf = false in wsl.conf

3. **Isolate WSL from Windows PATH if needed:**
   ```ini
   [interop]
   appendWindowsPath = false
   ```

4. **Regular maintenance:**
   ```bash
   # Weekly cleanup
   sudo apt-get update && sudo apt-get upgrade -y
   sudo apt-get autoremove -y
   sudo apt-get clean
   ```

5. **Monitor VPN interference:**
   - VPN software often conflicts with WSL networking
   - Use the network fix service for automatic repair

## Quick Reference Card

| Task | Command |
|------|---------|
| List distros | `wsl -l -v` |
| Default user | `<distro> config --default-user <user>` |
| Shutdown WSL | `wsl --shutdown` |
| Enter as root | `wsl -u root` |
| Export distro | `wsl --export <name> <file.tar>` |
| Import distro | `wsl --import <name> <path> <file.tar>` |
| Delete distro | `wsl --unregister <name>` |
| Check version | `wsl --version` |

## Troubleshooting Checklist

- [ ] WSL service running in Windows?
- [ ] Distribution state is "Running"?
- [ ] DNS resolves correctly?
- [ ] Can ping external IPs?
- [ ] No VPN routes hijacking traffic?
- [ ] /etc/resolv.conf has valid DNS servers?
- [ ] Default route points to correct gateway?
- [ ] No firewall blocking WSL?
