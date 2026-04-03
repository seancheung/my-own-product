# MOP — My Own Product

**从想法到上线，solo 开发者的全流程产品构建工具链。**

MOP 是一套 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 自定义 skills（slash commands），专为独立开发者 / indie hacker 设计。它将产品开发拆解为 8 个标准化阶段，通过文档驱动的方式，引导你从零开始完成一个产品的需求、设计、开发和测试。

---

## 特性

- **文档驱动** — 所有产出物保存在 `docs/` 目录，天然适配版本控制
- **断点续做** — 长时间运行的 skill 会将进度保存到 `docs/.mop-checkpoint.md`，中断后可恢复
- **自动同步** — 当需求或设计变更时，skill 会检测下游文档是否需要更新并提示你确认
- **Bug 追踪** — `mop-dev` 与 `mop-qa` 通过 `test-plan.md` 中的 bug 列表联动
- **决策日志** — `mop-dev` 维护 `docs/devlog.md`，记录开发过程中的关键决策

---

## 工作流

```
mop-start → mop-req → mop-ui → mop-design → mop-tasks → mop-dev → mop-qa
                                      \                       /
                                       ←──── mop-sync ──────→
```

按顺序执行各阶段。当需求、设计或技术方案发生变更时，运行 `mop-sync` 同步所有下游文档。`mop-sync` 也会在其他 skill 结束时自动触发（需用户确认）。

---

## Skills 一览

| Skill | 用途 |
|---|---|
| `/mop-start` | 项目初始化，创建 `docs/` 目录，展示工作流概览和项目状态 |
| `/mop-req` | 交互式需求收集，通过多轮对话输出 PRD（`docs/prd.md`）。可选阶段：竞品分析（web search）、头脑风暴（逐条建议，用户逐一接受/拒绝）、双视角需求评审（UX 和技术可行性两个子代理同时审查） |
| `/mop-ui` | 生成设计系统文档（`docs/design-system.md`）和交互式 HTML/CSS/SVG 原型（`docs/prototype/`），与用户迭代至满意后打开浏览器预览 |
| `/mop-design` | 基于 PRD 生成产品设计文档（`docs/product-design.md`）和技术设计文档（`docs/tech-design.md`） |
| `/mop-tasks` | 创建任务分解文档（`docs/tasks.md`），包含阶段划分、依赖关系、优先级和验收标准。任务粒度确保单个 agent session 可完成 |
| `/mop-dev` | 展示任务进度仪表盘，选择任务开发或修复 test-plan 中的 bug。处理依赖冲突（完成上游 / 延后 / 强制执行），更新任务状态，写入 devlog，设计偏离时触发文档同步 |
| `/mop-qa` | 创建测试计划和测试用例。自动检测项目是否可由 agent 测试（Web/CLI/API 可自动测试，原生移动端/桌面端需手动）。执行测试、追踪 bug，失败时提供修复/记录/调整/跳过选项 |
| `/mop-sync` | 同步所有文档，分析影响链并级联更新。也会在其他 skill 结束时自动触发（需用户确认） |

---

## 生成的文档结构

```
docs/
  prd.md                 # 产品需求文档
  design-system.md       # 设计系统
  prototype/             # 交互原型 (HTML/CSS/SVG)
  product-design.md      # 产品设计文档
  tech-design.md         # 技术设计文档
  tasks.md               # 任务分解
  devlog.md              # 开发决策日志
  test-plan.md           # 测试计划与 bug 列表
  .mop-checkpoint.md     # 断点续做检查点
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
      mop-ui.md
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
