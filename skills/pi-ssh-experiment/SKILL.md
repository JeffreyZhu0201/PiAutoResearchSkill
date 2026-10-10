---
name: pi-ssh-experiment
description: "Remote experiment manager using PI SSH extension. All experiments run on remote server, code is maintained remotely. Use when user says 'remote experiment', 'run on server', 'ssh experiment', or needs to manage experiments on a remote GPU server with standardized project structure."
argument-hint: "[action] [args]"
allowed-tools: pi_ssh(*), Bash(*), Read, Write, Edit, Grep, Glob
---

# PI SSH Remote Experiment Manager

**核心原则**: 所有试验代码只维护在远程服务器，本地通过 SSH 操作远程文件。

Manage remote experiments via PI SSH: **$ARGUMENTS**

## Project Structure Standard

所有远程项目必须遵循规范的结构：

```
/remote/path/to/project/
├── .env/                    # 环境配置
│   └── config.yaml          # 项目配置
├── .data/                   # 数据集
│   ├── raw/                 # 原始数据
│   └── processed/           # 处理后的数据
├── .src/                    # 源代码（函数、工具）
│   ├── models/              # 模型定义
│   ├── datasets/            # 数据加载器
│   ├── utils/              # 工具函数
│   └── losses/             # 损失函数
├── .scripts/               # 辅助脚本
├── .papers/                # 论文相关
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
- `.src/` - 代码库，不直接运行
- `exp/` - 论文直接相关的试验文件
- 本地只维护 CLAUDE.md 和本地结果副本

## Actions

### init — 在远程创建项目结构

**Usage:** `/pi-ssh-experiment init [project-name]`

**Steps:**

1. **Read CLAUDE.md** for remote path configuration:
   - `pi_ssh_remote_base`: Base directory on remote server

2. **Create project structure on remote:**
   ```bash
   pi_ssh_exec: <server>, "mkdir -p <remote_base>/<project>/{exp,results,logs,.env,.data/{raw,processed},.src/{models,datasets,utils,losses},.scripts,.papers}"
   ```

3. **Create config template:**
   ```bash
   pi_ssh_upload_content: <remote>/.env/config.yaml, [config content]
   ```

4. **Create experiment templates:**
   ```bash
   pi_ssh_upload_content: <remote>/exp/main_exp.py, [main experiment template]
   pi_ssh_upload_content: <remote>/exp/ablate_exp.py, [ablation template]
   pi_ssh_upload_content: <remote>/exp/compare_exp.py, [comparison template]
   ```

5. **Create source modules:**
   ```bash
   pi_ssh_upload_content: <remote>/.src/__init__.py, ""
   pi_ssh_upload_content: <remote>/.src/models/__init__.py, [model module]
   pi_ssh_upload_content: <remote>/.src/utils/__init__.py, [utils module]
   ```

6. **Report:**
   ```
   ✅ Project structure created at: <remote_path>
   Structure:
   ├── .env/config.yaml
   ├── .src/
   │   ├── models/
   │   ├── datasets/
   │   └── utils/
   ├── exp/
   │   ├── main_exp.py
   │   ├── ablate_exp.py
   │   ├── compare_exp.py
   │   └── figure_exp.py
   └── results/
   ```

### edit — 编辑远程代码

**Usage:** `/pi-ssh-experiment edit <remote-file> [content]`

**Steps:**

1. **Read current content:**
   ```bash
   pi_ssh_exec: <server>, "cat <remote_file>"
   ```

2. **Apply edits via diff or full content:**
   ```bash
   pi_ssh_upload_content: <remote_file>, [new content]
   ```

3. **Verify edit:**
   ```bash
   pi_ssh_exec: <server>, "head -20 <remote_file>"
   ```

### run — 在远程运行实验

**Usage:** `/pi-ssh-experiment run <exp-name> [--args]`

**Steps:**

1. **Verify project structure exists:**
   ```bash
   pi_ssh_exec: <server>, "ls -la <remote>/exp/"
   ```

2. **Create run script:**
   ```bash
   pi_ssh_exec: <server>, "cat > /tmp/run_<exp_name>.sh << 'SCRIPT'
   #!/bin/bash
   cd <remote>/exp
   export PYTHONPATH=<remote>:$PYTHONPATH
   python <exp_name>.py <args> 2>&1 | tee ../logs/<exp_name>_$(date +%Y%m%d_%H%M%S).log
   SCRIPT
   chmod +x /tmp/run_<exp_name>.sh"
   ```

3. **Execute via screen:**
   ```bash
   pi_ssh_exec: <server>, "screen -dmS <exp_name> bash /tmp/run_<exp_name>.sh"
   ```

4. **Verify running:**
   ```bash
   pi_ssh_exec: <server>, "screen -ls | grep <exp_name>"
   ```

5. **Report:**
   ```
   ✅ Experiment started: <exp_name>
   - Remote path: <remote>/exp/<exp_name>.py
   - Screen: <exp_name>
   - Log: <remote>/logs/<exp_name>_*.log
   ```

### monitor — 监控远程实验

**Usage:** `/pi-ssh-experiment monitor [exp-name]`

**Steps:**

1. **List running experiments:**
   ```bash
   pi_ssh_exec: <server>, "screen -ls"
   ```

2. **Get output from specific experiment:**
   ```bash
   pi_ssh_exec: <server>, "screen -S <exp_name> -X hardcopy /tmp/screen_<exp_name>.txt && tail -50 /tmp/screen_<exp_name>.txt"
   ```

3. **Check GPU status:**
   ```bash
   pi_ssh_exec: <server>, "nvidia-smi --query-gpu=index,memory.used,memory.total,utilization.gpu --format=csv,noheader"
   ```

4. **Check experiment logs:**
   ```bash
   pi_ssh_exec: <server>, "ls -lt <remote>/logs/*.log | head -5"
   pi_ssh_exec: <server>, "tail -30 <remote>/logs/<latest_log>"
   ```

5. **Present summary:**
   ```
   📊 Experiment Status
   
   | Name | Status | GPU Memory | Log |
   |------|--------|------------|-----|
   | exp1 | Running | 8.5/16 GB | logs/exp1_*.log |
   
   Latest output:
   [last 20 lines from screen]
   ```

### list — 列出远程实验

**Usage:** `/pi-ssh-experiment list`

**Steps:**

1. **List experiment files:**
   ```bash
   pi_ssh_exec: <server>, "ls -1 <remote>/exp/"
   ```

2. **List results:**
   ```bash
   pi_ssh_exec: <server>, "ls -1 <remote>/results/"
   ```

3. **List logs:**
   ```bash
   pi_ssh_exec: <server>, "ls -1 <remote>/logs/"
   ```

4. **Present:**
   ```
   📁 Remote Project: <project_name>
   
   exp/ (experiment files):
   ├── main_exp.py
   ├── ablate_exp.py
   ├── compare_exp.py
   ├── param_exp.py
   └── figure_exp.py
   
   results/ (outputs):
   ├── main_exp/
   └── ablate_exp/
   
   logs/:
   └── main_exp_20241010_143022.log
   ```

### collect — 下载实验结果

**Usage:** `/pi-ssh-experiment collect [exp-name] [--local-dir]`

**Steps:**

1. **List available results:**
   ```bash
   pi_ssh_exec: <server>, "ls -la <remote>/results/<exp_name>/"
   ```

2. **Download results:**
   ```bash
   pi_ssh_download: <server>, <remote>/results/<exp_name>/, <local_dir>/results/<exp_name>/
   ```

3. **Download relevant logs:**
   ```bash
   pi_ssh_download: <server>, <remote>/logs/, <local_dir>/logs/
   ```

4. **Download experiment config used:**
   ```bash
   pi_ssh_download: <server>, <remote>/.env/config.yaml, <local_dir>/config.yaml"
   ```

5. **Present:**
   ```
   ✅ Results collected:
   - Results: <local>/results/<exp_name>/
   - Logs: <local>/logs/
   - Config: <local>/config.yaml
   ```

### stop — 停止远程实验

**Usage:** `/pi-ssh-experiment stop [exp-name]`

**Steps:**

1. **Graceful stop:**
   ```bash
   pi_ssh_exec: <server>, "screen -S <exp_name> -X stuff '\\\\003'"
   ```

2. **Wait 10 seconds**

3. **Force stop if still running:**
   ```bash
   pi_ssh_exec: <server>, "screen -S <exp_name> -X quit 2>/dev/null || true"
   ```

4. **Verify:**
   ```bash
   pi_ssh_exec: <server>, "screen -ls | grep <exp_name> || echo 'Stopped'"
   ```

5. **Report:**
   ```
   ✅ Experiment stopped: <exp_name>
   ```

### cleanup — 清理远程资源

**Usage:** `/pi-ssh-experiment cleanup [scope] [--keep-results]`

**Scopes:**
- `logs` - 清理旧日志
- `temp` - 清理临时文件
- `all` - 清理所有（保留结果）
- `full` - 完全清理

**Steps:**

```bash
# Clean old logs (keep last 10)
pi_ssh_exec: <server>, "cd <remote>/logs && ls -t | tail -n +11 | xargs rm -f"

