---
name: evengine
description: >-
  Create, run, debug, and package EVEngine games. EVEngine is a lightweight
  C++20/Vulkan engine driven by Squirrel scripts; a game is a plain folder with
  config.nut + main.nut run by the eve CLI from a prebuilt SDK — no engine
  compilation required. Use when the user wants an AI to build an EVEngine game
  (breakout, platformer, top-down, etc.), write or edit Squirrel game scripts,
  run or package a game with eve, or connect eve-mcp to a live engine session.
---

# EVEngine（SDK 优先）

EVEngine 是一个 C++20 / Vulkan 游戏引擎，游戏逻辑用 Squirrel 脚本编写。
普通开发者只需要一个预编译的 SDK（`eve` 命令行工具），**不需要编译引擎**。

## 1. 定位 SDK

按顺序寻找 `eve`：

1. `eve` 已在 PATH 中（用 `eve -v` 验证）；
2. 环境变量 `EVE_SDK_DIR` 指向 SDK 根目录 → `$EVE_SDK_DIR/bin/eve`；
3. 都没有则下载当前宿主平台的 SDK：
   - 平台目录名：`win32` / `linux` / `macosx` / `android` / `ios`
   - 下载地址（替换 `<platform>`，例如 `win32`）：
     `https://github.com/EVEngine/EVEngine/releases/latest/download/eve-sdk-<platform>-v0.1.0.zip`
   - macOS / Linux：`curl -LO <url> && unzip <zip> -d <sdk-dir>`
   - Windows（PowerShell）：`Invoke-WebRequest <url> -OutFile sdk.zip; Expand-Archive sdk.zip -DestinationPath <sdk-dir>`
   - zip 内部带 `eve-sdk/<platform>/` 前缀，运行时位于
     `<sdk-dir>/eve-sdk/<platform>/bin/eve`（Windows 为 `eve.exe`）
   - 验证：`eve -v`

把 SDK 的 `bin/` 加进 PATH，或始终用完整路径调用。

## 2. 创建游戏（一个目录 + 两个脚本）

一个游戏就是一个目录，至少包含 `config.nut` 和 `main.nut`。

`config.nut`（窗口与运行配置）：

```squirrel
config = { width=960 height=540 title="My Game" hotReload=true };
```

`main.nut`（最小可运行）：

```squirrel
eve_init = function() {
    local g = eve.Graphics();
    g.clear(0.08, 0.10, 0.20, 1.0);
    print("hello eve\n");
};
eve_update = function(dt) {
    // 每帧逻辑，dt 为秒
};
```

引擎能力按模块提供，常用入口：

```squirrel
local g = eve.Graphics();      // 2D/3D 绘制、清屏、sprite
local w = eve.Window();        // 窗口、输入、事件
local p = eve.Physics();       // Box2D / Box3D
local m = eve.Map();           // tilemap
local parts = eve.Particles();
```

写脚本前先确认模块存在：`has_module("slot")`（裁剪构建时部分模块会被移除）。
查某个类/函数的用法时先打开在线手册：
https://evengine.github.io/EVEngine/（API 参考 + 用户手册 + 模块速查）。

## 3. 运行与热重载

```sh
eve run <game-dir>            # 指定游戏目录
eve run                       # 在游戏目录内直接运行当前目录
```

- `config.hotReload=true` 时改脚本会自动热重载，无需重启。
- 出错时优先看 `eve` 的 stdout / stderr 与脚本堆栈。

## 4. 打包与分发

```sh
eve zip <game-dir>                          # → <game-dir>.eve 压缩包
eve package <game-dir> -o <out-dir> --sdk <sdk-root>   # 自包含可运行目录
```

- `package` 会自动带上运行时与动态库（Windows DLL / macOS dylib）。
- SDK 根目录自动探测顺序：`--sdk` 参数 → `$EVENGINE_SDK` → eve 同级的 `../`。

## 5. 连接 AI（MCP，可选）

两种方式：

1. **无头 host（推荐，stdio，无需 Node）**：

   ```sh
   eve mcp --root <game-dir>        # 默认 stdio；--port <n> 切换 TCP
   ```

   暴露 `eve_host_*` 工具族：创建窗口、注册 ViewModel（MVVM 双向绑定）、
   截帧 PNG、执行 Squirrel 片段、读取交互事件等。

2. **直连正在运行的游戏（TCP）**：

   ```sh
   eve run --debug --mcp-port=7529 <game-dir>
   ```

   工具：`eve_status` / `eve_eval` / `eve_pause` / `eve_snapshot_capture` /
   `eve_error_slice`。若 AI 工具只支持 stdio，可加 Node 桥
   `node tools/eve-mcp/server.js`（env：`EVE_MCP_HOST` / `EVE_MCP_PORT`）。

## 6. 平台注意事项

- **Linux 无头 / CI**：GUI 需要软件 Vulkan 与虚拟显示：

  ```sh
  export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/lvp_icd.json
  export XDG_RUNTIME_DIR=/tmp/xdg-runtime && mkdir -p "$XDG_RUNTIME_DIR" && chmod 700 "$XDG_RUNTIME_DIR"
  export ALSOFT_DRIVERS=null
  xvfb-run -a eve run <game-dir>
  ```

- **macOS**：SDK 已带运行时 dylib（`@loader_path`），仍需要系统 Vulkan loader
  （MoltenVK，通常随 LunarG Vulkan SDK 安装）。
- **Windows**：开箱即用，无需额外运行时。
- **Android / iOS / WebGPU**：SDK 的 `platform/` 里有打包模板
  （Android 为 Gradle APK 模板），游戏脚本同样放在 `assets/game/` 下。

## 7. 什么时候才需要源码构建

只有想修改引擎本身时才需要：
`git clone https://github.com/EVEngine/EVEngine` 并按仓库 Readme 构建
（C++20 工具链 + Vulkan SDK + `make deps`）。普通游戏开发一律用 SDK。

## 参考

- 官网与 SDK 下载：https://evengine.github.io/ 、https://github.com/EVEngine/EVEngine/releases
- 用户手册与 API：https://evengine.github.io/EVEngine/
- 源码仓库（引擎开发）：https://github.com/EVEngine/EVEngine
