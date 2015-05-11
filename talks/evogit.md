# EvoGit

## Making Revision Control Exciting Again

---

# Why Switch from Subversion to git

---

## More Popular

![](/project_using_git.png)

---

## More Powerful

![](/power-tools.jpg)

---

# Git vs. Subversion

---

## How Subversion Works

![](/svn-centralized.svg)

---

## Subversion Commands

Initial checkout from the central repository (creates working directory
pointing to the server):

    svn co http://evogit/subversion/unity/trunk

Add new files:

    svn add file1 dir1 ...

Remove files:

    svn rm file1 ...

Update to latest version from server:

    svn update file1 ...

Commit your changes to the server:

    svn commit -m 'blah' file1 ...

Also:

    svn status, svn log, svn info, svn diff

---

![](/svnexplained01.png)

![](/svn_explained02.png)

---

## Principals (from Subversion 1.6 documentation)

> Subversion, CVS, and many other version control systems use a
> **copy-modify-merge** model as an alternative to locking.

...

> Subversion client programs use URLs to identify versioned files and
>  directories in Subversion repositories.

...

> Each directory in your working copy contains a subdirectory named `.svn`, also
> known as the working copy's *administrative directory*. The files in each
> administrative directory help Subversion recognize which files contain
>  unpublished changes, and which files are out of date with respect to others'
>  work.

...

> Subversion working copies do not always correspond to any single revision in
> the repository; they may contain files from several different revisions.

---

## Consequences

### Flexible

We can work on different projects in the same repository without bothering each other.

### Inconsistent

Two developers can test against different sets of files, and their working
directories will have different files than the production site.

There is no "release" or "tested version" inside Subversion.

### Fragile

If we change two different files that depend on each other, we can both
commit our changes without testing against each other's changes, and push
this to production.

BOOM



---

## How Git Works

### Git is Distributed

![](/git-distributed.svg)

### Everyone has a repository

---

### Subversion records diffs of files

![](/svn-vs-git.png)

### git records snapshots of the whole project

---

## git repository structure

* In git all content has a SHA-1 cryptographic signature - file contents, directory trees,
**commits** (= snapshots).

* Each commit is a revision of the entire project.

* Each commit points to a previous commit.

* The project's history is a lineage of commits, and it does not have to
  be a single chain - **git makes branches trivial**.

* A git branch is a pointer to a chain of commits

![](/branching.png)

The default branch is called `master`

---

## Using Git - Basics


**Clone** the central repository:

    git clone git@evogit.evogene.internal:cg/unity.git

This pulls the entire history of the project (or at least the default branch
of this history) to your local repository. This is stored in a single **.git**
directory at the root of your working directory.

Add new files

    git add file1 dir1 ...

Remove files

    git rm file1 ...

Commit - to your **local** branch

    git commit -a -m 'blah'

---

## Sharing via server

Update your local branch with the latest changes from the server:

    git pull --rebase

Merge your changes into the remote branch (update the server):

    git push

"Server" is just a remote git repository.

By convention, the remote git repository we cloned from is called `origin`.

---

## All together:

Do some work and commit it:

    $EDITOR ...
    git add new_file1 new_file2 ...
    git commit -a -m 'added stuff'

Get the latest from the server, so your changes get made on top of it:

    git pull --rebase

You can't do `git pull` unless all the changes in your working directory have
been `git commit`ed.

    git push

Done

---

# Things to do with a local repository

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

![](/git-add-commit.svg)

---

The local git environment is made up of 3 parts:

1. The working directory (the files you see).
2. A repository where commits are recorded
3. A staging area where commits are assembled, used in merging and other operations.


![](/git+commands.png)

---

## Examining things

![](/git-status-vs-log.svg)

---

## Current situation

What's tracked, what's changed, what's been added/removed, what branch are we on, etc

    git status

Show only changed files (not untracked ones):

    git status -uno

Show changes

    git diff

---

## History

Show history

    git log (... or git lg for nicer formatting)

To examine an old commit (as a diff/patch):

    git show 3ae2235179

### History search

Find commits where text was added/changed

    git log -S "text_added" file...

You can also search by date, file path modified, etc.

---

# Branches

---

