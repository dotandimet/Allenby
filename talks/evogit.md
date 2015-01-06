# EvoGit

## Making Revision Control Exciting Again

---
## Agenda

- Why switch from svn to git
- Setup
- Daily Use
- Pilot notes

---

## Why Switch from Subversion to git

- **More Powerful**
    - Designed for distributed work
    - Tracks changes, not revisions of files
- **More Popular**
    - Linux, [github.com](https://github.com) - many online resources, features, ecosystem

---

- Corollary: more complex, but more documentation, help and tutorials.
- You can solve problems with git that you couldn't even create with subversion ;P

---

## Distributed Source Control

    cd Project
    git init # create a git repository in the current directory.

With git you do not need a central server - you manage your revision history
locally, in a `.git` directory under the root of your working directory.

---

## Collaboration

For collaboration, you can sync your local repository with a remote repository

    git push origin # send local changes to remote repository nicknamed "origin".
    git pull origin #  revisions from remote repository "origin"


---

To list remote repositories

    git remote -v

Output looks like this:

    origin  git@evogit.evogene.internal:cg/unity.git (fetch)
    origin  git@evogit.evogene.internal:cg/unity.git (push)

---

## GitLab

[GitLab](https://about.gitlab.com/) is a web interface for a central git repository

![](/gitlab_dashboard.png)

Installed at [evogit.evogene.internal](https://evogit.evogene.internal)

---

## Evogit Setup

Login to evogit (Evogene password)
![](/gitlab_login.png)

---

## Profile Page

![](/gitlab_profile.png)

---

## Generate ssh key

To [generate a new SSH key](http://evogit.evogene.internal/help/ssh) just open your terminal and use code below.

    ssh-keygen -t rsa -C "dotan@evogene.com"# Creates a new ssh key using the provided email
    # Generating public/private rsa key pair...

Next just use code below to dump your public key and add to GitLab SSH Keys

    cat ~/.ssh/id_rsa.pub
    # ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6eNtGpNGwstc....

---

Paste it in your profile

![](/gitlab_ssh_key.png)

---

## Setup Groups

- Join group CG (send mail to dotan/admin)
- Git clone unity project (~svn checkout)

---

## Shell setup

See if your git is configured (it should be):

    $HOME/.gitconfig

It should look like this:

    cat ~/.gitconfig
    [user]
            name = Dotan Dimet
            email = dotan@evogene.com
    [color]
            diff = auto
            status = auto
            branch = auto
    [core]
            preloadindex = true
    [alias]
            lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

---

Or by command:

    git config --list --global

Should look like this:

    user.name=Dotan Dimet
    user.email=dotan@evogene.com
    color.diff=auto
    color.status=auto
    color.branch=auto
    core.preloadindex=true
    alias.lg=log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

---

## Using Git

---

## Clone

Clone the central repository:

    git clone git@evogit.evogene.internal:cg/unity.git

Subversion equivalent:

    svn co http://evogit/subversion/unity/trunk

---

### Update from server

Subversion

    svn update

git

    git pull -u --rebase

`--rebase` applies your changes on top of the latest changes.

---

### Add new files:

Subversion

    svn add newfile1 ...

git

    git add newfile1 ...

---

### Remove files:

Subversion

    svn rm file1 ...

git

    git rm file1 ...

---
### Commit:

Subversion

    svn commit -m 'blah' file1 ...

`svn commit` will update the server.

git

    git add file1 ...
    git commit -m 'blah' ...
    git push -u

`git commit` records the change in the local repository.
Only `git push` sends the changes to the server.

---

## Daily commands – new features

---

## History search

Find commits where text was added/changed

    git log -S "text_added" file... 

You can also search by date, file path modified, etc.

## Reseting state

Resets all changes in your working directory to previous version

    git checkout

Reset file to specific version:

    git checkout 1fc6392 dbtools/refresh_taxonomy.pl



---

## Branches

- A *branch* is a distinct line of revisions/commits.
- In git, you can maintain multiple distinct branches in your local repository.
- You can create, delete and merge different branches.
- You can push a branch to the server (or pull a specific branch from it).
- The default branch in git is called **master** (unless you want something
  different).

---

# Working with branches

Create new branch xxx and switch to it

    git checkout -b xxx

Show existing branches (current one will be highlighted)

    git branch --list


Merge branch1 into current branch

    git merge branch1

---

# Pilot

---

### Setting up the git pilot

    cd $HOME/work
    git clone --branch pilot git@evogit.evogene.internal:cg/unity.git pilot

---

### Testing environment

    https://dora/${USER}p/cgi/miner.cgi ...

For example

    https://dora/lizaap/cgi/...

configured to run scripts where

    UNITY_ROOT = /home/users/bioinf/lizaa/work/pilot

currently, only lizaa, eladm and nogah are supported in the Apache config.

---

### Work

    cd $HOME/work/pilot
    git pull -u # to get updates
    $EDITOR file1 file2 ...
    git add file1 file2 ...
    git commit -m 'commit message...'
    git status
    git pull -u
    git push origin pilot # to update evogit

