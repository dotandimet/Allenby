# EvoGit

## Making Revision Control Exciting Again

---
## Agenda

- Why switch from svn to git
- Setup
- Daily Use
- Pilot notes

---

# Why Switch from Subversion to git

---

## More Powerful

- Designed for distributed work
- Tracks changes to whole project, not revisions of files
- Local copy contains *entire* repository with all history
- Faster operations
- Smaller directories
- **Better Tools**
- Cheap and easy branching (because it only tracks the changes).

- [https://thkoch2001.github.io/whygitisbetter/](https://thkoch2001.github.io/whygitisbetter/) - Why git is better than X 

---

## More Popular

- Subversion was a good bet in 2005.
- Things have moved on.
- Git is currently the most widely used version control system.
- Linux, Perl, Eclipse, Gnome, KDE, PHP, Ruby on Rails, Mode.js, Go ....
- Resources, features, documentation.
- Linux, [github.com](https://github.com) - many online resources, features, ecosystem
- Migration (from Subversion) is easy.

---

## Caveats

- Simple migration from Subversion is one way
- More complex, but more documentation, help and tutorials.
- You can solve problems with git that you couldn't even create with subversion ;P

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

# Using Git

---

## Checkout / Clone

Subversion checkout the central repository:

    svn co http://evogit/subversion/unity/trunk

Clone the central repository:

    git clone git@evogit.evogene.internal:cg/unity.git

---

## Update from server

Subversion

    svn update

git

    git pull -u

---

## Add new files:

Subversion

    svn add file1 dir1 ...

git

    git add file1 dir1 ...

---

## Remove files:

Subversion

    svn rm file1 ...

git

    git rm file1 ...

---

## Commit:

Subversion

    svn commit -m 'blah' file1 ...

`svn commit` will update the server.

If no argument is specified, the current directory is commited.

git

    git commit -a -m 'blah'
    git push -u

`git commit` records the change in the local repository.
Only `git push` sends the changes to the server.

More steps because you track your history locally, not only on the server.

---
## Break up a commit

`git commit -a` will `add` all changed files to a "staging area" and `commit`
these changes to your local repository. The `-a` flag is a shortcut for two git commands.

You can break down this process to make 2 unrelated changes into seperate
commits:

    git add foo.css bar.html ...
    git commit -m 'changed header...'

    git add g2c.pl
    git commit -m 'fix bug in loader script...'

---

# Daily commands – new features

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

git status, diff, log, show
git checkout version file - or/and?
update servers - how does it work? We update the history, not files.
git reset, git commit --amend ...
stash (before/after branch)

---
## Branches

- A *branch* is a distinct line of revisions/commits.
- In git, you can maintain multiple distinct branches in your local repository.
- You can create, delete and merge different branches.
- You can push a branch to the server (or pull a specific branch from it).
- The default branch in git is called **master** (unless you want something
  different).

---

## Working with branches

Create new branch xxx and switch to it

    git checkout -b xxx

Show existing branches (current one will be highlighted)

    git branch --list

Merge branch1 into current branch

    git merge branch1

---

## Remotes

With git you can have multiple remote repositories.
Usually we will work with only one - evogit, which is aliased to `origin` 
(this is the default by convention, like `master` for the default branch).

To see all the remote repositories

     git remote -v

---

## Remote branches


    git pull branchname

Fetch and merge a remote branch.

    git push origin feature_branch

Push your local branch to the remote repository `origin`

    git push -a

Push all local branches to remote repository `origin`

    git pull -a

Pull all remote branches

---

# Merging

---

## Merging with remote branches

Every time you `pull` or `push`, you merge your local *master* branch with the
remote *master* branch.

The `-u` flag lets git know you are tracking the remote branch, so it will
tell you how many commits ahead/behind of it your local branch is.

---

## Merge

Whenever git merges two branches, it find the latest common point in their
history and does a **three-way merge**

---

## Conflict

    dotan@boots:pilot liza|MERGING$ git status
    # On branch liza
    # Unmerged paths:
    #   (use "git add/rm <file>..." as appropriate to mark resolution)
    #
    #       both modified:      cgi/ureport
    #
    no changes added to commit (use "git add" and/or "git commit -a")
    dotan@boots:pilot liza|MERGING$ 


    dotan@boots:pilot liza|MERGING$ git diff
    diff --cc cgi/ureport
    index 11f6688,c7204e9..0000000
    --- a/cgi/ureport
    +++ b/cgi/ureport
    @@@ -9,8 -9,8 +9,13 @@@ use UReportNG
      
      
      my $MAKE_REPORT_OK                            = 'ok';
    ++<<<<<<< HEAD
    +our $ERR_INVALID_METADATA_JSON        = 'invalid metadata json';
    +my $ERR_INVALID_REPORT_JSON           = 'invalid report json';
    ++=======
    + my $ERR_INVALID_METADATA_JSON = 'invalid metadata json';
    + our $ERR_INVALID_REPORT_JSON          = 'invalid report json';
    ++>>>>>>> elad
      my $ERR_MAKE_REPORT                           = 'make_report() failed without dieing';
      my $ERR_AT_REQUEST_INDEX              = 'at request index';
      

dotan@boots:pilot liza|MERGING$ git add !$
dotan@boots:pilot liza|MERGING$ git add cgi/ureport
dotan@boots:pilot liza|MERGING$ git status
# On branch liza
# Changes to be committed:
#
#       modified:   cgi/ureport
#
dotan@boots:pilot liza|MERGING$ git commit -m 'fix conflict'
[liza fcce7e3] fix conflict
dotan@boots:pilot liza$ git checkout elad
Switched to branch 'elad'
dotan@boots:pilot elad$ git merge liza
Updating e67d947..fcce7e3
Fast-forward
 cgi/ureport |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
dotan@boots:pilot elad$ 



# Moving Forward

---

## Ongoing

- Import from Subversion
    - Ongoing (cron job)
- Pilot
    - Ongoing (Elad and Liza)

## Future
- Deploy
    - Update sites from evogit
- Switch Users

---

# Pilot

---

## Leftover slides
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


