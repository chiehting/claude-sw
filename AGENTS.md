# 開發工作流程

本 repo 用 agents 分階段開發多個功能。細節在 `docs/`,這裡只放規則。

## 規則
- 通過判定唯一入口:`make verify`,且只有 verifier agent 執行;其他 agent、skill 與主對話一律不執行。通過與否只看 verifier 回報的結果。`make test FEATURE=NN` 供 test-writer、implementer 取得回饋,不構成通過依據。
- 每個功能一份 `docs/features/NN-name/spec.md`;狀態記在 `docs/features/STATUS.md`,由主對話(orchestrator)更新。
- 狀態機:`spec(草稿) → spec(已核准) → test-writing → test-verifying → implementing → verifying → debugging → review → merged`,另有 `blocked`。全部 AC 皆為人工驗證時,跳過 `test-writing`/`test-verifying`。
- spec 經使用者明確核准、且無阻擋實作的待決事項,才進入 `test-writing`;測試通過 `test-verifying` 並凍結後,才進入 `implementing`。
- `docs/STACK.md` 狀態為「未初始化」時,先跑 `/init-stack`,不得實作;變更技術棧也必須走 `/init-stack`(含 ADR)。
- 不確定的事記入 spec 的「待決事項」,或問使用者。
- 測試迴圈(test-verifying → test-writing)與實作迴圈(debugger → implementer → verifier)各最多 3 輪,仍失敗標 `blocked` 並交給使用者。凍結測試有誤或 AC 歧義造成的回退,計入實作迴圈。
- 合併前必須經使用者核准。
- subagent 回報的事實(版本、檔案、現況)與 `docs/` 或程式碼不符時,以後者為準並查證。
- 每個功能用獨立 git worktree(`../claude-software-development-framework-wt/NN-name`,分支 `feat/NN-name`)。

## Agents 與 Skills
- Agents 定義在 `.claude/agents/`,職責以各檔為準。
- 建議順序:`/project-rename` → `/init-stack` → `/write-spec`(僅 `/write-spec` 強制需先完成 `/init-stack`)。
- `/retro NN`:功能 `blocked`、或任一迴圈跑到第 3 輪時,由主對話執行。

## 高風險操作
範圍以 `docs/STACK.md`「高風險環境」為準(正式環境、正式資料、部署、權限、刪除或搬移檔案等);該欄寫「無」則不適用。
- 每一步都要使用者明確核准,核准不延續到下一步。
- 動手前先給:確切指令、blast radius、rollback 指令。
- 破壞性操作:先確認現況符合預期 → 備份 → 寫入 → 驗證結果。現況不符就停止並回報,維持原狀。
- 被權限機制擋下就停止,請使用者自己執行。
- 執行後查證實際狀態。
- subagent 遇到高風險操作就停止並回報,由主對話與使用者處理。

## 文件
- 技術棧:`docs/STACK.md`(語言、驗證指令、慣例、高風險環境;SSOT)
- 已知注意事項:`docs/NOTES.md`(專案特有、讀程式碼看不出來的事項;動手前先讀)
- 術語:`docs/GLOSSARY.md`(只放領域用詞,用詞以此為準)
- 設計決策:`docs/adr/`
- 回顧:`docs/retro/`(歷史紀錄;穩定結論要併入 `docs/NOTES.md`、ADR 或 agent 檔;`/retro` 同時重審並淘汰過時的 NOTES 條目)
