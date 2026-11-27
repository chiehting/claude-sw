---
name: init-stack
description: 訪談並定義技術棧與驗證指令,生成 STACK.md、ADR、Makefile verify;日後變更技術棧也用它。
disable-model-invocation: true
---

呼叫 Skill 工具載入 `grilling` 與 `domain-modeling`(取其 ADR 格式,ADR 放 `docs/adr/`)。訪談依 `grilling`:一輪問整個 frontier。

`docs/STACK.md` 是技術棧的 SSOT,Makefile 的 `verify` 是它的產物。

## 鐵則
- **事實自己查,決策才問**:現有檔案、已安裝的工具與版本,用唯讀指令或 subagent 查。使用者不確定的事,記入 STACK.md「待決事項」。
- **每輪回答後就寫入 `docs/STACK.md`**,中斷後從空白或待決處續談。
- **Makefile `verify`/`test` 先 dry run(展示差異)**,使用者同意後才寫入。
- 修改範圍:STACK.md、ADR、Makefile 的 `verify` 與 `test`。

## 首次初始化(STACK.md 狀態為「未初始化」)
訪談並寫入對應章節:
1. 語言與框架(含版本)
2. 套件管理工具與安裝指令
3. 驗證指令:測試、單功能測試(`make test FEATURE=NN` 對應的指令,只跑該功能的測試)、型別檢查、lint、格式化檢查。每項是一條可直接執行的指令;該語言沒有的項目寫「無」並註明原因。
4. 目錄與程式碼慣例:原始碼位置、測試目錄(固定格式 `- 測試目錄: <path>`,供 hook 與 verifier 讀取)、測試命名、命名規則、是否需要介面骨架(靜態型別語言通常需要:測試要能編譯才能因功能缺失而失敗)
5. 高風險環境:有沒有正式環境、正式資料、部署、權限或不可逆操作。沒有就寫「無」;有就逐項列出,並說明各自的 rollback 方式。

訪談完成標準:每個章節都有答案,或已記入「待決事項」。

收尾,依序:
1. 為選定的技術棧寫一份 ADR(選擇與主要取捨),連結於 STACK.md「相關 ADR」。
2. 依「驗證指令」生成 Makefile 的 `verify` 與 `test`(`test` 接受 `FEATURE=NN`)。
3. 派 verifier agent 執行 `make verify`,確認指令可執行。尚無測試時,空測試是否算通過,詢問使用者。
4. STACK.md 狀態改為「已初始化」。

收尾完成標準:verifier 回報的 `make verify` 結果與使用者對「通過」的定義一致,才執行第 4 步。

## 變更技術棧(STACK.md 狀態為「已初始化」)
1. 問變更原因與範圍。
2. 寫新 ADR,標明取代哪份舊 ADR。
3. 更新 STACK.md,重新生成 Makefile 的 `verify` 與 `test`。
4. 派 verifier agent 執行 `make verify`。
5. 告知使用者:既有程式碼維持原樣,遷移是一個功能,用 `/write-spec` 另開 spec。

完成標準:新 ADR 標明取代對象,STACK.md 與 Makefile `verify`/`test` 一致,且 verifier 回報的 `make verify` 結果與使用者對「通過」的定義一致,才執行第 5 步。
