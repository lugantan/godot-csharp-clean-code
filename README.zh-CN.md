# godot-csharp-clean-code

[English](./README.md) | [中文](./README.zh-CN.md)

一个面向 Codex 的技能，用于在 Godot C# 项目中进行设计、生成、重构和评审，并同时遵守 Clean Code 原则与 Godot 强领域架构规范。

## 简介

`godot-csharp-clean-code` 适用于“仅有通用 clean code 还不够”的场景，尤其关注：

- 场景树与 packed scene 的拆分边界
- 节点归属与脚本职责
- `_Ready`、`_Process`、`_PhysicsProcess` 和输入生命周期的正确使用
- 信号、事件流与 Autoload 的边界
- 面向 Godot 的 C# 命名和导出配置
- 适合玩法、UI 和共享系统的可维护项目结构

## 这个 Skill 可以帮助什么

- 在写实现之前先规划更清晰的场景树
- 将臃肿的 Godot 场景拆成更聚焦的 packed scene
- 保持脚本职责与所挂载节点一致
- 在直接引用、信号和 Autoload 服务之间做更合理的选择
- 按功能或领域组织 Godot C# 项目结构
- 生成更清晰的玩法和 UI 起始代码
- 评审现有 Godot C# 代码中的耦合、生命周期滥用和职责泄漏问题

## 仓库结构

```text
.
├── README.md
├── README.zh-CN.md
└── godot-csharp-clean-code
    ├── SKILL.md
    ├── assets
    │   └── godot-template
    │       ├── autoload
    │       ├── core
    │       ├── features
    │       ├── project.godot
    │       ├── scenes
    │       └── ui
    └── references
        ├── csharp-style.md
        ├── lifecycle.md
        ├── project-layout.md
        ├── scene-structure.md
        └── signals-and-events.md
```

## 核心文件

- [godot-csharp-clean-code/SKILL.md](./godot-csharp-clean-code/SKILL.md)：触发规则、工作流和输出约束
- [godot-csharp-clean-code/references/scene-structure.md](./godot-csharp-clean-code/references/scene-structure.md)：场景组合与节点归属
- [godot-csharp-clean-code/references/lifecycle.md](./godot-csharp-clean-code/references/lifecycle.md)：Godot 生命周期边界
- [godot-csharp-clean-code/references/signals-and-events.md](./godot-csharp-clean-code/references/signals-and-events.md)：信号、事件流与 Autoload 规范
- [godot-csharp-clean-code/references/project-layout.md](./godot-csharp-clean-code/references/project-layout.md)：目录和功能分层建议
- [godot-csharp-clean-code/references/csharp-style.md](./godot-csharp-clean-code/references/csharp-style.md)：Godot 风格的 C# 编码规范与示例

## 起始模板

仓库还包含一个接近可运行的起始模板，位置在 [godot-csharp-clean-code/assets/godot-template](./godot-csharp-clean-code/assets/godot-template)。

这个模板展示了：

- 一个 `Main.tscn` 作为组合根场景
- 一个 `Player` 功能场景和聚焦的玩家脚本
- 一个 `Hud` 场景和单独的 HUD 控制器
- 一个小型 `GameDirector` Autoload 示例
- `core`、`features`、`ui`、`autoload` 之间的清晰分层

## 示例提示词

```text
Use $godot-csharp-clean-code to design or refactor a Godot C# project with clean scene trees, focused scripts, sane signals, and clear project structure.
```

## 适用场景

- 用更好的默认结构启动新的 Godot C# 项目
- 将混乱的场景树重构为更小、更清晰的 packed scene
- 评审和拆分过大的玩法脚本
- 在节点通信中避免过度依赖全局管理器
- 为团队建立一致的 Godot 项目结构规范

## License

你可以根据仓库许可证或自身项目需要，将这个 skill 复制到自己的 Codex 环境中使用。
