# Moving from Subversion to Git

---

Below is an explanation of how to change your working environment from Subversion to Git.
We are all going to migrate simultaneously on the 30th of June. Once we move over, you will not be able to use Subversion anymore,
and we will take down the Subversion repository.

---

## Steps

### Preparation:

  - Start with these **checks** (in the terminal):
     - Can you run git?
     - Do you have the basic git configuration?
     - Do you have an SSH key?
  - Next, visit the [evogit web page](https://evogit.evogene.internal/) and:
     - Login to create your account
     - Add your public SSH key to your profile

### The Move:
  - Return to the terminal for the final stage:
      - Move your Subversion working directory
      - Clone the git repository
      - Import or create your Unity config file
      - Transfer any files you are still working on
      - Start working with git!

---

## Preparation - Checks

---

### Can you run git?

Open a terminal and see if you can run the git command properly:

    git --version
    git version 1.7.3.4

    git help commit
    ...

---

### Do you have the basic git configuration?

See if you have this configuration file (I set this up for everyone using Subversion; if you don't have it, talk to [me](mailto:dotan@evogene.com)).

    $HOME/.gitconfig

It should look like this (except with *your* name and email):

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

You can also list and set your git configuration through the `git config` command:

    git config --list --global

The output should look like this:

    user.name=Dotan Dimet
    user.email=dotan@evogene.com
    color.diff=auto
    color.status=auto
    color.branch=auto
    core.preloadindex=true
    alias.lg=log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

---

### Do you have an SSH key?

Open a terminal.

First, check if you already have an ssh key:

    ls ~/.ssh

If you do, you'll see this:

    ls ~/.ssh/
    authorized_keys  id_rsa  id_rsa.pub  known_hosts ...

If you don't, you'll see this:

    ls ~/.ssh/
    known_hosts

---

If the file isn't there, **generate a new SSH key** with this command:

    ssh-keygen -t rsa -C "your_email"

This will generate 2 files in your ~/.ssh directory, a public/private rsa key pair.

View the content of the *public* key (**~/.ssh/id_rsa.pub**):

    cat ~/.ssh/id_rsa.pub
    # ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6eNtGpNGwstc....

Copy the output of that command to your clipboard and open your browser.

---

## Preparation - GitLab

In your browser, go to [evogit.evogene.internal](https://evogit.evogene.internal).

The web interface for our central git repository is an application called [GitLab](https://about.gitlab.com/).

![](gitlab_dashboard.png)

---

### Login

Login to GitLab with your Evogene password (the Unity password, not the Outlook one)

![](gitlab_login.png)

---

### Profile Page

You will be directed to your profile page
![](gitlab_profile.png)

---

### SSH Keys

Navigate to **SSH Keys** and choose **Add Key**

![](gitlab_ssh_keys.png)

---

### Add SSH Key

Paste the contents of your `~/.ssh/id_rsa.pub` file into the Key field.  
The Title field is just to identify it.

![](gitlab_ssh_key.png)


---

## Making The Switch

---

### Final Subversion Review

Make a list of modified files in your working directory:

    svn status $UNITY_ROOT

(Or save this to a file)

    svn status $UNITY_ROOT > work_in_progress.txt

Do this before the 30th!  
You will not be able to `svn ci` on the 30th!  
Check-in as many files as you can today!

---

### Move Old Working Directory

Open a terminal and ssh to boots or gm2.

    cd ~/work

Backup your old working directory:

    mv unity svn

(If your old working directory isn't in ~/work/unity, skip this - but remember to change your UNITY_ROOT in your `.tcshrc` file later)

---

### Create New Working Directory

Clone the git repository:

    git clone git@evogit:cg/unity.git

Output:

    Cloning into unity...
    remote: Counting objects: 192970, done.
    remote: Compressing objects: 100% (59806/59806), done.
    remote: Total 192970 (delta 136159), reused 185259 (delta 130302)
    Receiving objects: 100% (192970/192970), 673.44 MiB | 29.60 MiB/s, done.
    Resolving deltas: 100% (136159/136159), done.

This may take a while. It will create a new **~/work/unity** directory and populate it with the latest version
of the code.

---

### Make It Live

Create or copy a **Config/Site.pm** file in your new working directory:

    cp ~work/svn/lib/Config/Site/my_site.pm ~work/unity/lib/Config/Site/my_site.pm
    cd ~work/unity/lib/Config
    ln -s Site/my_site.pm Site.pm

---

### Import Work-In-Progress

Examine your old working directory (*svn*), and see if there is any uncommitted work you'd like
to keep:

    cd svn
    svn status
    ...

Copy the files you want to keep to your git working directory:

    cp lib/Foo.pm ../unity/lib/
    ...

**Remember not to copy directories!**

---

### First Commit

Return to your new working directory and commit your changes:

    cd ../unity
    git status # just to see what's new
    git add newfiles
    git commit -a -m 'created new Foo module'

---

See your commit added to your history:

    git lg

---

### Sidenote: Ignoring Files

The file **`~work/unity/.gitignore`** contains a list of file patterns that won't show up in `git status` listings and won't be added to the repository.
You can add any file patterns you want to ignore that aren't there to this file.
`.gitignore` is part of the project repository. Remember to commit any changes you make to it!

---

### Sharing Your Changes

Pull updates from the server:

    git pull --rebase origin master

---

**ONCE WE GO LIVE** Push your changes:

    git push origin master

**"Go Live"** means that:

   - The admin has given you permission to push to the unity project on the evogit server, which can only be done after you create an account
   - The elves have done some magic to push changes from evogit to all the Unity sites.

---

### Sidenote: Feature Branches

If you have a bunch of unrelated changes that are part of ongoing work on features (that is, if your working directory has diverged considerably from the shared repository),
consider creating **branches** and putting your sets of changed files into these branches. Look at the evogit presentation! Talk to me!

---
### Good Luck

- Dotan (= I, me, the admin, the elves).

