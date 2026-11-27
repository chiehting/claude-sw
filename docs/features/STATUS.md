# 功能狀態

狀態:`spec(草稿)` `spec(已核准)` `test-writing` `test-verifying` `implementing` `verifying` `debugging` `review` `merged` `blocked`
由 orchestrator 更新。測試迴圈與實作迴圈各滿 3 輪仍失敗即標 `blocked`(規則見 AGENTS.md)。「測試 SHA」在 `test-verifying` 通過、測試凍結時記入(`.claude/hooks/test-freeze.sh` 與 verifier 以此檢查);全為人工 AC 時留空。

| # | 功能 | 狀態 | 依賴 | 測試 SHA | 重試輪數 | 備註 |
|---|------|------|------|----------|----------|------|
