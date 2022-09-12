;; remove the startup page

(setq inhibit-startup-message t)

;;;;; my own confis to remove menu bar , scroll bar and tool bar
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode 1)

;; enable beacon mode
(beacon-mode 1)



;;;; Make emacs transparent

;;;;(set-frame-parameter (selected-frame) 'alpha '(93 93))

;; ;;;; fonts and stuff

(defvar runemacs/default-font-size 160)

(set-face-attribute 'default nil :font "Hack" :height runemacs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Hack" :height 150)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 120 :weight 'regular)



;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))


;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


;; use the ivy package

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))


(use-package swiper :ensure t)


(use-package php-mode :ensure t)

;; use doom-modeline thingy

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
;;  :custom ((doom-modeline-height 25))
  )

;; all the icons for the icons 
(use-package all-the-icons
  :ensure t)



;; spacemacs theme

(use-package ewal-spacemacs-themes
  :ensure t)

;; other themes

(use-package intellij-theme)
;;(use-package kaolin-themes)

;; doom emacs themes
(use-package doom-themes
  :ensure t
  :config

  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled
 (load-theme 'doom-molokai t)
  
)
  ;; Enable flashing mode-line on errors
  ;;(doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;;(doom-themes-neotree-config)
  ;; or for treemacs users
  ;;(setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;;(doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  ;;(doom-themes-org-config)


;;(use-package rainbow-delimiters
;;  :hook (prog-mode , rainbow-delimiters-mode ))

;; which key mode
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; ivy rich mode
(use-package ivy-rich
 :init (ivy-rich-mode 1))

;; properly setting up counsel

(use-package counsel
  :bind (("M-x" . counsel-M-x)
;;       	 ("C-x b" . counsel-ibuffer)
       	 ("C-x b" . counsel-switch-buffer)
       	 ("C-x v" . counsel-describe-variable)
       	 ("C-x f" . counsel-describe-function)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	  ("C-r" . 'counsel-minibuffer-history)))

;; Evil Mode configuration

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil) ;; initiall nil
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil) ;; initially nil
;;  (setq evil-respect-visual-line-mode t)
  :config
  (evil-set-undo-system 'undo-tree) 
  (evil-mode 1)  
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
;; yay goddamit , it is vim now . finally , i am back home .
;; das ist sehr gut damn vim ist uber alles editors 
;; now for evil collection

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; undo tree to make C-r in evil mode redo
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode 1))


;; auto complete and stuff
(use-package auto-complete
  :ensure t
;;  :config
;;  (require 'auto-complete-config)
;;;   (ac-config-default)
  )


;; company mode



(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
	:custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.1))

(use-package company-box
  :hook (company-mode . company-box-mode))




;;;;;;; yasnepet

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  )

;; for LaTeX


;; (use-package auctex
;;   :ensure t
;;   :defer t
;;   :hook (LaTeX-mode .
;; 		    (lambda ()
;; 		      (push (list 'output-pdf "Zathura")
;; 			    TeX-view-program-selection))))

;;;;;; for org

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))



(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Hack" :weight 'regular :height (cdr face)))



  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))



(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (efs/org-font-setup))


(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  ;; :custom
  ;;  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●"))
  )

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

;;;;; Org reveal for slideshow presentations

(use-package ox-reveal
  :ensure t)

;; virtual terminal
(use-package vterm
  :ensure t)

(use-package beacon)

;; neotree to flex on vim users
(use-package neotree
  :ensure t)


;; helpful because system crafters said it was cool
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; rainbow delimiters


(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


(use-package markdown-mode 
  :ensure t)

;; for opening a web server at a spesefic directory because it is easier for me to make websites
;; and also because i am too lazy to configure apache and stuff
(use-package simple-httpd
  :ensure t)

;;lsp mode

(defun lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

;; lsp ui

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))


;; lsp treemacs
(use-package lsp-treemacs
  :ensure t
  :after lsp)

;; lsp ivy
(use-package lsp-ivy
  :ensure t)


;; projectile

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; ;; NOTE: Set this to the folder where you keep your Git repos!
  ;; (when (file-directory-p "~/Projects/Code")
  ;;   (setq projectile-project-search-path '("~/Projects/Code")))
  ;; (setq projectile-switch-project-action #'projectile-dired)
)

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package web-mode
  :ensure t)


;; fot javascript and typescript
(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))





;;; rust setup

(use-package flycheck
  :ensure t)

(use-package flycheck-rust
  :ensure t)

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  ;;(add-hook 'rustic-mode-hook 'rk/rustic-mode-hook)
  )

