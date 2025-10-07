**github base**
- Setup and config
```
git config --global user.name "your name"
git config --global user.email "your email"
git config --list
```

- starting a repo 
```
git init
git clone <url>
git status
git add . <or file>
git commit -m "content"
git log
git push -u orgin master --force
```

- git branching
```
git branch
git branch <name branch> # create new branch
git checkout <name branch> # switch branch
git checkout -b <name branch> # create and switch to branch
git merge
git branch -d <name branch> # delete branch or option -D with not merge
```

- remote github
```
git remote -v
git remote add origin <url>
git push
git pull
git fetch
```

- Undo and fix
```
git checkout -- <file> #discard change (before staging)
git reset HEAD <file> # unstage a file
git reset --hard HEAD # reset to last commit 
git revert <commit> # now commit that undoes a commit
```

- Stash
```
git stash # save uncomitted changes
git stash pop # reapply last stash
git stash list  # show stashes
```

- Tags
```
git tag v1.0  # create tag
git tag # List tag
git push origin v1.0 # psh tag to github
```

**git command**

| command | content |
| ------- | ------- |
| git init | create git |
| git add <option> | add 1 or more files to staging with ". all or file1, file2" |
| git reset file1 | removes one or more file from stagin |
| git status | status git |
| git commit -m | create commit |
| git remote add origin main | remote to storege on github |
| git push |
| git push origin main | push repo local into github |
| git pull |
| git pull origin main | pull come local |
| git branch | show all branch current |
| git branch <name_new_branch> | create new branch |
| git checkout name_branch | switches to other branch |
| git checkout -b name_branch | create branch and switches to branch |
| git log | check log of commit |
| git show <commit hash> | show infor by hash show from git log |
| git show --name-only <hash> | only show name |
| git reflog | gives us infor about all the changes that happened |  

**create other repo local**
- working on 1 repo github 

| command | content |
| ------- | ------- |
| git clone https://github.com/nth85/gitlab.git repogitlab | Create local repo with name repogitlab folder |
|  echo "i am from repogitlab" > fromrepogitlab..txt | test|
| git add . | |
| git status | |
| git commit -m "test commit" - git push | |

- from gitlab folder switches to main branch

| command | content |
| ------- | ------- |
| git checkout main | |
| git pull | pull from main branch |
| git log | check all commit have from repogit folder |

**undoing changed have 2 options**

| command | content |
| ------- | ------- |
| git log | enter "q" out log |
| git log -n 10 | 
| git revert <hash> | save that file by typing ":q", remove all changes from that commit  |
| git reset <hash>  | revert ho�n nguyen, reset thiet lap lai |
| git reset --soft <hash>  | removes commits from history but keeps changes |
| git reset --hard <hash> | remove commit from history and remove changes |

**git merge and pull request**
- merge

| command | content |
| ------- | ------- |
| git merge <name_branche> | merge into main branche |
| git log | :q|

- pull request

| command | content |
| ------- | ------- |
| git branch | main  |
| git push -f | override of the remote one |
| git checkout lab | lab |
| echo "lab pull request" > pullrequest.txt | 
| git add pullrequest.txt |
| git commit -m "update pullrequest" |
| git push -u origin lab | create feature branch on github |
| git checkout main |
| git merge |
| git branch -d lab | delete branch, If you are sure you want to delete it, run 'git branch -D lab' |

*move to github and swith to our lab branch, choose "new pull request" - "creat pull request", see changed "File changed" - add command "start a review"*
*add review to the PR in top "Conversation" - "reviers" --> Merge pull request*

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