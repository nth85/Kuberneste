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
| git reset <hash>  | revert hoàn nguyen, reset thiet lap lai |
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