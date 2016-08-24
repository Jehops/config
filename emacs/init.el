(add-to-list 'load-path "~/.emacs.d/elisp/")
(load-file "~/.emacs.d/secret.el")
(package-initialize)

;; (load-file "~/.emacs.d/exwm.el")

;; variables that can't be customized ------------------------------------------
(setq scpaste-http-destination "http://ftfl.ca/paste"
      scpaste-scp-destination  "gly:/www/paste"
      scpaste-user-name        "jrm"
      org-irc-link-to-logs     t)

;; enable some functions that are disabled by default --------------------------
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)

;; make quiting Emacs less interactive -----------------------------------------
(add-hook 'kill-emacs-hook 'gnus-group-exit)

;; quick buffer switching by mode ----------------------------------------------
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
           (buffer-list))) nil t)))

(defun jrm/sb-dired   () (interactive) (jrm/sbm "Dired: "  '(dired-mode)))
(defun jrm/sb-erc     () (interactive) (jrm/sbm "Erc: "    '(erc-mode)))
(defun jrm/sb-eshell  () (interactive) (jrm/sbm "Eshell: " '(eshell-mode)))
(defun jrm/sb-gnus    ()
  "Start Gnus if necessary, otherwise call jrm/sbm for Gnus buffers."
  (interactive)
  (if
      (null (gnus-alive-p))
      (when (y-or-n-p "Gnus is not running.  Start it? ") (gnus))
    (jrm/sbm "Gnus: "   '(gnus-group-mode
                          gnus-summary-mode
                          gnus-article-mode
                          message-mode))))
(defun jrm/sb-magit   () (interactive) (jrm/sbm "Magit: "  '(magit-status-mode
                                                             magit-diff-mode)))
(defun jrm/sb-pdf     () (interactive) (jrm/sbm "PDF: "    '(pdf-view-mode)))
(defun jrm/sb-rt      () (interactive) (jrm/sbm "R/TeX: "  '(ess-mode
                                                             inferior-ess-mode
                                                             latex-mode)))
(defun jrm/sb-term    () (interactive) (jrm/sbm "Term: "   '(term-mode)))
(defun jrm/sb-twit    () (interactive) (jrm/sbm "Twit: "   '(twittering-mode)))
(defun jrm/sb-scratch () (interactive) (switch-to-buffer   "*scratch*"))

(defun jrm/split-win-right-focus ()
  "Split window right and switch focus to it."
  (interactive)
  (split-window-right)
  (windmove-right))

(defun jrm/split-win-below-focus ()
  "Split window below and switch focus to it."
  (interactive)
  (split-window-below)
  (windmove-down))

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

(defun jrm/sort-lines-nocase ()
  "Sort lines ignoring case."
  (interactive)
  (let ((sort-fold-case t))
    (call-interactively 'sort-lines)))

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
;;(beacon-mode 1)

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

;; calfw -----------------------------------------------------------------------
;; Only load calfw after custom-set variables are loaded, otherwise unwated
;; holidays will be shown in calfw and calendar.  This happends because calfw
;; calls (require 'holiday), which sets calendar-holidays using values of,
;; e.g. holiday-bahai-holidays, before they are set to nil.
(add-hook 'after-init-hook
          (lambda ()
            (require 'calfw)
            (require 'calfw-cal)
            (require 'calfw-org)

            (defun jrm/open-calendar ()
              (interactive)
              (cfw:open-calendar-buffer
               :contents-sources
               (list
                (cfw:org-create-source "OliveDrab4")
                (cfw:cal-create-source "DarkOrange3"))))))

;; company ---------------------------------------------------------------------
(add-hook 'after-init-hook 'global-company-mode)

;; dired / dired+ --------------------------------------------------------------
(toggle-diredp-find-file-reuse-dir 1)

;; erc -------------------------------------------------------------------------
(require 'erc-tex)

(defun jrm/erc ()
  "Connect to irc networks set up in my znc bouncer."
  (interactive)
  (znc-erc "network-slug-efnet")
  (znc-erc "network-slug-freenode"))

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
(defun jrm/eshell-prompt ()
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
            (define-key eshell-mode-map
              (kbd "C-c C-r") 'jrm/counsel-esh-history)))

;; ess -------------------------------------------------------------------------
(require 'ess-site)

;; flycheck --------------------------------------------------------------------
(require 'flycheck)

;; flyspell --------------------------------------------------------------------
;; stop flyspell-auto-correct-word (which isn't affected by the customization
;; flyspell-auto-correct-binding) from hijacking C-.
(eval-after-load "flyspell" '(define-key flyspell-mode-map (kbd "C-.") nil))


;; garbage callection ----------------------------------------------------------
;;(defun jrm/minibuffer-setup-hook ()
;;  (setq gc-cons-threshold most-positive-fixnum))

;;(defun jrm/minibuffer-exit-hook ()
;;  (setq gc-cons-threshold 800000))

;;(add-hook 'minibuffer-setup-hook #'jrm/minibuffer-setup-hook)
;;(add-hook 'minibuffer-exit-hook  #'jrm/minibuffer-exit-hook)

;; gnus ------------------------------------------------------------------------
(defun jrm/gnus-group ()
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

;; ido -------------------------------------------------------------------------
;; (ido-mode t)
;; (ido-everywhere 1)
;; (ido-ubiquitous-mode 1)
;; (ido-vertical-mode 1)
;; (setq ido-vertical-define-keys 'C-n-and-C-p-only)
;; (setq ido-vertical-show-count t)

;; helm-bibtex -----------------------------------------------------------------
(setq bibtex-completion-bibliography '("~/scm/references.git/refs.bib"))

;; igor -----------------------------------------------------------------------
(flycheck-define-checker igor
  "FreeBSD Documentation Project sanity checker.

See URLs http://www.freebsd.org/docproj/ and
http://www.freshports.org/textproc/igor/."
  :command ("igor" "-X" source-inplace)
  :error-parser flycheck-parse-checkstyle
  :modes (nxml-mode)
  :standard-input t)

;; register the igor checker for automatic syntax checking
(add-to-list 'flycheck-checkers 'igor 'append)

;; keybindings -----------------------------------------------------------------

;; general stuff
(global-set-key (kbd "M-<f4>")          'save-buffers-kill-emacs)
(global-set-key (kbd "C-c l")           'list-packages)
(global-set-key (kbd "C-c s")           'helm-swoop)
(global-unset-key (kbd "C-h"))
(global-set-key (kbd "C-x h")           'help-command) ; help-key should be set
(global-set-key (kbd "C-<tab>")         'helm-dabbrev)
(global-set-key (kbd "M-SPC")           'cycle-spacing)

;; buffers and windows
(global-set-key (kbd "C-x C-b")         'ibuffer)
(global-set-key (kbd "C-x K")           'kill-buffer-and-its-windows)
(global-set-key (kbd "C-x o")           'ace-window)
(global-set-key (kbd "C-0")             'buffer-fname-to-kill-ring)
(global-set-key (kbd "C-c m")           'magit-status)
(global-set-key (kbd "C-c e c")         'multi-eshell)
(global-set-key (kbd "C-c o a")         'org-agenda)
(global-set-key (kbd "C-c o b")         'org-iswitchb)
(global-set-key (kbd "C-c o c")         'org-capture)
(global-set-key (kbd "C-c o l")         'org-store-link)
(global-set-key (kbd "C-c W")           'wttrin)
(global-set-key (kbd "C-c z")           'jrm/erc)

;; switching buffers
(global-set-key
 (kbd "C-c b")
 (defhydra hydra-buf (:color blue)
   "buf switch"
   ("C"                         jrm/open-calendar           "cfw")
   ("c"                         calendar                    "cal")
   ("d"                         jrm/sb-dired                "dired")
   ("i"                         jrm/sb-erc                  "erc")
   ("e"                         jrm/sb-eshell               "eshell")
   ("g"                         jrm/sb-gnus                 "Gnus")
   ("G"                         jrm/gnus-group              "Group")
   ("m"                         jrm/sb-magit                "magit")
   ("p"                         jrm/sb-pdf                  "pdf")
   ("r"                         jrm/sb-rt                   "R")
   ("s"                         jrm/sb-scratch              "scratch")
   ("t"                         jrm/sb-term                 "term")
   ("w"                         jrm/sb-twit                 "twit")))

;; moving resizing buffers and windows
(global-set-key
 (kbd "C-c w")
 (defhydra hydra-window ()
   "buf/win"
   ("h"                         windmove-left               "wleft")
   ("l"                         windmove-right              "wright")
   ("j"                         windmove-down               "wdown")
   ("k"                         windmove-up                 "wup")
   ("C-h"                       buf-move-left               "bleft")
   ("C-l"                       buf-move-right              "bright")
   ("C-j"                       buf-move-down               "bdown")
   ("C-k"                       buf-move-up                 "bup")
   ("}"                         enlarge-window-horizontally "henlarge")
   ("{"                         shrink-window-horizontally  "hshrink")
   ("^"                         enlarge-window              "venlarge")
   ("s"                         shrink-window               "vshrink")
   ("o"                         ace-maximize-window         "one"    :color blue)
   ("w"                         ace-swap-window             "swap"   :color blue)
   ("3"                         jrm/split-win-right-focus   "sright" :color blue)
   ("2"                         jrm/split-win-below-focus   "sbelow" :color blue)
   ("q"                         nil                         "cancel")))

;; mark and point
(global-set-key (kbd "C-.")     'avy-goto-word-or-subword-1)
(global-set-key (kbd "M-h")     'backward-kill-word)
(global-set-key (kbd "M-?")     'mark-paragraph)
(global-set-key (kbd "M-z")     'avy-zap-to-char-dwim)
(global-set-key (kbd "M-Z")     'avy-zap-up-to-char-dwim)

;; the translation makes C-h work with M-x in the minibuffer
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

;; toggling
(global-set-key
 (kbd "C-x t")
 (defhydra hydra-toggle (:color blue)
   "toggle"
   ("c"                         flycheck-mode               "flycheck")
   ("d"                         toggle-debug-on-error       "debug-on-error")
   ("e"                         erc-track-mode              "erc-track")
   ("f"                         auto-fill-mode              "auto-file")
   ("g"                         git-gutter:toggle           "git-gutter")
   ("i"                         fci-mode                    "fci")
   ("l"                         linum-mode                  "linum")
   ("m"                         menu-bar-mode               "menu-bar")
   ("p"                         paredit-mode                "paredit")
   ("r"                         dired-toggle-read-only      "dired-read-only")
   ("s"                         flyspell-mode               "flyspell")
   ("S"                         sauron-toggle-hide-show     "sauron")
   ("t"                         toggle-truncate-lines       "truncate-lines")
   ("v"                         visual-line-mode            "visual-line")
   ("w"                         whitespace-mode             "whitespace")
   ("q"                         nil                         "cancel")))

;; vcs
(global-set-key
 (kbd "C-c v")
 (defhydra hydra-vcs (:color blue)
   "vcs"
   ("h"                         git-gutter:popup-hunk       "popup-hunk")
   ("m"                         magit-status                "magit")
   ("n"                         git-gutter:next-hunk        "next-hunk")
   ("p"                         git-gutter:previous-hunk    "previous-hunk")
   ("r"                         git-gutter:revert-hunk      "revert-hunk")
   ("s"                         git-gutter:previous-hunk    "stage-hunk")
   ("q"                         nil                         "cancel")))

;; Google
(global-set-key
 (kbd "C-c g")
 (defhydra hydra-google (:color blue)
   "Google"
   ("RET" google-this                      "prompt")
   ("SPC" google-this-noconfirm            "noconfirm")
   ("f"   google-this-forecast             "forecast")
   ("i"   google-this-lucky-and-insert-url "lucky+intert")
   ("w"   google-this-word                 "word")
   ("s"   google-this-symbol               "symbol")
   ("e"   google-this-error                "error")
   ("l"   google-this-line                 "line")
   ("r"   google-this-region               "region")
   ("m"   google-maps                      "maps")
   ("T"   google-translate-at-point        "t8 point")
   ("t"   google-translate-query-translate "t8")
   ("R"   google-this-cpp-reference        "cpp-ref")
   ("L"   google-this-lucky-search         "lucky")
   ("R"   google-this-ray                  "ray")
   ("q"   nil                              "cancel")))

;; webjump
(global-set-key (kbd "C-c j") 'webjump)

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

;;multi-web-mode for lon-capa problems ----------------------------------------
;;(add-hook 'after-init-hook (lambda ()
;;                             (multi-web-global-mode 1)))

;; nnmairix --------------------------------------------------------------------
(require 'nnmairix)

;; noweb -----------------------------------------------------------------------
;;(add-hook 'LaTeX-mode-hook '(lambda ()
;;                              (if (string-match "\\.Rnw\\'" buffer-file-name)
;;                                  (setq fill-column 80))))

;; org-mode --------------------------------------------------------------------
(org-clock-persistence-insinuate)

;; pdf-tools -------------------------------------------------------------------
;; This causes all buttons to be text when starting the emacs daemon
;; with emacsclient -nc -a ''
(pdf-tools-install)

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
(set-register ?S '(file . "~/.emacs.d/secret.el"))
(set-register ?u '(file . "~/.emacs.d/custom.el"))
(set-register ?w '(file . "~/scm/org.git/work.org"))

;; s.el ------------------------------------------------------------------------
(require 's)

;; -----------------------------------------------------------------------------
(defadvice kill-buffer (around kill-buffer-around-advice activate)
  "Bury the scratch buffer, do not kill it."
  (let ((buffer-to-kill (ad-get-arg 0)))
    (if (equal buffer-to-kill "*scratch*")
        (bury-buffer)
      ad-do-it)))

;; sauron ----------------------------------------------------------------------
(require 'sauron)

(setq sauron-nick-insensitivity 5)
(setq sauron-hide-mode-line t)
(setq sauron-modules
     '(sauron-erc sauron-org sauron-notifications sauron-twittering
                  sauron-jabber sauron-identica sauron-elfeed))

(defun jrm/saruon-speak-erc (origin prio msg props)
  "When ORIGIN is erc with priority at least PRIO, say MSG ignoring PROPS."
  (when (eq origin 'erc)
    (call-process-shell-command
     (concat "espeak " "\"ERC alert: "
             (replace-regexp-in-string "\\(jrm\\)?@jrm:" "" msg) "\"&") nil 0)))

(defun jrm/sauron-erc-events-to-block (origin prio msg props)
  "When ORIGIN is erc with priority PRIO, match MSG to block it, ignoring PROPS."
  (when (eq origin 'erc)
    (or
     (string-match "^jrm has joined" msg)
     (string-match "[[:alnum:]]+jrm" msg)
     (string-match "jrm[[:alnum:]]+" msg)
     (string-match "[[:alnum:]]+jrm[[:alnum:]]+" msg))))

(add-hook 'sauron-event-added-functions 'jrm/saruon-speak-erc)
(add-hook 'sauron-event-block-functions 'jrm/sauron-erc-events-to-block)
(sauron-start-hidden)

;; slime/swank -----------------------------------------------------------------
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "~/local/bin/sbcl")

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

;; webjumps --------------------------------------------------------------------
(setq webjump-sites
      '(("aw" . "awarnach.mathstat.dal.ca")
        ("about:blank" . "about:blank")
        ("Brightspace" . "dal.ca/brightspace")
        ("Cambridge Dictionaries Online" . [simple-query "dictionary.cambridge.org" "dictionary.cambridge.org/cmd_search.asp?searchword=" ""])
        ("Capa" . "capa.mathstat.dal.ca")
        ("Coindesk" . "www.coindesk.com")
        ("Dictionary.com" . [simple-query "www.dictionary.com" "www.dictionary.com/cgi-bin/dict.pl?term=" "&db=*"])
        ("DuckDuckGo" . [simple-query "duckduckgo.com" "duckduckgo.com/?q=" ""])
        ("Electronic Frontier Foundation" . "www.eff.org")
        ("Emacs" . "www.gnu.org/software/emacs/emacs.html")
        ("Emacs Wiki" . [simple-query "www.emacswiki.org" "www.emacswiki.org/cgi-bin/wiki/" ""])
        ("FreeBSD Bugs" . "bugs.freebsd.org")
        ("FreeBSD Forums" . "https://forums.freebsd.org/find-new/5741072/posts")
        ("FreeBSD Handbook" . "freebsd.org/handbook")
        ("FreeBSD Porters Handbook" . "www.freebsd.org/doc/en_US.ISO8859-1/books/porters-handbook/book.html")
        ("Freshports" . [simple-query "freshports.org" "http://freshports.org/search.php?query=%s&search=go&num=100&stype=name&method=match&deleted=excludedeleted&start=1&casesensitivity=caseinsensitive" ""])
        ("Github" . "github.com")
        ("Google" . [simple-query "www.google.com" "www.google.com/search?q=" ""])
        ("Google Drive" . "drive.google.com")
        ("Google Images" . [simple-query "images.google.com" "images.google.com/images?q=" ""])
        ("Google Maps" . [simple-query "maps.google.com" "maps.google.com/?force=tt&q=" ""])
        ("Google Plus" . "plus.google.com")
        ("Google Scholar" . [simple-query "scholar.google.com" "scholar.google.com/scholar?q=" ""])
        ("Home" . "ftfl.ca")
        ("Merriam-Webster Dictionary" . [simple-query "www.m-w.com/dictionary" "www.m-w.com/cgi-bin/netdict?va=" ""])
        ("Nagio" . "awarnach.mathstat.dal.ca/nagios")
        ("Packages" . "pkg.awarnach.mathstat.dal.ca")
        ("PC Financial" . "pcfinancial.ca")
        ("RFC" . "www.ietf.org/rfc/rfc")
        ("Stackoverflow" . [simple-query "stackoverflow.com" "stackoverflow.com/search?q" ""])
        ("PGP Key Server" . [simple-query "pgp.mit.edu" "pgp.mit.edu:11371/pks/lookup?op=index&search=" ""])
        ("Project Gutenberg" . webjump-to-gutenberg)
        ("RBC" . "https://www1.royalbank.com/cgi-bin/rbaccess/rbunxcgi%3FF6=1%26F7=IB%26F21=IB%26F22=IB%26REQUEST=ClientSignin%26LANGUAGE=ENGLISH?_ga=1.223022555.1525730850.1448687611")
        ("Roget's Internet Thesaurus" . [simple-query "www.thesaurus.com" "www.thesaurus.com/cgi-bin/htsearch?config=roget&words=" ""])
        ("Savannah Emacs" . "savannah.gnu.org/projects/emacs")
        ("Slashdot" . [simple-query "slashdot.org" "slashdot.org/search.pl?query=" ""])
        ("Twitter" . "twitter.com")
        ("US Patents" . [simple-query "www.uspto.gov/patft/" ,(concat "appft1.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF" "&p=1&u=%2Fnetahtml%2FPTO%2Fsearch-bool.html&r=0&f=S&l=50" "&TERM1=") "&FIELD1=&co1=AND&TERM2=&FIELD2=&d=PG01"])
        ("Wikipedia" . [simple-query "wikipedia.org" "wikipedia.org/wiki/" ""])
        ("Youtube" . [simple-query "www.youtube.com" "www.youtube.com/results?search_query=" ""])
        ("ZNC". "https://ftfl.ca:2222")))

;; yasnippet -------------------------------------------------------------------
;; (yas-global-mode)

;; yes-or-no--------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)

;; custom set varaibles --------------------------------------------------------
;; tell customize to use ' instead of (quote ..) and #' instead of (function ..)
(advice-add 'custom-save-all
            :around (lambda (orig) (let ((print-quoted t)) (funcall orig))))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
