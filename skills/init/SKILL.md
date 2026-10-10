# Init Project Skill

初始化本地科研项目目录结构，并引导配置远程服务器。

## 触发条件

用户请求初始化新项目、创建项目目录、或配置远程实验环境时触发。

## 输入参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `project_name` | string | 是 | 项目名称 |
| `remote_server` | string | 否 | 远程服务器别名（如 `gpu-server`） |
| `remote_path` | string | 否 | 远程项目根路径 |
| `conda_env` | string | 否 | Conda 环境名称 |
| `skip_remote` | boolean | 否 | 跳过远程配置（仅初始化本地） |

## 工作流程

### 阶段 1: 本地目录初始化

```
📁 project_name/
├── CLAUDE.md                 # ← 自动生成（包含 SSH 配置）
├── paper/                    # 📚 论文目录
│   ├── reading_notes/        # 阅读笔记
│   └── .gitkeep
├── paper_analysis/           # 📊 分析结果
│   ├── 01_core_papers/
│   ├── 02_related_work/
│   ├── 03_baselines/
│   ├── 04_ideas/
│   ├── 05_synthesis/
│   ├── SYNOPSIS.md
│   └── RECOMMENDATIONS.md
├── docs/                     # 📄 项目文档
│   └── .gitkeep
├── local_results/            # 📁 本地结果
│   └── .gitkeep
├── .env/                     # 🔐 环境配置
│   ├── config.example.yaml   # 配置模板
│   └── .gitkeep
└── .remote/                  # 🔗 远程链接信息
    └── remote_info.json
```

### 阶段 2: SSH 配置引导

检查用户 PI SSH 配置状态：

1. **检查 PI SSH 扩展是否安装**
   - 如果未安装，提示安装并提供指引

2. **引导配置服务器连接**
   - 询问远程服务器信息
   - 支持添加多个服务器配置

3. **生成 CLAUDE.md 配置**

### 阶段 3: 远程目录引导（可选）

提供远程项目结构创建指引：

```bash
# 推荐的远程目录结构
/remote/path/to/project/
├── .env/
│   └── config.yaml          # 项目配置
├── .data/
│   ├── raw/
│   └── processed/
├── .src/                    # 源代码（可复用模块）
│   ├── __init__.py
│   ├── models/
│   ├── datasets/
│   └── utils/
├── .scripts/
├── .papers/
├── exp/                     # 试验文件
│   ├── main_exp.py
│   ├── ablate_exp.py
│   └── compare_exp.py
├── results/
└── logs/
```

## 输出产物

| 文件 | 说明 |
|------|------|
| `CLAUDE.md` | PI Agent 配置文件，包含项目设置和 SSH 配置 |
| `paper/` | 论文目录（空） |
| `paper_analysis/` | 分析结果目录（空） |
| `docs/` | 文档目录（空） |
| `local_results/` | 本地结果目录（空） |
| `.env/config.example.yaml` | 配置模板 |
| `.remote/remote_info.json` | 远程服务器信息 |

## 执行示例

### 示例 1: 完整初始化（本地 + 远程）

```
/init my-llm-research --remote_server gpu-server --remote_path /home/user/experiments/llm --conda_env research
```

输出：
```
✅ 本地目录创建完成
📁 my-llm-research/
├── CLAUDE.md
├── paper/
├── paper_analysis/
├── docs/
├── local_results/
└── .env/

🔧 SSH 配置
请配置 PI SSH 连接到 gpu-server

📝 远程目录创建指引：
在远程服务器上执行：
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JeffreyZhu0201/PiAutoResearchSkill/main/templates/project-structure/remote_exp_structure.sh)" llm /home/user/experiments
```

### 示例 2: 仅本地初始化

```
/init my-local-project --skip_remote
```

### 示例 3: 交互式初始化

```
/init
> 请输入项目名称: my-research
> 请选择远程服务器 [1] gpu-server [2] new-server [skip] : 1
> 远程项目路径 [/home/user/experiments/]: my-research
> Conda 环境 [research]: 
```

## 错误处理

| 错误 | 处理方式 |
|------|----------|
| 目录已存在 | 询问是否覆盖或合并 |
| SSH 连接失败 | 提示检查连接配置，提供调试命令 |
| 无写入权限 | 提示使用正确的目录路径 |
| 远程路径不存在 | 询问是否创建 |

## CLAUDE.md 模板

生成的 `CLAUDE.md` 应包含：

```markdown
# 项目配置

## 基本信息
- 项目名称: {project_name}
- 创建时间: {timestamp}
- 项目描述: 

## PI SSH
- gpu: pi-ssh
- pi_ssh_server: {server_alias}
- pi_ssh_remote_base: {remote_path}
- pi_ssh_project: {project_name}
- pi_ssh_conda_env: {conda_env}
- pi_ssh_gpu_id: 0

## 项目结构
- 本地: `paper/`, `paper_analysis/`, `docs/`, `local_results/`
- 远程: `.env/`, `.data/`, `.src/`, `exp/`, `results/`, `logs/`

## 研究方向
（留空，由用户填写）

## 当前进度
（留空，跟踪研究进度）
```

## 与其他 Skills 的衔接

- ✅ 初始化完成后，提示使用 `/idea-discovery` 开始研究方向发现
- ✅ 提示使用 `/pi-ssh-experiment` 管理远程实验
- ✅ 如需制定实验计划，使用 `/experiment-plan`
