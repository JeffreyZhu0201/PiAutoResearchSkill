---
name: monitor-experiment
description: "Monitor running experiments on remote server via PI SSH. Check progress, view logs, collect results. Use when user says 'check results', 'is it done', 'monitor experiment', or needs to check training progress."
argument-hint: "[server-alias or experiment-name]"
allowed-tools: pi_ssh(*), Bash(*), Read
---

# Monitor Experiment (Remote-First)

> **重要**: 强烈建议使用 `/pi-ssh-experiment monitor` 代替此技能，它提供完整的远程实验监控能力。

本技能专注于通过 PI SSH 监控远程服务器上的实验。

## 核心原则

1. **所有代码在远程** - 只通过 SSH 查看远程状态
2. **使用 PI SSH** - 通过 PI SSH 扩展操作
3. **只监控，不修改** - 查看日志和结果，不修改代码

## 工作流程

### Step 1: 读取配置

从项目的 `CLAUDE.md` 读取 PI SSH 配置：

```markdown
## PI SSH
- pi_ssh_server: my-gpu-server
- pi_ssh_remote_base: /home/user/experiments
- pi_ssh_project: my-project
```

### Step 2: 检查运行中的实验

```bash
pi_ssh_exec: <server>, "screen -ls"
```

### Step 3: 查看实验输出

#### Option A: 从 screen 会话获取

```bash
pi_ssh_exec: <server>, "screen -S <exp_name> -X hardcopy /tmp/screen_<exp_name>.txt && tail -50 /tmp/screen_<exp_name>.txt"
```

#### Option B: 从日志文件获取

```bash
pi_ssh_exec: <server>, "tail -50 <remote>/logs/<log_file>"
```

### Step 4: 检查 GPU 状态

```bash
pi_ssh_exec: <server>, "nvidia-smi --query-gpu=index,memory.used,memory.total,utilization.gpu --format=csv,noheader"
```

### Step 5: 检查结果文件

```bash
pi_ssh_exec: <server>, "ls -lt <remote>/results/ | head -20"
pi_ssh_exec: <server>, "ls -lt <remote>/logs/ | head -10"
```

### Step 6: 收集结果（如需要）

```bash
# 下载结果
pi_ssh_download: <server>, <remote>/results/, ./local_results/

# 下载日志
pi_ssh_download: <server>, <remote>/logs/, ./local_results/logs/
```

## 常见监控任务

| 任务 | 命令 |
|------|------|
| 列出运行中的实验 | `pi_ssh_exec: <server>, "screen -ls"` |
| 查看实时输出 | `pi_ssh_exec: <server>, "tail -f <remote>/logs/<log_file>"` |
| 查看最后50行 | `pi_ssh_exec: <server>, "tail -50 <remote>/logs/<log_file>"` |
| 检查GPU使用 | `pi_ssh_exec: <server>, "nvidia-smi"` |
| 查看结果目录 | `pi_ssh_exec: <server>, "ls -la <remote>/results/"` |
| 查看进程 | `pi_ssh_exec: <server>, "ps aux \| grep python"` |

## 规范项目结构

```
/remote/path/to/project/
├── .env/                    # 环境配置
│   └── config.yaml          # 项目配置
├── .data/                   # 数据集
│   ├── raw/                 # 原始数据
│   └── processed/           # 处理后的数据
├── .src/                    # 源代码
│   ├── models/              # 模型定义
│   ├── datasets/            # 数据加载器
│   ├── utils/               # 工具函数
│   └── losses/              # 损失函数
├── exp/                     # 试验文件夹
│   ├── main_exp.py          # 主试验
│   ├── ablate_exp.py        # 消融实验
│   ├── compare_exp.py       # 对比实验
│   ├── param_exp.py         # 参数实验
│   └── figure_exp.py        # 生成图片
├── results/                  # 结果输出
└── logs/                    # 日志
```

## 推荐: 使用 pi-ssh-experiment

对于完整的远程实验监控，建议使用 `/pi-ssh-experiment` 技能：

```bash
# 监控所有实验
/pi-ssh-experiment monitor

# 监控特定实验
/pi-ssh-experiment monitor main_exp

# 列出所有实验
/pi-ssh-experiment list

# 收集结果
/pi-ssh-experiment collect main_exp
```

## 关键规则

1. **远程优先** - 所有监控操作在远程执行
2. **只读操作** - 监控只查看，不修改
3. **记录日志** - 使用 logs/ 目录中的日志
4. **收集结果** - 实验完成后下载结果
5. **报告状态** - 清晰地报告实验状态和进度
