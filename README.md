# 🎯 PI Auto Research Skill

<div align="center">

![PI Agent](https://img.shields.io/badge/PI-Agent-Research-blue?style=for-the-badge)
![Python](https://img.shields.io/badge/Python-3.8+-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)
![Remote-First](https://img.shields.io/badge/Architecture-Remote--First-orange?style=for-the-badge)

**PI Agent 智能科研技能集** — 让 AI Agent 帮你做科研，从论文到实验的全流程自动化

[功能特性](#-功能特性) • [工作流程](#-工作流程) • [快速开始](#-快速开始) • [项目结构](#-项目结构) • [使用示例](#-使用示例)

</div>

---

## 🌟 功能特性

| 特性 | 说明 |
|------|------|
| 🚀 **远程实验管理** | 通过 SSH 统一管理远程 GPU 服务器上的实验 |
| 📄 **论文智能分析** | 自动爬取、分析论文，发现研究创新方向 |
| 🔬 **实验全生命周期** | 初始化 → 运行 → 监控 → 收集 → 清理 |
| 📊 **结果自动评审** | 分析实验结果，生成改进建议 |
 | 🎯 **一键端到端** | 一条命令完成从 idea 到 paper 的完整研究流程 |
---

## 🔄 工作流程

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           完整研究流程                                       │
└─────────────────────────────────────────────────────────────────────────────┘

     📚 Idea Discovery           📖 Research Refine           📋 Experiment Plan
    ┌─────────────────┐          ┌─────────────────┐         ┌─────────────────┐
    │  发现研究方向    │    →     │  细化研究方案    │   →    │  制定实验计划    │
    │  分析论文文献    │          │  迭代改进方法    │         │  规划实验步骤    │
    └────────┬────────┘          └────────┬────────┘         └────────┬────────┘
             │                            │                            │
             └────────────────────────────┴────────────────────────────┘
                                              ↓
                              ┌───────────────────────────────┐
                              │     💻 Experiment Bridge      │
                              │     实现实验代码并部署到 GPU    │
                              └───────────────┬───────────────┘
                                              ↓
    ┌─────────────────────────────────────────────────────────────────────────┐
    │                      ⚡ PI SSH Experiment Manager                       │
    ├─────────────────────────────────────────────────────────────────────────┤
    │                                                                          │
    │   init ◄────── 初始化远程项目结构                                         │
    │    │                                                                   │
    │    ├───► edit ◄──── 编辑远程代码                                         │
    │    │                                                                   │
    │    └───► run ◄────── 运行实验                                           │
    │              │                                                           │
    │              ├───► monitor ◄── 监控进度                                  │
    │              │                                                           │
    │              └───► collect ◄── 收集结果                                   │
    │                                                                            │
    │              ◄───────────────────────────────────                        │
    │                              │                                           │
    │                              ↓                                           │
    │                    ┌─────────────────┐                                   │
    │                    │  Auto Review    │                                   │
    │                    │  分析结果→迭代改进│                                   │
    │                    └────────┬────────┘                                   │
    │                             │                                            │
    └─────────────────────────────┴────────────────────────────────────────────┘
                                              ↓
                              ┌───────────────────────────────┐
                              │        📄 Paper Pipeline       │
                              │  paper-plan → paper-write     │
                              └───────────────────────────────┘
```

### 核心 Skills

#### 🎯 核心研究流程

| Skill | 功能 | 命令示例 |
|-------|------|---------|
 | `research` | 🎯 **一键端到端研究** | `/research "LLM推理加速"` |
 | `idea-discovery` | 📚 发现研究方向，分析论文文献 | `/idea-discovery "LLM推理加速"` |
| `research-refine` | 📖 细化研究问题，迭代方法改进 | `/research-refine "问题:延迟高 | 方法:投机解码"` |
| `experiment-plan` | 📋 制定详细实验路线图 | `/experiment-plan` |
| `experiment-bridge` | 💻 实现代码并部署到 GPU | `/experiment-bridge` |
| `pi-ssh-experiment` | ⚡ **统一管理远程实验** | `/pi-ssh-experiment run main_exp` |
| `auto-review-loop` | 🔄 分析结果，生成改进建议 | `/auto-review-loop` |

#### 📝 论文写作

| Skill | 功能 | 命令示例 |
|-------|------|---------|
| `paper-plan` | 📑 生成论文大纲 | `/paper-plan` |
| `paper-write` | ✍️ 撰写论文正文 | `/paper-write` |
| `paper-figure` | 📊 生成论文图表 | `/paper-figure` |
 ---
 
 ## 🎯 一键端到端研究
 
 只需一条命令，自动完成从研究方向发现到论文写作的完整流程：
 
 ```bash
 /research "LLM推理加速"
 ```
 
 **完整流程 (7 阶段)**:
 
 ```
 🎯 Idea Discovery → 📖 Research Refine → 📋 Experiment Plan → 💻 Experiment Bridge
         ↓
 ⚡ PI SSH Experiment (init → run → monitor → collect)
         ↓
 🔄 Auto Review Loop → 📄 Paper Write
 ```
 
 **执行模式**:
 - `full` - 完整流程（含实验）
 - `idea_only` - 仅发现方向  
 - `paper_only` - 仅论文写作
 - `--auto_experiment false` - 无实验模式
 
 ---
---

## 🚀 快速开始

### 1. 配置 PI SSH

在项目的 `CLAUDE.md` 中添加：

```yaml
## PI SSH
- gpu: pi-ssh              # 启用 PI SSH 远程实验
- pi_ssh_server: my-gpu-server  # 服务器别名
- pi_ssh_remote_base: /home/user/experiments/
- pi_ssh_project: my-project
- pi_ssh_conda_env: research    # Conda 环境名称
- pi_ssh_gpu_id: 0             # GPU ID
```

### 2. 初始化项目

```bash
# 初始化远程项目结构
/pi-ssh-experiment init my-project
```

### 3. 编辑 & 运行

```bash
# 编辑远程代码
/pi-ssh-experiment edit "<remote>/.src/models/my_model.py"

# 运行实验
/pi-ssh-experiment run main_exp --epochs 100 --lr 0.001

# 监控进度
/pi-ssh-experiment monitor main_exp

# 收集结果
/pi-ssh-experiment collect main_exp
```

---

## 📂 项目结构

### 本地项目结构

```
project/
├── CLAUDE.md                 # ⚙️ PI Agent 配置（包含 SSH 配置）
├── paper/                    # 📚 用户放置论文的地方
│   ├── reading_notes/        # 阅读笔记
│   └── *.pdf                 # 论文 PDF
├── paper_analysis/           # 📊 Agent 生成的分析
│   ├── 01_core_papers/       # 核心论文分析
│   ├── 02_related_work/      # 相关工作分析
│   ├── 03_baselines/         # 基线方法分析
│   ├── 04_ideas/             # 生成的 idea
│   ├── 05_synthesis/         # 综合分析
│   ├── SYNOPSIS.md           # 摘要
│   └── RECOMMENDATIONS.md    # 最终推荐
├── docs/                     # 📄 项目文档
├── local_results/            # 📁 本地结果（从远程同步）
└── .env/                     # 🔐 环境配置（可选）
```

### 远程项目结构

```
/remote/path/to/project/
├── .env/                    # ⚙️ 环境配置
│   └── config.yaml          # 项目配置
├── .data/                   # 📦 数据集
│   ├── raw/                 # 原始数据
│   └── processed/           # 处理后的数据
├── .src/                    # 💻 源代码（可复用模块）
│   ├── __init__.py
│   ├── models/              # 模型定义
│   ├── datasets/            # 数据加载器
│   ├── utils/               # 工具函数
│   └── losses/              # 损失函数
├── .scripts/                # 🔧 辅助脚本
├── .papers/                 # 📚 论文资料
├── exp/                     # 🔬 试验文件夹（论文直接相关）
│   ├── main_exp.py          # 主试验
│   ├── ablate_exp.py        # 消融实验
│   ├── compare_exp.py       # 对比实验
│   ├── param_exp.py         # 参数实验
│   └── figure_exp.py        # 生成图片
├── results/                  # 📊 结果输出
│   └── main_exp/
└── logs/                    # 📝 日志
    └── main_exp_*.log
```

### 目录说明

| 目录 | 说明 | 规则 |
|------|------|------|
| `.env/` | 环境配置 | 只存放配置文件 |
| `.data/` | 数据集 | raw/ 原始数据，processed/ 处理后 |
| `.src/` | 源代码 | 可复用模块，通过 PYTHONPATH 引用 |
| `exp/` | 试验文件 | 论文直接相关的试验代码 |
| `results/` | 结果输出 | 模型、日志、图表等 |
| `logs/` | 训练日志 | 所有实验的日志 |

---

## 📖 Idea Discovery: 论文到创新的桥梁

`/idea-discovery` 支持从论文到创新方向的完整流程：

### 使用方式

```bash
# 方式 1: 用户提供论文 + Agent 分析
# 用户在 paper/ 目录放置论文后
/idea-discovery "LLM推理加速"

# 方式 2: Agent 爬取论文
/idea-discovery "视觉语言模型对齐"

# 方式 3: 混合模式
/idea-discovery "扩散模型加速 --papers paper/ --supplement true"
```

### 工作流程

```
┌────────────────────────────────────────────────────────────────┐
│                    Idea Discovery 工作流程                       │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│   📂 检测本地文献 ──► 🌐 补充爬取 ──► 📊 论文分析                 │
│        │                  │                  │                  │
│        │            爬取 arXiv         每篇独立分析               │
│        │            ~10 篇论文          输出结构化报告             │
│        │                  │                  │                  │
│        └──────────────────┴──────────────────┘                  │
│                            │                                    │
│                            ▼                                    │
│                    🔍 综合分析                                   │
│              识别领域现状、开放问题、研究 Gap                     │
│                            │                                    │
│                            ▼                                    │
│                    💡 方向生成                                   │
│               基于分析生成 5-8 个创新方向                         │
│                            │                                    │
│                            ▼                                    │
│                    ⭐ 筛选推荐                                   │
│          新颖性、可行性、影响力评估，推荐最终方向                 │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 🔧 使用示例

### 完整研究流程

```bash
# 1. 发现研究方向
/idea-discovery "large language model efficiency"

# 2. 细化研究方案
/research-refine "PROBLEM: LLM推理延迟高 | APPROACH: 使用投机解码加速"

# 3. 制定实验计划
/experiment-plan

# 4. 实现实验代码
/experiment-bridge

# 5. 初始化远程项目
/pi-ssh-experiment init my-research

# 6. 编辑模型代码
/pi-ssh-experiment edit "<remote>/.src/models/my_model.py"

# 7. 运行主试验
/pi-ssh-experiment run main_exp --epochs 100

# 8. 监控实验
/pi-ssh-experiment monitor main_exp

# 9. 运行消融实验
/pi-ssh-experiment run ablate_exp --ablate component_a

# 10. 收集结果
/pi-ssh-experiment collect main_exp
/pi-ssh-experiment collect ablate_exp

# 11. 分析结果
/auto-review-loop

# 12. 撰写论文
/paper-plan
/paper-write
```

---

## 📦 项目组成

```
PiAutoResearchSkill/
├── skills/                    # 🎯 Skills 目录
│   ├── idea-discovery/        # 📚 想法发现
│   ├── research-refine/       # 📖 研究细化
│   ├── experiment-plan/       # 📋 实验计划
│   ├── experiment-bridge/     # 💻 实验桥接
│   ├── pi-ssh-experiment/      # ⚡ PI SSH 实验管理（核心）
│   ├── monitor-experiment/     # 📡 实验监控
│   ├── run-experiment/        # ▶️ 运行实验
│   ├── auto-review-loop/      # 🔄 自动评审
│   ├── paper-plan/            # 📑 论文规划
│   ├── paper-write/           # ✍️ 论文写作
│   └── paper-figure/          # 📊 论文图表
│
├── shared-references/          # 📄 共享协议
│   ├── output-versioning.md   # 输出版本控制
│   ├── output-manifest.md     # 输出清单
│   ├── output-language.md     # 输出语言
│   └── experiment-integrity.md # 实验完整性
│
├── templates/                  # 📋 模板文件
│   ├── EXPERIMENT_PLAN_TEMPLATE.md
│   ├── EXPERIMENT_LOG_TEMPLATE.md
│   ├── RESEARCH_CONTRACT_TEMPLATE.md
│   └── project-structure/
│       ├── PROJECT_STRUCTURE_GUIDE.md
│       └── remote_exp_structure.sh
│
└── README.md                   # 📖 本文件
```

---

## 🔑 核心原则

| 原则 | 说明 |
|------|------|
| 🌐 **远程优先架构** | 所有试验代码只维护在远程服务器，本地通过 SSH 操作 |
| 📁 **规范项目结构** | 使用标准化的目录结构组织代码、数据和实验 |
| ⚡ **PI SSH 集成** | 使用 PI SSH 扩展进行远程实验管理 |
| 🔀 **本地-远程分离** | 本地管理论文、配置、结果；远程执行实验、存储数据 |

---

## 📜 License

基于原项目 [Auto-claude-code-research-in-sleep](https://github.com/Skytliang/Auto-claude-code-research-in-sleep) 的 MIT License。

---

<div align="center">

**Made with ❤️ for PI Agent Research Automation**

</div>
