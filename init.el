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
; (setq use-package-always-ensure t) ; Has this in the other one, not sure what?


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





(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
