## 移除已经上交的文件

1. `git rm -r --cached .gitignore`
2. 添加新的忽略规则，重新提交就可以了 
3. 注意：中文加入 `.gitignore` 中会乱码，不能生效！



## 查看当前代码在 git 服务器的分支列表

`git branch -r`



## 05-11 如何重置commit

在 vscode 中写 cpp 时引入了万能头文件，手贱编译了一下在 .vscode 目录下面生成了很多大于100M的 .ipch 文件，结果还 commit 到了本地仓库中，push 到 github 被疯狂拒绝，弄了好半天才搞好。



#### 1. 备份本地文件

备份的目录是回退 commit 时，会回到你提交时的那个分支，本地新建的文件会消失的~

#### 2. 回退 commit

先用命令```git log``` 查看本地 commit 记录，然后使用命令 ```git reset --hard <commit_id>``` 就可以回退 commit，这里我傻逼了，hard 参数会连带着本地源码一起回退，其实只要改为 soft 就可以了，这样新建的文件不会消失，也不用去傻傻的备份文件了，重新 commit 就行了。要同时回退远程的状态可以使用命令 ```git push origin HEAD --force``` 

#### 3. 总结

在 commit 之前先检查一下有哪些文件不需要提交到远程，然后在 .gitignore 里面注册一下，如果已经 commit 了，再去注册是不会生效的~