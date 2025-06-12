**Commnad git**
- git base
```
git init
git add . # --all
git commit -m "change detail discretion"
git push origin master # --force
git remote add origin https://github.com/nth85/Kuberneste.git

git pull origin master

git branch
git branch opensearch
git checkout opensearch # traffer to new branch opensearch
git checkout -b opensearch # create and traffer

git checkout main
git merge opensearch

git branch -d opensearch #delete branch opensearch
```
- git config:
```
vi .git/config
[remote "origin"]
#        url = https://github.com/nth85/MY_DOCUMENT.git
         url = https://token_key_on_git@github.com/nth85/MY_DOCUMENT.git
        fetch = +refs/heads/*:refs/remotes/origin/*
```

**Install GI**
- Using winget tool install Powershell.
```
winget install --id Git.Git -e --source winget
#The current source code release is version 2.48.1. 
```
**On window open Powershell**
```
git --version
```
- change disk C to D
```
PS C:\Users\NTH> D:
PS D:\> ls
```
- Clone repo from GIT to PC local
```
cd folder/myfolder
https://github.com/nth85/Kuberneste.git
```
**Push local repo from PC local to git**
```
- Create one folder .git in my folder 
git init
git add . # '.' is all folder or file1.txt file2.excel
git commit -m "change detail discretion"
````
- Create new repository on github.com
`ex: https://github.com/nth85/Kuberneste.git`
copy this repo.
- Link this repo with my folder on PC
```
git remote add origin https://github.com/nth85/Kuberneste.git
```
- Push code into github
```
git push origin master --force
```
- pull my folder on PC with github repository
```
D:
cd Kuberneste
git pull origin main
ex: PS D:\Kuberneste> git pull origin main
```
**Set authencation for user**
```
git config –global user.name “Ten_cua_ban”.
git config –global user.email “email_cua_ban”.
```
- setup config .git
```
vi .git/config
url = https://user:pass@git.example.com/user/repository.git
```

hxxxpxxxx22@
