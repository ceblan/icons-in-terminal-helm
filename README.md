# icons-in-terminal-helm

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [icons-in-terminal-helm](#icons-in-terminal-helm)
    - [Screenshot](#screenshot)
    - [Pre-requisites](#pre-requisites)
    - [Install](#install)

<!-- markdown-toc end -->

Show icons in helm-buffers-list, helm-find-files, and helm-recentf for Emacs **in terminal** (emacs -nw) 😎

If you use Emacs GUI you should refer to <a href="https://github.com/yyoncho/helm-treemacs-icons">*helm-treemacs-icons*</a>

## Screenshot

**M-x helm-find-files**
![helm-ffiles](https://user-images.githubusercontent.com/236042/80796550-7a58e900-8bda-11ea-9e57-03dce8dd01a3.png)

**M-x helm-recentf**
![helm-recentf](https://user-images.githubusercontent.com/236042/80796553-7c22ac80-8bda-11ea-9b63-9c47bfae0bb9.png)

**M-x helm-buffers-list**
![helm-buffers](https://user-images.githubusercontent.com/236042/80796554-7cbb4300-8bda-11ea-8ce7-c54de00f2f7f.png)

cf) The line at the very bottom is not part of Emacs. It is *tmux* status bar 😉


## Pre-requisites

1. A font from  <a href="https://github.com/sebastiencs/icons-in-terminal">icons-in-terminal</a> which unifies many useful fonts. Follow the instruction found there.
2. An <a href="https://github.com/seagle0128/icons-in-terminal.el">icons-in-terminal.el</a> package.
  Put the elisp files in a directory where load-path locates


## Install

Put the elisp files of this project into a directory where load-path indicates. And add few lines of elisp code to your init.el

```emacs-lisp
(add-to-list 'load-path "<YOUR_PATH>/icons-in-terminal-helm")
(require 'icons-in-terminal-helm)
(icons-in-terminal-helm-enable)

;; Add key bindings for helm functions if you wish 😄
(global-set-key (kbd "C-x C-r") #'helm-recentf)
(global-set-key (kbd "C-x b") #'helm-buffers-list)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
```

Enjoy it! 😀
