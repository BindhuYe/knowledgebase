#!/bin/bash
git_repo="/path/to/your/repo"

cd "$git_repo"
git pull origin master
echo "Git repository updated."