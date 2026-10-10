---
name: idea-discovery
description: "发现研究方向：从论文调研到创新方向生成。检测paper目录，爬取/整合论文，生成高质量创新idea。Use when user says '找方向', '发现idea', '发现研究方向', 'research direction', or wants to discover new research ideas from literature."
argument-hint: "[research-direction or topic]"
allowed-tools: Bash(*), Read, Write, Edit, Grep, Glob, WebSearch, WebFetch, mcp_exa_web_search_exa(*), mcp_exa_web_fetch_exa(*)
---

# Idea Discovery: 从论文调研到创新方向

发现研究方向：检测项目中的 paper 目录，爬取相关论文，整合本地文献，生成高质量创新方向。

**$ARGUMENTS**

## 核心原则

1. **本地优先** - 优先使用用户提供的论文和阅读报告
2. **按论文组织** - 每篇论文独立分析，结果按论文归档
3. **系统化调研** - 爬取 arXiv/学术论文补充文献库
4. **生成高质量方向** - 基于文献分析生成有依据的创新点

## 工作流程

### Phase 0: 检测本地文献

**检查项目中的 paper 目录和相关文件：**

```bash
# 检查 paper 目录
ls -la paper/ 2>/dev/null || ls -la papers/ 2>/dev/null || ls -la ./ 2>/dev/null | grep -i paper

# 检查 PDF 文件
find . -maxdepth 3 -name "*.pdf" -type f 2>/dev/null | head -20

# 检查阅读报告
find . -maxdepth 3 -name "*.md" -type f 2>/dev/null | xargs grep -l "paper\|论文\|阅读" 2>/dev/null | head -10

# 检查 notes 目录
find . -maxdepth 3 -type d -name "*note*" -o -name "*paper*" 2>/dev/null | head -5
```

**本地文献优先级：**
1. `paper/` 或 `papers/` 目录中的 PDF 文件
2. 论文阅读报告（markdown 格式）
3. 论文笔记
4. 用户提供的 arXiv URL

### Phase 1: 论文爬取（补充文献）

**如果本地文献不足 10 篇，爬取相关论文：**

```bash
# 搜索相关论文
web_search: "arxiv <研究方向> recent papers 2024"
web_search: "site:arxiv.org <关键词> recent"
```

**爬取策略（10 篇左右）：**

1. **核心论文（3-4 篇）** - 该方向的奠基性工作和最新顶会论文
2. **相关工作（3-4 篇）** - 相关的子方向和变体
3. **对比基线（2-3 篇）** - 常用 baseline 方法

**爬取命令：**

```bash
# 获取论文摘要
web_fetch: "<arxiv_url>"  # 例如 https://arxiv.org/abs/2401.00001

# 搜索更多相关论文
web_search: "<研究主题> arxiv 2024"
```

### Phase 2: 论文分析与归档

**创建规范的论文分析目录：**

```bash
# 创建目录结构
mkdir -p paper_analysis/
mkdir -p paper_analysis/01_core_papers/    # 核心论文
mkdir -p paper_analysis/02_related_work/   # 相关工作
mkdir -p paper_analysis/03_baselines/       # 基线方法
mkdir -p paper_analysis/04_ideas/           # 生成的idea
mkdir -p paper_analysis/05_synthesis/       # 综合分析
```

**按论文分别分析，每篇论文一个文件：**

对于每篇论文（如 `paper_analysis/01_core_papers/paper_01.md`）：

```markdown
# 论文分析：Paper Title

**论文信息**
- Title: [论文标题]
- Authors: [作者]
- Venue: [会议/期刊]
- Year: [年份]
- arXiv: [链接]

**核心贡献**
[1-2 句话总结主要贡献]

**关键方法**
[核心技术路线]

**实验结果**
- 主要 benchmark: [结果]
- 关键指标: [数字]

**局限性**
[论文承认的局限或作者建议的未来方向]

**可改进点**
[从局限性衍生的潜在改进方向]
```

**本地 PDF 处理：**
- 读取 PDF 前 5-8 页（标题、摘要、引言、方法概述）
- 提取关键信息填入模板

### Phase 3: 综合分析与 Gap 识别

**创建综合分析报告（`paper_analysis/05_synthesis/SYNTHESIS.md`）：**

```markdown
# 综合分析报告

**研究方向**: $ARGUMENTS
**分析日期**: [今天]
**分析的论文数**: [N] 篇

## 1. 领域现状

### 1.1 主要技术路线
[总结该领域的主流方法]

### 1.2 代表性工作
| 论文 | 核心方法 | 主要结果 | 局限性 |
|------|----------|----------|--------|
| [Paper 1] | [方法] | [结果] | [局限] |
| [Paper 2] | [方法] | [结果] | [局限] |

### 1.3 数据集与 Benchmark
[常用的数据集和评估指标]

## 2. 开放问题与研究 Gap

### 2.1 已知局限
[从论文中汇总的共同局限]

### 2.2 未解决问题
[论文中明确提出的 open problem]

### 2.3 跨领域机会
[其他领域方法迁移的可能性]

## 3. 技术趋势
[从论文中观察到的技术演进方向]

## 4. 研究机会矩阵

| 机会 | 来源论文 | 可行性 | 潜在影响 |
|------|----------|--------|----------|
| [机会描述] | [论文] | [高/中/低] | [高/中/低] |
```

