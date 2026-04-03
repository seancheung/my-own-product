# MOP — My Own Product

**从想法到上线，solo 开发者的全流程产品构建工具链。**

MOP 是一套 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 自定义 skills（slash commands），专为独立开发者 / indie hacker 设计。它将产品开发拆解为 9 个标准化阶段，通过文档驱动的方式，引导你从零开始完成一个产品的需求、设计、开发和测试。

---

## 特性

- **文档驱动** — 所有产出物保存在 `docs/` 目录，天然适配版本控制
- **断点续做** — 长时间运行的 skill 会将进度保存到 `docs/.mop-checkpoint.md`，中断后可恢复
- **自动同步** — 当需求或设计变更时，skill 会检测下游文档是否需要更新并提示你确认
- **模式适配** — 根据产品定位（商业产品 / 开源 / 个人项目）和目标平台（Web / 移动 / 桌面）自动调整提问深度和设计输出
- **Bug 追踪** — `mop-dev` 与 `mop-qa` 通过 `test-plan.md` 中的 bug 列表联动
- **决策日志** — `mop-dev` 维护 `docs/devlog.md`，记录开发过程中的关键决策
- **完成状态报告** — 每个 skill 结束时报告统一的四状态结果：已完成 / 已完成（有保留）/ 已阻塞 / 需要补充信息

---

## 工作流

```
mop-start → mop-req → mop-prod → mop-ui → mop-tech → mop-tasks → mop-dev → mop-qa
                 \                                                      /
                  ←──────────────── mop-sync ─────────────────────────→
```

按顺序执行各阶段。当需求、设计或技术方案发生变更时，运行 `mop-sync` 同步所有下游文档。`mop-sync` 也会在其他 skill 结束时自动触发（需用户确认）。

---

## Skills 一览

| Skill | 用途 |
|---|---|
| `/mop-start` | 项目初始化，创建 `docs/` 目录，展示工作流概览和项目状态 |
| `/mop-req` | 交互式需求收集，通过多轮对话输出 PRD（`docs/prd.md`）。根据产品定位自动切换商业模式/构建者模式调整提问深度。可选阶段：竞品分析（web search）、头脑风暴、前提挑战、双视角需求评审 |
| `/mop-prod` | 基于 PRD 生成产品功能设计文档（`docs/product-design.md`），包含信息架构、功能模块设计、用户流程和权限设计 |
| `/mop-ui` | 基于产品设计文档生成设计系统文档（`docs/design-system.md`）、设计规范预览页（`docs/design-system-preview.html`）和交互式原型（`docs/prototype/`）。支持 Web/移动/桌面多平台适配，可选设计调研（web search） |
| `/mop-tech` | 基于产品设计和 UI 原型生成技术设计文档（`docs/tech-design.md`），包含技术选型、系统架构、数据模型、API 设计和故障模式分析。含复杂度嗅觉检查 |
| `/mop-tasks` | 创建任务分解文档（`docs/tasks.md`），包含阶段划分、依赖关系、优先级、验收标准和并行化策略。任务粒度确保单个 agent session 可完成 |
| `/mop-dev` | 展示任务进度仪表盘，选择任务开发或修复 test-plan 中的 bug。处理依赖冲突（完成上游 / 延后 / 强制执行），更新任务状态，写入 devlog，设计偏离时触发文档同步 |
| `/mop-qa` | 创建测试计划和测试用例，含路径覆盖分析和测试类型决策矩阵。自动检测项目可测试性。执行测试、追踪 bug，回归测试强制执行不可跳过 |
| `/mop-sync` | 同步所有文档，分析影响链并级联更新。也会在其他 skill 结束时自动触发（需用户确认） |

---

## 生成的文档结构

```
docs/
  prd.md                        # 产品需求文档
  product-design.md             # 产品功能设计文档
  design-system.md              # 设计规范
  design-system-preview.html    # 设计规范预览页
  prototype/                    # 交互原型 (HTML/CSS/SVG)
  tech-design.md                # 技术设计文档
  tasks.md                      # 任务分解与并行化策略
  devlog.md                     # 开发决策日志
  test-plan.md                  # 测试计划与 bug 列表
  changelog.md                  # 变更记录（mop-sync 生成）
  .mop-checkpoint.md            # 断点续做检查点（临时）
```

---

## 安装

MOP 支持两种安装方式：项目级安装和全局安装。

### 方式一：一键安装（推荐）

通过远程脚本直接安装，无需手动克隆仓库：

```bash
# 安装到当前项目（默认）
curl -fsSL https://raw.githubusercontent.com/seancheung/my-own-product/main/install.sh | bash

# 安装到全局（所有项目可用）
curl -fsSL https://raw.githubusercontent.com/seancheung/my-own-product/main/install.sh | bash -s -- --global
```

### 方式二：手动安装

#### 项目级安装

将命令文件复制到项目下的 `.claude/commands/`，仅在该项目中生效：

```bash
# 克隆仓库
git clone https://github.com/seancheung/my-own-product.git

# 复制到你的项目
cp -r my-own-product/commands/ your-project/.claude/commands/
```

目录结构：

```
your-project/
  .claude/
    commands/
      mop-start.md
      mop-req.md
      mop-prod.md
      mop-ui.md
      mop-tech.md
      ...
```

#### 全局安装

将命令文件复制到 `~/.claude/commands/`，所有项目中都可以使用 MOP：

```bash
# 克隆仓库
git clone https://github.com/seancheung/my-own-product.git

# 复制到全局命令目录
mkdir -p ~/.claude/commands
cp my-own-product/commands/*.md ~/.claude/commands/
```

### 验证安装

在项目中启动 Claude Code，输入 `/mop-start` 即可开始使用。如果命令能被识别并执行，说明安装成功。

---

## 环境要求

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)

---

## License

MIT
