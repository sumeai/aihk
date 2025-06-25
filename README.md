# AiHK (Ai Headquarters Keystone)

<div align="center">
  <img src="aihk.png" alt="AiHK Logo" width="128">
  <p>让你的Windows操作更智能、更个性化！</p>
</div>

## 项目简介

AiHK 是一个基于 AutoHotkey 的强大键盘增强和快捷键定制工具，旨在提高 Windows 系统的操作效率和使用体验。通过重新映射键位、添加快捷键组合和自定义功能，AiHK 可以让你的日常电脑操作更加高效和舒适。

名称由来：Ai (Artificial Intelligence) + HK (Hotkey) = AiHK，也可理解为 "Ai Headquarters Keystone"（AI司令部的基石）。

## 核心功能

### 键盘增强

- **CapsLock 增强**：将很少使用的 CapsLock 键改造为功能强大的修饰键
- **Vim 风格导航**：在任何应用中使用 Vim 风格的 HJKL 导航
- **应用特定快捷键**：为 VSCode、GVim、飞书等应用提供专门的快捷键

### 系统功能

- **窗口管理**：快速切换、调整和控制窗口
- **快速启动**：通过快捷键或命令快速启动常用应用
- **键盘布局切换**：快速切换不同的键盘布局
- **剪贴板增强**：提供更强大的剪贴板功能

### 工具功能

- **飞扬魔法键盘**：快速启动的辅助工具
- **临时脚本执行**：快速执行临时 AHK 脚本
- **热键列表显示**：查看所有已定义的热键

## 安装与设置

### 前提条件

- Windows 操作系统
- [AutoHotkey v2](https://www.autohotkey.com/) 已安装

### 安装步骤

1. 克隆或下载本仓库到本地
2. 运行 `aihk.ahk` 文件启动程序
3. (可选) 运行 `start_aihk_with_windows.ahk` 设置开机自启动

## 主要快捷键

### 全局快捷键

- `Pause + Esc` - 退出 AiHK
- `Shift + Pause` - 挂起/恢复热键功能
- `Alt + Pause` - 重启 AiHK
- `Win + Pause` - 临时执行 AHK 脚本
- `Pause + /` 或 `CapsLock + /` - 显示所有热键列表

### CapsLock 增强键位

CapsLock 键被重新映射为强大的功能修饰键：

- `CapsLock + HJKL` - 方向键 (左/下/上/右)
- `CapsLock + Space` - 启动飞扬魔法键盘
- `CapsLock + 其他键` - 更多功能，请查看热键列表

### 应用启动

- `AppsKey` 或 `;jp;` 或 `;aik;` - 启动飞扬魔法键盘
- `;ahkhelp;` - 打开 AutoHotkey 帮助文档
- `;ahkspy;` - 打开 AutoHotkey Spy 窗口信息查看器
- `;ahkroot;` - 打开 AiHK 根文件夹
- `;ahksrc;` - 打开 AiHK/src 文件夹

### 应用特定快捷键

- VSCode 特定快捷键
- GVim 特定快捷键
- 飞书特定快捷键

## 项目结构

```
aihk/
├── aihk.ahk              # 主入口文件
├── aihk_main.ahk         # 主要配置文件
├── aihk_run.ahk          # 运行时生成的脚本
├── src/                  # 源代码目录
│   ├── alt_vim.ahk       # Vim 风格键位映射
│   ├── capslock.ahk      # CapsLock 键增强
│   ├── switch_keyboard.ahk # 键盘布局切换
│   └── win/              # 应用特定脚本
│       ├── feishu.ahk    # 飞书快捷键
│       ├── gvim.ahk      # GVim 快捷键
│       └── vscode.ahk    # VSCode 快捷键
├── inc/              # 通用功能库
├── bin/                  # 可执行文件和资源
└── gui/                # 用户界面组件
```

## 自定义与扩展

AiHK 设计为易于扩展和自定义。你可以：

1. 修改现有脚本以适应你的工作流
2. 在 `src` 目录下添加新的脚本文件
3. 在 `aihk_main.ahk` 中引入你的自定义脚本

## 常见问题

- **Q: 某些快捷键在特定应用中不起作用？**  
  A: 某些应用可能拦截快捷键。尝试调整脚本或使用不同的快捷键组合。

- **Q: 如何临时禁用所有快捷键？**  
  A: 按 `Shift + Pause` 可以挂起/恢复所有热键功能。

## 贡献

欢迎提交 Pull Requests 或创建 Issues 来改进这个项目！

## 许可证

[待定] - 请添加适当的许可证信息

---

*使用 AiHK，让你的键盘成为提升工作效率的魔法工具！*