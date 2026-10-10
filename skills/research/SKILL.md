# 🎯 Research Pipeline Skill

**一键端到端自动研究** — 从研究方向到论文写作的全流程自动化

## 触发条件

用户请求一键启动完整研究流程时触发，如：
- "开始研究 LLM 推理加速"
- "一键科研：视觉语言模型对齐"
- "帮我跑完整个研究流程"

## 输入参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `topic` | string | 是 | 研究主题/方向 |
| `scope` | enum | 否 | `full`(完整) / `idea_only`(仅发现方向) / `paper_only`(仅论文写作) |
| `papers` | path | 否 | 本地论文目录 |
| `auto_experiment` | boolean | 否 | 是否自动运行实验（默认 true） |
| `target_venue` | string | 否 | 目标期刊/会议 |

## 端到端工作流程

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        🎯 一键端到端研究流程                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐ │
│  │   1. IDEA    │ →  │   2. REFINE  │ →  │   3. PLAN   │ →  │  4. BRIDGE  │ │
│  │   Discovery  │    │    & Solve   │    │   Experiment│    │  Implement  │ │
│  │   发现方向    │    │   问题细化    │    │   制定计划   │    │   实现代码   │ │
│  └─────────────┘    └─────────────┘    └─────────────┘    └──────┬──────┘ │
│                                                                     │        │
│                                                                     ↓        │
│  ┌─────────────────────────────────────────────────────────────────────────┐│
│  │                     ⚡ PI SSH Experiment Manager                        ││
│  │              init → edit → run → monitor → collect → cleanup           ││
│  └──────────────────────────────────┬──────────────────────────────────────┘│
│                                     │                                         │
│                                     ↓                                         │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐                     │
│  │   5. REVIEW │ →  │   6. PLAN   │ →  │   7. WRITE  │                     │
│  │   Auto Loop │    │   Paper     │    │   Paper     │                     │
│  │   结果评审   │    │   论文规划   │    │   论文写作   │                     │
│  └─────────────┘    └─────────────┘    └─────────────┘                     │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 阶段详解

### 阶段 1: 🎯 Idea Discovery (自动)

```
执行: /idea-discovery {topic}
输入: 研究主题
输出: 
  - paper_analysis/SYNOPSIS.md (领域概述)
  - paper_analysis/RECOMMENDATIONS.md (推荐方向)
  - paper_analysis/04_ideas/ (候选 idea 列表)
```

**Agent 行为**:
1. 检测 `paper/` 目录中的本地论文（如有）
2. 补充爬取 arXiv 相关论文（~10篇）
3. 生成领域分析报告
4. 输出 5-8 个候选创新方向
5. 选择最佳方向供用户确认

### 阶段 2: 📖 Research Refine (自动)

```
执行: /research-refine
输入: 选定的 idea
输出: 
  - 细化的研究问题
  - 明确的方法方案
  - 技术路线图
```

**Agent 行为**:
1. 迭代式问题细化
2. 方法设计优化
3. 识别潜在风险
4. 生成研究提案文档

### 阶段 3: 📋 Experiment Plan (自动)

```
执行: /experiment-plan
输入: 研究提案
输出:
  - 详细的实验路线图
  - 基线方法列表
  - 评估指标
  - 消融实验设计
```

**Agent 行为**:
1. 制定主实验计划
2. 设计消融实验
3. 确定对比基线
4. 规划实验顺序

### 阶段 4: 💻 Experiment Bridge (自动)

```
执行: /experiment-bridge
输入: 实验计划
输出:
  - 远程项目结构初始化
  - 代码实现
  - 实验配置
```

**Agent 行为**:
1. 初始化远程项目结构（调用 pi-ssh-experiment init）
2. 实现核心代码
3. 配置实验参数
4. 验证代码可运行

### 阶段 5: ⚡ PI SSH Experiment Manager (自动)

```
执行: /pi-ssh-experiment
输入: 实现的实验代码
输出:
  - 运行日志
  - 实验结果
```

**子命令序列**:
```bash
# 初始化（如未初始化）
/pi-ssh-experiment init {project}

/pi-ssh-experiment run main_exp --epochs 100
/pi-ssh-experiment monitor main_exp
/pi-ssh-experiment collect main_exp

/pi-ssh-experiment run ablate_exp
/pi-ssh-experiment collect ablate_exp
```

**Agent 行为**:
1. 提交主实验任务
2. 实时监控进度
3. 收集实验结果
4. 运行消融实验
5. 汇总所有结果

### 阶段 6: 🔄 Auto Review Loop (自动)

```
执行: /auto-review-loop
输入: 实验结果
输出:
  - 结果分析报告
  - 改进建议
  - 是否需要迭代
```

**Agent 行为**:
1. 分析实验结果
2. 生成可视化图表
3. 与基线对比
4. 评估是否达到预期
5. 生成改进建议

### 阶段 7: 📄 Paper Write (自动)

```
执行: /paper-plan + /paper-write
输入: 实验结果和改进报告
输出:
  - 论文大纲
  - 完整论文草稿
  - 图表和表格
```

**Agent 行为**:
1. 生成论文大纲
2. 撰写各章节
3. 生成实验图表
4. 整理参考文献

## 执行模式

### 模式 A: 完整流程 (默认)

```bash
/research "LLM推理加速"
```

