---
name: write-spec
description: 訪談並把功能釐清成一份或多份可獨立驗證的 spec。
disable-model-invocation: true
---

先呼叫 Skill 工具載入 `grilling` 與 `domain-modeling`(術語與 ADR 的格式與規則)。其中 GLOSSARY 的路徑以本專案為準:`docs/GLOSSARY.md`。訪談依 `grilling`:一輪問整個 frontier。

參數:`/write-spec [NN]`。有 NN 就續談 `docs/features/NN-*/spec.md` 草稿;沒有就從使用者描述新功能開始。

## 前置檢查
先讀 `docs/STACK.md`。若狀態為「未初始化」,**停止**並請使用者先執行 `/init-stack`。AC 的驗證方式使用 STACK.md 定義的指令。

## 鐵則
- **事實自己查,決策才問**:程式碼、文件、現有行為派 subagent 查。使用者也不確定的事,記入 spec「待決事項」,答案留給使用者。
- **每輪回答後就寫入草稿**,讓中斷後可續談。續談時先讀草稿,從未解決處接著問,不重頭來。
- 你的產出只有 spec、GLOSSARY、ADR 與 STATUS 的更新。

## 流程
1. **理解**:請使用者描述想做的功能。讀 `docs/GLOSSARY.md`、`docs/adr/`、既有 specs 與 `STATUS.md`,確認與既有內容不重複、不衝突。
2. **拆分**:功能太大時,先與使用者討論怎麼拆。標準是「每份 spec 能獨立驗證」,不是大小。寫明彼此依賴。完成標準:每份 spec 在 `STATUS.md` 佔一列、有編號 NN 與目錄 `docs/features/NN-name/`。
3. **逐份訪談**,釐清並寫入對應章節。完成標準:每個章節都有答案,或已記入「待決事項」。
   1. 目標與背景
   2. 範圍內 / 明確不做
   3. 驗收條件:編號 `AC-1…`,以 Given/When/Then 描述一個 scenario,並標**驗證方式類型**:
      - `自動`:可由測試判定,寫明預期的可觀察結果。「很快」不合格,「p95 < 200ms」合格。
      - `人工`:無法自動測試(文件、設定、主觀觀察),須附理由與給使用者的檢查步驟;由使用者驗證。
      全部 AC 皆為 `人工` 時,在 spec 註明跳過 `test-writing`/`test-verifying`。
   4. 依賴(其他 spec)
   5. 待決事項(標明阻擋哪些 AC)
   6. 相關 ADR 連結
4. **術語與決策**:出現新的領域術語就寫入 `docs/GLOSSARY.md`;做出難以反悔的設計決策就依 domain-modeling 的格式寫 ADR,並連結於 spec。
5. **放行檢查**:全部滿足,才問使用者是否核准——(a) 無阻擋實作的待決事項;(b) 每條 `自動` AC 可寫成測試、每條 `人工` AC 有理由與明確檢查步驟;(c) 新術語已入 GLOSSARY。
6. **核准**:使用者明確說「這份 spec 核准」,才把 `STATUS.md` 的狀態從 `spec(草稿)` 改為 `spec(已核准)`。核准權在使用者。核准後的下一步是 `test-writing`(全為 `人工` AC 時直接進 `implementing`)。

## spec 範本(`docs/features/NN-name/spec.md`)
狀態只記在 `STATUS.md`。
```md
# NN 功能名稱

## 目標與背景
## 範圍
**範圍內**:
**明確不做**:
## 驗收條件
- AC-1:Given … When … Then …(驗證方式:自動 | 人工〔理由、檢查步驟〕)
## 依賴
## 待決事項
- …(阻擋:AC-n)
## 相關 ADR
```
