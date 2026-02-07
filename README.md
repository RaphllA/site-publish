# site-publish

静态聚合发布仓库（`www.tukuyomi.cc.cd`）：
- `/`：聚合入口页
- `/twi/`：Twitter 模拟器（来源：`../twitter-simulator-v2-static`）
- `/2ch/`：2ch 模拟器（来源：`../2ch-generator`）
- `/hub/`：旧入口兼容地址（会跳转到 `/`）

## 一键同步子应用

在 `F:\所长的谣言\` 下三个仓库并列时执行：

```powershell
cd 'F:\所长的谣言\site-publish'
powershell -ExecutionPolicy Bypass -File .\scripts\sync-from-sources.ps1
```

脚本会：
- 重建 `twi/` 与 `2ch/`
- 自动修正跨应用链接（Twitter -> `/2ch/`，2ch -> `/twi/`）
- 保留根目录入口页、`CNAME`、`hub/`、`sw.js`

## 本地预览

```powershell
cd 'F:\所长的谣言\site-publish'
python -m http.server 8000
```

访问：
- `http://localhost:8000/`
- `http://localhost:8000/twi/`
- `http://localhost:8000/2ch/`

## GitHub Pages

建议设置：
- Source: `master` 分支
- Folder: `/ (root)`
- Custom domain: `www.tukuyomi.cc.cd`