#!/usr/bin/env bash
# implementer/debugger 結束前的閘門:凍結的測試目錄與 STATUS.md 記錄的 SHA 有差異就阻止結束 (exit 2)。
# 只是早期回饋;獨立 gate 是 verifier 在 verifying 階段的 git diff 檢查。
input=$(cat)
# 已因本 hook 被擋過一次再度停止時放行,避免無限迴圈。
if echo "$input" | grep -q '"stop_hook_active": *true'; then exit 0; fi
# STATUS.md 與 STACK.md 由 orchestrator 在主 worktree 更新;worktree 內的副本可能過期,一律讀主 worktree。
start="${CLAUDE_PROJECT_DIR:-.}"
root=$(cd "$start" 2>/dev/null && git worktree list --porcelain | awk '/^worktree / { print substr($0, 10); exit }')
[ -n "$root" ] && cd "$root" || exit 0
# agent 的工作目錄(hook input 的 cwd)。若在某個 feat/* worktree 內,只檢查那一個,避免被其他功能的狀態誤擋。
agent_cwd=$(echo "$input" | sed -n 's/.*"cwd": *"\([^"]*\)".*/\1/p' | head -n 1)
if grep -q '^狀態:未初始化' docs/STACK.md 2>/dev/null; then exit 0; fi

# 測試目錄:STACK.md 的固定格式「- 測試目錄: <path>」。
testdir=$(sed -n 's/^- 測試目錄:[[:space:]]*//p' docs/STACK.md 2>/dev/null | head -n 1 | tr -d '`')
if [ -z "$testdir" ]; then
  echo "test-freeze: STACK.md 沒有「- 測試目錄:」,未檢查凍結就放行。" >&2
  exit 0
fi

# hook 的 cwd 是主 repo,不是 worktree。找 feat/NN-name 的 worktree,
# 且 STATUS.md 中 NN 的狀態為 implementing 或 debugging,並取其「測試 SHA」欄。
status="$root/docs/features/STATUS.md"
only=""
while read -r wt br; do
  case "$agent_cwd" in "$wt"|"$wt"/*) only="$wt" ;; esac
done < <(git worktree list --porcelain | awk '
  /^worktree / { wt = substr($0, 10) }
  /^branch refs\/heads\/feat\// { print wt, substr($2, 12) }')
fail=""
checked=0
while read -r wt br; do
  nn=${br#feat/}; nn=${nn%%-*}
  case "$agent_cwd" in
    "$wt"|"$wt"/*) ;;
    *) if [ -n "$only" ]; then continue; fi ;;
  esac
  sha=$(awk -F'|' -v n="$nn" '
    { gsub(/[ `]/, "", $2); gsub(/[ `]/, "", $4); gsub(/[ `]/, "", $6) }
    $2 != "" && ($2 + 0) == (n + 0) && $4 ~ /^(implementing|debugging)$/ { print $6; exit }' "$status" 2>/dev/null)
  [ -z "$sha" ] && continue
  checked=$((checked + 1))
  if ! (cd "$wt" && git cat-file -e "$sha^{commit}" 2>/dev/null); then
    echo "test-freeze: [$wt] 找不到 SHA $sha,未檢查凍結就放行。" >&2
    continue
  fi
  if ! out=$(cd "$wt" && git diff --stat "$sha" -- "$testdir" 2>&1) || [ -n "$out" ]; then
    fail+="[$wt]"$'\n'"$out"$'\n'
  fi
done < <(git worktree list --porcelain | awk '
  /^worktree / { wt = substr($0, 10) }
  /^branch refs\/heads\/feat\// { print wt, substr($2, 12) }')

if [ "$checked" -eq 0 ]; then
  echo "test-freeze: 找不到 implementing/debugging 且有測試 SHA 的 feat/* worktree,未檢查凍結就放行。" >&2
  exit 0
fi
[ -z "$fail" ] && exit 0
{
  echo "凍結的測試($testdir)已被修改,不能結束。請還原測試;若測試有誤,停止並回報,由主對話回退到 test-writing:"
  echo "$fail"
} >&2
exit 2
