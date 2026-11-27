# 統一驗證入口。由 /init-stack 依 docs/STACK.md 的「驗證指令」生成,請勿手改。
# 在設定完成前刻意失敗(fail closed),避免未驗證就被視為通過。
.PHONY: verify
verify:
	@echo "make verify 尚未設定:請先選定技術棧並串接測試/型別檢查/lint。" >&2
	@exit 1
