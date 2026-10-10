#!/bin/bash
# PI Research Project Structure Setup
# 在远程服务器创建规范的项目结构

set -e

PROJECT_NAME=${1:-"my_project"}
REMOTE_BASE=${2:-"/home/user/experiments"}

PROJECT_DIR="$REMOTE_BASE/$PROJECT_NAME"

echo "Creating project structure at: $PROJECT_DIR"

# 创建目录结构
mkdir -p "$PROJECT_DIR/.env"
mkdir -p "$PROJECT_DIR/.data/raw"
mkdir -p "$PROJECT_DIR/.data/processed"
mkdir -p "$PROJECT_DIR/.src/models"
mkdir -p "$PROJECT_DIR/.src/datasets"
mkdir -p "$PROJECT_DIR/.src/utils"
mkdir -p "$PROJECT_DIR/.src/losses"
mkdir -p "$PROJECT_DIR/.scripts"
mkdir -p "$PROJECT_DIR/.papers"
mkdir -p "$PROJECT_DIR/exp"
mkdir -p "$PROJECT_DIR/results"
mkdir -p "$PROJECT_DIR/logs"

# 创建配置文件
cat > "$PROJECT_DIR/.env/config.yaml" << 'EOF'
# Project Configuration
project:
  name: PROJECT_NAME
  version: 1.0.0

# GPU Configuration
gpu:
  device: cuda:0
  num_workers: 4

# Training Configuration
training:
  batch_size: 32
  epochs: 100
  learning_rate: 0.001
  weight_decay: 0.0001

# Paths (relative to project root)
paths:
  data: .data/processed
  results: results
  logs: logs

# W&B (optional)
wandb:
  enabled: false
  project: PROJECT_NAME
  entity: null
EOF

# 创建主试验模板
cat > "$PROJECT_DIR/exp/main_exp.py" << 'EOF'
#!/usr/bin/env python3
"""
Main Experiment - 主试验
论文核心实验
"""
import argparse
import sys
sys.path.insert(0, '../.src')

from models import YourModel
from datasets import get_dataloader
from utils import set_seed, count_params

def main():
    parser = argparse.ArgumentParser(description='Main Experiment')
    parser.add_argument('--config', type=str, default='../.env/config.yaml')
    parser.add_argument('--seed', type=int, default=42)
    parser.add_argument('--output', type=str, default='../results/main')
    args = parser.parse_args()
    
    # 你的实验代码
    pass

if __name__ == '__main__':
    main()
EOF

# 创建消融实验模板
cat > "$PROJECT_DIR/exp/ablate_exp.py" << 'EOF'
#!/usr/bin/env python3
"""
Ablation Experiment - 消融实验
"""
import argparse
import sys
sys.path.insert(0, '../.src')

def main():
    parser = argparse.ArgumentParser(description='Ablation Experiment')
    parser.add_argument('--ablate', type=str, required=True,
                       choices=['component_a', 'component_b', 'loss_type'])
    args = parser.parse_args()
    
    # 你的消融实验代码
    pass

if __name__ == '__main__':
    main()
EOF

# 创建对比实验模板
cat > "$PROJECT_DIR/exp/compare_exp.py" << 'EOF'
#!/usr/bin/env python3
"""
Comparison Experiment - 对比实验
与 baseline 和 SOTA 方法对比
"""
import argparse
import sys
sys.path.insert(0, '../.src')

def main():
    parser = argparse.ArgumentParser(description='Comparison Experiment')
    parser.add_argument('--baseline', type=str, default='baseline')
    parser.add_argument('--method', type=str, default='ours')
    args = parser.parse_args()
    
    # 你的对比实验代码
    pass

if __name__ == '__main__':
    main()
EOF

# 创建参数实验模板
cat > "$PROJECT_DIR/exp/param_exp.py" << 'EOF'
#!/usr/bin/env python3
"""
Parameter Experiment - 参数实验
超参数搜索
"""
import argparse
import sys
sys.path.insert(0, '../.src')

