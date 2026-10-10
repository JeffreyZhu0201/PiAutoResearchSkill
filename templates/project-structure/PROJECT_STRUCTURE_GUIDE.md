# 项目结构指南

## 核心原则

1. **远程执行，本地管理** - 试验代码和执行在远程，本地只做管理和分析
2. **数据分离** - 大型数据集在远程，本地只存副本和元数据
3. **结果同步** - 远程结果定期同步到本地备份

---

## 本地项目结构

```
project/
├── CLAUDE.md                 # ★ 项目配置（必须）
├── .env/                     # 本地环境配置
│   └── config.yaml          # PI SSH 配置等
├── paper/                    # ★ 论文资源
│   ├── reading_notes/        # 阅读笔记
│   │   ├── paper1_notes.md  # 每篇论文的笔记
│   │   └── paper2_notes.md
│   ├── *.pdf                # 论文 PDF
│   └── arxiv_urls.txt       # 收集的 arXiv 链接
├── paper_analysis/           # Agent 生成的论文分析
│   ├── 01_core_papers/      # 核心论文分析
│   ├── 02_related_work/      # 相关工作分析
│   ├── 03_baselines/         # 基线方法分析
│   ├── 04_ideas/             # 生成的 idea
│   ├── 05_synthesis/         # 综合分析
│   ├── SYNOPSIS.md          # 项目摘要
│   └── RECOMMENDATIONS.md   # ★ 最终推荐
├── docs/                     # 项目文档
│   ├── proposal.md          # 提案
│   ├── experiment_plan.md    # 实验计划
│   └── meeting_notes/        # 会议笔记
├── local_results/            # 从远程同步的结果
│   ├── main_exp/            # 主实验结果
│   ├── ablate_exp/           # 消融实验结果
│   └── compare_exp/          # 对比实验结果
├── logs/                     # 本地日志（如果有）
├── .remote/                  # 远程项目信息
│   └── config.yaml          # 远程项目路径等配置
└── README.md                 # 项目说明
```

### 目录说明

| 目录 | 说明 | 同步 |
|------|------|------|
| `CLAUDE.md` | 项目配置，包含 PI SSH 配置 | 不需要 |
| `.env/config.yaml` | PI SSH 连接信息 | 不需要 |
| `paper/` | 用户收集的论文资源 | 不需要 |
| `paper_analysis/` | Agent 分析结果 | 建议备份 |
| `docs/` | 项目文档 | 建议备份 |
| `local_results/` | 远程结果副本 | 从远程同步 |
| `logs/` | 本地日志 | 可选 |
| `.remote/` | 远程配置信息 | 不需要 |

---

## 远程项目结构

```
/remote/path/to/project/
├── .env/                    # 环境配置
│   └── config.yaml          # 项目配置
├── .data/                   # 数据集（大型）
│   ├── raw/                 # 原始数据
│   └── processed/            # 处理后的数据
├── .src/                    # ★ 源代码
│   ├── models/              # 模型定义
│   ├── datasets/            # 数据加载器
│   ├── utils/               # 工具函数
│   └── losses/              # 损失函数
├── .scripts/                # 辅助脚本
├── .papers/                 # 论文资料（可选）
├── exp/                     # ★ 试验文件夹
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

| 目录 | 说明 | 同步 |
|------|------|------|
| `.env/config.yaml` | 项目配置 | 本地需要副本 |
| `.data/` | 大型数据集 | 不需要 |
| `.src/` | 源代码 | 不需要 |
| `exp/` | 试验文件 | 不需要 |
| `results/` | 实验结果 | 同步到本地 |
| `logs/` | 训练日志 | 同步到本地 |

---

## CLAUDE.md 配置

```markdown
# 项目配置

## 项目信息
- name: my-research-project
- description: [项目描述]

## PI SSH
- gpu: pi-ssh
- pi_ssh_server: my-gpu-server
- pi_ssh_remote_base: /home/user/experiments
- pi_ssh_project: my-project
- pi_ssh_conda_env: research
- pi_ssh_gpu_id: 0

## 本地路径
- local_results: ./local_results
- paper: ./paper
- paper_analysis: ./paper_analysis
- docs: ./docs

