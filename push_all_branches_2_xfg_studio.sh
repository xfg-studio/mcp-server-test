#!/bin/bash

# GitHub 用户名和个人访问令牌
GITHUB_USER="xfg-studio-project"
GITHUB_TOKEN="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"
ORG_NAME="xfg-studio-project"
REPO_NAME=$(basename $(git rev-parse --show-toplevel))

# 创建 GitHub 仓库
create_repo_response=$(curl -s -o /dev/null -w "%{http_code}" -u "$GITHUB_USER:$GITHUB_TOKEN" https://api.github.com/orgs/$ORG_NAME/repos -d "{\"name\":\"$REPO_NAME\"}")

if [ "$create_repo_response" -eq 201 ]; then
    echo "GitHub 仓库创建成功：$ORG_NAME/$REPO_NAME"
else
    echo "GitHub 仓库创建失败，HTTP 响应码：$create_repo_response"
    exit
fi

# 构建完整的远程仓库 URL
REMOTE_URL="https://github.com/$ORG_NAME/${REPO_NAME}.git"

# 检查远程仓库是否已存在，如果没有则添加
if ! git remote | grep -q '^target$'; then
  git remote add target $REMOTE_URL
fi

# 获取最新的远程仓库信息
git fetch target

# 循环遍历所有本地分支并推送到远程
for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
  echo "正在推送分支 $branch 到远程仓库 $REMOTE_URL"
  git push target $branch
done

echo "所有分支已推送完成！"
