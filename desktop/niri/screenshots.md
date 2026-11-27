# 截图与标注

区域和屏幕截图使用 Noctalia 自带的冻结标注浮层，不再保存后另开 Satty，
也不需要额外的“编辑截图”快捷键或截图事件监听进程。

1. `Print`（PrintScreen）冻结画面，拖选区域后松开鼠标进入标注。
   `Ctrl+Shift+2` / `Ctrl+Print` 直接标注当前屏幕。
2. 使用浮层工具栏画框、画圈、箭头、文字；也可用 `S` 选矩形、`O` 选圆圈、
   `A` 选箭头、`T` 选文字，`Ctrl+Z` 撤销。
3. 不需要标注就直接回车，需要时先画再回车。回车完成复制和保存后关闭浮层。
   工具栏的复制、保存按钮可分别执行对应动作；不必使用 `Ctrl+C`。
   编辑文字时先结束文字输入，再完成截图。
4. 取消使用 Esc 或工具栏关闭按钮；未完成的截图不先行保存。

`Ctrl+Shift+3` / `Alt+Print` 保留 Niri 的快速窗口截图，直接复制并保存，
不经过标注。若要标注窗口内容，使用区域截图选择所需区域。

默认保存到 `~/Pictures/Screenshots`。台式机部署保留其已有的本地化截图目录。
Noctalia 的截图策略在 `.config/noctalia/screenshot.toml`，快捷键在
`desktop/niri/cfg/keybinds.kdl`。未修改 Satty 的现有配置，也没有卸载它。

## 设计参考与验证边界

- [Snipaste](https://www.snipaste.com/)：参考选区后连续标注、完成后输出的体验。
- [Shorin 的截图流程](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/blob/main/wiki/archlinux/ShorinNiri功能介绍.md#截图和录屏)：
  使用 Niri 与 Satty 分步截图编辑；此处不采用第二个编辑入口。
- [Omarchy 截图文档](https://github.com/omacom/omarchy/blob/quattro/manual/12-screenshots-recording.md)：
  当前默认分支使用 Omasnap，参考其覆盖层交互，不引入其工具链。

实现依据是本机 Noctalia 的截图配置与原生标注能力，没有复制上述项目的代码或资产。
这不是 Snipaste 完整复刻，不包含贴图置顶、长截图或 OCR。
2026-10-25 已在台式机部署，用户确认能满足使用需求。
2026-10-26 已备份部署到笔记本，配置及命令兼容性检查通过，用户确认 PrintScreen
正常。按用户要求删除区域截图的 `Ctrl+Shift+1` 别名，无需再测试这个组合。
部署验证没有由代理触发截图或读取剪贴板。
