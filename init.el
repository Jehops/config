;; -*-Emacs-Lisp-*-

(add-to-list 'load-path "~/.emacs.d/elisp/")
(load-file "~/.emacs.d/secret.el")

(require 'misc) ;; part of emacs for forward/backward-to-word

;; variables that can't be customized
(setq ring-bell-function 'ignore)
(setq scpaste-http-destination "http://ftfl.ca/paste"
      scpaste-scp-destination "gly:/www/paste")
(setq org-irc-link-to-logs t)

;; tell customize to use ' instead of (quote ..) and #' instead of (function ..)
(advice-add 'custom-save-all
	    :around (lambda (orig) (let ((print-quoted t)) (funcall orig))))

;; enable some functions that are disabled by default
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; quick buffer switching by mode ----------------------------------------------
(defun jrm-switch-by-mode(prompt mode-list)
  (switch-to-buffer
   (completing-read prompt
		    (delq nil (mapcar (lambda (buf)
					(with-current-buffer buf
					  (and (member major-mode mode-list)
					       (buffer-name buf))))
				      (buffer-list))) nil t nil)))

(defun jrm-switch-dired-buffer()   (interactive) (jrm-switch-by-mode "Dired: "  '(dired-mode)))
(defun jrm-switch-erc-buffer()     (interactive) (jrm-switch-by-mode "Erc: "    '(erc-mode)))
(defun jrm-switch-eshell-buffer()  (interactive) (jrm-switch-by-mode "Eshell: " '(eshell-mode)))
(defun jrm-switch-gnus-buffer()    (interactive) (jrm-switch-by-mode "Gnus: "   '(gnus-group-mode gnus-summary-mode gnus-article-mode message-mode)))
(defun jrm-switch-r-buffer()       (interactive) (jrm-switch-by-mode "R: "      '(ess-mode inferior-ess-mode)))
(defun jrm-switch-term-buffer()    (interactive) (jrm-switch-by-mode "Term: "   '(term-mode)))
(defun jrm-switch-twit-buffer()    (interactive) (jrm-switch-by-mode "Twit: "   '(twittering-mode)))

(defun jrm-switch-scratch-buffer() (interactive) (switch-to-buffer   "*scratch*"))

;; appointments in the diary ---------------------------------------------------
(add-hook 'after-init-hook (lambda () (appt-activate 1)))

;; auctex / latex --------------------------------------------------------------
;;(add-hook 'after-init-hook (lambda () (use-package auctex-latexmk)))

;; auto-complete ---------------------------------------------------------------
(add-hook 'after-init-hook (lambda ()
			     (require 'auto-complete-config)
			     (ac-config-default)
			     (ac-flyspell-workaround)))
;;(define-key ac-menu-map (kbd "C-n") 'ac-next)
;;(define-key ac-menu-map (kbd "C-p") 'ac-previous)))

;; bbdb ------------------------------------------------------------------------
;; (add-hook 'after-init-hook (lambda ()
;; 			     (bbdb-initialize 'gnus 'message)
;; 			     (bbdb-mua-auto-update-init 'gnus 'message)))

;; beacon ----------------------------------------------------------------------
(add-hook 'after-init-hook (lambda () (beacon-mode 1)))

;; c/c++ -----------------------------------------------------------------------
(defun knf ()  ;; knf is Kernel Normal Form.  See style(9)
  (interactive) ; means you can activate it by typing M-x knf
  ;; Basic indent is 4 spaces
  (make-local-variable 'c-basic-offset)
  (setq c-basic-offset 4)
  ;; Continuation lines are indented 8 spaces
  (make-local-variable 'c-offsets-alist)
  (c-set-offset 'arglist-cont 8)
  (c-set-offset 'arglist-cont-nonempty 8)
  (c-set-offset 'statement-cont 8)
  ;; Labels are flush to the left
  (c-set-offset 'label [0])
  ;; Fill column
  (make-local-variable 'fill-column)
  (define-key c-mode-map "\C-cc" 'compile))
(add-hook 'c-mode-common-hook (lambda () (flyspell-prog-mode) (knf)))

;; calfw -----------------------------------------------------------------------
(add-hook 'after-init-hook (lambda ()
			     (require 'calfw-org)
			     (require 'calfw-cal)))

(defun calfw ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list (cfw:org-create-source "Green") (cfw:cal-create-source "Orange"))))

;; dired / dired+ --------------------------------------------------------------
(add-hook 'after-init-hook (lambda () (toggle-diredp-find-file-reuse-dir 1)))

;; doc-view --------------------------------------------------------------------
;;(add-hook 'doc-view-mode-hook 'auto-revert-mode)

;; erc -------------------------------------------------------------------------
(require 'erc-tex)

(defun jrm-erc-generate-log-file-name-network (buffer target nick server port)
  "Generates a log-file name using the network name rather than server name.
This results in a file name of the form channel@network.txt.
This function is a possible value for `erc-generate-log-file-name-function'."
  (require 'erc-networks)
  (let ((file
	 (concat
	  (if target (s-replace "#" "" target))
	  "@"
	  (or (with-current-buffer buffer (erc-network-name)) server) ".txt")))
    ;; we need a make-safe-file-name function.
    (convert-standard-filename file)))

(add-hook 'window-configuration-change-hook
	  (lambda () (setq erc-fill-column (- (window-width) 2))))

;; eshell completions ----------------------------------------------------------

(defun eshell-prompt ()
  (concat
   (propertize (user-login-name) 'face '(:foreground "red"))
   "@"
   (propertize
    (car (split-string (system-name) "[.]")) 'face '(:foreground "green"))
   " "
   (propertize
    (replace-regexp-in-string
     (concat "^\\(/usr\\)?/home/" (user-login-name)) "~" (eshell/pwd))
    'face '(:foreground "yellow"))
   (if (= (user-uid) 0) " # " " % ")))

(defalias 'pcomplete/sudo 'pcomplete/xargs)
(defalias 'pcomplete/s 'pcomplete/xargs)

(defconst pcmpl-pkg-commands
  '("add" "annotate" "audit" "autoremove" "backup" "check" "clean" "config"
    "convert" "create" "delete" "fetch" "help" "info" "install" "lock" "plugins"
    "query" "register" "remove" "repo" "rquery" "search" "set" "ssh" "shell"
    "shlib" "stats" "unlock" "update" "updating" "upgrade" "version" "which")
  "List of 'pkg' commands")

(defconst pcmpl-pkg-cats
  '("accessibility" "arabic" "archivers" "astro" "audio" "benchmarks" "biology"
    "cad" "chinese" "comms" "converters" "databases" "deskutils" "devel"
    "distfiles" "dns" "editors" "emulators" "finance" "french" "ftp" "games"
    "german" "graphics" "hebrew" "hungarian" "irc" "japanese" "java" "korean"
    "lang" "mail" "math" "misc" "multimedia" "net" "net-im" "net-mgmt" "net-p2p"
    "news" "old_ports" "packages" "palm" "polish" "ports-mgmt" "portuguese"
    "print" "russian" "science" "security" "shells" "sysutils" "textproc"
    "ukrainian" "vietnamese" "www" "x11" "x11-clocks" "x11-drivers" "x11-fm"
    "x11-fonts" "x11-servers" "x11-themes" "x11-toolkits" "x11-wm")
  "List of port categories")

(defun pcomplete/pkg ()
  "Completion for 'pkg'."
  (pcomplete-opt "djcCRlvN")
  (pcomplete-here* pcmpl-pkg-commands)
  (cond
   ((pcomplete-match "info" 1)
    "Completion for 'pkg info'."
    (pcomplete-opt "aAfReDgixdrklbBsqOEopF")
    (pcomplete-here*
     (split-string (shell-command-to-string "pkg info -q") "\n" t)))
   ((pcomplete-match "which" 1)
    "Completion for 'pkg which'."
    (pcomplete-opt "qog")
    (while (pcomplete-here (pcomplete-entries))))
   ((pcomplete-match "help" 1)
    "Completion for 'pkg help'."
    (pcomplete-here* pcmpl-pkg-commands))
   ((pcomplete-match "lock" 1)
    "Completion for 'pkg lock'."
    (pcomplete-opt "aqxy")
    (pcomplete-here* pcmpl-pkg-commands))
   ((pcomplete-match "audit" 1)
    "Completion for 'pkg audit'."
    (pcomplete-opt "Fqc")
    (pcomplete-here* pcmpl-pkg-commands))
   ((pcomplete-match "autoremove" 1)
    "Completion for 'pkg autoremove'."
    (pcomplete-opt "ynq"))
   ((pcomplete-match "backup" 1)
    "Completion for 'pkg backup'."
    (pcomplete-opt "dr")
    (pcomplete-here (pcomplete-entries)))
   ((pcomplete-match "check" 1)
    "Completion for 'pkg check'."
    (pcomplete-opt "Bdsrvyna")
    (pcomplete-here* pcmpl-pkg-commands))
   ((pcomplete-match "clean" 1)
    "Completion for 'pkg clean'."
    (pcomplete-opt "anqy"))
   ((pcomplete-match "delete" 1)
    "Completion for 'pkg delete'."
    (pcomplete-opt "DfginqRxya")
    (while (pcomplete-here*
	    (split-string (shell-command-to-string "pkg info -q") "\n" t))))
   ((pcomplete-match "install" 1)
    "Completion for 'pkg install'."
    (pcomplete-opt "AfIMnFqRUy")
    (let ((default-directory "/usr/ports/"))
      ;;(pcomplete-here* (pcomplete-dirs))
      (pcomplete-here*
       (split-string
	(shell-command-to-string "pkg rquery -a '%n-%v'") "\n" t))))))

(defconst pcmpl-zfs-commands
  '("allow" "bookmark" "clone" "create" "destroy"
    "diff" "get" "groupspace" "hold" "holds" "inherit" "jail" "list" "mount"
    "promote" "receive" "release" "rename" "rollback" "send" "set" "share"
    "snapshot" "unallow" "unjail" "unmount" "unshare" "upgrade" "userspace")
  "List of 'zfs' commands")

(defun pcomplete/service ()
  "Completion for 'service'."
  (pcomplete-opt "eRlrv")
  (pcomplete-here* (split-string (shell-command-to-string "service -l") "\n" t)))

(defun pcomplete/zfs ()
  "Completion for 'zfs'."
  (pcomplete-here* pcmpl-zfs-commands)
  (cond
   ((pcomplete-match "allow" 1)
    "Completion for 'pkg allow'."
    (pcomplete-opt "ldug"))))

(add-hook 'eshell-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-l") (lambda () (interactive) (recenter 0)))))

(add-hook 'eshell-mode-hook
          (lambda ()
	    (define-key eshell-mode-map (kbd "C-c C-r") 'helm-eshell-history)))

;; flyspell --------------------------------------------------------------------
;; stop flyspell-auto-correct-word (which isn't affected by the customization
;; flyspell-auto-correct-binding) from hijacking C-.
(eval-after-load "flyspell" '(define-key flyspell-mode-map (kbd "C-.") nil))

;; ess -------------------------------------------------------------------------
(add-hook 'after-init-hook (lambda () (require 'ess-site)))

;; gnus ------------------------------------------------------------------------
(defun jrm-gnus-enter-group ()
  "Start Gnus if necessary and enter GROUP."
  (interactive)
  (unless (gnus-alive-p) (gnus))
  (let ((group (gnus-group-completing-read "Group: " gnus-active-hashtb t)))
    (gnus-group-read-group nil t group)))

(defun jrm-toggle-personal-work-message-fields ()
  "Toggle message fields for personal and work messages."
  (interactive)
  (save-excursion
    (if (string-match (concat user-full-name " <" user-mail-address ">")
		      (message-field-value "From" t))
	(progn
	  (message-remove-header "From")
	  (message-add-header (concat "From: " user-full-name
				      " <" user-work-mail-address ">"))
	  (message-add-header (concat "X-Message-SMTP-Method: smtp "
				      work-smtp-server " 587"))
	  (unless (string-match (message-field-value "Gcc" t)
				user-work-mail-folder)
	    (message-remove-header "Gcc")
	    (message-add-header (concat "Gcc: " user-work-mail-folder))))
      (message-remove-header "From")
      (message-add-header (concat "From: " user-full-name
				  " <" user-mail-address ">"))
      (message-remove-header "X-Message-SMTP-Method")
      (unless (string-match (message-field-value "Gcc" t) "mail.misc")
	(message-remove-header "Gcc")
	(message-add-header "Gcc: mail.misc")))))

;; google
(add-hook 'after-init-hook 'google-this-mode)

;; helm ------------------------------------------------------------------------
(add-hook 'after-init-hook
	  (lambda ()
	    (require 'helm-config)
	    (helm-mode 1)
	    (define-key global-map [remap find-file] 'helm-find-files)
	    (define-key global-map [remap occur] 'helm-occur)
	    (define-key global-map [remap switch-to-buffer] 'helm-buffers-list)
	    (define-key global-map [remap dabbrev-expand] 'helm-dabbrev)
	    (define-key global-map [remap yank-pop] 'helm-show-kill-ring)
	    (global-set-key (kbd "M-x") 'helm-M-x)
	    (unless (boundp 'completion-in-region-function)
	      (define-key lisp-interaction-mode-map
		[remap completion-at-point] 'helm-lisp-completion-at-point)
	      (define-key emacs-lisp-mode-map
		[remap completion-at-point] 'helm-lisp-completion-at-point))
	    ;; open helm buffer inside current window
	    (setq helm-split-window-in-side-p t
		  helm-buffers-fuzzy-matching t
		  ;; search for library in `require' and `declare-function' sexp.
		  ;;helm-ff-search-library-in-sexp t
		  ;; scroll 8 lines other window using M-<next>/M-<prior>
		  ;;helm-scroll-amount 8
		  helm-ff-file-name-history-use-recentf t)))

;; keybindings ----------------------------------------------------------------

;; general stuff
(global-set-key (kbd "M-<f1>") 'menu-bar-mode)
(global-set-key (kbd "M-<f4>") 'save-buffers-kill-emacs)
(global-set-key [f11] 'linum-mode)
(global-set-key [f12] 'visual-line-mode)
(global-set-key (kbd "C-c i") 'helm-swoop)
(global-set-key (kbd "C-x h") 'help-command)
(global-set-key (kbd "<C-tab>") 'hippie-expand)

;; buffers and windows
(global-set-key (kbd "C-x C-b")   'ibuffer)
(global-set-key (kbd "C-x K")     'kill-buffer-and-its-windows)
(global-set-key (kbd "C-x o")     'ace-window)
(global-set-key (kbd "C-c b c")   'calfw)
(global-set-key (kbd "C-c b d")   'jrm-switch-dired-buffer)
(global-set-key (kbd "C-c b i")   'jrm-switch-erc-buffer)
(global-set-key (kbd "C-c b e")   'jrm-switch-eshell-buffer)
(global-set-key (kbd "C-c b g")   'jrm-switch-gnus-buffer)
(global-set-key (kbd "C-c b G")   'jrm-gnus-enter-group)
(global-set-key (kbd "C-c b r")   'jrm-switch-r-buffer)
(global-set-key (kbd "C-c b s")   'jrm-switch-scratch-buffer)
(global-set-key (kbd "C-c b t")   'jrm-switch-term-buffer)
(global-set-key (kbd "C-c b w")   'jrm-switch-twit-buffer)
(global-set-key (kbd "C-c g")     'magit-status)
(global-set-key (kbd "C-c e c")   'multi-eshell)
(global-set-key (kbd "C-c o a")   'org-agenda)
(global-set-key (kbd "C-c o b")   'org-iswitchb)
(global-set-key (kbd "C-c o c")   'org-capture)
(global-set-key (kbd "C-c o l")   'org-store-link)
(global-set-key (kbd "C-c p h")   'windmove-left)
(global-set-key (kbd "C-c p l")   'windmove-right)
(global-set-key (kbd "C-c p j")   'windmove-down)
(global-set-key (kbd "C-c p k")   'windmove-up)
(global-set-key (kbd "C-c p C-h") 'buf-move-left)
(global-set-key (kbd "C-c p C-l") 'buf-move-right)
(global-set-key (kbd "C-c p C-j") 'buf-move-down)
(global-set-key (kbd "C-c p C-k") 'buf-move-up)

;; mark and point
(global-set-key (kbd "C-.")       'ace-jump-word-mode)
(global-set-key (kbd "M-h")       'backward-kill-word)
(global-set-key (kbd "M-?")       'mark-paragraph)
(global-set-key (kbd "M-z")       'ace-jump-zap-up-to-char)
(global-set-key (kbd "M-Z")       'ace-jump-zap-to-char)
;; the translation makes C-h work with M-x in the minibuffer
(define-key key-translation-map (kbd "C-h") [?\C-?])

;; ace-link for various modes
(add-hook 'after-init-hook
	  (lambda ()
	    (ace-link-setup-default (kbd "C-,"))
	    (require 'ert)
	    (define-key ert-results-mode-map  (kbd "C-,") 'ace-link-help)
	    (define-key gnus-summary-mode-map (kbd "C-,") 'ace-link-gnus)
	    (define-key gnus-article-mode-map (kbd "C-,") 'ace-link-gnus)))

(defun cperl-mode-keybindings ()
  (local-set-key (kbd "C-c c") 'cperl-check-syntax)
  (local-set-key (kbd "M-n")   'next-error)
  (local-set-key (kbd "M-p")   'previous-error))

;; key chords ------------------------------------------------------------------
(add-hook 'after-init-hook
	  (lambda ()
	    (key-chord-mode 1)
	    (key-chord-define-global "jf" 'forward-to-word)
	    (key-chord-define-global "jb" 'backward-to-word)
	    (key-chord-define-global "jg" 'ace-jump-line-mode)
	    (key-chord-define-global "jx" 'multi-eshell)))

;; mozrepl ---------------------------------------------------------------------
(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)

(add-hook 'javascript-mode-hook 'javascript-custom-setup)
(add-hook 'js-mode-hook 'javascript-custom-setup)
(defun javascript-custom-setup () (moz-minor-mode 1))

;; multi-term ------------------------------------------------------------------
(add-hook 'term-mode-hook (lambda () (setq show-trailing-whitespace nil)))
(autoload 'multi-term "multi-term" nil t)
(autoload 'multi-term-next "multi-term" nil t)

;; multi-web-mode for lon-capa problems ----------------------------------------
;;(add-hook 'after-init-hook (lambda ()
;;			     (multi-web-global-mode 1)))

;; nnmairix --------------------------------------------------------------------
(require 'nnmairix)

;; noweb -----------------------------------------------------------------------
;; (add-hook 'LaTeX-mode-hook '(lambda ()
;; 			      (if (string-match "\\.Rnw\\'" buffer-file-name)
;; 				  (setq fill-column 80))))

;; org-mode --------------------------------------------------------------------
;;(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(add-hook 'after-init-hook 'org-clock-persistence-insinuate)

;; pdf-tools
;;(add-hook 'after-init-hook 'pdf-tools-install)

;; perl ------------------------------------------------------------------------
(defalias 'perl-mode 'cperl-mode)
;;(autoload 'perl-mode "cperl-mode" "alternate mode for editing Perl programs" t)
(add-hook 'cperl-mode-hook 'cperl-mode-keybindings)
(setq cperl-close-paren-offset -4)
(setq cperl-continued-statement-offset 0)
(setq cperl-extra-newline-before-brace nil)
(setq cperl-font-lock t)
;;(setq cperl-hairy t)
(setq cperl-indent-level 4)
(setq cperl-indent-parens-as-block t)
(setq cperl-tab-always-indent t)

;; php -------------------------------------------------------------------------
(autoload 'php-mode "php-mode" "Mode for editing PHP source files")
(add-to-list 'auto-mode-alist '("\\.\\(inc\\|php[s34]?\\)" . php-mode))

;; rainbow delimeters ----------------------------------------------------------
;;(global-rainbow-delimiters-mode)

;; registers
(set-register ?c '(file . "~/scm/org.git/capture.org"))
(set-register ?d '(file . "~/.emacs.d/diary"))
(set-register ?i '(file . "~/.emacs.d/init.el"))
(set-register ?P '(file . "~/files/crypt/passwords.org.gpg"))
(set-register ?p '(file . "~/scm/org.git/personal.org"))
(set-register ?r '(file . "~/scm/org.git/research.org"))
(set-register ?s '(file . "~/scm/org.git/sites.org"))
(set-register ?w '(file . "~/scm/org.git/work.org"))

;; s.el
(add-hook 'after-init-hook (lambda () (require 's)))

;; slime/swank -----------------------------------------------------------------
;; only evaluate next two lines as needed
;;(load (expand-file-name "~/quicklisp/slime-helper.el"))
;;(setq inferior-lisp-program "~/local/bin/sbcl")

;;(require 'slime)
;;(slime-setup '(slime-fancy))

;; transpar (transpose-paragraph-as-table) -------------------------------------
(require 'transpar)

;; twittering-mode -------------------------------------------------------------
;;(add-hook 'twittering-edit-mode-hook
;;	  (lambda () (ispell-minor-mode) (flyspell-mode)))

;; undo-tree -------------------------------------------------------------------
(add-hook 'after-init-hook 'global-undo-tree-mode)

;; yasnippet -------------------------------------------------------------------
;;(add-hook 'after-init-hook (lambda ()
;;			     (yas-global-mode)))

;; -----------------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-mode-hook '(flyspell-mode LaTeX-math-mode turn-on-reftex))
 '(TeX-PDF-mode t)
 '(TeX-auto-save t)
 '(TeX-parse-self t)
 '(TeX-source-correlate-mode t)
 '(TeX-view-program-list
   '(("pv" "pv %o&")
     ("emacs" "emacsclient -n %o")
     ("xpdf" "xpdf %o&")))
 '(TeX-view-program-selection
   '((output-pdf "pv" "emacs" "xpdf")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-html "xdg-open")))
 '(ac-dictionary-files '("~/.emacs/ac-dict"))
 '(add-to-list 'default-frame-alist t)
 '(ansi-color-names-vector
   ["black" "red" "green" "yellow" "sky blue" "magenta" "cyan" "white"])
 '(auto-save-file-name-transforms '((".*/\\([^/]*\\)" "~/.emacs.d/.emacs_auto_saves/\\1" t)))
 '(aw-keys '(97 115 100 102 103 104 106 107 108))
 '(aw-scope 'frame)
 '(backup-directory-alist '((".*" . "~/.emacs.d/.emacs_backups/")))
 '(bbdb-complete-mail-allow-cycling t)
 '(bbdb-mua-pop-up nil)
 '(before-save-hook '(time-stamp))
 '(blink-cursor-mode nil)
 '(browse-url-browser-function 'browse-url-generic)
 '(browse-url-generic-program "~/local/bin/ck")
 '(browse-url-mailto-function 'browse-url-mail)
 '(c-default-style '((java-mode . "java") (awk-mode . "awk") (other . "bsd")))
 '(calendar-date-style 'iso)
 '(calendar-latitude 44.630294)
 '(calendar-longitude -63.582304)
 '(calendar-mark-diary-entries-flag t)
 '(calendar-mark-holidays-flag t)
 '(calendar-time-display-form
   '(24-hours ":" minutes
	      (if time-zone " (")
	      time-zone
	      (if time-zone ")")))
 '(calendar-today-visible-hook '(calendar-mark-today))
 '(calendar-week-start-day 1)
 '(column-number-mode t)
 '(compilation-window-height 6)
 '(custom-buffer-done-kill t)
 '(delete-old-versions t)
 '(diary-comment-end "*/")
 '(diary-comment-start "/*")
 '(diary-file "~/.emacs.d/diary")
 '(diary-list-entries-hook
   '(diary-include-other-diary-files diary-sort-entries bbdb-anniv-diary-entries))
 '(dired-auto-revert-buffer 'dired-directory-changed-p)
 '(dired-listing-switches "-alh")
 '(dired-use-ls-dired nil)
 '(diredp-hide-details-initially-flag nil)
 '(doc-view-continuous t)
 '(doc-view-pdftotext-program "/usr/local/libexec/xpdf/pdftotext")
 '(erc-fill-column 144)
 '(erc-generate-log-file-name-function 'jrm-erc-generate-log-file-name-network)
 '(erc-hl-nicks-mode t)
 '(erc-hl-nicks-skip-faces
   '("erc-notice-face" "erc-pal-face" "erc-fool-face" "erc-my-nick-face" "erc-current-nick-face" "erc-direct-msg-face"))
 '(erc-hl-nicks-skip-nicks nil)
 '(erc-join-buffer 'bury)
 '(erc-log-channels-directory "~/.emacs.d/.erc/logs")
 '(erc-log-write-after-insert t)
 '(erc-log-write-after-send t)
 '(erc-modules
   '(button completion fill irccontrols list log match menu move-to-prompt networks noncommands readonly ring stamp spelling))
 '(erc-timestamp-format "%c")
 '(erc-track-exclude-types
   '("JOIN" "MODE" "NICK" "PART" "QUIT" "305" "306" "324" "329" "332" "333" "353" "477"))
 '(erc-track-showcount t)
 '(erc-truncate-mode nil)
 '(eshell-aliases-file "~/.emacs.d/eshell/alias")
 '(eshell-banner-load-hook nil)
 '(eshell-banner-message "")
 '(eshell-cmpl-cycle-completions nil)
 '(eshell-cmpl-use-paring nil)
 '(eshell-command-completions-alist
   '(("CC" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("acc" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("acroread" . "\\.pdf\\'")
     ("adb" . "\\`\\([^.]*\\|a\\.out\\)\\'")
     ("ar" . "\\.[ao]\\'")
     ("bcc" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("cc" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("clang" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("clang++" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("dbx" . "\\`\\([^.]*\\|a\\.out\\)\\'")
     ("g++" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("gcc" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("gdb" . "\\`\\([^.]*\\|a\\.out\\)\\'")
     ("gunzip" . "\\.gz\\'")
     ("nm" . "\\(\\`[^.]*\\|\\.\\([ao]\\|so\\)\\)\\'")
     ("objdump" . "\\(\\`[^.]*\\|\\.\\([ao]\\|so\\)\\)\\'")
     ("readelf" . "\\(\\`[^.]*\\|\\.\\([ao]\\|so\\)\\)\\'")
     ("sdb" . "\\`\\([^.]*\\|a\\.out\\)\\'")
     ("xpdf" . "\\.pdf\\'")))
 '(eshell-cp-interactive-query t)
 '(eshell-first-time-mode-hook '((lambda nil (setenv "PAGER" "cat"))))
 '(eshell-glob-include-dot-files nil)
 '(eshell-glob-show-progress t)
 '(eshell-highlight-prompt nil)
 '(eshell-hist-ignoredups t)
 '(eshell-history-file-name "~/.emacs.d/eshell/history")
 '(eshell-history-size 1024)
 '(eshell-last-dir-ring-file-name "~/.emacs.d/eshell/lastdir")
 '(eshell-modules-list
   '(eshell-alias eshell-banner eshell-basic eshell-cmpl eshell-dirs eshell-glob eshell-hist eshell-ls eshell-pred eshell-prompt eshell-script eshell-term eshell-unix eshell-xtra))
 '(eshell-mv-interactive-query t)
 '(eshell-mv-overwrite-files nil)
 '(eshell-output-filter-functions
   '(eshell-handle-control-codes eshell-handle-ansi-color eshell-watch-for-password-prompt))
 '(eshell-prompt-function 'eshell-prompt)
 '(eshell-prompt-regexp "^[^%#]*@[^%#]*[#%] ")
 '(eshell-pwd-convert-function 'expand-file-name)
 '(eshell-rm-interactive-query t)
 '(eshell-visual-commands
   '("less" "links" "lynx" "more" "ncftp" "mplayer" "mpv" "portmaster" "top" "trn" "unison" "vi" "vipw"))
 '(eshell-visual-options '(("sudo" "make config") ("git" "diff" "log" "--help")))
 '(ess-ask-for-ess-directory nil)
 '(ess-eval-visibly nil)
 '(ess-history-directory "~/")
 '(ess-pdf-viewer-pref "pv")
 '(ess-swv-pdflatex-commands '("latexmk"))
 '(ess-swv-processor 'knitr)
 '(ess-transcript-mode-hook '(ess-S-mouse-me-menu-commands turn-on-font-lock))
 '(explicit-shell-file-name "/usr/local/bin/zsh")
 '(flymake-log-level 3)
 '(global-auto-complete-mode t)
 '(global-auto-revert-mode t)
 '(global-hl-line-mode nil)
 '(gnus-activate-level 4)
 '(gnus-after-getting-new-news-hook '(gnus-display-time-event-handler))
 '(gnus-agent nil)
 '(gnus-article-date-headers '(local))
 '(gnus-article-mode-hook visual-line-mode)
 '(gnus-article-prepare-hook
   '(bbdb-mua-auto-update
     (lambda nil
       (gnus-article-fill-cited-article
	(max 72
	     (frame-width))
	t))))
 '(gnus-article-sort-functions '(gnus-article-sort-by-date))
 '(gnus-auto-subscribed-groups "nil")
 '(gnus-exit-gnus-hook '(mm-destroy-postponed-undisplay-list))
 '(gnus-group-catchup-group-hook '(gnus-topic-update-topic))
 '(gnus-group-mode-hook '(gnus-topic-mode hl-line-mode nnmairix-group-mode-hook))
 '(gnus-group-sort-function '(gnus-group-sort-by-alphabet gnus-group-sort-by-level))
 '(gnus-inhibit-mime-unbuttonizing t)
 '(gnus-init-file "~/.emacs.d/gnus.el")
 '(gnus-message-archive-group
   '((lambda
       (x)
       (cond
	((message-news-p)
	 nil)
	((and
	  (boundp 'group)
	  (<
	   (gnus-group-level group)
	   4))
	 group)
	(t "mail.misc")))))
 '(gnus-message-archive-method '(nnml ""))
 '(gnus-message-setup-hook '(message-remove-blank-cited-lines mml-secure-message-sign))
 '(gnus-read-newsrc-file nil)
 '(gnus-save-newsrc-file nil)
 '(gnus-secondary-select-methods
   '((nntp "news.gmane.org"
	   (nntp-port-number 563)
	   (nntp-open-connection-function nntp-open-tls-stream))))
 '(gnus-select-method '(nnml ""))
 '(gnus-startup-file "~/.emacs.d/newsrc")
 '(gnus-subthread-sort-functions '(gnus-thread-sort-by-number gnus-thread-sort-by-date))
 '(gnus-sum-thread-tree-false-root "⚇")
 '(gnus-sum-thread-tree-indent "   ")
 '(gnus-sum-thread-tree-leaf-with-other "├――►")
 '(gnus-sum-thread-tree-root "●")
 '(gnus-sum-thread-tree-single-indent "○")
 '(gnus-sum-thread-tree-single-leaf "└――►")
 '(gnus-sum-thread-tree-vertical "│  ")
 '(gnus-summary-line-format
   "%U%R %5N %6k %24&user-date; │ %~(max-right 75)~(pad-right 75)S │ %B %f
")
 '(gnus-summary-mode-hook '(hl-line-mode nnmairix-summary-mode-hook))
 '(gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references)
 '(gnus-thread-sort-functions
   '(gnus-thread-sort-by-number gnus-thread-sort-by-most-recent-date))
 '(gnus-treat-fill-long-lines nil)
 '(gnutls-min-prime-bits 1024)
 '(gnutls-trustfiles
   '("/usr/local/share/certs/ca-root-nss.crt" "/home/jrm/.emacs.d/news.gmane.org.crt.pem"))
 '(gnutls-verify-error t)
 '(google-translate-default-target-language "en")
 '(helm-boring-buffer-regexp-list
   '("\\` " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*Minibuf" "\\*tramp" "diary" "\\*ESS\\*"))
 '(helm-buffers-fuzzy-matching nil)
 '(helm-completion-in-region-fuzzy-match nil)
 '(helm-ff-file-name-history-use-recentf t)
 '(helm-ff-search-library-in-sexp t)
 '(helm-split-window-in-side-p t)
 '(holiday-bahai-holidays nil)
 '(holiday-general-holidays
   '((holiday-fixed 1 1 "New Year's Day")
     (holiday-float 1 1 3 "Martin Luther King Day (US)")
     (holiday-fixed 2 2 "Groundhog Day")
     (holiday-fixed 2 14 "Valentine's Day")
     (holiday-float 2 1 3 "President's Day (US)")
     (holiday-fixed 3 17 "St. Patrick's Day")
     (holiday-fixed 4 1 "April Fools' Day")
     (holiday-float 5 0 2 "Mother's Day")
     (holiday-float 5 1 -1 "Memorial Day")
     (holiday-float 5 1 -1 "Victoria Day (CA)" 24)
     (holiday-fixed 6 14 "Flag Day")
     (holiday-float 6 0 3 "Father's Day")
     (holiday-fixed 7 1 "Canada Day")
     (holiday-fixed 7 4 "Independence Day (US)")
     (holiday-float 8 1 1 "Civic (CA)")
     (holiday-float 9 1 1 "Labor Day")
     (holiday-float 10 1 2 "Columbus Day (US) Thanksgiving (CA)")
     (holiday-fixed 10 31 "Halloween")
     (holiday-fixed 11 11 "Remeberance Day (CA) Veteran's Day (US)")
     (holiday-float 11 4 4 "Thanksgiving (US)")
     (holiday-fixed 12 26 "Boxing Day (CA)")))
 '(ibuffer-default-sorting-mode 'alphabetic)
 '(ibuffer-maybe-show-predicates
   '("^\\*ESS\\*" "^\\*Compile" "^\\*mairix output*\\*" "^\\*helm"
     (lambda
       (buf)
       (and
	(string-match "^ "
		      (buffer-name buf))
	(null buffer-file-name)))))
 '(ibuffer-mode-hook
   '((lambda nil
       (ibuffer-switch-to-saved-filter-groups "default"))
     pdf-occur-ibuffer-minor-mode))
 '(ibuffer-saved-filter-groups
   '(("default"
      ("dired"
       (mode . dired-mode))
      ("emacs"
       (or
	(mode . Custom-mode)
	(name . "^\\*scratch\\*$")
	(name . "^\\*Messages\\*$")))
      ("erc"
       (mode . erc-mode))
      ("eshell"
       (mode . eshell-mode))
      ("gnus"
       (or
	(mode . message-mode)
	(mode . bbdb-mode)
	(mode . mail-mode)
	(mode . gnus-group-mode)
	(mode . gnus-summary-mode)
	(mode . gnus-article-mode)
	(name . "^\\.?bbdb$")
	(name . "^\\.?newsrc-dribble")))
      ("help"
       (mode . help-mode))
      ("LaTeX"
       (or
	(mode . latex-mode)
	(name . "^.*\\.Rnw")))
      ("magit"
       (or
	(mode . magit-diff-mode)
	(mode . magit-proces-mode)
	(mode . magit-status-mode)))
      ("planning"
       (or
	(name . "^\\*Calendar\\*$")
	(name . "^diary$")
	(name . ".*\\.org")
	(mode . org-agenda-mode)
	(name . "^\\*\\Holidays\\*$")
	(mode . muse-mode)))
      ("programming"
       (or
	(mode . emacs-lisp-mode)
	(mode . cperl-mode)
	(mode . c-mode)
	(mode . java-mode)
	(mode . idl-mode)
	(mode . lisp-mode)))
      ("R"
       (or
	(mode . ess-mode)
	(mode . inferior-ess-mode))))))
 '(ibuffer-saved-filters
   '(("gnus"
      ((or
	(mode . message-mode)
	(mode . mail-mode)
	(mode . gnus-group-mode)
	(mode . gnus-summary-mode)
	(mode . gnus-article-mode))))
     ("programming"
      (or
       (mode . emacs-lisp-mode)
       (mode . cperl-mode)
       (mode . c-mode)
       (mode . java-mode)
       (mode . idl-mode)
       (mode . lisp-mode)))))
 '(ido-default-buffer-method 'selected-window)
 '(ido-enable-flex-matching t)
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(ispell-help-in-bufferp 'electric)
 '(kill-whole-line t)
 '(mail-sources '((maildir :path "/home/jrm/mail/")))
 '(mail-user-agent 'gnus-user-agent)
 '(menu-bar-mode nil)
 '(message-fill-column nil)
 '(message-kill-buffer-on-exit t)
 '(message-log-max 16384)
 '(message-mode-hook
   '((lambda nil
       (local-set-key
	(kbd "C-c C-f o")
	'jrm-toggle-personal-work-message-fields))
     flyspell-mode visual-line-mode))
 '(message-setup-hook '(bbdb-insinuate-message mml-secure-message-sign))
 '(mm-attachment-override-types
   '("text/x-vcard" "application/pkcs7-mime" "application/x-pkcs7-mime" "application/pkcs7-signature" "application/x-pkcs7-signature" "image/.*"))
 '(mm-discouraged-alternatives '("text/html" "text/richtext"))
 '(mm-encrypt-option 'guided)
 '(mm-inline-large-images 'resize)
 '(mm-verify-option 'known)
 '(mml-smime-encrypt-to-self t)
 '(mml-smime-passphrase-cache-expiry 604800)
 '(mml-smime-signers '("B0D6EF9E"))
 '(mml2015-encrypt-to-self t)
 '(mml2015-passphrase-cache-expiry 604800)
 '(mml2015-signers '("B0D6EF9E"))
 '(mode-line-format
   '("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position
     (vc-mode vc-mode)
     "  " mode-line-modes mode-line-misc-info
     (:eval
      (car
       (split-string system-name
		     (rx "."))))
     mode-line-end-spaces))
 '(mode-require-final-newline nil)
 '(multi-eshell-name "*eshell*")
 '(multi-eshell-shell-function '(eshell))
 '(multi-term-program "/usr/local/bin/zsh")
 '(multi-term-scroll-to-bottom-on-output t)
 '(mweb-default-major-mode 'nxml-mode)
 '(mweb-filename-extensions '("php" "htm" "html" "problem"))
 '(mweb-tags
   '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
     (js-mode "<script>" "</script>")
     (css-mode "<style[^>]*>" "</style>")
     (cperl-mode "<script type=\"loncapa/perl\">" "</script>")))
 '(nnir-method-default-engines '((nnimap . imap) (nntp . gmane) (nnml . find-grep)))
 '(org-agenda-files `(,org-directory))
 '(org-agenda-include-diary t)
 '(org-agenda-use-time-grid nil)
 '(org-capture-templates
   '(("t" "Todo" entry
      (file+headline "~/scm/org.git/capture.org" "Tasks")
      "** TODO %u %?")
     ("w" "Web Link" item
      (file+headline "~/scm/org.git/capture.org" "Web Links")
      "- %u %c
 \"%i\"")))
 '(org-clock-persist 'history)
 '(org-default-notes-file "~/scm/org.git/capture.org")
 '(org-directory "~/scm/org.git")
 '(org-export-html-postamble nil)
 '(org-mobile-directory "~/.org-mobile")
 '(org-modules
   '(org-bbdb org-bibtex org-docview org-gnus org-info org-irc org-mhe org-protocol org-w3m))
 '(org-refile-targets '((org-agenda-files :tag . "")))
 '(org-refile-use-outline-path t)
 '(org-todo-keywords
   '((sequence "TODO(t!)" "|" "POSTPONED(p!)" "CANCELLED(c!)" "DONE(d!)")))
 '(org-use-fast-todo-selection t)
 '(package-archives
   '(("melpa" . "https://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")))
 '(preview-scale-function 1.2)
 '(reb-re-syntax 'string)
 '(reftex-bibpath-environment-variables '("BIBINPUTS" "TEXBIB" "~/scm/references.git/refs.bib"))
 '(reftex-plug-into-AUCTeX t)
 '(require-final-newline nil)
 '(safe-local-variable-values
   '((whitespace-style face tabs spaces trailing lines space-before-tab::space newline indentation::space empty space-after-tab::space space-mark tab-mark newline-mark)))
 '(scroll-bar-mode nil)
 '(scroll-conservatively 10000)
 '(send-mail-function 'mailclient-send-it)
 '(show-paren-mode t)
 '(show-trailing-whitespace nil)
 '(sort-fold-case nil)
 '(term-bind-key-alist nil)
 '(term-buffer-maximum-size 10000)
 '(term-scroll-show-maximum-output nil)
 '(term-unbind-key-list '("C-c b" "C-c t" "C-x" "M-x"))
 '(tls-checktrust t)
 '(tls-program
   '(("gnutls-cli --x509cafile /usr/local/share/certs/ca-root-nss.crt -p %p %h")))
 '(tool-bar-mode nil)
 '(truncate-lines t)
 '(truncate-partial-width-windows nil)
 '(twittering-oauth-invoke-browser t)
 '(twittering-request-confirmation-on-posting t)
 '(twittering-use-master-password t)
 '(undo-tree-visualizer-timestamps t)
 '(uniquify-buffer-name-style 'forward nil (uniquify))
 '(version-control t)
 '(web-mode-attr-indent-offset 2)
 '(x-select-enable-clipboard t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(cfw:face-toolbar ((t (:background "black" :foreground "Steelblue4"))))
 '(erc-button ((t (:underline t :weight bold))))
 '(erc-current-nick-face ((t (:foreground "OliveDrab4" :weight bold))))
 '(erc-input-face ((t (:foreground "DarkOrange4"))))
 '(erc-my-nick-face ((t (:foreground "DarkOrange4" :weight bold))))
 '(erc-notice-face ((t (:foreground "dim gray" :weight bold))))
 '(erc-timestamp-face ((t (:foreground "dim gray" :weight bold))))
 '(eshell-ls-archive ((((class color) (background dark)) (:foreground "Yellow" :weight bold))))
 '(eshell-ls-backup ((((class color) (background dark)) (:foreground "LightSalmon"))))
 '(eshell-ls-clutter ((((class color) (background dark)) (:foreground "gray" :weight bold))))
 '(eshell-ls-directory ((t (:foreground "royal blue" :weight bold))))
 '(eshell-ls-executable ((((class color) (background dark)) (:foreground "Orange" :weight bold))))
 '(eshell-ls-readonly ((((class color) (background dark)) (:foreground "LightPink"))))
 '(eshell-ls-symlink ((((class color) (background dark)) (:foreground "Purple" :weight bold))))
 '(eshell-ls-unreadable ((((class color) (background dark)) (:foreground "Brown"))))
 '(eshell-prompt ((((class color) (background dark)) (:foreground "white" :weight bold))))
 '(fringe ((((class color) (background dark)) (:background "black"))))
 '(highlight ((t (:background "gray18"))))
 '(mode-line ((t (:background "gray10" :foreground "white"))))
 '(mode-line-highlight ((t nil)))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "cyan"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "green"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "pink"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "purple"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "orange"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "blue"))))
 '(rainbow-delimiters-unmatched-face ((t (:background "yellow" :foreground "red"))))
 '(term-color-blue ((t (:background "DodgerBlue1" :foreground "DodgerBlue1")))))
