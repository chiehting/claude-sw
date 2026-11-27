# Claude 軟體開發框架

用 Claude Code agents 分階段開發多個功能的 repo 範本:先寫 spec、再實作、獨立驗證、除錯、審查,最後經使用者核准才合併。

## 快速開始

1. `/project-rename`:把範本佔位名稱換成真正的專案名稱。
2. `/init-stack`:訪談並定義技術棧與驗證指令,生成 `docs/STACK.md`、ADR 與 `Makefile` 的 `verify`、`test`。
3. `/write-spec`:訪談需求,產出 `docs/features/NN-name/spec.md`。
4. spec 經使用者核准後,依下方流程進行實作與驗證。

> 技術棧為「未初始化」時不得實作;在 `/init-stack` 完成前,`make verify` 會刻意失敗(fail closed)。

## 開發流程

```text
spec(草稿) → spec(已核准) → test-writing → test-verifying → implementing → verifying → debugging → review → merged
```

另有 `blocked` 狀態。全部 AC 皆為人工驗證時,跳過 `test-writing`/`test-verifying`。狀態記在 `docs/features/STATUS.md`,由主對話(orchestrator)更新。

- 測試先行:test-writer 依 AC(Given/When/Then)先寫測試,verifier 在 `test-verifying` 確認可執行、為 red 且原因是功能缺失後凍結(`STATUS.md` 記測試 SHA);implementer 與 debugger 不得改測試(`.claude/hooks/test-freeze.sh` 與 verifier 檢查)。
- 通過判定唯一入口:`make verify`,只有 verifier agent 執行;`make test FEATURE=NN` 供 test-writer、implementer 取得回饋,不構成通過依據。
- 無法自動測試的 AC 標「人工」,由使用者驗證;未確認前不得視為通過。
- 測試迴圈(test-verifying → test-writing)與實作迴圈(debugger → implementer → verifier)各最多 3 輪,仍失敗則標 `blocked` 並交給使用者。凍結測試有誤或 AC 歧義造成的回退,計入實作迴圈。
- 合併前必須經使用者核准。
- 功能 `blocked`、或任一迴圈跑到第 3 輪(順利 merged 不需要),執行 `/retro`,把教訓轉成規則(經使用者同意)。
- 有高風險環境(正式環境、部署、不可逆操作)時,每一步都要核准,並先給指令、blast radius 與 rollback 方式。
- 每個功能使用獨立 git worktree(`../claude-software-development-framework-wt/NN-name`,分支 `feat/NN-name`)。

## Agents(`.claude/agents/`)

| Agent | 派工時的狀態 | 職責 |
| --- | --- | --- |
| `test-writer` | `test-writing` | 依 AC 先寫測試(red),只改測試目錄與必要骨架 |
| `implementer` | `implementing` | 依凍結的測試實作單一功能,不得改測試;全為人工 AC 時無測試 |
| `verifier` | `test-verifying`、`verifying` | 驗證測試與實作,唯讀;全為人工 AC 時略過凍結檢查 |
| `debugger` | `debugging` | 重現失敗、找根因並歸類(實作錯/測試錯/AC 歧義),不修改程式 |
| `reviewer` | `review` | 審查功能分支的 diff,唯讀 |

狀態只記在 `docs/features/STATUS.md`,spec 檔內不重複記錄。

## Skills(`.claude/skills/`)

| Skill | 用途 |
| --- | --- |
| `/project-rename` | 替換專案名稱(建議最先執行,可重複執行) |
| `/init-stack` | 定義技術棧與驗證指令 |
| `/write-spec` | 訪談並產出或更新 spec |
| `/retro` | 功能結案或失敗時寫回顧,並提議新增規則 |

## 目錄結構

```text
.
├── AGENTS.md            # 工作流程規則
├── Makefile             # make verify、make test(由 /init-stack 生成)
├── .claude/             # agents、skills、hooks、settings
├── docs/
│   ├── STACK.md         # 技術棧(SSOT)
│   ├── GLOSSARY.md      # 領域術語
│   ├── NOTES.md         # 已知注意事項(專案特有、讀程式碼看不出來的事項)
│   ├── adr/             # 設計決策紀錄
│   ├── retro/           # 功能回顧(歷史;穩定結論併入 NOTES.md、ADR 或 agent 檔)
│   └── features/        # STATUS.md 與各功能 spec
├── src/                 # 原始碼
└── tests/               # 測試
```

## 文件

- 規則細節:[`AGENTS.md`](AGENTS.md)
- 技術棧:[`docs/STACK.md`](docs/STACK.md)
- 術語:[`docs/GLOSSARY.md`](docs/GLOSSARY.md)
- 已知注意事項:[`docs/NOTES.md`](docs/NOTES.md)
- 設計決策:[`docs/adr/`](docs/adr/)
