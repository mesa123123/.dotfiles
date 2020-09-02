#!/bin/bash

git add .
commit_message="Sessions End $(date)"
echo $commit_message
git commit -m "${commit_message}"
git push origin master

expect "Username for 'https://github.com':"
send -- "mesa123123"
