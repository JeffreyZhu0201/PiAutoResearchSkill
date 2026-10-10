# PI Research Skills

PI Agent 的研究实验技能包，将 Auto-claude-code-research-in-sleep 项目蒸馏为 PI Agent 可用的 skills。

## 核心原则

1. **远程优先架构** - 所有试验代码只维护在远程服务器，本地通过 SSH 操作
2. **规范项目结构** - 使用标准化的目录结构组织代码、数据和实验
3. **PI SSH 集成** - 使用 PI SSH 扩展进行远程实验管理
4. **本地-远程分离** - 本地管理论文、配置、结果；远程执行实验、存储数据

完整项目结构规范请参考：[templates/project-structure/PROJECT_STRUCTURE_GUIDE.md](templates/project-structure/PROJECT_STRUCTURE_GUIDE.md)
## Skills 列表

### 核心研究流程

| Skill | 用途 |
|-------|------|
| `/idea-discovery` | 发现研究方向和候选想法 |
| `/research-refine` | 研究问题细化，迭代式方法改进 |
| `/experiment-plan` | 将提案转化为详细的实验路线图 |
| `/experiment-bridge` | 实现实验代码并部署到GPU |
| `/pi-ssh-experiment` | 统一管理远程实验生命周期 |
| `/auto-review-loop` | 自动评审循环，分析结果并迭代 |

### 论文写作

| Skill | 用途 |
|-------|------|
| `/paper-plan` | 生成论文大纲 |
| `/paper-write` | 撰写论文 |
| `/paper-figure` | 生成论文图表 |

## 工作流程

```
/idea-discovery        发现研究方向
        ↓
/research-refine       细化方法提案
        ↓
/experiment-plan       制定实验计划
        ↓
/experiment-bridge     实现实验代码
        ↓
/pi-ssh-experiment     远程实验管理
   ├── init            初始化项目结构
   ├── run             运行实验
   ├── monitor         监控进度
   ├── collect         收集结果
   └── cleanup         清理资源
        ↓
/auto-review-loop     分析结果，迭代改进
        ↓
/paper-plan           规划论文结构
        ↓
/paper-write          撰写论文
---

## Idea Discovery: 论文整合 + 方向发现

`/idea-discovery` 支持从论文到创新方向的完整流程：

### 论文来源

| 来源 | 说明 |
|------|------|
| **本地论文** | 用户在 `paper/` 目录放置 PDF 或阅读笔记 |
| **爬取论文** | Agent 爬取 arXiv/学术论文（10 篇左右） |
| **混合模式** | 本地论文 + 补充爬取 |

### 本地论文目录结构

```
project/
├── paper/                    # ★ 用户放置论文的地方
│   ├── reading_notes/         # 阅读笔记
│   └── *.pdf                 # 论文 PDF
├── paper_analysis/           # Agent 生成的分析
│   ├── 01_core_papers/       # 核心论文分析
│   ├── 02_related_work/       # 相关工作分析
│   ├── 03_baselines/          # 基线方法分析
│   ├── 04_ideas/             # 生成的 idea
│   ├── 05_synthesis/          # 综合分析
│   ├── SYNOPSIS.md            # 摘要
│   └── RECOMMENDATIONS.md     # 最终推荐
└── CLAUDE.md
```

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

1. **检测本地文献** - 检查 paper/ 目录中的 PDF 和阅读笔记
2. **补充爬取** - 本地文献不足 10 篇时，爬取 arXiv 相关论文
3. **论文分析** - 每篇论文独立分析，输出结构化分析报告
4. **综合分析** - 识别领域现状、开放问题、研究 Gap
5. **方向生成** - 基于分析生成 5-8 个创新方向
6. **筛选推荐** - 新颖性、可行性、影响力评估，推荐最终方向


---

## 规范项目结构

所有远程项目必须遵循以下规范结构：

```
/remote/path/to/project/
├── .env/                    # 环境配置
│   └── config.yaml          # 项目配置
├── .data/                   # 数据集
│   ├── raw/                 # 原始数据
│   └── processed/           # 处理后的数据
├── .src/                    # ★ 源代码（不直接运行）
│   ├── __init__.py
│   ├── models/              # 模型定义
│   │   └── *.py
│   ├── datasets/            # 数据加载器
│   │   └── *.py
│   ├── utils/               # 工具函数
│   │   └── *.py
│   └── losses/              # 损失函数
│       └── *.py
├── .scripts/                # 辅助脚本
├── .papers/                 # 论文相关资料
├── exp/                     # ★ 试验文件夹（论文直接相关）
│   ├── main_exp.py          # 主试验
│   ├── ablate_exp.py        # 消融实验
│   ├── compare_exp.py       # 对比实验
│   ├── param_exp.py         # 参数实验
│   └── figure_exp.py        # 生成图片
├── results/                  # 结果输出
│   └── main_exp/
└── logs/                    # 日志
    └── main_exp_*.log
