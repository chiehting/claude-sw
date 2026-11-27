# claude-software-development-framework

使用 agents 開發軟體的工作流程與其產出的產品。

## Language

**Spec**:
一個可獨立驗證的功能規格,含目標、範圍、驗收條件(AC)、依賴與待決事項。
_Avoid_: 需求文件, ticket

**AC (驗收條件)**:
spec 中編號的、可由指令或可觀察結果判定通過與否的條件。
_Avoid_: 需求, 期望行為

**待決事項**:
spec 中尚未確定、且不得被猜測的事,標明阻擋哪些 AC。
_Avoid_: TODO, 假設

**測試凍結**:
測試通過 `test-verifying` 後,以 `STATUS.md` 記錄的 commit SHA 為基準,implementer 與 debugger 不得再修改測試目錄。
_Avoid_: 鎖定測試

**AC→測試對照表**:
test-writer 產出的對照,列出每條 AC 對應的測試,或標「人工」(免測)並附理由。
_Avoid_: 測試清單

**人工驗證**:
無法自動測試的 AC,由使用者依 spec 的檢查步驟確認,結果記在 spec 該 AC 旁。
_Avoid_: 手動測試
