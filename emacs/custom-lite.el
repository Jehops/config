(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms '((".*/\\([^/]*\\)" "~/.emacs.d/.emacs_auto_saves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/.emacs_backups/")))
 '(before-save-hook '(time-stamp))
 '(blink-cursor-mode nil)
 '(c-default-style '((java-mode . "java") (awk-mode . "awk") (other . "bsd")))
 '(column-number-mode t)
 '(custom-buffer-done-kill t)
 '(delete-old-versions 'other)
 '(dired-auto-revert-buffer 'dired-directory-changed-p)
 '(dired-listing-switches "-alh")
 '(dired-use-ls-dired nil)
 '(diredp-hide-details-initially-flag nil)
 '(fill-column 80)
 '(global-auto-revert-mode t)
 '(gnutls-min-prime-bits 1024)
 '(gnutls-trustfiles '("/usr/local/share/certs/ca-root-nss.crt"))
 '(gnutls-verify-error t)
 '(help-char 67)
 '(indent-tabs-mode nil)
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(kill-do-not-save-duplicates t)
 '(kill-whole-line t)
 '(menu-bar-mode nil)
 '(ring-bell-function 'ignore)
 '(tls-checktrust 'ask)
 '(tls-program
   '(("gnutls-cli --x509cafile /usr/local/share/certs/ca-root-nss.crt -p %p %h")))
 '(tool-bar-mode nil)
 '(vc-follow-symlinks t)
 '(vc-make-backup-files t)
 '(version-control t)
 '(uniquify-buffer-name-style 'forward nil (uniquify)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "None" :family "DejaVu Sans Mono"))))
 '(mode-line ((t (:background "gray10" :foreground "white"))))
 '(mode-line-highlight ((t nil))))
