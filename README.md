# site-publish

发布仓库（静态站点聚合）：

- `/`：Twitter 模拟器（来自同级目录 `twitter-simulator-v2-static`）
- `/2ch/`：2ch 模拟器（来自同级目录 `2ch-generator`）
- `/hub/`：入口页（本仓库维护）

## 同步组装

在 `F:\所长的谣言\` 下三仓库并列时，运行：

```powershell
cd 'F:\所长的谣言\site-publish'
powershell -ExecutionPolicy Bypass -File .\scripts\sync-from-sources.ps1
```

说明：

- `hub/` 与 `sw.js` 属于发布仓库自定义内容，不会被覆盖。
- 其它静态文件会从两个前端仓库重新复制生成。

## 本地预览

```powershell
cd 'F:\所长的谣言\site-publish'
python -m http.server 8000
```

访问：

- `http://localhost:8000/`
- `http://localhost:8000/hub/`
- `http://localhost:8000/2ch/`

## 接入已部署的 Twitter 仓库（不动 master）

你的自定义域名 `www.tukuyomi.cc.cd` 现在已经在本仓库的 `CNAME` 里了。为了不影响 `twitter-simulator-v2-static` 的 `master` 分支，推荐把本仓库推送到同一个 GitHub 仓库的 `gh-pages`（或 `pages`）分支，然后在 GitHub Pages 设置里把发布源切到该分支。

示例（仅供参考，按你的实际仓库地址替换）：

```powershell
cd 'F:\所长的谣言\site-publish'
git remote add origin https://github.com/RaphllA/twitter-simulator-v2-static.git

# 推送到 gh-pages 分支（不会动远端 master）
git push -u origin master:gh-pages
```

GitHub Pages 设置建议：

- Source: `gh-pages` 分支
- Folder: `/ (root)`

回滚：

- 直接把 `gh-pages` 回退到上一个 commit（或在 GitHub 上 Revert），域名不会变。
