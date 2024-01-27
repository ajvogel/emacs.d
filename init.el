;;=============================================================================
;;                       ADOLPH VOGEL'S EMACS SETUP
;;=============================================================================


(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


;; -------------------[ Basic User Interface Settings ]------------------------
(setq-default frame-title-format '("%b (%f)"))
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(delete-selection-mode 1)
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-screen t)
(electric-pair-mode 1)
(global-display-line-numbers-mode)
(global-hl-line-mode +1)
(set-fringe-mode 16)
(column-number-mode)
;;(global-git-gutter-mode +1)
(setq-default cursor-type 'bar) 
(setq scroll-margin 5
scroll-conservatively 1000)

(global-set-key (kbd "C-c C-c") 'recompile)

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

(setq use-package-always-ensure t) ; Has this in the other one, not sure what?


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

;; --> Markdown
;; https://www.reddit.com/r/emacs/comments/10h9jf0/beautify_markdown_on_emacs/
(use-package markdown-mode
  :hook
  (markdown-mode . nb/markdown-unhighlight)
  (markdown-mode . flycheck-mode)
  (markdown-mode . visual-line-mode)
  :config
  (defvar nb/current-line '(0 . 0)
    "(start . end) of current line in current buffer")
  (make-variable-buffer-local 'nb/current-line)

  (defun nb/unhide-current-line (limit)
    "Font-lock function"
    (let ((start (max (point) (car nb/current-line)))
          (end (min limit (cdr nb/current-line))))
      (when (< start end)
        (remove-text-properties start end
                                '(invisible t display "" composition ""))
        (goto-char limit)
        t)))

  (defun nb/refontify-on-linemove ()
    "Post-command-hook"
    (let* ((start (line-beginning-position))
           (end (line-beginning-position 2))
           (needs-update (not (equal start (car nb/current-line)))))
      (setq nb/current-line (cons start end))
      (when needs-update
        (font-lock-fontify-block 3))))

  (defun nb/markdown-unhighlight ()
    "Enable markdown concealling"
    (interactive)
    (markdown-toggle-markup-hiding 'toggle)
    (font-lock-add-keywords nil '((nb/unhide-current-line)) t)
    (add-hook 'post-command-hook #'nb/refontify-on-linemove nil t))
  :custom-face
  (markdown-header-delimiter-face ((t (:foreground "#616161" :height 0.9))))
  (markdown-header-face-1 ((t (:height 1.6  :foreground "#A3BE8C" :weight extra-bold :inherit markdown-header-face))))
  (markdown-header-face-2 ((t (:height 1.4  :foreground "#EBCB8B" :weight extra-bold :inherit markdown-header-face))))
  (markdown-header-face-3 ((t (:height 1.2  :foreground "#D08770" :weight extra-bold :inherit markdown-header-face))))
  (markdown-header-face-4 ((t (:height 1.15 :foreground "#BF616A" :weight bold :inherit markdown-header-face))))
  (markdown-header-face-5 ((t (:height 1.1  :foreground "#b48ead" :weight bold :inherit markdown-header-face))))
  (markdown-header-face-6 ((t (:height 1.05 :foreground "#5e81ac" :weight semi-bold :inherit markdown-header-face)))))


(use-package flycheck-posframe
  :ensure t
  :after flycheck
  :config (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode))

(use-package flycheck-vale)
(flycheck-vale-setup)
(setq-default flycheck-indication-mode 'left-margin)
(add-hook 'flycheck-mode-hook #'flycheck-set-indication-mode)

;; (straight-use-package
;;  '(flymake-vale :type git :host github :repo "tpeacock19/flymake-vale"))
;; (add-hook 'markdown-mode-hook #'flymake-vale-load)
;; (add-hook 'find-file-hook 'flymake-vale-maybe-load)
;; flymake-vale-modes defaults to: 
;;  => (text-mode latex-mode org-mode markdown-mode message-mode)

;; (add-to-list 'flymake-vale-modes 'markdown-mode)
;; (add-to-list 'load-path "~/.emacs.d/flymake-vale")
;; (add-hook 'markdown-mode-hook #'flymake-vale-load)

;; (add-hook 'markdown-mode-hook #'eglot-ensure)
;; (with-eval-after-load 'eglot
;;   (add-to-list 'eglot-server-programs '((markdown-mode) "efm-langserver")))

;; (add-to-list 'eglot-server-programs '(markdown-mode "efm-langserver"))


;; (add-to-list 'eglot-server-programs '((org-mode) "efm-langserver"))

;;-----------------------------------[ Magit ]---------------------------------
(use-package magit)

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

;;----------------------------------[ Org Mode ]-------------------------------

;; (use-package org-superstar
;;   :after org-mode)

;; (defun ajv-org-mode-hook ()
;;   (org-indent-mode t)
;;   (visual-line-mode t)
;;   (org-superstar-mode t)
;;   (setq org-hide-emphasis-markers t)
;;   (set-face-attribute 'org-level-8 nil :inherit 'default)
;;   (set-face-attribute 'org-level-7 nil :inherit 'org-level-8)
;;   (set-face-attribute 'org-level-6 nil :inherit 'org-level-8)
;;   (set-face-attribute 'org-level-5 nil :inherit 'org-level-8)
;;   (set-face-attribute 'org-level-4 nil :inherit 'org-level-8)
;;   ;; Scaling top headings
;;   (set-face-attribute 'org-level-3 nil :inherit 'org-level-8 :height 1.0)
;;   (set-face-attribute 'org-level-2 nil :inherit 'org-level-8 :height 1.1)
;;   (set-face-attribute 'org-level-1 nil :inherit 'org-level-8 :height 1.21)

;;   (set-face-attribute 'org-document-title nil
;;                     :height 2.0
;;                     :foreground 'unspecified
;;                     :inherit 'org-level-8)  
  
;;   )

;; (add-hook 'org-mode-hook (lambda ()(ajv-org-mode-hook)))


;;------------------------------------[ SQL ]----------------------------------
(defvar ajsql-constants
  '(
    "OVER"
    "ROW_NUMBER"
    "CAST"
    "COALESCE"
    "DATEADD"
    "FORMAT"
    "SUBSTRING"
    "CHARINDEX"
    "GETDATE"
    "COUNT"
    "VARCHAR"
    "GREATEST"
    "NULL"
    "ISNULL"))


(defvar ajsql-keywords
  '("SELECT"
    "ASC"
    "AND"
    "PARTITION"
    "TABLE"
    "IN"
    "BETWEEN"
    "DESC"
    "DROP"
    "VALUES"
    "GROUP"
    "FULL"
    "OUTER"
    "RIGHT"
    "INSERT"
    "TOP"
    "UNION"
    "UPDATE"
    "MERGE"
    "WITH"
    "END"
    "ELSE"
    "HAVING"
    "CASE"
    "DISTINCT"
    "GO"
    "LEFT"
    "JOIN"
    "THEN"
    "WHEN"
    "AS"
    "GO"
    "IS"
    "NOT"
    "CREATE"
    "VIEW"
    "FROM"
    "ORDER"
    "ON"
    "BY"
    "WHERE"))

(defvar ajsql-font-lock-defaults
  `((

     ;; ("font-lock-warning-face" . font-lock-warning-face) **/
     ;; ("font-lock-function-name-face" . font-lock-function-name-face) **/
     ;; ("font-lock-function-call-face" . font-lock-function-call-face) **/
     ;; ("font-lock-variable-name-face" . font-lock-variable-name-face) **/
     ;; ("font-lock-variable-use-face" . font-lock-variable-use-face) **/
     ;; ("font-lock-keyword-face" . font-lock-keyword-face) **/
     ;; ("font-lock-comment-face" . font-lock-comment-face) **/
     ;; ("font-lock-comment-delimiter-face" . font-lock-comment-delimiter-face) **/
     ;; ("font-lock-type-face" . font-lock-type-face) **/
     ;; ("font-lock-constant-face" . font-lock-constant-face) **/
     ;; ("font-lock-builtin-face" . font-lock-builtin-face) **/
     ;; ("font-lock-preprocessor-face" . font-lock-preprocessor-face) **/
     ;; ("font-lock-string-face" . font-lock-string-face) **/
     ;; ("font-lock-doc-face" . font-lock-doc-face) **/
     ;; ("font-lock-doc-markup-face" . font-lock-doc-markup-face) **/
     ;; ("font-lock-negation-char-face" . font-lock-negation-char-face) **/
     ;; ("font-lock-escape-face" . font-lock-escape-face) **/
     ;; ("font-lock-number-face" . font-lock-number-face) **/
     ;; ("font-lock-operator-face" . font-lock-operator-face) **/
     ;; ("font-lock-property-name-face" . font-lock-property-name-face) **/
     ;; ("font-lock-property-use-face" . font-lock-property-use-face) **/
     ;; ("font-lock-punctuation-face" . font-lock-punctuation-face) **/
     ;; ("font-lock-bracket-face" . font-lock-bracket-face) **/
     ;; ("font-lock-delimiter-face" . font-lock-delimiter-face) **/
     ;; ("font-lock-misc-punctuation-face" . font-lock-misc-punctuation-face) **/


     ("--.*" . font-lock-comment-face)
     ("\"\\.\\*\\?" . font-lock-string-face)
     ("\'\\.\\*\\?" . font-lock-string-face)
     ("\\[.+?\\]" . font-lock-type-face)
     ("'.*?'" . font-lock-string-face)

     ;;(":\\|,\\|;\\|{\\|}\\|=>\\|@\\|$\\|=" . font-lock-keyword-face)
     ( ,(regexp-opt ajsql-keywords 'words) . font-lock-keyword-face)
     ( ,(regexp-opt ajsql-constants 'words) . font-lock-function-name-face)
     )))

(define-derived-mode ajsql-mode prog-mode "SQL(ajv)"
  "MYDSL mode is a major mode for editing MYDSL files"
  ;; you again used quote when you had '((mydsl-hilite))
  ;; I just updated the variable to have the proper nesting (as noted above)
  ;; and use the value directly here
  (setq font-lock-defaults ajsql-font-lock-defaults)
  
  ;; when there's an override, use it
  ;; otherwise it gets the default value
  (setq tab-width 4)
  ;; (when ajsql-tab-width
  ;;   (setq tab-width ajsql-tab-width))
  
  ;; for comments
  ;; overriding these vars gets you what (I think) you want
  ;; they're made buffer local when you set them
  (setq comment-start "--")
  (setq comment-end "")
  
  ;; (modify-syntax-entry ?# "< b" ajsql-mode-syntax-table)
  ;; (modify-syntax-entry ?\n "> b" ajsql-mode-syntax-table)
  
  ;; Note that there's no need to manually call `mydsl-mode-hook'; `define-derived-mode'
  ;; will define `mydsl-mode' to call it properly right before it exits
  )

(provide 'ajsql-mode)


(setq indy-rules '(
                   (ajsql-mode . (
                                  ((indy--prev 'indy--ends-on "FROM") (indy--prev-tab 1))
                                  ((indy--prev 'indy--ends-on "SELECT") (indy--prev-tab 1))
                                  ((indy--prev 'indy--ends-on "WHERE") (indy--prev-tab 1))
                                  ((indy--current 'indy--ends-on "FROM") (indy--prev-tab -2))
                                  ))
))



;;----------------------------------[ Python ]---------------------------------
(use-package python
  :config
  ;; Remove guess indent python message
  (setq python-indent-guess-indent-offset-verbose nil))


(add-hook 'python-mode-hook
          (lambda ()
            (define-key python-mode-map "\r" 'newline-and-indent)
            (lsp-bridge-mode)))

;; LSP-BRIDGE

(add-to-list 'load-path "~/.emacs.d/lsp-bridge/")
(use-package yasnippet)

(yas-global-mode 1)
(require 'lsp-bridge)
;(global-lsp-bridge-mode)

(setq lsp-bridge-enable-hover-diagnostic t)
(setq lsp-bridge-signature-show-function 'lsp-bridge-signature-posframe)



;; (use-package company
;;   :ensure t
;;   :defer t
;;   :custom
;;   ;; Search other buffers with the same modes for completion instead of
;;   ;; searching all other buffers.
;;   (company-dabbrev-other-buffers t)
;;   (company-dabbrev-code-other-buffers t)
;;   ;; M-<num> to select an option according to its number.
;;   (company-show-numbers t)
;;   ;; Only 2 letters required for completion to activate.
;;   (company-minimum-prefix-length 3)
;;   ;; Do not downcase completions by default.
;;   (company-dabbrev-downcase nil)
;;   ;; Even if I write something with the wrong case,
;;   ;; provide the correct casing.
;;   (company-dabbrev-ignore-case t)
;;   ;; company completion wait
;;   (company-idle-delay 0.2)
;;   ;; No company-mode in shell & eshell
;;   (company-global-modes '(not eshell-mode shell-mode))
;;   ;; Use company with text and programming modes.
;;     :hook ((text-mode . company-mode)
;;            (prog-mode . company-mode)))

;; Supposedly, makes company look a little nicer.
;; (use-package company-box
;;   :hook (company-mode . company-box-mode))


;; ;; LSP MODE START
;; (use-package lsp-mode
;;   :commands (lsp lsp-deferred)
;;   :hook (lsp-mode . ajv-lsp-mode-hook)
;;   :init
;;   (setq lsp-keymap-prefix "C-c l")
;;   :config
;;   (lsp-enable-which-key-integration t))

;; ; Seems to work the best so far...
;; ;; NEED: to do "npm install -g pyright"
;; (use-package lsp-pyright
;;   :ensure t
;;   :hook (python-mode . (lambda ()
;; 			 (require 'lsp-pyright)
;; 			 (lsp-deferred))))

;; (use-package lsp-ui
;;   :hook (lsp-mode . lsp-ui-mode)
;;   :custom
;;   (lsp-ui-doc-position 'bottom))

;; (use-package lsp-ivy
;;   :after lsp)

;; LSP mode stop ---



;; (use-package eglot
;;   :ensure t
;;   :defer t
;;   :hook (python-mode . eglot-ensure))




;; (use-package pipenv
;;   :hook (python-mode . pipenv-mode)
;;   :init
;;   (
;;    setq pipenv-projectile-after-switch-function #'pipenv-projectile-after-switch-extended))

(use-package highlight-indent-guides)

(use-package poetry
  :ensure t)

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
	    (highlight-indent-guides-mode)
	    (defalias 'insert-python-cell
	      (kmacro "C-e <return> <return> # # SPC C e l l . . . <return> <return>"))
	    (local-set-key (kbd "M-RET") 'insert-python-cell)
	    
	    ))


;; Enable the www ligature in every possible major mode
;(ligature-set-ligatures 't '("www"))

;; Enable ligatures in programming modes
;; (use-package ligature)

;; (ligature-set-ligatures 'prog-mode '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
;;                                      ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
;;                                      "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
;;                                      "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
;;                                      "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
;;                                      "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
;;                                      "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
;;                                      "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
;;                                      "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
;;                                      "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))

;; (global-ligature-mode 't)



(use-package fira-code-mode
  :custom (fira-code-mode-disabled-ligatures '("[]" "x", "and"))  ; ligatures you don't want
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
 '(fira-code-mode-disabled-ligatures '("and" "or"))
 '(global-display-line-numbers-mode t)
 '(highlight-indent-guides-bitmap-function 'highlight-indent-guides--bitmap-line)
 '(highlight-indent-guides-method 'bitmap)
 '(ispell-dictionary nil)
 '(lsp-bridge-multi-lang-server-mode-list '(((qml-mode qml-ts-mode) . "qmlls_javascript")))
 '(lsp-bridge-python-lsp-server "ruff")
 '(lsp-bridge-python-multi-lsp-server "pyright_ruff")
 '(markdown-asymmetric-header t)
 '(markdown-enable-math t)
 '(markdown-header-scaling t)
 '(markdown-header-scaling-values '(1.7 1.4 1.1 1.0 1.0 1.0))
 '(markdown-hide-markup t)
 '(markdown-hide-urls t)
 '(markdown-use-pandoc-style-yaml-metadata t)
 '(package-selected-packages
   '(indy sql-indent writeroom-mode graphviz-dot-mode ligature git-gutter git-gutter-fringe diff-hl poetry org-superstar magit fira-code-mode all-the-icons use-package))
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
 '(default ((t (:family "Fira Code" :foundry "CTDB" :slant normal :weight normal :height 113 :width normal))))
 '(markdown-bold-face ((t (:inherit bold))))
 '(markdown-header-face ((t (:inherit bold)))))