For the next part, we'll need this:

[Git Visualization](http://pcottle.github.io/learnGitBranching/?NODEMO)

---

## Working with branches

Say we want to work on a new feature which we won't publish for a while, but
still be able to make bug fixes and urgent changes quickly and cleanly.

Create a new branch (and switch to it):

    git checkout -b featureX

Once you're on the new branch, add and commit your changes.

Switch back to the main branch:

    git checkout master

Do pull, work, etc.

Show existing branches (current one will be highlighted)

    git branch --list

---

# Merging

---

## What do we merge

* In Subversion, we merge files; **in git, we merge branches**.
* `git push` merges our local branch `master` into the remote branch
  `origin/master` (the server's version of `master`).
* `git pull` merges `origin/master` into our local `master` branch.
* Local and remote merges work the same.

So, when featureX is ready:

    git checkout master
    git merge featureX

Or, if we want to apply all the work from featureX to the *current* latest
version, we can do:

    git checkout featureX
    git rebase master
    git checkout master
    git rebase featureX

---

## Kinds of Merge

Whenever git merges two branches, it find the last common point in their
history and the first divergent commit in each branch and does a **three-way merge**.

Three types of merge:

- The trivial case where branch A hasn't advanced since branch B diverged from
  it.
- The one where git can figure out how to do it.
- The one where git needs your help (conflict).

## Rebase

`git rebase` (and `git pull --rebase`) *rewrite history* so that a future
merge will be of the trivial kind

---

## Fast-forward merge

![](/git-ff-merge.svg)

No new commit is created

---

## 3-Way merge

![](/git-before-3-way-merge.svg)

A **merge commit** is created

---

## Rebase

![](/git-merge-after-rebase.svg)

---

## Conflict

Git can't figure out how to merge the two branches. The merge exits with an
alarming message, you are no longer on any branch, there are conflict markers
in files... **what to do what to do**

### Don't panic

Use `git status` to see what the problem is:

    # On branch featureX
    # Unmerged paths:
    #   (use "git add/rm <file>..." as appropriate to mark resolution)
    #
    #       both modified:      xxxx.pl
    #
    no changes added to commit (use "git add" and/or "git commit -a")

---

## Resolving a merge conflict:

Edit the conflicted files, then add them:

    $EDITOR xxxx.pl
    git add xxxx.pl
    git commit -m 'fix conflict'

---

## Important Note: Rewriting History

* `git rebase` let's you rewrite history.
* This allows you to create a cleaner history, for example before merging a
branch into master.
* However, you should never rewrite **published** history.

* Specifically, **never** rebase `master` on any branch *except*
`origin/master`.


---

## GitLab

[GitLab](https://about.gitlab.com/) is a web interface for a central git repository

![](/gitlab_dashboard.png)

Installed at [evogit.evogene.internal](https://evogit.evogene.internal)

---

## GitLab Setup

Login to GitLab (Evogene password)
![](/gitlab_login.png)

---

## Profile Page

![](/gitlab_profile.png)

---

## SSH Keys

![](/gitlab_ssh_keys.png)

---

## Generate ssh key

To [generate a new SSH key](http://evogit.evogene.internal/help/ssh) just open your terminal and use code below.

    ssh-keygen -t rsa -C "dotan@evogene.com"# Creates a new ssh key using the provided email
    # Generating public/private rsa key pair...

Next just use code below to dump your public key and add to GitLab SSH Keys

    cat ~/.ssh/id_rsa.pub
    # ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6eNtGpNGwstc....

---

## Add SSH Key

Paste it in your profile

![](/gitlab_ssh_key.png)

---

## Further Reading

- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)
- [Pro Git book (online)](http://git-scm.com/book/en/v2)
- [Learn Git Branching](http://pcottle.github.io/learnGitBranching/) -
tutorials with pretty visualizations
- [Git Resources For Visual
  Learners](https://changelog.com/git-resources-for-visual-learners/)
- [Most common git screwups/questions and solutions](http://41j.com/blog/2015/02/common-git-screwupsquestions-solutions/)
- [How git's merge-recursive strategy works](http://codicesoftware.blogspot.com/2011/09/merge-recursive-strategy.html)

