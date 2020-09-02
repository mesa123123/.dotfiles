#!/bin/bash

git add .
commit_message="Sessions End $(date)"
echo $commit_message
git commit -m "${commit_message}"
git push origin master
