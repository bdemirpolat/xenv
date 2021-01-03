# xenv

## Download
DMG file can be downloaded [here](https://github.com/bdemirpolat/xenv/raw/main/xenv-Installer.dmg)

## How it works?

This app creates a new profile on current user's your home directory. All variables created from this app located in
this file.
<br>For example:
```/Users/john/.xenv_profile``` or ```$HOME/.xenv_profile```

## Important
<b>This installation step is done only one time.</b><br>
To use this application, you need reference ```.xenv_profile``` to your current shell profile.

- Open current shell profile.
    - For zsh: ```/Users/john/.zprofile ``` or ```$HOME/.zprofile```
    - For bash: ```/Users/john/.bash_profile``` or ```$HOME/.bash_profile```
    

- Add line below and save.<br>
  ```source /Users/john/.xenv_profile``` or ```source $HOME/.xenv_profile```