```

### 目录说明

| 目录 | 说明 | 规则 |
|------|------|------|
| `.env/` | 环境配置 | 只存放配置文件，如 config.yaml |
| `.data/` | 数据集 | 原始数据在 raw/，处理后在 processed/ |
| `.src/` | 源代码 | 可复用模块，不直接运行，通过 PYTHONPATH 引用 |
| `.scripts/` | 辅助脚本 | 数据处理、预处理等辅助脚本 |
| `.papers/` | 论文资料 | 参考文献、笔记等 |
| `exp/` | 试验文件 | 论文直接相关的试验代码，可直接运行 |
| `results/` | 结果输出 | 实验产生的模型、日志、图表等 |
| `logs/` | 训练日志 | 所有实验的日志文件 |

### 关键规则

1. **`.src/` vs `exp/`**
   - `.src/`: 代码库，存放模型、数据加载器、工具函数等可复用模块
   - `exp/`: 论文直接相关的试验文件，如主试验、消融实验、对比实验等

2. **导入方式**
   ```python
   import sys
   sys.path.insert(0, '..')  # 添加项目根目录到 PYTHONPATH
   
   from .src.models import YourModel
   from .src.datasets import get_dataloader
   from .src.utils import set_seed
   ```

3. **路径引用**
   - 使用相对路径引用项目内资源
   - 配置文件中使用相对路径：`paths.data: .data/processed`

---

## 快速开始

### 1. 配置 PI SSH

在项目的 `CLAUDE.md` 中添加：

```markdown
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
/pi-ssh-experiment init my-project
```

这将在远程服务器上创建规范的项目结构。

### 3. 编辑远程代码

```bash
/pi-ssh-experiment edit "<remote>/.src/models/my_model.py"
```

### 4. 运行实验

```bash
/pi-ssh-experiment run main_exp --epochs 100 --lr 0.001
```

### 5. 监控进度

```bash
/pi-ssh-experiment monitor
/pi-ssh-experiment monitor main_exp
```

### 6. 收集结果

```bash
/pi-ssh-experiment collect main_exp
```

---

## 完整研究流程示例

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

## 项目模板

`templates/project-structure/remote_exp_structure.sh` 提供了在远程服务器创建项目结构的脚本。

```bash
# 在远程服务器上运行
bash remote_exp_structure.sh my_project /home/user/experiments
```

---

## 共享资源

- `shared-references/output-versioning.md` - 输出版本控制协议
- `shared-references/output-manifest.md` - 输出清单协议
- `shared-references/output-language.md` - 输出语言协议
- `shared-references/experiment-integrity.md` - 实验完整性协议

## 模板文件

- `templates/EXPERIMENT_PLAN_TEMPLATE.md` - 实验计划模板
- `templates/EXPERIMENT_LOG_TEMPLATE.md` - 实验日志模板
- `templates/RESEARCH_CONTRACT_TEMPLATE.md` - 研究契约模板
- `templates/project-structure/remote_exp_structure.sh` - 远程项目结构脚本

## 目录结构

```
pi-research-skills/
├── skills/                    # Skills 目录
│   ├── research-refine/       # 研究细化
│   ├── experiment-plan/       # 实验计划
│   ├── experiment-bridge/     # 实验桥接
│   ├── pi-ssh-experiment/     # PI SSH 实验管理（核心）
│   ├── idea-discovery/         # 想法发现
│   ├── paper-plan/            # 论文规划
│   ├── paper-write/           # 论文写作
│   ├── auto-review-loop/      # 自动评审
│   ├── paper-figure/          # 论文图表
│   └── vast-gpu/              # Vast.ai GPU (可选)
├── shared-references/          # 共享协议
├── templates/                  # 模板文件
│   └── project-structure/      # 项目结构模板
└── README.md                   # 本文件
```

## 与原项目的差异

本项目相比 Auto-claude-code-research-in-sleep 进行了以下调整：

1. **远程优先架构** - 所有代码维护在远程，本地通过 SSH 操作
2. **规范项目结构** - 统一的项目目录结构，便于管理和协作
3. **移除 Codex 依赖** - 使用 PI Agent 内置的 AI 评审能力
4. **添加 PI SSH 支持** - 新增 `pi-ssh-experiment` skill，统一管理远程实验

## License

基于原项目 Auto-claude-code-research-in-sleep 的 MIT License。
