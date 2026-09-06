#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: ./scripts/analyze.sh FILE" >&2
}

# 参数校验
if [ "$#" -ne 1 ]; then
  usage
  exit 1
fi

file="$1"

# 文件存在性与可读性校验
if [ ! -f "$file" ]; then
  echo "Error: File '$file' does not exist." >&2
  exit 2
fi

if [ ! -r "$file" ]; then
  echo "Error: File '$file' is not readable." >&2
  exit 2
fi

# 统计包含 "ERROR" 的行数（大小写敏感）
total=$(grep -c 'ERROR' "$file" || true)

# 提取 ERROR 后面的数字代码（例如 500），找到出现频率最高的一个
top=$(awk '{
  if (match($0, /ERROR[^0-9]*([0-9]{3,})/, a)) print a[1]
}' "$file" | sort | uniq -c | sort -nr | awk 'NR==1{print $2}')

if [ -z "$top" ]; then
  top="N/A"
fi

echo "Total ERROR: $total"
echo "Top Code: $top"

exit 0
