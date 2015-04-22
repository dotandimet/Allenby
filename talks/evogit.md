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

## More Popular

- Subversion was a good bet in 2005.
- Things have moved on.
- Linux, Perl, Eclipse, PHP and many more all use git.
- More Documentation, Tutorials, Help.
- Many online resources, features, ecosystem 
- [github.com](https://github.com) - THE site for hosting open source code 
- [https://thkoch2001.github.io/whygitisbetter/](https://thkoch2001.github.io/whygitisbetter/) - Why git is better than X

---

## More Powerful

- **Distributed** Source Control
- Distributed > Centralized
- Local Repository (full history) > working directory
- History is not linear!
- Cheap and easy branching and merging.
- **Better Tools**

---

## Caveats: Power Tools

![](/power-tools.jpg)

---


# Git vs. Subversion

---

## Subversion is Centralized

![](/svn-centralized.svg)

---

## Git is Distributed

![](/git-distributed.svg)

---

### Subversion records diffs, git records snapshots

![](/svn-diffs.svg)

---

![](/svn-vs-git.png)

In git all content has a SHA-1 signature - file contents, directory contents,
**commits**

---

### Example - How To Update

Subversion: examine entire project tree; any file with a revision earlier than
the last revision gets updated.

Git: compare the last commit to the current commit, apply the diff to the
project tree.

---

## Subversion branches are copies of repository root

---

## Git branch is a pointer to a chain of commits

![](/branching.png)

The default branch is called `master`

---

# Using Git - Basics

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

If no argument is specified, the current directory is committed.

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

You can break down this process to group unrelated changes into separate
commits:

    git add foo.css bar.html ...
    git commit -m 'changed header...'

    git add g2c.pl
    git commit -m 'fix bug in loader script...'

---

## Why is a commit distinct from add?

![](/git-3-areas.svg)

`git help commit` (man page) says:

> Stores the current contents of the index in a new commit along with a log
> message from the user describing the changes.

**WAT?**

---

![](/git-add-commit-checkout.svg)

The local git environment is made up of 3 parts:

1. The working directory (the files you see).
2. A repository where commits are recorded
3. A staging area where commits are assembled, used in merging and other operations.

---


![](/git+commands.png)

---

# Using Daily commands – new features

---

## Status

What's tracked, what's changed, what's been added/removed, what branch are we on, etc

    git status

Show only changed files (not untracked ones):

   git status -uno

Show changes

   git diff

---

## History

Show history

   git log

Or, in a compact, pretty format:

   git lg

(`lg` is a `git alias`, its really `log` with a few formatting flags)

Show contents of a commit (as a diff/patch):

    git show 3ae2235179fe487096d715807e6346c2302d377d

This also works:

    git show 3ae2235179

---

![](/git-status-vs-log.svg)

---

## History search

Find commits where text was added/changed

    git log -S "text_added" file...

You can also search by date, file path modified, etc.

---

For the next part, we'll need this:

[Git Visualization](http://pcottle.github.io/learnGitBranching/?NODEMO)

---

## Reseting state

Resets all changes in your working directory to previous version

    git checkout [commit / tag / branch] [file]

Reset file to specific version:

    git checkout 1fc6392 dbtools/refresh_taxonomy.pl

Undo add/rm (reset the staging area/index):

    git reset [commit]

Undo a commit (just changes what the last commit is considered to be)

    git reset --soft [commit]

Undo a commit and reset the working directory to the commit

    git reset --hard [commit]

---

## Oops commits

Merge this commit with the last commit:

    git commit --amend

Solution for the "oops, typo" extra commit.

In general, you can merge, split and edit commits - as long as you don't touch published history (i.e, commits that you've pushed or pulled).

---

## Never Change Published History

---

## Stash changes for later work

Save changes in working tree to the side, so you can pull/push/work on something else:

    git stash save [some_name]

Re-apply the changed files back to the working tree:

    git stash pop

See what's saved on the stash:

    git stash list

---

## Alternative: Use a branch:

Create a new branch (and switch to it):

    git checkout -b featureX

Once you're on the new branch, add and commit your changes.

    git commit -a -m '...'

Switch back to the main branch:

    git checkout master

Do pull, work, etc.

    git merge featureX

---

Or, to get the same effect as git stash pop, do:

    git checkout featureX
    git rebase master
    git checkout master
    git merge featureX

---

git checkout version file - or/and?
update servers - how does it work? We update the history, not files.
stash (before/after branch)

---

## Branches

![](/git-branches.svg)

---

## Branches

- The history in git is a directed acyclic graph of commit objects.
- Each commit points to (one or more) "parent" commits.
- A *branch* is a distinct line of revisions/commits.
- **A branch is implemented as a pointer to a commit**.

---

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

    git remote add name url

Usually we will work with only one - *evogit*, which is aliased to **`origin`**
(this is the default by convention, like `master` for the default branch).

To see all the remote repositories with their URLs

     git remote -v

---

## Remote branches

Fetch and merge a remote branch.

    git pull [remote] [branch]

Default branch is usually **master**.
Default remote is usually **origin**.

Same as
    git fetch ..
    git merge origin/master

---

Push your local branch to the remote repository

    git push [remote] [branch]

Will be rejected if git can't do a fast-forward merge.

---

Push all local branches to remote repository `origin`

    git push -a

Pull all remote branches

    git pull -a

---

# Merging

---

## Merging with remote branches

Every time you `pull` or `push`, you merge your local *master* branch with the
remote *master* branch.

The `-u` flag lets git know you are tracking the remote branch, so it will
tell you how many commits ahead/behind of it your local branch is.

---

## git pull

![](/git-before-pull.svg)

---

## git push

![](/git-before-push.svg)

---

## Merge

Whenever git merges two branches, it find the latest common point in their
history and does a **three-way merge**.

Three types of merge:

- Fast-Forward merge
- Recursive
- The one where git needs your help (conflict).

---


![](/git-ff-merge.svg)

---

![](/git-before-3-way-merge.svg)

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

---

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

---

## Resolving a merge conflict:

Edit the conflicted files, then add them:

    dotan@boots:pilot liza|MERGING$ git add !$
    dotan@boots:pilot liza|MERGING$ git add cgi/ureport

Check status:

      dotan@boots:pilot liza|MERGING$ git status
      # On branch liza
      # Changes to be committed:
      #
      #       modified:   cgi/ureport
      #

Commit:

      dotan@boots:pilot liza|MERGING$ git commit -m 'fix conflict'
      [liza fcce7e3] fix conflict

---

Can now merge to other branch:

      dotan@boots:pilot liza$ git checkout elad
      Switched to branch 'elad'
      dotan@boots:pilot elad$ git merge liza
      Updating e67d947..fcce7e3
      Fast-forward
       cgi/ureport |    2 +-
       1 files changed, 1 insertions(+), 1 deletions(-)
      dotan@boots:pilot elad$

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

## Further Reading

- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)
- [Pro Git book (online)](http://git-scm.com/book/en/v2)
- [Learn Git Branching](http://pcottle.github.io/learnGitBranching/) -
tutorials with pretty visualizations
- [Most common git screwups/questions and solutions](http://41j.com/blog/2015/02/common-git-screwupsquestions-solutions/)


