;;=============================================================================
;;                       ADOLPH VOGEL'S EMACS SETUP
;;=============================================================================

;; -------------------[ Basic User Interface Settings ]------------------------
(setq-default frame-title-format '("%b (%f)"))
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)
(electric-pair-mode 1)
(global-display-line-numbers-mode)
(global-hl-line-mode +1)
(set-fringe-mode 16)
(column-number-mode)

(setq scroll-margin 5
scroll-conservatively 1000)

;;----------------------[ Setup Package Configuration ]------------------------
(require 'package)

;; ELPA is the official Emacs repository, we should prefer it over MELPA if 
;; possible.
(setq package-archives '(
                            ("melpa-stable" . "https://stable.melpa.org/packages/")
                            ("melpa" . "https://melpa.org/packages/")
                            ("org" . "https://orgmode.org/elpa/")
                            ("elpa" . "https://elpa.gnu.org/packages/")))


(require 'use-package)

; This slows down things a lot, only needed when we start from scratch.

;(setq use-package-always-ensure t) ; Has this in the other one, not sure what?


;;----------------------------[ DooM Themes ]----------------------------------
(use-package doom-themes
    :ensure t
    :config 
        (setq 
            doom-themes-enabled-bold t
            doom-themes-enabled-italic t)

        (load-theme 'doom-one t)
        ;; Corrects (and improves) org-mode's native fontification.
        (doom-themes-org-config)
)


(use-package doom-modeline
    :ensure t
    :init (doom-modeline-mode 1)
    :custom ((doom-modeline-height 15)))

(use-package dashboard
  :ensure t
  :config
  (setq dashboard-center-content t)
  (setq dashboard-banner-logo-title "WELCOME BACK, COMMANDER")
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-startup-banner "~/.emacs.d/emacs.png")
  (setq dashboard-items '((recents  . 5)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 5)))  
  (dashboard-setup-startup-hook)
  )

;;----------------------------------[ Ivy Mode ]-------------------------------
;; Let's the completion and stuff happen in the middle of the screen.
(use-package swiper)
(use-package ivy
    :diminish
    :bind (("C-s" . swiper))
    :config
        (ivy-mode 1))

(use-package ivy-posframe
    :config
    (ivy-posframe-mode 1))

;;--------------------------------[ Projectile ]-------------------------------
(use-package projectile
  :diminish projectile-mode ;; Think this makes things not show in mode-line
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map))


;;----------------------------------[ Python ]---------------------------------
(use-package python
  :config
  ;; Remove guess indent python message
  (setq python-indent-guess-indent-offset-verbose nil))

(use-package company
  :ensure t
  :defer t
  :custom
  ;; Search other buffers with the same modes for completion instead of
  ;; searching all other buffers.
  (company-dabbrev-other-buffers t)
  (company-dabbrev-code-other-buffers t)
  ;; M-<num> to select an option according to its number.
  (company-show-numbers t)
  ;; Only 2 letters required for completion to activate.
  (company-minimum-prefix-length 3)
  ;; Do not downcase completions by default.
  (company-dabbrev-downcase nil)
  ;; Even if I write something with the wrong case,
  ;; provide the correct casing.
  (company-dabbrev-ignore-case t)
  ;; company completion wait
  (company-idle-delay 0.2)
  ;; No company-mode in shell & eshell
  (company-global-modes '(not eshell-mode shell-mode))
  ;; Use company with text and programming modes.
    :hook ((text-mode . company-mode)
           (prog-mode . company-mode)))

;; Supposedly, makes company look a little nicer.
(use-package company-box
  :hook (company-mode . company-box-mode))


;; LSP MODE START
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . ajv-lsp-mode-hook)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

; Seems to work the best so far...
;; NEED: to do "npm install -g pyright"
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
			 (require 'lsp-pyright)
			 (lsp-deferred))))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-ivy
  :after lsp)

;; LSP mode stop ---



;; (use-package eglot
;;   :ensure t
;;   :defer t
;;   :hook (python-mode . eglot-ensure))

(use-package pipenv
  :hook (python-mode . pipenv-mode)
  :init
  (
   setq pipenv-projectile-after-switch-function #'pipenv-projectile-after-switch-extended))

(use-package rainbow-delimiters
  :after python-mode
  :hook (python-mode . rainbow-delimiters-mode))

(use-package indent-guide
  :after python-mode
  :hook (python-mode . indent-guide-mode))

(use-package python-cell
  :after python-mode
  :hook (python-mode . python-cell-mode))

(add-hook 'python-mode-hook
	  (lambda ()
	    ;; (hs-minor-mode)
	    (outline-minor-mode)
	    (local-set-key (kbd "C-.") 'python-indent-shift-right)
	    (local-set-key (kbd "C-,") 'python-indent-shift-left)
	    (local-set-key (kbd "M-n") 'python-cell-forward-cell)
	    (local-set-key (kbd "M-p") 'python-cell-backward-cell)
	    (local-set-key (kbd "C--") 'outline-hide-subtree)
	    (local-set-key (kbd "C-=") 'outline-show-subtree)	    
	    (setq python-shell-interpreter "ipython" python-shell-interpreter-args "--simple-prompt -i")
	    (local-set-key (kbd "C-c i") 'run-python) ;; Python Shell
	    (setq-default py-split-windows-on-execute-function 'split-window-horizontally)
	    (rainbow-delimiters-mode)
	    (python-cell-mode)
	    (indent-guide-mode)
	    ))


(use-package fira-code-mode
  :custom (fira-code-mode-disabled-ligatures '("[]" "x"))  ; ligatures you don't want
  :hook prog-mode) 

;;---------------------------[ Custom Set Variables ]--------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(company-show-quick-access t nil nil "Customized with use-package company")
 '(cursor-type 'bar)
 '(global-display-line-numbers-mode t)
 '(ispell-dictionary nil)
 '(package-selected-packages '(fira-code-mode all-the-icons use-package))
 '(py-shell-name "ipython3")
 '(python-cell-highlight-cell nil)
 '(tool-bar-mode nil)
 '(warning-suppress-types
   '((use-package)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Fira Code" :foundry "CTDB" :slant normal :weight normal :height 98 :width normal)))))
