;;; init.el --- My Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; This is my Emacs configuration.  Flycheck expects this section to exist.

;;; Code:

(setq gc-cons-threshold most-positive-fixnum)
(add-to-list 'load-path "~/.emacs.d/elisp/")

;;(require 'benchmark-init-loaddefs)
;;(benchmark-init/activate)
;;(add-hook 'after-init-hook 'benchmark-init/deactivate)

(unless package--initialized (package-initialize t))

;; custom set varaibles --------------------------------------------------------
;; tell customize to use ' instead of (quote ..) and #' instead of (function ..)
(advice-add 'custom-save-all
            :around (lambda (orig) (let ((print-quoted t)) (funcall orig))))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(load-file "~/.emacs.d/secret.el")

;; exwm
;; (require 'exwm)
;; (require 'exwm-randr)

;; (exwm-input-set-key (kbd "C-t") #'exwm-reset)

;; (add-hook 'exwm-update-class-hook
;;           (lambda ()
;;             (exwm-workspace-rename-buffer exwm-class-name)))

;; (setq exwm-randr-workspace-output-plist '(0 "LVDS1" 1 "VGA1")
;;       exwm-workspace-show-all-buffers t
;;       exwm-layout-show-all-buffers t
;;       exwm-input-line-mode-passthrough t)
;; (add-hook 'exwm-randr-screen-change-hook
;;           (lambda ()
;;             (start-process-shell-command
;;              "xrandr" nil "xrandr --output VGA1 --above LVDS1 --auto")))
;; (defun jrm/exwm-launch (command)
;;   (interactive (list (read-shell-command "$ ")))
;;   (start-process-shell-command command nil command))

;; (exwm-randr-enable)

;; (require 'exwm-systemtray)
;; (exwm-systemtray-enable)

;; (exwm-enable)

;; variables that can't be customized ------------------------------------------
(setq scpaste-http-destination "http://ftfl.ca/paste"
      scpaste-scp-destination  "ser.ftfl.ca:/usr/local/www/ftfl.ca/paste"
      scpaste-user-name        "jrm"
      org-irc-link-to-logs     t)

;; enable some functions that are disabled by default --------------------------
(put 'dired-find-alternate-file 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)

;; quick buffer switching by mode ----------------------------------------------
(defun jrm/sbm (prompt mode-list)
  "PROMPT for buffers that have a major mode matching an element of MODE-LIST."
  (let ((blist
         (delq nil
               (mapcar
                (lambda (buf)
                  (with-current-buffer buf
                    (and (member major-mode mode-list) (buffer-name buf))))
                (buffer-list)))))
    (if (null blist)
      nil
      (switch-to-buffer (completing-read prompt blist nil t)))))

(defun jrm/sb-dired ()
  "Switch to Dired buffer."
  (interactive)
  (unless (jrm/sbm "Dired: "  '(dired-mode))
    (when (y-or-n-p "No Dired buffer.  Open one? ")
      (dired (read-directory-name "Directory: ")))))

(defun jrm/sb-erc ()
  "Switch to ERC buffer."
  (interactive)
  (unless (jrm/sbm "Erc: "    '(erc-mode))
    (when (y-or-n-p "ERC is not running.  Start it? ") (jrm/erc))))
(defun jrm/sb-eshell ()
  "Call multi-eshell if necessary, otherwise just call jrm/sb for eshell."
  (interactive)
  (unless (jrm/sbm "Eshell: " '(eshell-mode))
    (when (y-or-n-p "No eshell buffer.  Start one? ") (multi-eshell 1))))
(defun jrm/sb-gnus ()
  "Start Gnus if necessary, otherwise call jrm/sb for Gnus buffers."
  (interactive)
  (autoload 'gnus-alive-p "gnus-util")
  (if
      (null (gnus-alive-p))
      (when (y-or-n-p "Gnus is not running.  Start it? ") (gnus-unplugged))
    (jrm/sbm "Gnus: "   '(gnus-group-mode
                          gnus-summary-mode
                          gnus-article-mode
                          message-mode))))
(defun jrm/sb-magit ()
  "Switch to a magit buffer."
  (interactive)
  (jrm/sbm "Magit: "
           '(magit-diff-mode
             magit-log-mode
             magit-process-mode
             git-rebase-mode
             magit-revision-mode
             magit-status-mode)))
(defun jrm/sb-notmuch ()
  "Switch to a notmuch-hello buffer."
  (interactive)
  (if
      (null (get-buffer "*notmuch-hello*"))
      (notmuch)
    (jrm/sbm "Notmuch: "
             '(notmuch-hello-mode
               notmuch-search-mode
               notmuch-show-mode
               notmuch-tree-mode))))
(defun jrm/sb-pdf ()
  "Switch to a PDF buffer."
  (interactive)
  (jrm/sbm "PDF: "
           '(pdf-view-mode)))

(defun jrm/sb-rt ()
  "Switch to an R or Tex buffer."
  (interactive)
  (unless (jrm/sbm "R/TeX: "
                   '(ess-mode
                     inferior-ess-r-mode
                     latex-mode))
    (when (y-or-n-p "No R buffer.  Start R? ") (R))))

(defun jrm/sb-term ()
  "Switch to term buffer."
  (interactive)
  (jrm/sbm "Term: " '(term-mode)))

(defun jrm/sb-scratch ()
  "Switch to scratch buffer."
  (interactive)
  (switch-to-buffer "*scratch*"))

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

(defun jrm/rename-current-file ()
  "Rename the file associated with the current buffer and visit it."
  (interactive)
  (when (null (buffer-file-name))
    (user-error "Buffer is not associated with a file"))
  (let ((nn (read-file-name (format "New name: "))))
    (when (not (file-writable-p nn)) (user-error "%s is not writable " nn))
    (rename-file (buffer-file-name) nn 1)
    (find-alternate-file nn)))

(defun jrm/getmail ()
  "Retrieve new mail with getmail."
  (interactive)
  (call-process-shell-command "getmail"))

(defun jrm/make ()
  "Call make in the current directory.

When the file ends with .Rnw, visit the generated .pdf file."
  (interactive)
  (call-process-shell-command "make"))
;;  (when (string-match ".Rnw$" (buffer-file-name))
;;    (let ((outfile (replace-regexp-in-string ".Rnw$" ".pdf" (buffer-file-name))))
;;          (find-file outfile))))

;; (defun jrm/sort-lines-nocase ()
;;   "Sort lines ignoring case."
;;   (interactive)
;;   (let ((sort-fold-case t))
;;     (call-interactively 'sort-lines)))

(defun jrm/sort-lines-nocase ()
  "Sort lines in the region, ignoring case."
  (interactive)
  (let ((sort-fold-case t))
    (sort-lines nil (region-beginning) (region-end))))

;; ace-link for various modes --------------------------------------------------
;; needs to be evaluated after init so gnus-*-mode-map are defined
;; (add-hook 'after-init-hook
;;           (lambda ()
;;             (require 'ert)
;;             (ace-link-setup-default (kbd "C-,"))
;;             (define-key ert-results-mode-map  (kbd "C-,") 'ace-link-help)))
(ace-link-setup-default (kbd "C-,"))
(with-eval-after-load 'ert
  (define-key ert-results-mode-map  (kbd "C-,") 'ace-link-help))
(with-eval-after-load 'gnus
  (define-key gnus-summary-mode-map (kbd "C-,") 'ace-link-gnus)
  (define-key gnus-article-mode-map (kbd "C-,") 'ace-link-gnus))
(with-eval-after-load 'gnus-art
  (defvar gnus-summary-mode-map) ;; Suppress Flycheck warning
  (define-key gnus-summary-mode-map (kbd "C-,") 'ace-link-gnus))

;; appointments in the diary (commented b/c using org-mode exclusively now -----
;; without after-init-hook, customized holiday-general-holidays is not respected
;; (add-hook 'after-init-hook (lambda () (appt-activate 1)))

;; beacon ----------------------------------------------------------------------
;;(beacon-mode 1)

;; c/c++ -----------------------------------------------------------------------
;; (add-to-list 'auto-mode-alist '("\\.ii\\'" . c++-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.i\\'" . c-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.lex\\'" . c-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.y\\(acc\\)?\\'" . c-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.h\\'" . c-or-c++-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.c\\'" . c-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.\\(CC?\\|HH?\\)\\'" . c++-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.[ch]\\(pp\\|xx\\|\\+\\+\\)\\'" . c++-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.\\(cc\\|hh\\)\\'" . c++-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.xs\\'" . c-ts-mode))

(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode))

;;(load-file "/usr/src/tools/tools/editing/freebsd.el")

;;(with-eval-after-load 'cc-mode
;;  (push 'company-lsp company-backends))

;;(add-hook 'c-mode-common-hook 'google-set-c-style)
;;(add-hook 'c-mode-common-hook 'google-make-newline-indent)
;;(add-hook 'c-mode-common-hook 'lsp)
;;(add-hook 'c-mode-common-hook 'flycheck-mode)

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
;;(add-hook 'c-mode-common-hook (lambda () (flyspell-prog-mode) (knf)))

;; calfw -----------------------------------------------------------------------
;; Only load calfw after custom-set variables are loaded, otherwise unwated
;; holidays will be shown in calfw and calendar.  This happends because calfw
;; calls (require 'holiday), which sets calendar-holidays using values of,
;; e.g. holiday-bahai-holidays, before they are set to nil.
;; (add-hook 'after-init-hook
;;           (lambda ()
;;             (require 'calfw)
;;             (require 'calfw-cal)
;;             (require 'calfw-org)

;;             (defun jrm/open-calendar ()
;;               (interactive)
;;               (cfw:open-calendar-buffer
;;                :contents-sources
;;                (list
;;                 (cfw:org-create-source "OliveDrab4")
;;                 (cfw:cal-create-source "DarkOrange3"))))))

(defun jrm/open-calendar ()
  "Open calendar."
  (interactive)

  (require 'calfw)
  (require 'calfw-cal)
  (require 'calfw-org)

  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "OliveDrab4")
    (cfw:cal-create-source "DarkOrange3"))))


;; company ---------------------------------------------------------------------
(with-eval-after-load 'company
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "C-<tab>") #'company-complete-selection))

;; dired / dired+ --------------------------------------------------------------
;;(with-eval-after-load 'dired
;;  (require 'dired+))
;;  (toggle-diredp-find-file-reuse-dir 1))

;; emoji -----------------------------------------------------------------------
(add-hook 'server-after-make-frame-hook
          (lambda ()
            (set-fontset-font t 'symbol "Apple Color Emoji")
            (set-fontset-font t 'symbol "Noto Color Emoji" nil 'append)
            (set-fontset-font t 'symbol "Symbola" nil 'append)))

;; erc -------------------------------------------------------------------------
(with-eval-after-load 'erc
  (require 'erc-image)

  ;; track query buffers as if everything contains current nick
  ;; (defadvice erc-track-find-face
  ;;     (around erc-track-find-face-promote-query activate)
  ;;   (if (erc-query-buffer-p)
  ;;       (setq ad-return-value (intern "erc-current-nick-face"))
  ;;     ad-do-it))

  (advice-add 'erc-track-find-face :around
              (lambda (orig-fun &rest args)
                (if (erc-query-buffer-p)
                    (intern "erc-current-nick-face")
                  (apply orig-fun args))))

  (defadvice erc-track-modified-channels
      (around erc-track-modified-channels-promote-query activate)
    (if (erc-query-buffer-p) (setq erc-track-priority-faces-only 'nil))
    ad-do-it
    (if (erc-query-buffer-p) (setq erc-track-priority-faces-only 'all)))

  (advice-add 'erc-track-modified-channels :around
              (lambda (orig-fun &rest args)
                (if (erc-query-buffer-p) (setq erc-track-priority-faces-only 'nil))
                (apply orig-fun args)
                (if (erc-query-buffer-p) (setq erc-track-priority-faces-only 'all))))

  (defun jrm/erc-generate-log-file-name-network (buffer target nick server port)
    "Generate ERC BUFFER log file, TARGET for user NICK on SERVER:PORT.

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

  (defun jrm/erc-open-log-file ()
    "Open the log file for the IRC channel in the current buffer."
    (interactive)
    (require 'erc-networks)
    (if (string= major-mode "erc-mode")
        (find-file (erc-current-logfile))
      (message "This is not an ERC channel buffer.")))

  ;; add to erc-text-matched-hook
  (defun jrm/erc-say-match-text (match-type nickuserhost msg)
    (cond
     ((eq match-type 'current-nick)
      ;;(message msg)
      (unless
          (or
           (string-match "^\\*\\*\\* Users on" msg)
           (string-match "ask jrm or retroj for write access" msg)
           (string-match "topic set by jrm" msg)
           (string-match "^\\(<fbsdslack> \\[[0-9:]+\\] \\)?<jrm> " msg)
           (string-match "^\\*\\*\\* jrm" msg))
        (call-process-shell-command
         (concat "flite -voice /home/" (user-login-name)
                 "/local/share/data/flite/cmu_us_aew.flitevox \"I-R-C matched text: "
                 ;;(replace-regexp-in-string "@?jrm:?,?" "" msg)
                 msg
                 "\"&") nil 0 nil)))))

  ;; to turn off jrm/erc-say-match-text
  ;; (defun jrm/erc-say-match-text ())

  (defun jrm/erc-say-privmsg-alert (proc parsed)
    (let* ((tgt (car (erc-response.command-args parsed)))
           (privp (erc-current-nick-p tgt)))
      (and
       privp
       (call-process-shell-command
        (concat "flite -voice /home/" (user-login-name)
                "/local/share/data/flite/cmu_us_aew.flitevox \
\"I-R-C private message received. " "\"&")
        nil 0)
       nil))) ; Must return nil. See help for `erc-server-PRIVMSG-functions'
  (add-hook 'erc-server-PRIVMSG-functions 'jrm/erc-say-privmsg-alert)

  ;; based on a function from bandali
  (defun jrm/erc-detach-or-kill-channel ()
    (when (erc-server-process-alive)
      (let ((tgt (erc-default-target)))
        (erc-server-send (format "DETACH %s" tgt) nil tgt)))
    (erc-kill-channel))
  (add-hook 'erc-kill-channel-hook #'jrm/erc-detach-or-kill-channel)
  (remove-hook 'erc-kill-channel-hook #'erc-kill-channel))

(defun jrm/erc ()
  "Connect to IRC."
  (interactive)
  (let* ((auth (auth-source-search :host "znc.ftfl.ca"))
         (p (if (null auth)
                (error "Couldn't find znc.ftfl.ca's authinfo")
              (funcall (plist-get (car auth) :secret)))))
    ;; (erc-tls :server "geekshed.ftfl.ca"
    ;;          :port 2222
    ;;          :password (concat "jrm/geekshed:" p))
    (erc-tls :server "efnet.ftfl.ca"
             :port 2222
             :password (concat "jrm/efnet:" p))
    (erc-tls :server "libera.ftfl.ca"
             :port 2222
             :password (concat "jrm/Libera:" p))
    (erc-tls :server "oftc.ftfl.ca"
             :port 2222
             :password (concat "jrm/OFTC:" p))))

;; eshell ----------------------------------------------------------------------
(require 'multi-eshell)

;; Could not get this working as an alias
(defun eshell/gp (&optional port)
  "Go to PORT."
  (cd (concat "/usr/ports/" port))
  nil)

(defun jrm/eshell-visual-ports-make (command args)
  "Run FreeBSD port make commands in a terminal."
  (when (and (or (string-match "scm/freebsd/ports/head" default-directory)
                 (string-match "/usr/ports" default-directory))
             (or
             (and (string-match "make" command)
                  (or (null args)
                      (string-match "config" (car args))))
             (and (or (string-match "sudo" command) (string-match "s" command))
                  (string-match "make" (car args))
                  (or (null (cdr args))
                      (string-match "config" (nth 1 args))))))
    (throw 'eshell-replace-command
           (eshell-parse-command "ls" args))))
;;(apply (eshell-exec-visual (cons command args))))))

(defun jrm/eshell-prompt ()
  "Customize the eshell prompt."
  (concat
   (propertize (user-login-name) 'face '(:foreground "gray"))
   "@"
   (propertize
    (car (split-string (system-name) "[.]")) 'face '(:foreground "gray"))
   " "
   (propertize
    (replace-regexp-in-string
     (concat "^\\(/usr\\)?/home/" (user-login-name)) "~" (eshell/pwd))
    'face '(:foreground "orange"))
   (if (= (user-uid) 0) " # " " % ")))

(defun pcomplete/gp ()
  "Completion for eshell/gp."
  (cd "/usr/ports/")
    (pcomplete-here (pcomplete-dirs)))

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

(defun jrm/eshell-complete-history ()
  "Complete eshell history."
  (interactive)
  (insert (completing-read
           "Eshell history: "
           (delete-dups (ring-elements eshell-history-ring)))))

(add-hook 'eshell-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-r") 'jrm/eshell-complete-history)))


;; ess -------------------------------------------------------------------------
;;(require 'ess-site)
(with-eval-after-load 'ess-r-mode
  (define-key ess-r-mode-map "_" #'ess-insert-assign)
  (define-key inferior-ess-r-mode-map "_" #'ess-insert-assign))

;; flyspell --------------------------------------------------------------------
;; stop flyspell-auto-correct-word from hijacking C-.
;; (customizing flyspell-auto-correct-binding doesn't help)
(eval-after-load "flyspell" '(define-key flyspell-mode-map (kbd "C-.") nil))

;; gnus -----------------------------------------------------------------------
(defun jrm/gnus-article-toggle-visual-line-mode ()
  "Turn on `visual-line-mode' in the current article."
  (interactive)
  (with-current-buffer gnus-article-buffer
    (let ((buffer-read-only nil)
	  (inhibit-point-motion-hooks t))
      (visual-line-mode 'toggle))))

(defun jrm/gnus-article-enable-visual-line-mode ()
  "Turn on `visual-line-mode' in the current article."
  (interactive)
  (with-current-buffer gnus-article-buffer
    (let ((buffer-read-only nil)
	  (inhibit-point-motion-hooks t))
      (visual-line-mode))))

(defun jrm/gnus-group ()
  "Start Gnus if necessary and enter GROUP."
  (interactive)
  (unless (gnus-alive-p) (gnus))
  (let ((group (gnus-group-completing-read "Group: " gnus-active-hashtb t)))
    (gnus-group-read-group nil t group)))

;; Gnus gets loaded on startup if gnus-select-method is customized
(with-eval-after-load 'gnus
  (setq
   gnus-message-archive-group
   '((lambda (group)
       (cond ((message-news-p) nil)
             ((and
               (boundp 'group)
               (< (gnus-group-level group) 4))
              group)
             (t "mail.misc"))))
   gnus-select-method '(nnml ""))
  (add-hook 'gnus-summary-mode-hook 'hl-line-mode))

(with-eval-after-load 'gnus-group
  ;; make quitting Emacs less interactive
  (add-hook 'kill-emacs-hook 'gnus-group-exit)
  (define-key gnus-group-mode-map (kbd "C-k") nil)
  (define-key gnus-group-mode-map (kbd "C-w") nil)
  (define-key gnus-group-mode-map (kbd "u") nil)
  (define-key gnus-group-mode-map (kbd "G n") 'jrm/gnus-notmuch-search))

(with-eval-after-load 'gnus-topic
  (define-key gnus-topic-mode-map (kbd "C-k") nil)
  (define-key gnus-topic-mode-map (kbd "RET")
    (lambda () (interactive) ()
      (gnus-group-select-group 200))))

(defun jrm/toggle-message-fields ()
  "Toggle message header values such as From: for various roles."
  (interactive)
  (save-excursion
    (cond ((string-match (concat user-full-name " <" user-mail-address ">")
                         (message-field-value "From" t))
           (progn
             (message-remove-header "From")
             (message-add-header (concat "From: " user-full-name
                                         " <" user-work-mail-address ">"))
             (message-remove-header "X-Message-SMTP-Method")
             (message-add-header (concat "X-Message-SMTP-Method: smtp "
                                         work-smtp-server " 587 "
                                         user-work-mail-address))
             (unless (string-match (message-field-value "Gcc" t)
                                   user-work-mail-folder)
               (message-remove-header "Gcc")
               (message-add-header (concat "Gcc: " user-work-mail-folder)))
             (turn-off-auto-fill)))

          ((string-match (concat user-full-name " <" user-work-mail-address ">")
                         (message-field-value "From" t))
           (progn
             (message-remove-header "From")
             (message-add-header (concat "From: " user-full-name
                                         " <" user-FreeBSD-mail-address ">"))
             (message-remove-header "X-Message-SMTP-Method")
             (unless (string-match (message-field-value "Gcc" t)
                                   user-FreeBSD-mail-folder)
               (message-remove-header "Gcc")
               (message-add-header (concat "Gcc: " user-FreeBSD-mail-folder)))
             (turn-on-auto-fill)))
          (t
           (message-remove-header "From")
           (message-add-header (concat "From: " user-full-name
                                       " <" user-mail-address ">"))
           (message-add-header (concat "X-Message-SMTP-Method: smtp "
                                       smtpmail-smtp-server " 587 "
                                       user-mail-address))
           (unless (string-match (message-field-value "Gcc" t) "mail.misc")
             (message-remove-header "Gcc")
             (message-add-header "Gcc: mail.misc"))
           (turn-off-auto-fill)))))

(defun jrm/mml-secure-message-sign ()
  "Sign messages only when sending from certain groups."
  (interactive)
  (cond ((string-match "^FreeBSD" gnus-newsgroup-name)
         (mml-secure-message-sign))))

(defun jrm/gnus-set-auto-fill ()
  "Turn on auto-fill."
  (save-excursion
    (cond ((string-match
            (concat user-full-name " <" user-FreeBSD-mail-address ">")
            (message-field-value "From" t))
           (turn-on-auto-fill))
          (t (turn-off-auto-fill)))))

(defun jrm/gnus-notmuch-search ()
  "Pre-populate a notmuch search with a Gnus Group."
  (interactive)
  (let ((group (gnus-group-group-name)))
    (if (not (equal group nil))
        ;;      (notmuch-search (concat "folder:" group))
        (notmuch-search)
      (notmuch-search))))

;; google ----------------------------------------------------------------------
;; Is this the only way to unset google-this-mode key binding?
;; The default conflicts with org-sparse-tree and customizing it does not work.
(setq google-this-keybind (kbd "C-<f12>"))

;; haskell-mode workaround
;; http://emacs.stackexchange.com/questions/28967/haskell-mode-hook-is-nil
;; (setq haskell-mode-hook nil)

(defun jrm/cf-as-root ()
  "Visit the current file with root privileges."
  (interactive)
  ;; Check for remote host (must have sudo root access on remote host)
  (let ((x (buffer-file-name)))
    (cond
     ((null x) (message "Not visiting a file."))
     ((file-writable-p buffer-file-name)
      (message "The file is already writable."))
     ((string-match "^/ssh:\\(.*\\):\\(.*\\)" x)
      (let ( (host (match-string 1 x))
             (path (match-string 2 x)))
        (find-alternate-file (concat "/ssh:" host "|sudo:" host ":" path))))
     (t (find-alternate-file (concat "/sudo::" x))))))

(defun jrm/counsel-find-file-cd-bookmark-action (_)
  "Reset `counsel-find-file' from selected directory."
  (require 'bookmark)
  (bookmark-maybe-load-default-file)
  (ivy-read ": "
       (delq nil (mapcar #'bookmark-get-filename (copy-sequence bookmark-alist)))
       :action (lambda (x)
                 (let ((default-directory (file-name-directory x)))
                   (counsel-find-file)))))

(defun jrm/confirm-delete-file (x)
  "Confirm when deleting file X."
  (dired-delete-file x 'top))

(defun jrm/ff-as-root (x)
  "Find file X as root."
;; Check for remote host (must have sudo root access on remote host)
  (if (string-match "^/ssh:\\(.*\\):\\(.*\\)" x)
      (let ( (host (match-string 1 x))
             (path (match-string 2 x)))
        (find-file (concat "/ssh:" host "|sudo:" host ":" path)))
    (find-file (concat "/sudo::" x))))

(with-eval-after-load "counsel"
  (define-key ivy-minibuffer-map (kbd "C-.") 'ivy-avy)
  (define-key global-map [remap yank-pop] 'counsel-yank-pop)

  (ivy-add-actions
   'counsel-find-file
   `(("b" jrm/counsel-find-file-cd-bookmark-action "bookmark")
     ("r" jrm/ff-as-root "root")
     ("d" jrm/confirm-delete-file "delete")))

  (ivy-add-actions
   'counsel-notmuch
   `(("g" jrm/notmuch-message-to-gnus-article "Gnus")))

  (ivy-set-actions
   'counsel-yank-pop
   '(("t" kill-new "top"))))

;; Does not work, ivy caches something about ivy-height
;; (add-hook 'window-configuration-change-hook
;;           (lambda () (set-variable 'ivy-height
;;                                    (max (/ (window-total-height) 2) 10))))

;; ivy-bibtex -----------------------------------------------------------------
(setq bibtex-completion-bibliography '("~/scm/references.git/refs.bib"))
(with-eval-after-load "ivy-bibtex"
  (global-set-key (kbd "C-c I") 'ivy-bibtex))

;; igor -----------------------------------------------------------------------
;; (with-eval-after-load 'flycheck
;;   (flycheck-define-checker igor
;;     "FreeBSD Documentation Project sanity checker.

;;   See URLs http://www.freebsd.org/docproj/ and
;;   http://www.freshports.org/textproc/igor/."
;;     :command ("igor" "-X" source-inplace)
;;     :error-parser flycheck-parse-checkstyle
;;     :modes (nxml-mode)
;;     :standard-input t))

;;   ;; register the igor checker for automatic syntax checking
;;   ;;(add-to-list 'flycheck-checkers 'igor 'append))

;; keybindings -----------------------------------------------------------------

;; general stuff
(global-set-key (kbd "M-<f4>")          'save-buffers-kill-emacs)
(global-set-key (kbd "<f12>")           'jrm/make)
(global-set-key (kbd "C-c g")           'jrm/getmail)
(global-set-key (kbd "C-c r")           'jrm/cf-as-root)
(global-set-key (kbd "C-c s")           'swiper)
(global-unset-key (kbd "C-h"))
(global-set-key (kbd "C-x h")           'help-command) ; help-key should be set
(global-set-key (kbd "C-x p")           'list-packages)
(global-set-key (kbd "C-x R")           'jrm/rename-current-file)
;;(global-set-key (kbd "C-<tab>")         'helm-dabbrev)
;;(global-set-key (kbd "C-<tab>")         'company-complete)
(global-set-key (kbd "M-SPC")           'cycle-spacing)

;; buffers and windows
(global-set-key (kbd "C-x C-b")         'ibuffer)
(global-set-key (kbd "C-x K")           'kill-buffer-and-window)
(global-set-key (kbd "C-x o")           'ace-window)
(global-set-key (kbd "C-0")             'buffer-fname-to-kill-ring)
(global-set-key (kbd "C-c m")           'magit-status)
(global-set-key (kbd "C-c e c")         'multi-eshell)
(global-set-key (kbd "C-c o a")         'org-agenda)
(global-set-key (kbd "C-c o b")         'org-iswitchb)
(global-set-key (kbd "C-c o c")         'org-capture)
(global-set-key (kbd "C-c o l")         'org-store-link)
(global-set-key (kbd "C-c W")           'wttrin)

;; erc
(global-set-key
 (kbd "C-c i")
 (defhydra hydra-erc (:color blue)
   "erc"
   ("c"                         jrm/erc                     "connect")
   ("l"                         jrm/erc-open-log-file       "log")))

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
   ("n"                         jrm/sb-notmuch              "notmuch")
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
   ("h"                         windmove-left               "wleft"  :color blue)
   ("l"                         windmove-right              "wright" :color blue)
   ("j"                         windmove-down               "wdown"  :color blue)
   ("k"                         windmove-up                 "wup"    :color blue)
   ("H"                         buf-move-left               "bleft"  :color blue)
   ("L"                         buf-move-right              "bright" :color blue)
   ("J"                         buf-move-down               "bdown"  :color blue)
   ("K"                         buf-move-up                 "bup"    :color blue)
   ("<right>"                   enlarge-window-horizontally "henlarge")
   ("<left>"                    shrink-window-horizontally  "hshrink")
   ("<up>"                      enlarge-window              "venlarge")
   ("<down>"                    shrink-window               "vshrink")
   ("o"                         ace-maximize-window         "one"    :color blue)
   ("r"                         winner-redo                 "wredo"  :color blue)
   ("s"                         ace-swap-window             "swap"   :color blue)
   ("u"                         winner-undo                 "wundo"  :color blue)
   ("3"                         jrm/split-win-right-focus   "sright" :color blue)
   ("2"                         jrm/split-win-below-focus   "sbelow" :color blue)
   ("q"                         nil                         "cancel")))

;; mark and point
(global-set-key (kbd "C-.")     'avy-goto-word-or-subword-1)
(global-set-key (kbd "M-h")     'backward-kill-word)
(global-set-key (kbd "M-?")     'mark-paragraph)
(global-set-key (kbd "M-z")     'avy-zap-to-char-dwim)
(global-set-key (kbd "M-Z")     'avy-zap-up-to-char-dwim)

;; notmuch
(autoload 'notmuch "notmuch" "notmuch mail" t)
(with-eval-after-load "notmuch"
  (define-key notmuch-show-mode-map
    (kbd "C-c C-c") 'jrm/notmuch-message-to-gnus-article)
  (define-key notmuch-tree-mode-map
    (kbd "C-c C-c") 'jrm/notmuch-message-to-gnus-article))

;; origami code folding
(global-set-key
 (kbd "C-c f")
 (defhydra hydra-origami (:color teal :hint nil)
   "
_o_pen node, _c_lose node, _n_ext fold, _p_revious fold, toggle _f_orward, \
toggle _a_ll _q_uit
"
   ("o" origami-open-node)
   ("c" origami-close-node)
   ("n" origami-next-fold)
   ("p" origami-previous-fold)
   ("f" origami-forward-toggle-node)
   ("a" origami-toggle-all-nodes)
   ("q" nil)))

;; translation to make C-h work with M-x in the minibuffer
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

;; toggling
(global-set-key
 (kbd "C-x t")
 (defhydra hydra-toggle (:color blue :hint nil)
   "
fly_c_heck _d_ebug _e_rc-track auto-_f_ill _g_it-gutter _h_l-line fc_i_ \
_l_ine-numbers _m_enu _p_aredit fly_s_pell _S_auron _t_runcate _v_isual \
_w_hitspace _q_uit"
   ("c"  flycheck-mode)
   ("d"  toggle-debug-on-error)
   ("e"  erc-track-mode)
   ("f"  auto-fill-mode)
   ("g"  git-gutter:toggle)
   ("h"  hl-line-mode)
   ("i"  fci-mode)
   ("l"  display-line-numbers-mode)
   ("m"  menu-bar-mode)
   ("p"  paredit-mode)
   ("s"  flyspell-mode)
   ("S"  sauron-toggle-hide-show)
   ("t"  toggle-truncate-lines)
   ("v"  visual-line-mode)
   ("w"  whitespace-mode)
   ("q"  nil)))

;; tramp
;;(run-with-idle-timer 1 nil (lambda () (require 'tramp)))
;;(with-eval-after-load 'tramp
;;  (setq tramp-use-ssh-controlmaster-options nil))

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
 (kbd "C-c G")
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
;;(key-chord-mode 1)
;;(key-chord-define-global "jf" 'forward-to-word)
;;(key-chord-define-global "jb" 'backward-to-word)
;;(key-chord-define-global "jg" 'avy-goto-line)
;;(key-chord-define-global "jx" 'multi-eshell)

;; lsp (language server protocol) ----------------------------------------------
(add-hook 'lsp-mode-hook
          (lambda ()
            (lsp-ui-mode)
            (local-set-key
             (kbd "C-c l")
             (defhydra hydra-lsp (:color blue :hint nil)
   "
_d_efinition _i_menu _p_op _r_eferences _s_ideline _q_uit"
   ("d"  lsp-ui-peek-find-definitions)
   ("i"  lsp-ui-imenu)
   ("p"  xref-pop-marker-stack)
   ("r"  lsp-ui-peek-find-references)
   ("s"  lsp-ui-sideline-mode)
   ("q"  nil)))))

;; magithub --------------------------------------------------------------------
;; (with-eval-after-load 'magit
;;   (require 'magithub)
;;   (magithub-feature-autoinject t)
;;   (setq ghub-username 'Jehops))

;; magit-todo --------------------------------------------------------------------
;;(with-eval-after-load 'magit
;;  (magit-todos-mode))

;; Make (FreeBSD ports)
(defun portfmt (&optional b e)
  "Format FreeBSD port Makefile region (B to E) with PORTFMT(1)."
  (interactive "r")
  (shell-command-on-region b e "portfmt " (current-buffer) t
                           "*portfmt errors*" t))
(with-eval-after-load 'make-mode
  (define-key makefile-bsdmake-mode-map (kbd "C-c p") 'portfmt))

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
(add-to-list 'auto-mode-alist '("\\.problem\\'" . multi-web-mode))
;;(add-hook 'after-init-hook (lambda ()
;;                             (multi-web-global-mode 1)))

;; noweb -----------------------------------------------------------------------
;;(add-hook 'LaTeX-mode-hook '(lambda ()
;;                              (if (string-match "\\.Rnw\\'" buffer-file-name)
;;                                  (setq fill-column 80))))

;; operating control sequence (ocs) 52 -----------------------------------------
(require 'osc52e)
(osc52-set-cut-function)

;; org-mode --------------------------------------------------------------------
(autoload 'org-agenda "org-agenda")
(with-eval-after-load 'org
  (org-clock-persistence-insinuate)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; notmuch ---------------------------------------------------------------------
(defun jrm/notmuch-message-to-gnus-article ()
  "Open a summary buffer containing the current notmuch article."
  (interactive)
  (autoload 'org-gnus-follow-link "ol-gnus")
  (let ((group
         (replace-regexp-in-string
          "/" "."
          (replace-regexp-in-string
           "Stashed: /home/jrm/Mail/\\(.*\\)/[[:digit:]]+" "\\1"
           (notmuch-show-stash-filename))))
        (article
         (replace-regexp-in-string
          "[^[:digit:]]*\\([[:digit:]]+\\)" "\\1"
          (notmuch-show-stash-filename))))
    (if (and group article)
        (org-gnus-follow-link group article)
      (message "Unable to switch to Gnus article."))))

;; nov.el
(add-to-list 'auto-mode-alist '("\\.[eE][pP][uU][bB]\\'" . nov-mode))

;; pdf-tools -------------------------------------------------------------------
(load "pdf-tools-init.el")
;; `p' at the top of a page will show the bottom of the previous page
;; `n' at the bottom of a page will show the top of the next page
(with-eval-after-load 'pdf-tools
  (define-key pdf-view-mode-map (kbd "p")
    (lambda (&optional n)
      (interactive "p")
      (pdf-view-next-page (- (or n 1)))
      (image-eob)))
  (define-key pdf-view-mode-map (kbd "n")
    (lambda (&optional n)
      (interactive "p")
      (pdf-view-goto-page (+ (pdf-view-current-page)
                             (or n 1)))
      (image-bob))))

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

;; registers -------------------------------------------------------------------
(set-register ?c '(file . "~/scm/org.git/capture.org"))
(set-register ?C '(file . "~/scm/org.git/capture.org"))
(set-register ?d '(file . "~/scm/org.git/diary.org"))
(set-register ?f '(file . "~/scm/org.git/ff.org"))
(set-register ?g '(file . "~/scm/freebsd/ports/head"))
(set-register ?i '(file . "~/.emacs.d/init.el"))
(set-register ?P '(file . "~/files/crypt/passwords.org.gpg"))
(set-register ?p '(file . "/ssh:ser.ftfl.ca:/usr/ports/"))
(set-register ?r '(file . "~/scm/org.git/research.org"))
(set-register ?s '(file . "~/scm/org.git/sites.org"))
(set-register ?S '(file . "~/.emacs.d/secret.el"))
(set-register ?t '(file . "~/scm/thesis.git/thesis.Rnw"))
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

;; new version with flite
(defun jrm/sauron-speak-erc (origin prio msg props)
  "When ORIGIN is erc with priority at least PRIO, say MSG ignoring PROPS."
  (when (eq origin 'erc)
    (call-process-shell-command
     (concat "flite -voice /home/" (user-login-name)
             "/local/share/data/flite/cmu_us_aew.flitevox \"I-R-C message: "
             msg "\"&") nil 0)))

(defun jrm/sauron-erc-events-to-block (origin prio msg props)
  "When ORIGIN is erc with priority PRIO, match MSG to block it, ignoring PROPS."
  (when (eq origin 'erc)
    (or
     (string-match "^jrm has joined" msg)
     (string-match "[[:alnum:]]+jrm" msg)
     (string-match "jrm[[:alnum:]]+" msg)
     (string-match "[[:alnum:]]+jrm[[:alnum:]]+" msg))))

(add-hook 'sauron-event-added-functions 'jrm/sauron-speak-erc)
(add-hook 'sauron-event-block-functions 'jrm/sauron-erc-events-to-block)

;; scratch ---------------------------------------------------------------------
;; Do not put this in custom.el, because it screws up indentation
(setq initial-scratch-message
      (format ";; %s\n\n"
              (replace-regexp-in-string "\n" "\n;; "
                                        (shell-command-to-string
                                         "/usr/bin/fortune freebsd-tips"))))

;; slime/swank -----------------------------------------------------------------
;;(load (expand-file-name "~/.quicklisp/slime-helper.el"))
(setq inferior-lisp-program "/usr/local/bin/sbcl")

;;(require 'slime)
;;(with-eval-after-load 'slime
;;  (slime-setup '(slime-company slime-fancy)))

;; smart mode line -------------------------------------------------------------
(sml/setup)

;; transpar (transpose-paragraph-as-table) -------------------------------------
(autoload 'transpose-paragraph-as-table "transpar"
  "Transpose paragraph as table." t)

;; undo-tree -------------------------------------------------------------------
(global-undo-tree-mode)

;; yasnippet -------------------------------------------------------------------
;; (yas-global-mode)

;; yes-or-no--------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)

(setq gc-cons-threshold 800000)

;;; init.el ends here
