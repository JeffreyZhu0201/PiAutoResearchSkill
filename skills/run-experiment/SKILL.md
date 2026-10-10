---
name: run-experiment
description: "Deploy and run ML experiments on remote server via PI SSH. All experiment code maintained on remote. Use when user says 'run experiment', 'deploy', 'start training', or needs to launch training jobs. For full remote experiment lifecycle, use /pi-ssh-experiment instead."
argument-hint: "[experiment-description]"
allowed-tools: pi_ssh(*), Bash(*), Read, Grep
---

# Run Experiment (Remote-First)

> **重要**: 强烈建议使用 `/pi-ssh-experiment` 代替此技能，它提供完整的远程实验生命周期管理。

本技能专注于通过 PI SSH 在远程服务器上运行 ML 实验。

## 核心原则

1. **所有代码维护在远程** - 本地不存储实验代码
2. **使用 PI SSH 操作** - 通过 SSH 执行远程命令
3. **规范项目结构** - 代码存放在 `.src/`，试验存放在 `exp/`

## 工作流程

### Step 1: 读取配置

从项目的 `CLAUDE.md` 读取 PI SSH 配置：

```markdown
## PI SSH
- pi_ssh_server: my-gpu-server
- pi_ssh_remote_base: /home/user/experiments
- pi_ssh_project: my-project
- pi_ssh_conda_env: research
- pi_ssh_gpu_id: 0
```

### Step 2: 检查 GPU 可用性

```bash
pi_ssh_exec: <server>, "nvidia-smi --query-gpu=index,memory.used,memory.total --format=csv,noheader"
```

**空闲 GPU**: `memory.used < 500 MiB`

### Step 3: 验证项目结构

```bash
# 确认 exp/ 目录存在
pi_ssh_exec: <server>, "ls -la <remote>/exp/"

# 确认 .src/ 目录存在
pi_ssh_exec: <server>, "ls -la <remote>/.src/"
```

### Step 4: 运行实验

#### Option A: 使用 screen 运行（推荐）

```bash
# 创建运行脚本
pi_ssh_exec: <server>, "cat > /tmp/run_exp.sh << 'EOF'
#!/bin/bash
cd <remote>/exp
export PYTHONPATH=<remote>:$PYTHONPATH
eval \"\$(conda shell.bash hook)\" && conda activate <conda_env>
CUDA_VISIBLE_DEVICES=<gpu_id> python <exp_script>.py <args> 2>&1 | tee ../logs/<exp_name>_$(date +%Y%m%d_%H%M%S).log
EOF
chmod +x /tmp/run_exp.sh"

# 后台运行
pi_ssh_exec: <server>, "screen -dmS <exp_name> bash /tmp/run_exp.sh"
```

#### Option B: 直接运行

```bash
pi_ssh_exec: <server>, "cd <remote>/exp && \
export PYTHONPATH=<remote> && \
eval \"\$(conda shell.bash hook)\" && conda activate <conda_env> && \
CUDA_VISIBLE_DEVICES=<gpu_id> nohup python <exp_script>.py <args> > ../logs/<exp_name>.log 2>&1 &"
```

### Step 5: 验证启动

```bash
pi_ssh_exec: <server>, "screen -ls"
```

### Step 6: 检查输出

```bash
pi_ssh_exec: <server>, "tail -30 <remote>/logs/<log_file>"
```

## 规范项目结构

```
/remote/path/to/project/
├── .env/                    # 环境配置
│   └── config.yaml          # 项目配置
├── .data/                   # 数据集
│   ├── raw/                 # 原始数据
│   └── processed/           # 处理后的数据
├── .src/                    # ★ 源代码（不直接运行）
│   ├── models/              # 模型定义
│   ├── datasets/            # 数据加载器
│   ├── utils/               # 工具函数
│   └── losses/              # 损失函数
├── .scripts/                # 辅助脚本
├── .papers/                 # 论文相关资料
├── exp/                     # ★ 试验文件夹（论文直接相关）
│   ├── main_exp.py          # 主试验
│   ├── ablate_exp.py        # 消融实验
│   ├── compare_exp.py       # 对比实验
│   ├── param_exp.py         # 参数实验
│   └── figure_exp.py        # 生成图片
├── results/                  # 结果输出
└── logs/                    # 日志
```

**关键规则**:
- `.src/` - 代码库，存放可复用模块，不直接运行
- `exp/` - 论文直接相关的试验文件，可直接运行
- 所有路径使用相对引用（相对于项目根目录）

## CLAUDE.md 示例

```markdown
## PI SSH
- gpu: pi-ssh
- pi_ssh_server: my-gpu-server
- pi_ssh_remote_base: /home/user/experiments
- pi_ssh_project: my-project
- pi_ssh_conda_env: research
- pi_ssh_gpu_id: 0

## Project Structure (Remote)
All code maintained at: <pi_ssh_remote_base>/<pi_ssh_project>/
- .src/ - Models, datasets, utilities
- exp/ - Experiment scripts (main_exp, ablate_exp, compare_exp, param_exp, figure_exp)
- results/ - Experiment outputs
- logs/ - Training logs
```

## 常见命令

| 任务 | 命令 |
|------|------|
| 列出实验 | `pi_ssh_exec: <server>, "ls -1 <remote>/exp/"` |
| 查看日志 | `pi_ssh_exec: <server>, "tail -50 <remote>/logs/*.log"` |
| 检查进程 | `pi_ssh_exec: <server>, "ps aux \| grep python"` |
| 停止实验 | `pi_ssh_exec: <server>, "pkill -f '<exp_name>'"` |

## 推荐: 使用 pi-ssh-experiment

对于完整的远程实验管理，建议使用 `/pi-ssh-experiment` 技能：

```bash
# 初始化项目
/pi-ssh-experiment init my-project

# 运行实验
/pi-ssh-experiment run main_exp --epochs 100

# 监控实验
/pi-ssh-experiment monitor

# 收集结果
/pi-ssh-experiment collect main_exp
```

## 关键规则

1. **远程优先** - 所有代码在远程，本地只管理
2. **规范结构** - 使用标准化的项目结构
3. **使用 screen** - 确保实验在断开连接后继续运行
4. **记录日志** - 所有实验输出保存到 logs/ 目录
5. **收集结果** - 实验完成后下载结果到本地