def main():
    parser = argparse.ArgumentParser(description='Parameter Experiment')
    parser.add_argument('--param', type=str, required=True)
    parser.add_argument('--values', type=str, required=True)
    args = parser.parse_args()
    
    # 你的参数实验代码
    pass

if __name__ == '__main__':
    main()
EOF

# 创建图片生成模板
cat > "$PROJECT_DIR/exp/figure_exp.py" << 'EOF'
#!/usr/bin/env python3
"""
Figure Experiment - 生成论文图片
"""
import argparse
import sys
sys.path.insert(0, '../.src')

def main():
    parser = argparse.ArgumentParser(description='Generate Figures')
    parser.add_argument('--figure', type=str, required=True)
    parser.add_argument('--input', type=str, required=True)
    args = parser.parse_args()
    
    # 你的图片生成代码
    pass

if __name__ == '__main__':
    main()
EOF

# 创建模型模板
cat > "$PROJECT_DIR/.src/models/__init__.py" << 'EOF'
"""Models module"""
from .your_model import YourModel

__all__ = ['YourModel']
EOF

cat > "$PROJECT_DIR/.src/models/your_model.py" << 'EOF'
"""Your Model Implementation"""
import torch
import torch.nn as nn

class YourModel(nn.Module):
    def __init__(self, config):
        super().__init__()
        self.config = config
        
    def forward(self, x):
        return x
EOF

# 创建工具模板
cat > "$PROJECT_DIR/.src/utils/__init__.py" << 'EOF'
"""Utils module"""
from .seed import set_seed
from .count import count_params

__all__ = ['set_seed', 'count_params']
EOF

cat > "$PROJECT_DIR/.src/utils/seed.py" << 'EOF'
"""Random seed utilities"""
import random
import numpy as np
import torch

def set_seed(seed=42):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
EOF

cat > "$PROJECT_DIR/.src/utils/count.py" << 'EOF'
"""Count model parameters"""
def count_params(model):
    return sum(p.numel() for p in model.parameters())
EOF

# 创建数据集模板
cat > "$PROJECT_DIR/.src/datasets/__init__.py" << 'EOF'
"""Datasets module"""
from .dataloader import get_dataloader

__all__ = ['get_dataloader']
EOF

cat > "$PROJECT_DIR/.src/datasets/dataloader.py" << 'EOF'
"""DataLoader utilities"""
def get_dataloader(split='train', batch_size=32):
    # 实现你的数据加载器
    pass
EOF

# 创建 README
cat > "$PROJECT_DIR/README.md" << 'EOF'
# PROJECT_NAME

## 项目结构

```
.
├── .env/            # 环境配置
│   └── config.yaml  # 项目配置
├── .data/           # 数据集
│   ├── raw/         # 原始数据
│   └── processed/   # 处理后数据
├── .src/            # 源代码
│   ├── models/      # 模型
│   ├── datasets/    # 数据集
│   ├── utils/       # 工具
│   └── losses/      # 损失函数
├── .scripts/        # 辅助脚本
├── .papers/         # 论文相关
├── exp/             # 试验文件（论文直接相关）
│   ├── main_exp.py  # 主试验
│   ├── ablate_exp.py# 消融实验
│   ├── compare_exp.py# 对比实验
│   ├── param_exp.py # 参数实验
│   └── figure_exp.py# 生成图片
├── results/         # 结果
└── logs/            # 日志
```

## 使用方法

### 初始化
在远程服务器上运行初始化脚本创建项目结构

### 运行实验

```bash
# 主试验
cd exp && python main_exp.py --config ../.env/config.yaml

# 消融实验
python ablate_exp.py --ablate component_a

# 对比实验
python compare_exp.py --method ours
```

### 查看结果
结果保存在 `results/` 目录，日志保存在 `logs/` 目录。
EOF

echo "✅ Project structure created at: $PROJECT_DIR"
echo ""
echo "Structure:"
tree -L 2 "$PROJECT_DIR" 2>/dev/null || find "$PROJECT_DIR" -type d | head -20
