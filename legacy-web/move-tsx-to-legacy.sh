#!/bin/bash
# 將根目錄所有 .tsx 移到 legacy-web，保持根目錄清爽（不動 ios 內檔案）
set -e
cd "$(dirname "$0")"

mkdir -p legacy-web
count=0
for f in ./*.tsx; do
  [ -f "$f" ] && mv "$f" legacy-web/ && count=$((count+1))
done
echo "已將 $count 個 .tsx 移至 legacy-web/"

git add -A
git status --short
git commit -m "chore: 將根目錄 .tsx 移入 legacy-web，保持根目錄清爽" || true
echo "--- 完成。推送到 GitHub 請執行: git push origin main ---"