### Phase 4: 创新方向生成

**基于综合分析，生成 5-8 个创新方向：**

创建 `paper_analysis/04_ideas/IDEAS.md`：

```markdown
# 创新方向候选

**研究方向**: $ARGUMENTS
**生成日期**: [今天]

## 方向 1: [方向标题]

**问题定义**
[清晰描述要解决的问题]

**动机**
[为什么这个问题重要]

**核心思路**
[提出的方法/改进的核心点]

**创新点**
1. [创新点 1]
2. [创新点 2]

**可行性分析**
- 数据: [需要的训练/评估数据]
- 计算: [预估的计算资源]
- 时间: [预估的开发周期]

**与现有工作的区别**
- 区别于 [Paper X]: [具体差异]
- 区别于 [Paper Y]: [具体差异]

**初步实验设计**
1. [实验 1]
2. [实验 2]

**风险与缓解**
- 风险: [风险描述]
- 缓解: [应对策略]

---

## 方向 2: [方向标题]
...

## 方向 3: [方向标题]
...
```

### Phase 5: 方向筛选与推荐

**对生成的方向进行筛选：**

1. **新颖性检查** - 确认没有完全相同的已发表工作
2. **可行性评估** - 评估数据、计算资源、时间
3. **影响力评估** - 评估潜在学术和应用价值

**输出最终推荐（`paper_analysis/RECOMMENDATIONS.md`）：**

```markdown
# 创新方向推荐

**研究方向**: $ARGUMENTS
**推荐日期**: [今天]

## 🏆 推荐方向 #1: [方向标题]

**综合评分**: [X/10]
- 新颖性: [X/10]
- 可行性: [X/10]
- 影响力: [X/10]

**一句话总结**: [一句话描述核心贡献]

**问题与动机**: [2-3 句话]

**核心方法**: [核心思路]

**预期结果**: [预期的实验结果]

**下一步**: → /research-refine 细化方案

---

## 🥈 备选方向 #2: [方向标题]

[同上格式]

---

## 🥉 备选方向 #3: [方向标题]

[同上格式]
```

## 论文目录规范

建议用户在项目中创建以下结构：

```
project/
├── paper/                    # ★ 用户放置论文的地方
│   ├── reading_notes/         # 阅读笔记
│   └── *.pdf                 # 论文 PDF
├── paper_analysis/           # Agent 生成的分析
│   ├── 01_core_papers/       # 核心论文分析
│   ├── 02_related_work/      # 相关工作分析
│   ├── 03_baselines/         # 基线方法分析
│   ├── 04_ideas/             # 生成的 idea
│   ├── 05_synthesis/         # 综合分析
│   ├── SYNOPSIS.md           # 摘要
│   └── RECOMMENDATIONS.md    # 最终推荐
└── CLAUDE.md                 # 项目配置
```

## 快速使用

### 方式 1: 用户提供论文

```bash
# 1. 用户在 paper/ 目录放置论文 PDF 或阅读笔记
# 2. 调用 skill
/idea-discovery "LLM推理加速"

# Agent 自动检测 paper/ 目录，分析论文，生成方向
```

### 方式 2: Agent 爬取论文

```bash
# 1. 用户提供研究方向
/idea-discovery "视觉语言模型对齐"

# Agent 爬取 10 篇相关论文，分析并生成方向
```

### 方式 3: 混合模式

```bash
# 用户提供部分论文 + Agent 补充
/idea-discovery "扩散模型加速 --papers paper/ --supplement true"
```

## 输出文件清单

| 文件 | 说明 |
|------|------|
| `paper_analysis/01_core_papers/paper_XX.md` | 每篇核心论文的分析 |
| `paper_analysis/02_related_work/` | 相关工作分析 |
| `paper_analysis/03_baselines/` | 基线方法分析 |
| `paper_analysis/04_ideas/IDEAS.md` | 生成的创新方向 |
| `paper_analysis/05_synthesis/SYNTHESIS.md` | 综合分析报告 |
| `paper_analysis/SYNOPSIS.md` | 项目摘要 |
| `paper_analysis/RECOMMENDATIONS.md` | 最终推荐（最重要） |

## 关键规则

1. **本地优先** - 优先使用用户提供的论文
2. **按论文组织** - 每篇论文独立分析，避免信息混杂
3. **10 篇左右** - 平衡广度和深度
4. **有依据的创新** - 每个 idea 都要有文献依据
5. **可执行的下一步** - 推荐连接到 /research-refine

## 后续步骤

生成推荐方向后，可继续：

```bash
/research-refine "[推荐方向]"     # 细化方案
/experiment-plan                  # 制定实验计划
/experiment-bridge                # 实现实验代码
/pi-ssh-experiment init            # 初始化远程项目
```
