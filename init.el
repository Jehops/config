(add-to-list 'load-path "~/.emacs.d/elisp/")
(load-file "~/.emacs.d/secret.el")
(package-initialize)

;; variables that can't be customized ------------------------------------------
(setq scpaste-http-destination "http://ftfl.ca/paste"
      scpaste-scp-destination "gly:/www/paste")
(setq org-irc-link-to-logs t)

;; enable some functions that are disabled by default --------------------------
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)

;; quick buffer switching by mode ----------------------------------------------
;;
;; Below, I define keymappings for buffer switching by mode with the
;; prefix C-c b <x>.  For example, to switch to a dired buffer I use
;; C-c b d
(defun jrm/sbm (prompt mode-list)
  "PROMPT for buffers that have a major mode matching an element of MODE-LIST."
  (switch-to-buffer
   (completing-read
    prompt
    (delq nil
	  (mapcar
	   (lambda (buf)
	     (with-current-buffer buf
	       (and (member major-mode mode-list) (buffer-name buf))))
	   (buffer-list))) nil t nil)))

(defun jrm/sb-dired ()   (interactive) (jrm/sbm "Dired: "  '(dired-mode)))
(defun jrm/sb-erc ()     (interactive) (jrm/sbm "Erc: "    '(erc-mode)))
(defun jrm/sb-eshell ()  (interactive) (jrm/sbm "Eshell: " '(eshell-mode)))
(defun jrm/sb-gnus ()    (interactive) (jrm/sbm "Gnus: "   '(gnus-group-mode
							     gnus-summary-mode
							     gnus-article-mode
							     message-mode)))
(defun jrm/sb-magit ()   (interactive) (jrm/sbm "Magit: "  '(magit-status-mode
							     magit-diff-mode)))
(defun jrm/sb-rt()       (interactive) (jrm/sbm "R/TeX: "  '(ess-mode
							     inferior-ess-mode
							     latex-mode)))
(defun jrm/sb-term ()    (interactive) (jrm/sbm "Term: "   '(term-mode)))
(defun jrm/sb-twit()     (interactive) (jrm/sbm "Twit: "   '(twittering-mode)))
(defun jrm/sb-scratch () (interactive) (switch-to-buffer   "*scratch*"))

;; via offby1
(defun buffer-fname-to-kill-ring (use-backslashes)
  "Add buffer's file name to the kill ring.
When no file is being visit, add the associated directory to the
kill ring.  With an argument, USE-BACKSLASHES instead of forward
slashes."
  (interactive "P")
  (let ((fn (subst-char-in-string
             ?/
             (if use-backslashes ?\\ ?/)
             (or
              (buffer-file-name (current-buffer))
              (expand-file-name default-directory)))))
    (when (null fn)
      (error "Buffer is not associated with any file or directory"))
    (kill-new fn)
    (message "%s" fn)
  fn))

;; ace-link for various modes --------------------------------------------------
;; needs to be evaluated after init so gnus-*-mode-map are defined
(add-hook 'after-init-hook
	  (lambda ()
	    (require 'ert)
	    (ace-link-setup-default (kbd "C-,"))
	    (define-key ert-results-mode-map  (kbd "C-,") 'ace-link-help)
 	    (define-key gnus-summary-mode-map (kbd "C-,") 'ace-link-gnus)
 	    (define-key gnus-article-mode-map (kbd "C-,") 'ace-link-gnus)))

;; appointments in the diary ---------------------------------------------------
;; without after-init-hook, customized holiday-general-holidays is not respected
(add-hook 'after-init-hook (lambda () (appt-activate 1)))

;; beacon ----------------------------------------------------------------------
(beacon-mode 1)

;; c/c++ -----------------------------------------------------------------------
(defun knf ()
  "Set up kernel normal form.  See style(9) on FreeBSD."
  (interactive)
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
  (define-key c-mode-map (kbd "C-c c") 'compile))
(add-hook 'c-mode-common-hook (lambda () (flyspell-prog-mode) (knf)))

;; clipmon ---------------------------------------------------------------------
(add-hook 'after-init-hook 'clipmon-persist)

;; company ---------------------------------------------------------------------
(add-hook 'after-init-hook 'global-company-mode)

;; dired / dired+ --------------------------------------------------------------
(toggle-diredp-find-file-reuse-dir 1)

;; erc -------------------------------------------------------------------------
(require 'erc-tex)

(defun jrm/erc-generate-log-file-name-network (buffer target nick server port)
  "Generate erc BUFFER log file, TARGET for user NICK on SERVER:PORT.
Using the network name rather than server name.  This results in
a file name of the form channel@network.txt.  This function is a
possible value for `erc-generate-log-file-name-function'."
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
  "Customize the eshell prompt."
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
  "List of 'pkg' commands.")

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
  "List of port categories.")

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
  "List of 'zfs' commands.")

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

;; ess -------------------------------------------------------------------------
(require 'ess-site)

;; flyspell --------------------------------------------------------------------
;; stop flyspell-auto-correct-word (which isn't affected by the customization
;; flyspell-auto-correct-binding) from hijacking C-.
(eval-after-load "flyspell" '(define-key flyspell-mode-map (kbd "C-.") nil))

;; gnus ------------------------------------------------------------------------
(defun jrm/gnus-enter-group ()
  "Start Gnus if necessary and enter GROUP."
  (interactive)
  (unless (gnus-alive-p) (gnus))
  (let ((group (gnus-group-completing-read "Group: " gnus-active-hashtb t)))
    (gnus-group-read-group nil t group)))

(defun jrm/toggle-personal-work-message-fields ()
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

;; google ----------------------------------------------------------------------
(google-this-mode)

;; helm ------------------------------------------------------------------------
(helm-mode 1)
(helm-flx-mode +1)
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

;; keybindings -----------------------------------------------------------------

;; general stuff
(global-set-key (kbd "M-<f4>")    'save-buffers-kill-emacs)
(global-set-key (kbd "C-c i")     'helm-swoop)
(global-set-key (kbd "C-x h")     'help-command)
(global-set-key (kbd "<C-tab>")   'helm-dabbrev)

;; buffers and windows
(global-set-key (kbd "C-x C-b")   'ibuffer)
(global-set-key (kbd "C-x K")     'kill-buffer-and-its-windows)
(global-set-key (kbd "C-x o")     'ace-window)
(global-set-key (kbd "C-c b c")   'calendar)
(global-set-key (kbd "C-c b d")   'jrm/sb-dired)
(global-set-key (kbd "C-c b i")   'jrm/sb-erc)
(global-set-key (kbd "C-c b e")   'jrm/sb-eshell)
(global-set-key (kbd "C-c b g")   'jrm/sb-gnus)
(global-set-key (kbd "C-c b G")   'jrm/gnus-enter-group)
(global-set-key (kbd "C-c b r")   'jrm/sb-rt)
(global-set-key (kbd "C-c b s")   'jrm/sb-scratch)
(global-set-key (kbd "C-c b t")   'jrm/sb-term)
(global-set-key (kbd "C-c b w")   'jrm/sb-twit)
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
(global-set-key (kbd "C-0")       'buffer-fname-to-kill-ring)

;; mark and point
(global-set-key (kbd "C-.")       'avy-goto-word-or-subword-1)
(global-set-key (kbd "M-h")       'backward-kill-word)
(global-set-key (kbd "M-?")       'mark-paragraph)
(global-set-key (kbd "M-z")       'avy-zap-to-char-dwim)
(global-set-key (kbd "M-Z")       'avy-zap-up-to-char-dwim)
;; the translation makes C-h work with M-x in the minibuffer
(define-key key-translation-map (kbd "C-h") [?\C-?])

;; toggling
(global-set-key (kbd "C-x t c") 'flycheck-mode)
(global-set-key (kbd "C-x t d") 'toggle-debug-on-error)
(global-set-key (kbd "C-x t f") 'auto-fill-mode)
(global-set-key (kbd "C-x t l") 'linum-mode)
(global-set-key (kbd "C-x t m") 'menu-bar-mode)
(global-set-key (kbd "C-x t r") 'dired-toggle-read-only)
(global-set-key (kbd "C-x t s") 'flyspell-mode)
(global-set-key (kbd "C-x t t") 'toggle-truncate-lines)
(global-set-key (kbd "C-x t v") 'visual-line-mode)
(global-set-key (kbd "C-x t w") 'whitespace-mode)

(defun cperl-mode-keybindings ()
  "Additional keybindings for 'cperl-mode'."
  (local-set-key (kbd "C-c c") 'cperl-check-syntax)
  (local-set-key (kbd "M-n")   'next-error)
  (local-set-key (kbd "M-p")   'previous-error))

;; key chords ------------------------------------------------------------------
(key-chord-mode 1)
(key-chord-define-global "jf" 'forward-to-word)
(key-chord-define-global "jb" 'backward-to-word)
(key-chord-define-global "jg" 'avy-goto-line)
(key-chord-define-global "jx" 'multi-eshell)

;; misc is part of emacs; for forward/backward-to-word -------------------------
(require 'misc)

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
(org-clock-persistence-insinuate)

;; pdf-tools -------------------------------------------------------------------
;; This causes all buttons to be text when starting the emacs daemon
;; with emacsclient -nc -a ''
;; (pdf-tools-install)

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

;; polymode --------------------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.md"  . poly-markdown-mode))
(add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))

;; rainbow delimeters ----------------------------------------------------------
;;(global-rainbow-delimiters-mode)

;; registers -------------------------------------------------------------------
(set-register ?c '(file . "~/scm/org.git/capture.org"))
(set-register ?d '(file . "~/.emacs.d/diary"))
(set-register ?i '(file . "~/.emacs.d/init.el"))
(set-register ?P '(file . "~/files/crypt/passwords.org.gpg"))
(set-register ?p '(file . "~/scm/org.git/personal.org"))
(set-register ?r '(file . "~/scm/org.git/research.org"))
(set-register ?s '(file . "~/scm/org.git/sites.org"))
(set-register ?u '(file . "~/.emacs.d/custom.el"))
(set-register ?w '(file . "~/scm/org.git/work.org"))

;; s.el ------------------------------------------------------------------------
(require 's)

;; scratch buffer - bury it, never kill it -------------------------------------
(defadvice kill-buffer (around kill-buffer-around-advice activate)
  (let ((buffer-to-kill (ad-get-arg 0)))
    (if (equal buffer-to-kill "*scratch*")
        (bury-buffer)
      ad-do-it)))

;; slime/swank -----------------------------------------------------------------
;; only evaluate next two lines as needed
;;(load (expand-file-name "~/quicklisp/slime-helper.el"))
;;(setq inferior-lisp-program "~/local/bin/sbcl")

;;(require 'slime)
;;(slime-setup '(slime-fancy))

;; smart mode line -------------------------------------------------------------
;; without after-init-hook there is always a warning about loading a theme
(add-hook 'after-init-hook 'sml/setup)

;; transpar (transpose-paragraph-as-table) -------------------------------------
(require 'transpar)

;; twittering-mode -------------------------------------------------------------
(add-hook 'twittering-edit-mode-hook
	  (lambda () (ispell-minor-mode) (flyspell-mode)))

;; undo-tree -------------------------------------------------------------------
(global-undo-tree-mode)

;; yasnippet -------------------------------------------------------------------
;; (yas-global-mode)

;; yes-or-no--------------------------------------------------------------------
(defalias 'yes-or-no-p 'y-or-n-p)

;; custom set varaibles --------------------------------------------------------
;; tell customize to use ' instead of (quote ..) and #' instead of (function ..)
(advice-add 'custom-save-all
	    :around (lambda (orig) (let ((print-quoted t)) (funcall orig))))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
