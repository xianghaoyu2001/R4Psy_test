# 8R9d 计算可复现性检验

对 Christensen 等人(2018) *Remotely Close Associations: Openness to Experience and Semantic Memory Structure* 一文的分析可复现性检验项目。

## 文献信息

- **DOI**: 10.1002/per.2157
- **期刊**: European Journal of Personality, 32(4), 463–479
- **数据来源**: https://osf.io/craky/
- **原始方法**: R (SemNetCleaner + NetworkToolbox)

## 目录结构

```
├── README.md                           # 本文件
├── 8R9d_复现方案.md                    # 详细复现方案
├── Data/                               # 数据文件
│   ├── Raw/                            # 原始数据 (.sav)
│   ├── Cleaned FINAL/                  # 清洗后数据 (.csv, .sav)
│   ├── Saved R Cleaning Files/         # 中间清洗文件 (.csv, .RData)
│   └── Data Cleaning.docx              # 数据清洗说明
├── Analysis Scripts/                   # 分析代码
│   ├── Remotely Close Associations R Script.R   # 主分析脚本
│   └── Openness Model.inp              # Mplus 模型文件
├── Materials/                          # 实验材料 (.que)
├── Supplementary Information/          # 原文补充材料
├── Thesis/                             # 学位论文相关
└── Working Manuscript/                 # 论文手稿
```

## 核心文件

- 分析代码: `Analysis Scripts/Remotely Close Associations R Script.R`
- 原始数据: `Data/Raw/All samples merged and totaled_shared.sav`
- 清洗后数据: `Data/Cleaned FINAL/FINAL fluency.csv`, `FINAL open.csv`
- 复现方案: `8R9d_复现方案.md`

## 依赖 R 包

- SemNetCleaner
- NetworkToolbox
- psych
- haven (读取 .sav)

## 复现流程概要

1. 读取原始 SAV 数据，匹配开放性分数
2. SemNetCleaner 清洗语义流畅性反应
3. 按开放性中位数分组（high/low）
4. 描述性统计 + 推断性统计（McNemar、相关、t检验、语义网络分析）
5. 与原论文结果对比，计算 PE 并评级
6. 可选：Bayes 方法做创新分析
