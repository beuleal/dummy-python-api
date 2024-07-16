# Github setup

In case you have multiples Github accounts and you need to use different keys:

1. Create the key for the new account

```txt
╭─    ~/.ssh ──────────────────────────────────────────────── ✔  09:27:04 
╰─ ssh-keygen -t ed25519 -C "beuleal@gmail.com"

╭─    ~/.ssh ──────────────────────────────────────── ✔  33s   09:27:49 
╰─ ls
github-beuleal github-beuleal.pub ...

╭─    ~/.ssh ──────────────────────────────────────────────── ✔  09:28:50 
╰─ ssh-add --apple-use-keychain ~/.ssh/github-beuleal
Identity added: /Users/brenno/.ssh/github-beuleal ...

╭─    ~/.ssh ──────────────────────────────────────────────── ✔  09:29:24 
╰─ cat github-beuleal.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICkCkoyT...
```

2. To manage 2 accounts, upate the ~/.ssh/config file:

```txt
Host github-beuleal
  Hostname github.com
  User beuleal
  AddKeysToAgent yes
  IdentityFile ~/.ssh/github-beuleal

Host github.com
  Hostname github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/<another-key>
```

3. In your repository, update the `origin`:

```txt
╭─    ~/Personal Workspace/dummy-python-api    main ⇣1⇡1 ────────────────────────────────── ✘  09:48:55 
╰─ git remote remove origin

╭─    ~/Personal Workspace/dummy-python-api    main ─────────────────────────────────────── ✔  09:49:09 
╰─ git remote add origin git@github-beuleal:beuleal/dummy-python-api.git
```

Done!
