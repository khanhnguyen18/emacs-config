(setq inhibit-startup-message t) ;Not show initialize screen 

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(setq truncate-partial-width-windows 200) 
(menu-bar-mode -1)          ; Disable the menu bar 

(set-face-attribute 'default nil :font "Fira Code" :height 170)

;; Prevent undo tree files from polluting your git repo
(setq undo-tree-history-directory-alist  `((".*" . ,temporary-file-directory))) 

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Make ESC quit prompts
(defun open-emacs-config-file ()
  (interactive)
  (let ((split-width-threshold 0)
        (split-height-threshold nil))
    (find-file-other-window "~/.emacs.d/config.org"))
  (message "Open emacs config"))
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "<f12>")  'open-emacs-config-file)
(global-set-key (kbd "<f2>")  (lambda () (interactive) (message "Hello Khanh")))

(use-package doom-themes
  :init (load-theme 'doom-gruvbox-light t))

(defun color-for-doom-palenight ()
  (set-face-attribute 'default nil :background "black")
  (set-face-attribute 'org-table nil :foreground "#fff383")
  ;; Set color for KEYWORD
  (setq org-todo-keyword-faces
        '(("TODO"."red")
          ("PROCESSING".(:foreground "black" :background "#fff383"))
          ("DONE"."green")
          ))
  ;; Change color depend on LEVEL
  ;; (set-face-attribute 'org-level-2 nil :foreground "#fff383")
  (set-face-attribute 'org-level-3 nil :foreground "#fff383")
  ;; Done with strike out
  ;; (set-face-attribute 'org-headline-done nil :strike-through t)

  ;; Set color of link better
  (set-face-attribute 'org-link nil :foreground "systemBlueColor" :weight 'regular)

  (set-face-attribute 'bold nil :foreground "green1")
  (set-face-attribute 'italic nil :foreground  "SlateGray1")

  ;; Show asterisk correctly
  (set-face-attribute 'org-hide nil :foreground  "black")
  )

(defun color-for-doom-gruvbox ()
 (set-face-attribute 'org-table nil :foreground "DarkViolet")

  )

(defun efs/org-colors()
  ;; (color-for-doom-palenight)
  (color-for-doom-gruvbox)
  )

(defun dw/evil-hook ()
  (dolist (mode '(custom-mode
                  eshell-mode
                  git-rebase-mode
                  erc-mode
                  circe-server-mode
                  circe-chat-mode
                  circe-query-mode
                  sauron-mode
                  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(use-package undo-tree
  :init
  (global-undo-tree-mode 1))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)
  :config
  (add-hook 'evil-mode-hook 'dw/evil-hook)
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-c C-c") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :init
  (setq evil-collection-company-use-tng nil)  ;; Is this a bug in evil-collection?
  :custom
  (evil-collection-outline-bind-tab-p nil)
  :config
  (setq evil-collection-mode-list
        (remove 'lispy evil-collection-mode-list))
  (evil-collection-init))

(defun my-indent-org-block-automatically ()
  (interactive)
  (when (org-in-src-block-p)
    (org-edit-special)
    (indent-region (point-min) (point-max))
    (org-edit-src-exit)))



(defun efs/org-font-setup ()
  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 0.95)
                  (org-level-6 . 0.9)
                  (org-level-7 . 0.85)
                  (org-level-8 . 0.8)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

  )

(defun efs/org-mode-setup ()
  ;; (text-scale-set 2)
  (org-indent-mode)
  (variable-pitch-mode 1)
  (delete-selection-mode 1)
  (visual-line-mode 0))

(defun efs/org-mode-keys ()
  ;; Set C-i for indent code block
  (define-key org-mode-map (kbd "<f4>") #'my-indent-org-block-automatically)
  ;; Use space for next window
  ;;(define-key org-mode-map (kbd "SPC") (lambda () (interactive) (evil-window-next nil))) 
  ;; F5 to run source block    
  (define-key org-mode-map (kbd "<f5>") #'org-ctrl-c-ctrl-c))


(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config

  (setq org-ellipsis " ▾")
  (setq org-adapt-indentation t)
  (setq org-M-RET-may-split-line nil)
  (setq org-hide-emphasis-markers t)
  (setq org-todo-keywords '((sequence "TODO(t)" "PROCESSING(p)" "|" "DONE(d)")))

  (efs/org-font-setup)
  (efs/org-colors)
  (efs/org-mode-keys))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "☆" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 300
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(org-babel-do-load-languages
  'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)))

 (setq org-confirm-babel-evaluate nil)

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package general
:config
(general-evil-setup t)

(general-create-definer dw/leader-key-def
  :keymaps '(normal insert visual emacs)
  :prefix "SPC"
  :global-prefix "C-SPC")

(general-create-definer dw/ctrl-c-keys
  :prefix "C-c"))

(dw/leader-key-def
"t"  '(:ignore t :which-key "toggles")
"tw" 'whitespace-mode
"tt" '(counsel-load-theme :which-key "choose theme"))
