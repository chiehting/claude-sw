---
name: project-rename
description: 把專案名稱換成新名稱:首次替換範本佔位名稱,之後也可再次改名。
disable-model-invocation: true
---

- 目前名稱:`claude-software-development-framework`

「目前名稱」那行**會被替換**,所以永遠代表現況。本檔不排除在替換之外。

1. 以「目前名稱」為 N。問使用者:**新專案名稱是什麼?**(一題,不附預設值;只接受英數、`-`、`_`,且不等於 N)。
2. `grep -rIlw -- "N" . --exclude-dir=.git`,不排除任何檔案(含各 `SKILL.md`)。列出將修改的檔案與行;使用者確認後全部替換(整詞比對,`N-wt` 這類也要換)。`AGENTS.md` 的 worktree 路徑是 `../<新名稱>-wt/NN-name`。N 若是一般單字(例如 `terraform`),先提醒會誤傷其他用法,改成逐一確認。
3. 完成標準:步驟 2 的 grep 無輸出,且本檔「目前名稱」已是新名稱。
4. 資料夾本身若仍叫 N,提醒使用者自行 `mv`(搬動工作目錄會讓目前 session 失去路徑),並說明既有 worktree 也要依新名稱重建。
