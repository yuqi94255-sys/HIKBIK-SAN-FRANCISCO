#!/bin/bash
# 一鍵推到 yuqi94255-sys/HIKBIK-SAN-FRANCISCO（只需貼上 Token 一次）

cd "$(dirname "$0")"

echo "請先用瀏覽器打開："
echo "  https://github.com/settings/tokens/new?description=HIKBIK-SAN-FRANCISCO&scopes=repo"
echo "用 yuqi94255-sys 登入後，勾選 repo，點 Generate token，複製產生的 token。"
echo ""
read -sp "貼上 Token 後按 Enter: " TOKEN
echo ""

if [ -z "$TOKEN" ]; then
  echo "未輸入 Token，已取消。"
  exit 1
fi

git push https://yuqi94255-sys:${TOKEN}@github.com/yuqi94255-sys/HIKBIK-SAN-FRANCISCO.git main && \
  git branch --set-upstream-to=origin/main main 2>/dev/null

if [ $? -eq 0 ]; then
  echo "已成功推送到 GitHub。"
else
  echo "推送失敗，請確認 Token 有效且帳號為 yuqi94255-sys。"
  exit 1
fi