# Clean temp files
pi_ssh_exec: <server>, "rm -rf <remote>/.data/raw/tmp_*"
pi_ssh_exec: <server>, "rm -f /tmp/screen_*.txt"

# Full cleanup (if scope=all)
pi_ssh_exec: <server>, "rm -rf <remote>/logs/* && rm -rf <remote>/.data/processed/tmp_*"
```

### sync — 同步本地代码到远程

**Usage:** `/pi-ssh-experiment sync <local-dir> [--remote-dir]`

**Steps:**

1. **Upload changed files:**
   ```bash
   pi_ssh_upload: <local_dir>/.src/, <remote>/.src/
   pi_ssh_upload: <local_dir>/exp/, <remote>/exp/
   ```

2. **Verify sync:**
   ```bash
   pi_ssh_exec: <server>, "ls -la <remote>/.src/ && ls -la <remote>/exp/"
   ```

3. **Report:**
   ```
   ✅ Code synced:
   - .src/ → <remote>/.src/
   - exp/ → <remote>/exp/
   ```

## CLAUDE.md Configuration

```markdown
## PI SSH
- gpu: pi-ssh
- pi_ssh_server: my-gpu-server
- pi_ssh_remote_base: /home/user/experiments
- pi_ssh_project: my-project

## Project Structure
Remote code maintained at: <pi_ssh_remote_base>/<pi_ssh_project>/
- .src/ - Models, datasets, utilities
- exp/ - Experiment scripts (main, ablate, compare, param, figure)
- results/ - Experiment outputs
- logs/ - Training logs
```

## Example Workflow

```
1. /pi-ssh-experiment init "my-research"
   → Creates project structure on remote server

2. /pi-ssh-experiment edit "<remote>/.src/models/my_model.py"
   → Edit remote model code

3. /pi-ssh-experiment run main_exp --epochs 100 --lr 0.001
   → Run main experiment on remote GPU

4. /pi-ssh-experiment monitor main_exp
   → Check training progress

5. /pi-ssh-experiment collect main_exp
   → Download results to local

6. /pi-ssh-experiment cleanup logs
   → Clean up old logs
```

## Key Rules

- **Remote-first**: All code lives on remote, local only manages and views
- **Standard structure**: Always use the defined project structure
- **Screen sessions**: Use screen to keep experiments running after disconnect
- **Log everything**: All experiments should log to `logs/` directory
- **Collect results**: Download results after experiment completes
- **Clean regularly**: Clean old logs and temp files to free disk space