## 远程路径
- remote_base: <pi_ssh_remote_base>/<pi_ssh_project>
- remote_data: <remote_base>/.data
- remote_results: <remote_base>/results
- remote_logs: <remote_base>/logs
- remote_exp: <remote_base>/exp
```

---

## 初始化流程

### 1. 创建本地项目

```bash
# 创建目录结构
mkdir -p project/{paper/reading_notes,paper_analysis/{01_core_papers,02_related_work,03_baselines,04_ideas,05_synthesis},docs/meeting_notes,local_results,logs,.env,.remote}

# 创建 CLAUDE.md
cat > project/CLAUDE.md << 'EOF'
# 项目配置
...
EOF
```

### 2. 初始化远程项目

```bash
/pi-ssh-experiment init my-project
```

### 3. 同步配置

将远程配置信息保存到本地：

```bash
# 记录远程路径
echo "remote_project: /home/user/experiments/my-project" > .remote/config.yaml
```

---

## 常用工作流

### 论文分析流程

```bash
# 1. 用户在 paper/ 放置论文
cp ~/Downloads/*.pdf paper/

# 2. 添加阅读笔记
cat > paper/reading_notes/paper1_notes.md << 'EOF'
# 论文笔记：Paper Title

## 核心贡献
[笔记内容]
...
EOF

# 3. 运行 idea-discovery
/idea-discovery "研究方向"
```

### 实验执行流程

```bash
# 1. 初始化远程项目
/pi-ssh-experiment init my-project

# 2. 编辑远程代码
/pi-ssh-experiment edit "<remote>/.src/models/my_model.py"

# 3. 运行实验
/pi-ssh-experiment run main_exp --epochs 100

# 4. 监控进度
/pi-ssh-experiment monitor

# 5. 收集结果
/pi-ssh-experiment collect main_exp
```

### 结果同步流程

```bash
# 使用 pi-ssh-experiment 收集
/pi-ssh-experiment collect main_exp --local-dir ./local_results

# 或手动同步
pi_ssh_download: <server>, <remote>/results/, ./local_results/
pi_ssh_download: <server>, <remote>/logs/, ./local_results/logs/
```

---

## 目录大小管理

| 类型 | 远程 | 本地 |
|------|------|------|
| 论文 PDF | 不存 | 存 |
| 数据集 | 存 | 不存 |
| 模型权重 | 存 | 只存最终版 |
| 日志 | 存 | 存副本 |
| 代码 | 存 | 不存 |

### 清理策略

**本地定期清理：**
```bash
# 删除旧日志
rm -rf logs/*

# 只保留最终结果
rm -rf local_results/*/checkpoints/
```

**远程定期清理：**
```bash
/pi-ssh-experiment cleanup logs    # 清理旧日志
/pi-ssh-experiment cleanup temp    # 清理临时文件
```

---

## 文件模板

### paper/reading_notes/TEMPLATE.md

```markdown
# 论文笔记：Paper Title

**论文信息**
- Title: [标题]
- Authors: [作者]
- Venue: [会议/年份]
- arXiv: [链接]

## 一句话总结
[1-2 句话的核心贡献]

## 核心方法
[核心技术路线]

## 关键创新点
1. [创新点 1]
2. [创新点 2]

## 实验结果
- 主要 Benchmark: [结果]
- 关键指标: [数字]

## 局限性
[论文承认的局限]

## 可改进点
[从局限性衍生的改进方向]

## 与我的研究方向的关系
[关联性分析]
```

### .env/config.yaml

```yaml
# PI SSH 配置
pi_ssh:
  server: my-gpu-server
  remote_base: /home/user/experiments
  project: my-project
  conda_env: research
  gpu_id: 0

# 同步配置
sync:
  auto_sync: false
  sync_interval: daily
  exclude:
    - "*.pt"
    - "*.pth"
    - "*.ckpt"
    - "__pycache__"
```

---

## 最佳实践

1. **CLAUDE.md 是核心** - 所有配置集中在 CLAUDE.md
2. **论文本地管理** - PDF 和笔记放在 paper/ 目录
3. **结果及时同步** - 实验完成后立即同步结果
4. **日志本地备份** - 重要实验日志保留本地副本
5. **定期清理** - 远程和本地都要定期清理旧文件