自动执行所有 7 个阶段，每个阶段完成后暂停询问用户确认。

### 模式 B: 仅发现方向

```bash
/research "扩散模型加速" --scope idea_only
```

只执行阶段 1-2，生成研究方向后停止。

### 模式 C: 仅论文写作

```bash
/research --scope paper_only
```

使用已有实验结果，直接撰写论文。

### 模式 D: 无实验模式

```bash
/research "理论研究方向" --auto_experiment false
```

跳过实验阶段，直接从 idea 到 paper。

## 交互策略

### 自动执行 + 用户确认

```
🔄 [阶段 1/7] Idea Discovery
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
正在分析论文文献...
发现 12 篇相关论文
生成 6 个候选方向

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 推荐方向: "投机解码加速LLM推理"

候选方向:
1. [★] 投机解码加速LLM推理
2. [ ] 稀疏注意力机制
3. [ ] 知识蒸馏压缩模型
...

> 请选择研究方向 (输入编号或直接回车确认): 
```

### 错误恢复

| 阶段 | 错误类型 | 处理方式 |
|------|----------|----------|
| Idea | 无相关论文 | 扩大搜索范围，询问用户补充关键词 |
| Refine | 方法不可行 | 回退到 idea 阶段，重新选择方向 |
| Bridge | 代码实现失败 | 报告具体错误，提供修复建议 |
| Experiment | 实验超时/失败 | 重试或调整参数，记录问题 |
| Review | 结果不理想 | 询问是否迭代或调整方向 |
| Paper | 结果不足以支撑 | 建议补充实验或调整论文范围 |

## 输出产物

```
project/
├── CLAUDE.md
├── paper/                          # 源论文
├── paper_analysis/
│   ├── 01_core_papers/            # 论文分析
│   ├── 04_ideas/                  # 生成的 idea
│   ├── SYNOPSIS.md                # 领域概述
│   └── RECOMMENDATIONS.md         # 方向推荐
│
├── .remote/{project}/             # 远程项目
│   ├── .src/                      # 源代码
│   ├── exp/                       # 实验代码
│   ├── results/                   # 实验结果
│   └── logs/                      # 日志
│
├── local_results/                 # 本地同步结果
│   ├── main_exp/                  # 主实验结果
│   ├── ablate_exp/               # 消融实验结果
│   └── figures/                   # 图表
│
└── paper/
    ├── outline.md                 # 论文大纲
    ├── main.pdf                   # 论文 PDF
    ├── figures/                   # 论文图表
    └── references.bib             # 参考文献
```

## 与其他 Skills 的衔接

| 调用 | 阶段 | 说明 |
|------|------|------|
| `/idea-discovery` | 阶段 1 | 发现研究方向 |
| `/research-refine` | 阶段 2 | 细化研究方案 |
| `/experiment-plan` | 阶段 3 | 制定实验计划 |
| `/experiment-bridge` | 阶段 4 | 实现实验代码 |
| `/pi-ssh-experiment` | 阶段 5 | 管理远程实验 |
| `/auto-review-loop` | 阶段 6 | 分析实验结果 |
| `/paper-plan` | 阶段 7a | 规划论文结构 |
| `/paper-write` | 阶段 7b | 撰写论文内容 |

## 执行示例

### 示例 1: 标准一键研究

```
/research "视觉语言模型对齐"
```

输出：
```
🎯 端到端研究流程启动
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📚 [阶段 1/7] Idea Discovery
   发现研究方向: 视觉语言模型对齐
   找到 15 篇相关论文
   生成 5 个候选方向
   → 推荐: "对比学习增强CLIP"

📖 [阶段 2/7] Research Refine  
   细化研究方案...
   → 确定: 基于 MA-VL 的对比学习方案

📋 [阶段 3/7] Experiment Plan
   制定实验计划...
   → 主实验 + 4 项消融实验

💻 [阶段 4/7] Experiment Bridge
   初始化远程项目...
   实现代码...
   → 验证通过

⚡ [阶段 5/7] Running Experiments
   主实验: 100 epochs [████████░░] 80%
   消融实验 1/4: [██████████] 完成
   ...
   
🔄 [阶段 6/7] Auto Review
   结果分析...
   → 实验结果达标 ✓

📄 [阶段 7/7] Paper Write
   生成论文大纲...
   撰写论文...
   → 完成初稿

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ 端到端研究流程完成！
📁 论文: paper/main.pdf
📊 图表: local_results/figures/
```

### 示例 2: 快速方向发现

```
/research "多模态大模型" --scope idea_only
```

### 示例 3: 仅论文写作

```
/research --scope paper_only
```

## 使用前提

1. **PI SSH 已配置**: 需要配置好远程 GPU 服务器连接
2. **实验环境就绪**: 远程服务器有可用的 CUDA 环境
3. **必要的包已安装**: torch, transformers 等基础包

## 状态码

| 状态 | 说明 |
|------|------|
| `IDLE` | 等待启动 |
| `RUNNING` | 执行中 |
| `WAITING_CONFIRM` | 等待用户确认 |
| `PAUSED` | 暂停（用户中断） |
| `COMPLETED` | 完成 |
| `FAILED` | 失败 |

## 提示用户

研究开始前，提示用户确认：
- 研究主题是否正确
- 是否需要调整范围
- 远程服务器配置是否正确