;; (defun rk/rustic-mode-hook ()
;;   ;; so that run C-c C-c C-r works without having to confirm, but don't try to
;;   ;; save rust buffers that are not file visiting. Once
;;   ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
;;   ;; no longer be necessary.
;;   (when buffer-file-name
;;     (setq-local buffer-save-without-query t)))


;; user defined functions (starts with my-)

;; to get the ide layout like vscode with neotree and stuff

;; (defun my-ide()
;;   "Get a modern IDE layout"
;;   (evil-window-split)
;;   (evil-window-down 1)
;;   (evil-window-decrease-height 10)
;;   (vterm)
;;   (neotree)
;;   (evil-window-right 1)
;;   )


 (org-babel-do-load-languages
  'org-babel-load-languages '((C . t)))


;; custom keybindings


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("d516f1e3e5504c26b1123caa311476dc66d26d379539d12f9f4ed51f10629df3" "6128465c3d56c2630732d98a3d1c2438c76a2f296f3c795ebda534d62bb8a0e3" "3c7a784b90f7abebb213869a21e84da462c26a1fda7e5bd0ffebf6ba12dbd041" "9cd57dd6d61cdf4f6aef3102c4cc2cfc04f5884d4f40b2c90a866c9b6267f2b3" "f00a605fb19cb258ad7e0d99c007f226f24d767d01bf31f3828ce6688cbdeb22" "249e100de137f516d56bcf2e98c1e3f9e1e8a6dce50726c974fa6838fbfcec6b" "e266d44fa3b75406394b979a3addc9b7f202348099cfde69e74ee6432f781336" "353ffc8e6b53a91ac87b7e86bebc6796877a0b76ddfc15793e4d7880976132ae" "da53441eb1a2a6c50217ee685a850c259e9974a8fa60e899d393040b4b8cc922" "4f1d2476c290eaa5d9ab9d13b60f2c0f1c8fa7703596fa91b235db7f99a9441b" "cf922a7a5c514fad79c483048257c5d8f242b21987af0db813d3f0b138dfaf53" "d916b686ba9f23a46ee9620c967f6039ca4ea0e682c1b9219450acee80e10e40" "fe2539ccf78f28c519541e37dc77115c6c7c2efcec18b970b16e4a4d2cd9891d" "41098e2f8fa67dc51bbe89cce4fb7109f53a164e3a92356964c72f76d068587e" "ba72dfc6bb260a9d8609136b9166e04ad0292b9760a3e2431cf0cd0679f83c3a" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "850bb46cc41d8a28669f78b98db04a46053eca663db71a001b40288a9b36796c" "1278c5f263cdb064b5c86ab7aa0a76552082cf0189acf6df17269219ba496053" "6f4421bf31387397f6710b6f6381c448d1a71944d9e9da4e0057b3fe5d6f2fad" "1bddd01e6851f5c4336f7d16c56934513d41cc3d0233863760d1798e74809b4b" "4a5aa2ccb3fa837f322276c060ea8a3d10181fecbd1b74cb97df8e191b214313" "4699e3a86b1863bbc695236036158d175a81f0f3ea504e2b7c71f8f7025e19e3" "e19ac4ef0f028f503b1ccafa7c337021834ce0d1a2bca03fcebc1ef635776bea" "5f19cb23200e0ac301d42b880641128833067d341d22344806cdad48e6ec62f6" "1d44ec8ec6ec6e6be32f2f73edf398620bb721afeed50f75df6b12ccff0fbb15" "c2aeb1bd4aa80f1e4f95746bda040aafb78b1808de07d340007ba898efa484f5" "246a9596178bb806c5f41e5b571546bb6e0f4bd41a9da0df5dfbca7ec6e2250c" "c4063322b5011829f7fdd7509979b5823e8eea2abf1fe5572ec4b7af1dd78519" "745d03d647c4b118f671c49214420639cb3af7152e81f132478ed1c649d4597d" "c5ded9320a346146bbc2ead692f0c63be512747963257f18cc8518c5254b7bf5" "4b6b6b0a44a40f3586f0f641c25340718c7c626cbf163a78b5a399fbe0226659" "8146edab0de2007a99a2361041015331af706e7907de9d6a330a3493a541e5a6" "6c531d6c3dbc344045af7829a3a20a09929e6c41d7a7278963f7d3215139f6a7" "6c98bc9f39e8f8fd6da5b9c74a624cbb3782b4be8abae8fd84cbc43053d7c175" "8d7b028e7b7843ae00498f68fad28f3c6258eda0650fe7e17bfb017d51d0e2a2" "97db542a8a1731ef44b60bc97406c1eb7ed4528b0d7296997cbb53969df852d6" "1704976a1797342a1b4ea7a75bdbb3be1569f4619134341bd5a4c1cfb16abad4" "613aedadd3b9e2554f39afe760708fc3285bf594f6447822dd29f947f0775d6c" "0466adb5554ea3055d0353d363832446cd8be7b799c39839f387abb631ea0995" "835868dcd17131ba8b9619d14c67c127aa18b90a82438c8613586331129dda63" "23c806e34594a583ea5bbf5adf9a964afe4f28b4467d28777bcba0d35aa0872e" "cbdf8c2e1b2b5c15b34ddb5063f1b21514c7169ff20e081d39cf57ffee89bc1e" "76ed126dd3c3b653601ec8447f28d8e71a59be07d010cd96c55794c3008df4d7" "d268b67e0935b9ebc427cad88ded41e875abfcc27abd409726a92e55459e0d01" "f91395598d4cb3e2ae6a2db8527ceb83fed79dbaf007f435de3e91e5bda485fb" "028c226411a386abc7f7a0fba1a2ebfae5fe69e2a816f54898df41a6a3412bb5" "da186cce19b5aed3f6a2316845583dbee76aea9255ea0da857d1c058ff003546" "a9a67b318b7417adbedaab02f05fa679973e9718d9d26075c6235b1f0db703c8" "266ecb1511fa3513ed7992e6cd461756a895dcc5fef2d378f165fed1c894a78c" "d47f868fd34613bd1fc11721fe055f26fd163426a299d45ce69bef1f109e1e71" "1f1b545575c81b967879a5dddc878783e6ebcca764e4916a270f9474215289e5" "b5803dfb0e4b6b71f309606587dd88651efe0972a5be16ece6a958b197caeed8" "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" "d6844d1e698d76ef048a53cefe713dbbe3af43a1362de81cdd3aefa3711eae0d" "f6665ce2f7f56c5ed5d91ed5e7f6acb66ce44d0ef4acfaa3a42c7cfe9e9a9013" "7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae" "47db50ff66e35d3a440485357fb6acb767c100e135ccdf459060407f8baea7b2" default))
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(mnimap flycheck-rust kaolin-themes intellij-theme ewal-spacemacs-themes ewal-spacemax-themes beacon beacon-mode flycheck rustic rust-mode phps-mode simple-httpd typescript-mode web-mode counsel-projectile projectile company-box company helpful markdown-mode lsp-treemacs lsp-mode mastodon neotree vterm ox-reveal auctex undo-tree yasnippet org-mode doom-themes evil-collection evil counsel ivy-rich which-key rainbow-delimiters ranbow-delimeters doom-modeline swiper use-package ivy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; to make sure line number is not displayed everywhere
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
		vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))
;; setup relative line number mode

(menu-bar--display-line-numbers-mode-relative)


