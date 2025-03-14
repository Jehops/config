;;; -*- lexical-binding: t -*-

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
   '(("pv" "pv %o&") ("emacs" "emacsclient -n %o") ("xpdf" "xpdf %o&")))
 '(TeX-view-program-selection
   '((output-pdf "PDF Tools" "emacs" "pv" "xpdf")
     ((output-dvi style-pstricks) "dvips and gv") (output-dvi "xdvi")
     (output-html "xdg-open")))
 '(ac-dictionary-files '("~/.emacs/ac-dict"))
 '(add-to-list 'default-frame-alist t)
 '(ansi-color-names-vector
   ["black" "red" "green" "yellow" "sky blue" "magenta" "cyan" "white"])
 '(auto-save-file-name-transforms '((".*/\\([^/]*\\)" "~/.emacs.d/auto-saves/\\1" t)))
 '(avy-keys
   '(97 115 100 102 103 104 106 107 108 113 119 101 114 116 121 117 105 111 112 122
        120 99 118 98 110 109 65 83 68 70 71 72 74 75 76 81 87 69 82 84 89 85 73
        79 80 90 88 67 86 66 78 77))
 '(avy-style 'post)
 '(aw-keys '(97 115 100 102 103 104 106 107 108))
 '(aw-scope 'frame)
 '(backup-directory-alist '(("." . "~/.emacs.d/backups/")))
 '(bbdb-complete-mail-allow-cycling t)
 '(bbdb-mua-pop-up nil)
 '(before-save-hook '(time-stamp))
 '(bibtex-completion-library-path '("~/files/edu/papers"))
 '(blink-cursor-mode nil)
 '(browse-kill-ring-highlight-current-entry t)
 '(browse-kill-ring-show-preview nil)
 '(browse-url-chrome-program "chrome")
 '(browse-url-conkeror-program "ck")
 '(browse-url-generic-program "~/local/bin/ck")
 '(browse-url-mailto-function 'browse-url-mail)
 '(browse-url-secondary-browser-function 'browse-url-chrome)
 '(c-ts-mode-indent-style 'bsd)
 '(calendar-date-style 'iso)
 '(calendar-latitude 44.630294)
 '(calendar-location-name "Halifax, NS")
 '(calendar-longitude -63.582304)
 '(calendar-mark-diary-entries-flag t)
 '(calendar-mark-holidays-flag t)
 '(calendar-time-display-form
   '(24-hours ":" minutes (if time-zone " (") time-zone (if time-zone ")")))
 '(calendar-today-visible-hook '(calendar-mark-today))
 '(calendar-week-start-day 1)
 '(column-number-mode t)
 '(compilation-window-height 6)
 '(counsel-mode t)
 '(counsel-yank-pop-preselect-last t)
 '(counsel-yank-pop-separator "\12---------------------------\12")
 '(custom-buffer-done-kill t)
 '(custom-safe-themes
   '("fc1275617f9c8d1c8351df9667d750a8e3da2658077cfdda2ca281a2ebc914e0"
     "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))
 '(delete-old-versions 'other)
 '(desktop-restore-forces-onscreen nil)
 '(diary-comment-end "*/")
 '(diary-comment-start "/*")
 '(diary-file "~/.emacs.d/diary")
 '(diary-list-entries-hook '(diary-include-other-diary-files diary-sort-entries))
 '(dired-auto-revert-buffer 'dired-directory-changed-p)
 '(dired-dwim-target t)
 '(dired-listing-switches "-alh")
 '(dired-use-ls-dired nil)
 '(diredp-hide-details-initially-flag nil)
 '(diredp-wrap-around-flag nil)
 '(doc-view-continuous t)
 '(doc-view-pdftotext-program "/usr/local/libexec/xpdf/pdftotext")
 '(echo-keystrokes 0.5)
 '(emoji-fontset-default-font-family "Apple Color Emoji")
 '(epg-pinentry-mode 'loopback)
 '(erc-autojoin-domain-only nil)
 '(erc-buffer-display 'bury)
 '(erc-email-userid "jrm")
 '(erc-generate-log-file-name-function 'jrm/erc-generate-log-file-name-network)
 '(erc-hl-nicks-mode t nil (erc-hl-nicks))
 '(erc-hl-nicks-skip-faces
   '("erc-notice-face" "erc-pal-face" "erc-fool-face" "erc-my-nick-face"
     "erc-current-nick-face" "erc-direct-msg-face"))
 '(erc-hl-nicks-skip-nicks '("fbsdslack"))
 '(erc-image-inline-rescale 200)
 '(erc-insert-away-timestamp-function 'erc-insert-timestamp-left)
 '(erc-insert-post-hook
   '(erc-make-read-only erc-save-buffer-in-logs erc-track-modified-channels))
 '(erc-insert-timestamp-function 'erc-insert-timestamp-left)
 '(erc-log-channels-directory "~/.emacs.d/.erc/logs")
 '(erc-log-write-after-insert t)
 '(erc-log-write-after-send t)
 '(erc-match-exclude-server-buffer t)
 '(erc-mode-hook
   '(pcomplete-erc-setup erc-stamp--recover-on-reconnect
                         erc-munge-invisibility-spec erc-move-to-prompt-setup
                         erc-imenu-setup visual-line-mode))
 '(erc-modules
   '(autojoin button completion imenu irccontrols list log match menu
              move-to-prompt netsplit networks noncommands readonly ring
              spelling stamp track hl-nicks image))
 '(erc-nick "jrm")
 '(erc-port 2222)
 '(erc-prompt-for-password nil)
 '(erc-rename-buffers t)
 '(erc-server-reconnect-attempts 5)
 '(erc-server-reconnect-timeout 3)
 '(erc-text-matched-hook '(erc-log-matches jrm/erc-say-match-text))
 '(erc-timestamp-format "[%Y-%m-%d %k:%M] ")
 '(erc-track-exclude-types
   '("JOIN" "NICK" "PART" "QUIT" "MODE" "305" "306" "324" "329" "332" "333" "353"
     "477"))
 '(erc-track-faces-priority-list
   '(erc-error-face (erc-nick-default-face erc-current-nick-face)
                    erc-current-nick-face erc-keyword-face
                    (erc-nick-default-face erc-pal-face) erc-pal-face
                    erc-nick-msg-face erc-direct-msg-face
                    (erc-nick-default-face erc-dangerous-host-face)
                    erc-dangerous-host-face
                    (erc-nick-default-face erc-fool-face) erc-fool-face
                    erc-notice-face erc-input-face erc-prompt-face))
 '(erc-track-priority-faces-only 'all)
 '(erc-track-showcount t)
 '(erc-truncate-mode nil)
 '(erc-whowas-on-nosuchnick t)
 '(eshell-aliases-file "~/.emacs.d/eshell/alias")
 '(eshell-banner-load-hook nil)
 '(eshell-banner-message "")
 '(eshell-cmpl-cycle-completions nil)
 '(eshell-cmpl-use-paring nil)
 '(eshell-command-completions-alist
   '(("CC" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("acc" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'") ("acroread" . "\\.pdf\\'")
     ("adb" . "\\`\\([^.]*\\|a\\.out\\)\\'") ("ar" . "\\.[ao]\\'")
     ("bcc" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("cc" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("clang" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("clang++" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("dbx" . "\\`\\([^.]*\\|a\\.out\\)\\'")
     ("g++" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("gcc" . "\\.[Cc]\\([Cc]\\|[Pp][Pp]\\)?\\'")
     ("gdb" . "\\`\\([^.]*\\|a\\.out\\)\\'") ("gunzip" . "\\.gz\\'")
     ("nm" . "\\(\\`[^.]*\\|\\.\\([ao]\\|so\\)\\)\\'")
     ("objdump" . "\\(\\`[^.]*\\|\\.\\([ao]\\|so\\)\\)\\'")
     ("readelf" . "\\(\\`[^.]*\\|\\.\\([ao]\\|so\\)\\)\\'")
     ("sdb" . "\\`\\([^.]*\\|a\\.out\\)\\'") ("xpdf" . "\\.pdf\\'")))
 '(eshell-cp-interactive-query t)
 '(eshell-first-time-mode-hook '((lambda nil (setenv "PAGER" "cat"))))
 '(eshell-glob-include-dot-files nil)
 '(eshell-glob-show-progress t)
 '(eshell-highlight-prompt nil)
 '(eshell-hist-ignoredups t)
 '(eshell-history-file-name "~/.emacs.d/eshell/history")
 '(eshell-history-size 10000)
 '(eshell-last-dir-ring-file-name "~/.emacs.d/eshell/lastdir")
 '(eshell-modules-list
   '(eshell-alias eshell-banner eshell-basic eshell-cmpl eshell-dirs eshell-glob
                  eshell-hist eshell-ls eshell-pred eshell-prompt eshell-script
                  eshell-term eshell-unix eshell-xtra))
 '(eshell-mv-interactive-query t)
 '(eshell-mv-overwrite-files nil)
 '(eshell-named-command-hook '(jrm/eshell-visual-ports-make))
 '(eshell-output-filter-functions
   '(eshell-handle-control-codes eshell-handle-ansi-color
                                 eshell-watch-for-password-prompt))
 '(eshell-prompt-function 'jrm/eshell-prompt)
 '(eshell-prompt-regexp "^[^%#]*@[^%#]*[#%] ")
 '(eshell-pwd-convert-function 'expand-file-name)
 '(eshell-review-quick-commands t)
 '(eshell-rm-interactive-query t)
 '(eshell-visual-commands
   '("htop" "cdiff" "less" "links" "lynx" "more" "ncftp" "mplayer" "mpv"
     "portmaster" "top" "trn" "unison" "vi" "vipw" "ncdu"))
 '(eshell-visual-options nil)
 '(eshell-visual-subcommands '(("git" "clog" "diff" "log" "show") ("make") ("config")))
 '(ess-ask-for-ess-directory nil)
 '(ess-eval-visibly nil)
 '(ess-history-directory "~/")
 '(ess-swv-pdflatex-commands '("latexmk"))
 '(ess-swv-processor 'knitr)
 '(ess-transcript-mode-hook '(ess-S-mouse-me-menu-commands turn-on-font-lock))
 '(eval-expression-print-length 500)
 '(eyebrowse-close-window-config-prompt t)
 '(eyebrowse-keymap-prefix "\3^w")
 '(eyebrowse-mode t)
 '(eyebrowse-mode-line-separator " ")
 '(eyebrowse-wrap-around t)
 '(fill-column 80)
 '(fill-flowed-display-column '(- (window-width) 5))
 '(flycheck-checkers
   '(ada-gnat asciidoctor asciidoc c/c++-clang c/c++-gcc c/c++-cppcheck cfengine
              chef-foodcritic coffee coffee-coffeelint coq css-csslint
              css-stylelint cwl d-dmd dockerfile-hadolint emacs-lisp
              emacs-lisp-checkdoc erlang-rebar3 erlang eruby-erubis
              fortran-gfortran go-gofmt go-golint go-vet go-build go-test
              go-errcheck go-unconvert go-megacheck groovy haml handlebars
              haskell-stack-ghc haskell-ghc haskell-hlint html-tidy
              javascript-eslint javascript-jshint javascript-standard
              json-jsonlint json-python-json jsonnet less less-stylelint
              llvm-llc lua-luacheck lua markdown-markdownlint-cli markdown-mdl
              nix perl perl-perlcritic php php-phpmd php-phpcs processing
              proselint protobuf-protoc pug puppet-parser puppet-lint
              python-flake8 python-pylint python-pycompile python-mypy r-lintr
              racket rpm-rpmlint rst-sphinx rst ruby-rubocop ruby-reek
              ruby-rubylint ruby ruby-jruby rust-cargo rust rust-clippy scala
              scala-scalastyle scheme-chicken scss-lint scss-stylelint
              sass/scss-sass-lint sass scss sh-bash sh-posix-dash sh-posix-bash
              sh-zsh sh-shellcheck slim slim-lint sql-sqlint systemd-analyze
              tcl-nagelfar tex-chktex tex-lacheck texinfo typescript-tslint
              verilog-verilator vhdl-ghdl igor xml-xmlstarlet xml-xmllint
              yaml-jsyaml yaml-ruby))
 '(flycheck-xml-xmlstarlet-executable "/usr/local/bin/xml")
 '(flymake-log-level 3)
 '(gdb-many-windows t)
 '(git-commit-setup-hook
   '(git-commit-save-message git-commit-setup-changelog-support
                             git-commit-turn-on-auto-fill
                             git-commit-turn-on-flyspell
                             git-commit-propertize-diff
                             with-editor-usage-message))
 '(git-gutter:modified-sign "*")
 '(global-auto-revert-mode t)
 '(global-company-mode t)
 '(gnus-activate-level 4)
 '(gnus-after-getting-new-news-hook '(gnus-display-time-event-handler))
 '(gnus-agent-auto-agentize-methods nil)
 '(gnus-agent-go-online t)
 '(gnus-agent-queue-mail nil)
 '(gnus-article-date-headers '(local))
 '(gnus-article-prepare-hook
   '(bbdb-mua-auto-update jrm/gnus-article-enable-visual-line-mode))
 '(gnus-auto-subscribed-groups "nil")
 '(gnus-check-new-newsgroups nil)
 '(gnus-cite-blank-line-after-header nil)
 '(gnus-cite-face-list
   '(gnus-cite-1 gnus-cite-2 gnus-cite-3 gnus-cite-4 gnus-cite-5 gnus-cite-6
                 gnus-cite-7 gnus-cite-8 gnus-cite-9 gnus-cite-10))
 '(gnus-exit-gnus-hook '(mm-destroy-postponed-undisplay-list))
 '(gnus-group-catchup-group-hook '(gnus-topic-update-topic))
 '(gnus-group-mode-hook '(gnus-topic-mode gnus-agent-mode hl-line-mode))
 '(gnus-inhibit-mime-unbuttonizing t)
 '(gnus-inhibit-startup-message t)
 '(gnus-init-file "~/.emacs.d/gnus.el")
 '(gnus-interactive-exit nil)
 '(gnus-message-archive-method '(nnml ""))
 '(gnus-message-setup-hook
   '(message-remove-blank-cited-lines turn-off-auto-fill
                                      jrm/mml-secure-message-sign))
 '(gnus-read-newsrc-file nil)
 '(gnus-refer-thread-limit 5000)
 '(gnus-save-duplicate-list t)
 '(gnus-save-newsrc-file nil)
 '(gnus-search-default-engines '((nnimap . imap) (nntp . gmane) (nnml . notmuch)))
 '(gnus-secondary-select-methods
   '((nntp "news.gmane.io" (nntp-open-connection-function nntp-open-plain-stream))
     (nntp "news.freelists.org" (nntp-port-number 563)
           (nntp-open-connection-function nntp-open-tls-stream))))
 '(gnus-started-hook '((lambda nil (gnus-group-jump-to-group "mail.misc"))))
 '(gnus-startup-file "~/.emacs.d/newsrc")
 '(gnus-subthread-sort-functions '(gnus-thread-sort-by-number))
 '(gnus-sum-thread-tree-false-root "⚇")
 '(gnus-sum-thread-tree-indent "   ")
 '(gnus-sum-thread-tree-leaf-with-other "├――►")
 '(gnus-sum-thread-tree-root "●")
 '(gnus-sum-thread-tree-single-indent "○")
 '(gnus-sum-thread-tree-single-leaf "└――►")
 '(gnus-sum-thread-tree-vertical "│  ")
 '(gnus-summary-line-format
   "%U%R %5N %6k %24&user-date; │ %~(max-right 75)~(pad-right 75)S │ %B %f\12")
 '(gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references)
 '(gnus-suppress-duplicates t)
 '(gnus-thread-sort-functions '(gnus-thread-sort-by-most-recent-number))
 '(gnus-treat-display-smileys nil)
 '(gnus-treat-fill-long-lines nil)
 '(gnus-user-agent '(gnus emacs))
 '(gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
 '(gnutls-min-prime-bits 1024)
 '(gnutls-verify-error t)
 '(google-translate-default-target-language "en")
 '(haskell-mode-hook
   '(capitalized-words-mode flyspell-prog-mode haskell-decl-scan-mode
                            haskell-indent-mode interactive-haskell-mode))
 '(haskell-stylish-on-save t)
 '(help-char 67)
 '(holiday-bahai-holidays nil)
 '(holiday-general-holidays
   '((holiday-fixed 1 1 "New Year's Day")
     (holiday-float 1 1 3 "Martin Luther King Day (US)")
     (holiday-fixed 2 2 "Groundhog Day") (holiday-fixed 2 14 "Valentine's Day")
     (holiday-float 2 1 3 "President's Day (US)")
     (holiday-fixed 3 17 "St. Patrick's Day")
     (holiday-fixed 4 1 "April Fools' Day") (holiday-float 5 0 2 "Mother's Day")
     (holiday-float 5 1 -1 "Memorial Day (US)")
     (holiday-float 5 1 -1 "Victoria Day (CA)" 24)
     (holiday-fixed 6 14 "Flag Day (US)") (holiday-float 6 0 3 "Father's Day")
     (holiday-fixed 7 1 "Canada Day")
     (holiday-fixed 7 4 "Independence Day (US)")
     (holiday-float 8 1 1 "Civic (CA)") (holiday-float 9 1 1 "Labor Day")
     (holiday-float 10 1 2 "Columbus Day (US) Thanksgiving (CA)")
     (holiday-fixed 10 31 "Halloween")
     (holiday-fixed 11 11 "Remeberance Day (CA) Veteran's Day (US)")
     (holiday-float 11 4 4 "Thanksgiving (US)")
     (holiday-fixed 12 26 "Boxing Day (CA)")))
 '(holiday-hebrew-holidays nil)
 '(holiday-islamic-holidays nil)
 '(htmlize-ignore-face-size nil)
 '(ibuffer-always-compile-formats nil)
 '(ibuffer-default-sorting-mode 'alphabetic)
 '(ibuffer-maybe-show-predicates
   '("^\\*ESS\\*" "^\\*Compile"
     (lambda (buf)
       (and (string-match "^ " (buffer-name buf)) (null buffer-file-name)))))
 '(ibuffer-mode-hook
   '((lambda nil (ibuffer-switch-to-saved-filter-groups "default"))
     pdf-occur-ibuffer-minor-mode))
 '(ibuffer-saved-filter-groups
   '(("default" ("dired" (mode . dired-mode))
      ("emacs"
       (or (mode . Custom-mode) (name . "^\\*scratch\\*$")
           (name . "^\\*Messages\\*$")))
      ("erc" (mode . erc-mode)) ("eshell" (mode . eshell-mode))
      ("gnus"
       (or (mode . message-mode) (mode . bbdb-mode) (mode . mail-mode)
           (mode . gnus-group-mode) (mode . gnus-summary-mode)
           (mode . gnus-article-mode) (name . "^\\.?bbdb$")
           (name . "^\\.?newsrc-dribble")))
      ("help" (mode . help-mode))
      ("LaTeX" (or (mode . latex-mode) (name . "^.*\\.Rnw")))
      ("magit"
       (or (mode . magit-diff-mode) (mode . magit-log-mode)
           (mode . magit-process-mode) (mode . magit-revision-mode)
           (mode . magit-status-mode)))
      ("planning"
       (or (name . "^\\*Calendar\\*$") (name . "^diary$") (name . ".*\\.org")
           (mode . org-agenda-mode) (name . "^\\*\\Holidays\\*$")
           (mode . muse-mode)))
      ("programming"
       (or (mode . emacs-lisp-mode) (mode . cperl-mode) (mode . c-mode)
           (mode . java-mode) (mode . idl-mode) (mode . lisp-mode)))
      ("R" (or (mode . ess-mode) (mode . inferior-ess-mode))))))
 '(ibuffer-saved-filters
   '(("gnus"
      ((or (mode . message-mode) (mode . mail-mode) (mode . gnus-group-mode)
           (mode . gnus-summary-mode) (mode . gnus-article-mode))))
     ("programming"
      (or (mode . emacs-lisp-mode) (mode . cperl-mode) (mode . c-mode)
          (mode . java-mode) (mode . idl-mode) (mode . lisp-mode)))))
 '(ido-default-buffer-method 'selected-window)
 '(ido-enable-flex-matching t)
 '(indent-tabs-mode nil)
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(ispell-help-in-bufferp 'electric)
 '(ivy-count-format "")
 '(ivy-fixed-height-minibuffer t)
 '(ivy-height 25)
 '(ivy-mode t)
 '(kill-do-not-save-duplicates t)
 '(kill-ring-max 100)
 '(kill-whole-line t)
 '(line-number-display-limit-width 10000)
 '(lsp-clients-clangd-executable "/usr/local/bin/clangd13")
 '(lsp-enable-eldoc nil)
 '(lsp-prefer-flymake nil)
 '(lsp-ui-doc-enable nil)
 '(lsp-ui-sideline-enable nil)
 '(magit-repository-directories '(("/ssh:ser:/usr/ports" . 0)))
 '(mail-sources
   '((maildir :path "/home/jrm/mail/" :plugged t)
     (maildir :path "/home/jrm/mail/noalert/" :plugged t)
     (file :path "/var/mail/jrm" :plugged t)))
 '(mail-user-agent 'gnus-user-agent)
 '(major-mode 'text-mode)
 '(mastodon-instance-url "https://bsd.network")
 '(menu-bar-mode nil)
 '(message-citation-line-format "On %a, %Y-%m-%d at %R, %f wrote:\12")
 '(message-citation-line-function 'message-insert-formatted-citation-line)
 '(message-kill-buffer-on-exit t)
 '(message-log-max 16384)
 '(message-mode-hook
   '((lambda nil (local-set-key (kbd "C-c C-f o") 'jrm/toggle-message-fields))
     flyspell-mode visual-line-mode))
 '(message-setup-hook '(message-check-recipients bbdb-insinuate-message))
 '(mm-attachment-override-types
   '("text/x-vcard" "application/pkcs7-mime" "application/x-pkcs7-mime"
     "application/pkcs7-signature" "application/x-pkcs7-signature" "image/.*"))
 '(mm-discouraged-alternatives '("text/html" "text/richtext"))
 '(mm-inline-large-images 'resize)
 '(mm-verify-option 'known)
 '(mml-secure-openpgp-encrypt-to-self t)
 '(mml-secure-openpgp-sign-with-sender t)
 '(mml-secure-smime-encrypt-to-self t)
 '(mml-secure-smime-sign-with-sender t)
 '(mml-smime-passphrase-cache-expiry 604800)
 '(mml2015-passphrase-cache-expiry 604800)
 '(mode-line-format
   '("%e" mode-line-front-space mode-line-mule-info mode-line-client
     mode-line-modified mode-line-remote mode-line-frame-identification
     mode-line-buffer-identification "   " mode-line-position (vc-mode vc-mode)
     "  " mode-line-modes mode-line-misc-info
     (:eval (car (split-string system-name (rx ".")))) mode-line-end-spaces))
 '(mode-require-final-newline nil)
 '(multi-eshell-name "*eshell*")
 '(multi-eshell-shell-function '(eshell))
 '(multi-term-program "/usr/local/bin/zsh")
 '(multi-term-scroll-to-bottom-on-output t)
 '(mweb-default-major-mode 'nxml-mode)
 '(mweb-filename-extensions '("php" "htm" "html" "problem"))
 '(mweb-tags
   '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>") (js-mode "<script>" "</script>")
     (css-mode "<style[^>]*>" "</style>")
     (cperl-mode "<script type=\"loncapa/perl\">" "</script>")))
 '(nnir-method-default-engines '((nnimap . imap) (nntp . gmane) (nnml . notmuch)))
 '(nnmail-split-header-length-limit 4096)
 '(nnmail-treat-duplicates 'delete)
 '(notmuch-saved-searches
   '((:name "Dal" :query "folder:Dal" :key "d" :sort-order newest-first
            :search-type tree)
     (:name "FreeBSD" :query "folder:FreeBSD" :key "f" :sort-order newest-first
            :search-type tree)
     (:name "mail.misc" :query "folder:mail/misc" :key "m" :sort-order
            newest-first :search-type tree)
     (:name "Month" :query "date:30days..today" :key "M" :sort-order
            newest-first :search-type tree)))
 '(notmuch-search-oldest-first nil)
 '(nxml-attribute-indent 2)
 '(org-agenda-files '("~/scm/org.git"))
 '(org-agenda-use-time-grid nil)
 '(org-babel-load-languages '((emacs-lisp . t) (R . t) (shell . t)))
 '(org-bbdb-anniversary-format-alist
   '(("birthday" lambda (name years suffix)
      (concat "Birthday: [[bbdb:" name "][" name " (" (format "%s" years) suffix
              ")]]"))
     ("death" lambda (name years suffix)
      (concat "Death: [[bbdb:" name "][" name " (" (format "%s" years) ")]]"))
     ("wedding" lambda (name years suffix)
      (concat "[[bbdb:" name "][" name "'s " (format "%s" years) suffix
              " wedding anniversary]]"))) nil (bbdb))
 '(org-capture-templates
   '(("e" "Event" entry (file+headline "~/scm/org.git/capture.org" "Events")
      "** %a\12   %^T\12   Location: %?" :jump-to-captured t :time-prompt t)
     ("t" "TODO" entry (file+headline "~/scm/org.git/capture.org" "Todos")
      "** TODO %?\12   - State \"TODO\"       from              %u\12   %a"
      :jump-to-captured t :empty-lines-after 1 :table-line-pos t)
     ("w" "Web Link" item
      (file+headline "~/scm/org.git/capture.org" "Web Links") "- %u %a\12%i"
      :jump-to-captured t)))
 '(org-clock-persist 'history)
 '(org-confirm-babel-evaluate nil)
 '(org-default-notes-file "~/scm/org.git/capture.org")
 '(org-directory "~/scm/org.git")
 '(org-export-html-postamble nil)
 '(org-export-with-sub-superscripts '{})
 '(org-latex-pdf-process '("latexmk -f -pdf %f"))
 '(org-mobile-directory "~/.org-mobile")
 '(org-refile-targets '((org-agenda-files :maxlevel . 3)))
 '(org-refile-use-outline-path t)
 '(org-todo-keyword-faces '(("X CANCELLED" . "dim gray") ("~ WAIT" . "goldenrod")))
 '(org-todo-keywords
   '((sequence "TODO(t!)" "|" "WAIT(w!)" "|" "CANCELLED(c!)" "DONE(d!)")))
 '(org-use-fast-todo-selection t)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")
     ("org" . "https://orgmode.org/elpa/")))
 '(package-gnupghome-dir "~/.gnupg")
 '(package-selected-packages
   '(ace-link ace-window adoc-mode auctex auctex-latexmk avy-zap bbdb buffer-move
              calfw calfw-cal calfw-gcal calfw-org chess company company-auctex
              company-bibtex counsel embark erc-hl-nicks erc-image erc-view-log
              ess esup eyebrowse fennel-mode fill-column-indicator flycheck
              google-translate haskell-mode hydra ivy ivy-bibtex ivy-emoji
              ivy-hydra languagetool lsp-haskell lsp-ivy lsp-mode lsp-treemacs
              lsp-ui lua-mode magit marginalia nginx-mode notmuch nov oauth2
              orderless org-bullets parinfer-rust-mode php-mode poly-R
              poly-noweb polymode scpaste sly smart-mode-line swiper transient
              undo-tree vertico w3m which-key yaml-mode yasnippet zop-to-char))
 '(parinfer-rust-library "/usr/local/lib/libparinfer_rust.so" t)
 '(pdf-misc-print-program "/usr/local/bin/lpr" t)
 '(pdf-misc-print-program-args '("-o media=Letter -o fitplot"))
 '(pdf-view-continuous nil)
 '(pdf-view-display-size 'fit-page)
 '(preview-scale-function 1.2)
 '(prog-mode-hook '(flyspell-prog-mode))
 '(ps-lpr-command "psif")
 '(ps-lpr-switches nil)
 '(reb-re-syntax 'string)
 '(reftex-bibpath-environment-variables '("BIBINPUTS" "TEXBIB" "~/scm/references.git/refs.bib"))
 '(reftex-default-bibliography '("~/scm/references.git/refs.bib"))
 '(reftex-plug-into-AUCTeX t)
 '(require-final-newline nil)
 '(ring-bell-function 'ignore)
 '(safe-local-variable-values
   '((eval hl-line-mode t)
     (whitespace-style face tabs spaces trailing lines space-before-tab::space
                       newline indentation::space empty space-after-tab::space
                       space-mark tab-mark newline-mark)))
 '(savehist-additional-variables
   '(kill-ring regexp-search-ring search-ring tablist-named-filter))
 '(savehist-autosave-interval 60)
 '(savehist-mode t)
 '(sc-auto-fill-region-p nil)
 '(sc-preferred-attribution-list
   '("sc-lastchoice" "x-attribution" "initials" "firstname" "lastname"))
 '(scroll-bar-mode nil)
 '(scroll-conservatively 10000)
 '(select-enable-clipboard t)
 '(send-mail-function 'mailclient-send-it)
 '(sh-basic-offset 8)
 '(sh-indentation 2)
 '(show-paren-mode t)
 '(show-trailing-whitespace nil)
 '(shr-external-browser 'browse-url-conkeror)
 '(sml/extra-filler -3)
 '(sml/replacer-regexp-list '(("^/usr/home/jrm" "~")))
 '(sml/theme 'dark)
 '(sunshine-location "Halifax, CA")
 '(sunshine-show-icons t)
 '(sunshine-units 'metric)
 '(term-bind-key-alist nil)
 '(term-buffer-maximum-size 10000)
 '(term-scroll-show-maximum-output nil)
 '(term-unbind-key-list '("C-c b" "C-c t" "C-x" "M-x"))
 '(text-mode-hook '(turn-on-flyspell text-mode-hook-identify))
 '(tls-checktrust 'ask)
 '(tls-program
   '(("gnutls-cli --x509cafile /usr/local/share/certs/ca-root-nss.crt -p %p %h")))
 '(tool-bar-mode nil)
 '(tramp-default-method "ssh")
 '(truncate-lines t)
 '(truncate-partial-width-windows nil)
 '(twittering-oauth-invoke-browser t)
 '(twittering-request-confirmation-on-posting t)
 '(twittering-use-master-password t)
 '(undo-tree-auto-save-history nil)
 '(undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
 '(undo-tree-visualizer-timestamps t)
 '(uniquify-buffer-name-style 'forward nil (uniquify))
 '(vc-follow-symlinks t)
 '(vc-make-backup-files t)
 '(version-control t)
 '(web-mode-attr-indent-offset 2)
 '(webjump-sites
   '(("aw" . "awarnach.mathstat.dal.ca") ("about:blank" . "about:blank")
     ("Brightspace" . "dal.ca/brightspace")
     ("Cambridge Dictionaries Online"
      . [simple-query "dictionary.cambridge.org"
                      "dictionary.cambridge.org/cmd_search.asp?searchword=" ""])
     ("Capa" . "capa.mathstat.dal.ca") ("cbc" . "cbc.ca/news")
     ("cbc/ns" . "cbc.ca/ns") ("Coindesk" . "www.coindesk.com")
     ("Dictionary.com"
      . [simple-query "www.dictionary.com" "www.dictionary.com/browse/" ""])
     ("DuckDuckGo" . [simple-query "duckduckgo.com" "duckduckgo.com/?q=" ""])
     ("Electronic Frontier Foundation" . "www.eff.org")
     ("Emacs" . "www.gnu.org/software/emacs/emacs.html")
     ("Emacs Wiki"
      . [simple-query "www.emacswiki.org" "www.emacswiki.org/cgi-bin/wiki/" ""])
     ("FreeBSD Bugs" . "bugs.freebsd.org")
     ("FreeBSD Forums" . "https://forums.freebsd.org/find-new/5741072/posts")
     ("FreeBSD Handbook" . "freebsd.org/handbook")
     ("FreeBSD Porters Handbook"
      . "www.freebsd.org/doc/en_US.ISO8859-1/books/porters-handbook/book.html")
     ("Freshports"
      . [simple-query "freshports.org"
                      "http://freshports.org/search.php?search=go&num=100&stype=name&method=match&deleted=excludedeleted&start=1&casesensitivity=caseinsensitive&query="
                      ""])
     ("Github" . "github.com")
     ("Google" . [simple-query "www.google.com" "www.google.com/search?q=" ""])
     ("Google Drive" . "drive.google.com")
     ("Google Images"
      . [simple-query "images.google.com" "images.google.com/images?q=" ""])
     ("Google Maps"
      . [simple-query "maps.google.com" "maps.google.com/?force=tt&q=" ""])
     ("Google Plus" . "plus.google.com")
     ("Google Scholar"
      . [simple-query "scholar.google.com" "scholar.google.com/scholar?q=" ""])
     ("Hacker News" . "https://news.ycombinator.com") ("Home" . "ftfl.ca")
     ("Merriam-Webster Dictionary"
      . [simple-query "www.m-w.com/dictionary" "www.m-w.com/cgi-bin/netdict?va="
                      ""])
     ("Nagio" . "awarnach.mathstat.dal.ca/nagios")
     ("Packages" . "pkg.awarnach.mathstat.dal.ca")
     ("PC Financial" . "pcfinancial.ca") ("RFC" . "www.ietf.org/rfc/rfc")
     ("Stackoverflow"
      . [simple-query "stackoverflow.com" "stackoverflow.com/search?q" ""])
     ("PGP Key Server"
      . [simple-query "pgp.mit.edu"
                      "pgp.mit.edu:11371/pks/lookup?op=index&search=" ""])
     ("Portscout" . "https://portscout.freebsd.org/")
     ("Project Gutenberg" . webjump-to-gutenberg)
     ("RBC"
      . "https://www1.royalbank.com/cgi-bin/rbaccess/rbunxcgi%3FF6=1%26F7=IB%26F21=IB%26F22=IB%26REQUEST=ClientSignin%26LANGUAGE=ENGLISH?_ga=1.223022555.1525730850.1448687611")
     ("Thesaurus.com"
      . [simple-query "www.thesaurus.com" "www.thesaurus.com/browse/" ""])
     ("Savannah Emacs" . "savannah.gnu.org/projects/emacs")
     ("Slashdot"
      . [simple-query "slashdot.org" "slashdot.org/search.pl?query=" ""])
     ("Twitter" . "twitter.com") ("US Patents" . [simple-query
                                                  "www.uspto.gov/patft/" (\

                                                                          (\

                                                                           (\

                                                                            (\

                                                                             (\

                                                                              (\,
                                                                               (concat
                                                                                "appft1.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF"
                                                                                "&p=1&u=%2Fnetahtml%2FPTO%2Fsearch-bool.html&r=0&f=S&l=50"
                                                                                "&TERM1=")))))))
                                                  "&FIELD1=&co1=AND&TERM2=&FIELD2=&d=PG01"])
     ("Wikipedia" . [simple-query "wikipedia.org" "wikipedia.org/wiki/" ""])
     ("Youtube"
      . [simple-query "www.youtube.com" "www.youtube.com/results?search_query="
                      ""])
     ("ZNC" . "https://ftfl.ca:2222")))
 '(which-key-mode t)
 '(wttrin-default-accept-language '("Accept-Language" . "en-US,en;q=0.8"))
 '(wttrin-default-cities '("Halifax")))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 112 :width normal :foundry "PfEd" :family "Monospace"))))
 '(Man-overstrike ((t (:inherit bold :foreground "orange red" :weight bold))))
 '(Man-underline ((t (:inherit underline :foreground "forest green" :underline t))))
 '(anything-candidate-number ((t (:background "#f57900" :foreground "black"))))
 '(anything-header ((t (:bold t :background "grey15" :foreground "#edd400"))))
 '(button ((t (:inherit (link)))))
 '(cfw:face-toolbar ((t (:background "black" :foreground "Steelblue4"))))
 '(custom-button ((t (:box (:line-width 1 :style released-button) :background "grey50" :foreground "black"))))
 '(custom-button-mouse ((t (:inherit 'custom-button :background "grey60"))))
 '(custom-button-mouse-pressed-unraised ((t (:inherit 'custom-button-unraised :background "grey60"))))
 '(custom-button-mouse-unraised ((t (:inherit 'custom-button-unraised :background "grey60"))))
 '(custom-button-pressed ((t (:inherit 'custom-button :box (:style pressed-button)))))
 '(custom-button-unraised ((t (:background "grey50" :foreground "black"))))
 '(custom-documentation ((t (:italic t))))
 '(custom-face-tag ((t (:bold t :foreground "#edd400" :height 1.1))))
 '(custom-group-tag ((t (:bold t :foreground "#edd400" :height 1.3))))
 '(custom-state-face ((t (:foreground "#729fcf"))))
 '(custom-variable-button ((t (:inherit 'custom-button))))
 '(custom-variable-tag ((t (:bold t :foreground "#edd400" :height 1.1))))
 '(diary-face ((t (:bold t :foreground "IndianRed"))))
 '(diredp-date-time ((t (:foreground "white"))))
 '(diredp-dir-name ((t (:background "black" :foreground "dodger blue"))))
 '(diredp-dir-priv ((t (:background "black" :foreground "white"))))
 '(diredp-exec-priv ((t (:background "black"))))
 '(diredp-file-name ((t (:foreground "white"))))
 '(diredp-file-suffix ((t (:foreground "white"))))
 '(diredp-no-priv ((t (:background "black"))))
 '(diredp-number ((t (:foreground "white"))))
 '(diredp-other-priv ((t (:background "black"))))
 '(diredp-rare-priv ((t (:background "black" :foreground "white"))))
 '(diredp-read-priv ((t (:background "black"))))
 '(diredp-symlink ((t (:foreground "magenta3"))))
 '(diredp-write-priv ((t (:background "black"))))
 '(ecb-default-highlight-face ((t (:background "#729fcf"))))
 '(ecb-tag-header-face ((t (:background "#f57900"))))
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
 '(ess-jb-comment-face ((t (:background "#2e3436" :foreground "#888a85" :slant italic))))
 '(ess-jb-h1-face ((t (:height 1.6 :foreground "dodger blue" :slant normal))))
 '(ess-jb-h2-face ((t (:height 1.4 :foreground "#6ac214" :slant normal))))
 '(ess-jb-h3-face ((t (:height 1.2 :foreground "#edd400" :slant normal))))
 '(ess-jb-hide-face ((t (:background "#2e3436" :foreground "#243436"))))
 '(eyebrowse-mode-line-active ((t (:inherit mode-line-emphasis :underline t))))
 '(font-lock-builtin-face ((t (:foreground "#729fcf"))))
 '(font-lock-comment-delimiter-face ((default (:inherit (font-lock-comment-face)))))
 '(font-lock-comment-face ((t (:foreground "#888a85"))))
 '(font-lock-constant-face ((t (:foreground "#8ae234"))))
 '(font-lock-doc-face ((t (:foreground "#888a85"))))
 '(font-lock-function-name-face ((t (:weight bold :foreground "#edd400"))))
 '(font-lock-keyword-face ((t (:weight bold :foreground "#729fcf"))))
 '(font-lock-negation-char-face ((t (:foreground "#6ac214"))))
 '(font-lock-preprocessor-face ((t (:inherit (font-lock-builtin-face)))))
 '(font-lock-regexp-grouping-backslash ((t (:foreground "#888a85"))))
 '(font-lock-regexp-grouping-construct ((t (:foreground "#edd400"))))
 '(font-lock-string-face ((t (:foreground "PaleGreen4" :slant italic))))
 '(font-lock-type-face ((t (:weight bold :foreground "#8ae234"))))
 '(font-lock-variable-name-face ((t (:foreground "tomato"))))
 '(font-lock-warning-face ((t (:weight bold :foreground "#f57900"))))
 '(gnus-cite-1 ((t (:foreground "deep sky blue"))))
 '(gnus-cite-10 ((t (:foreground "OrangeRed4"))))
 '(gnus-cite-2 ((t (:foreground "orange"))))
 '(gnus-cite-3 ((t (:foreground "green"))))
 '(gnus-cite-4 ((t (:foreground "yellow"))))
 '(gnus-cite-5 ((t (:foreground "magenta"))))
 '(gnus-cite-6 ((t (:foreground "red"))))
 '(gnus-cite-7 ((t (:foreground "chocolate"))))
 '(gnus-cite-8 ((t (:foreground "cyan"))))
 '(gnus-cite-face-1 ((t (:foreground "#ad7fa8"))) t)
 '(gnus-cite-face-2 ((t (:foreground "sienna4"))) t)
 '(gnus-cite-face-3 ((t (:foreground "khaki4"))) t)
 '(gnus-cite-face-4 ((t (:foreground "PaleTurquoise4"))) t)
 '(gnus-group-mail-1 ((t (:bold t :foreground "light cyan"))))
 '(gnus-group-mail-1-empty ((t (:foreground "light cyan"))))
 '(gnus-group-mail-2 ((t (:foreground "DodgerBlue1" :weight bold))))
 '(gnus-group-mail-2-empty ((t (:foreground "DodgerBlue4"))))
 '(gnus-group-mail-3 ((t (:foreground "OliveDrab1" :weight bold))))
 '(gnus-group-mail-3-empty ((t (:foreground "DarkOliveGreen4"))))
 '(gnus-group-mail-low ((t (:foreground "dark gray" :weight bold))))
 '(gnus-group-mail-low-empty ((t (:foreground "dodger blue"))))
 '(gnus-group-news-1 ((t (:bold t :foreground "light cyan"))))
 '(gnus-group-news-1-empty ((t (:foreground "light cyan"))))
 '(gnus-group-news-2 ((t (:bold t :foreground "turquoise"))))
 '(gnus-group-news-2-empty ((t (:foreground "turquoise"))))
 '(gnus-group-news-3 ((t (:bold t :foreground "#edd400"))))
 '(gnus-group-news-3-empty ((t (:foreground "#729fcf"))))
 '(gnus-group-news-4 ((t (:foreground "forest green" :weight bold))))
 '(gnus-group-news-4-empty ((t (:foreground "dark green"))))
 '(gnus-group-news-low ((t (:bold t :foreground "dodger blue"))))
 '(gnus-group-news-low-empty ((t (:foreground "dodger blue"))))
 '(gnus-header-content ((t (:italic t :foreground "#8ae234"))))
 '(gnus-header-from ((t (:bold t :foreground "#edd400"))))
 '(gnus-header-name ((t (:bold t :foreground "#729fcf"))))
 '(gnus-header-newsgroups ((t (:italic t :bold t :foreground "LightSkyBlue3"))))
 '(gnus-header-subject ((t (:foreground "#edd400"))))
 '(gnus-summary-cancelled ((t (:background "black" :foreground "yellow"))))
 '(gnus-summary-high-ancient ((t (:bold t :foreground "gray50"))))
 '(gnus-summary-high-read ((t (:bold t :foreground "lime green"))))
 '(gnus-summary-high-ticked ((t (:bold t :foreground "tomato"))))
 '(gnus-summary-high-unread ((t (:bold t :foreground "white"))))
 '(gnus-summary-low-ancient ((t (:italic t :foreground "lime green"))))
 '(gnus-summary-low-read ((t (:italic t :foreground "gray50"))))
 '(gnus-summary-low-ticked ((t (:italic t :foreground "dark red"))))
 '(gnus-summary-low-unread ((t (:italic t :foreground "white"))))
 '(gnus-summary-normal-ancient ((t (:foreground "gray66"))))
 '(gnus-summary-normal-read ((t (:foreground "lime green"))))
 '(gnus-summary-normal-ticked ((t (:foreground "indian red"))))
 '(gnus-summary-normal-unread ((t (:foreground "white"))))
 '(gnus-summary-selected ((t (:background "DarkOrange3" :foreground "white"))))
 '(header-line ((default (:inherit (mode-line))) (((type tty)) (:underline (:color foreground-color :style line) :inverse-video nil)) (((class color grayscale) (background light)) (:box nil :foreground "grey20" :background "grey90")) (((class color grayscale) (background dark)) (:box nil :foreground "grey90" :background "grey20")) (((class mono) (background light)) (:underline (:color foreground-color :style line) :box nil :inverse-video nil :foreground "black" :background "white")) (((class mono) (background dark)) (:underline (:color foreground-color :style line) :box nil :inverse-video nil :foreground "white" :background "black"))))
 '(highlight ((t (:background "gray19"))))
 '(info-xref ((t (:foreground "#729fcf"))))
 '(info-xref-visited ((t (:foreground "#ad7fa8"))))
 '(isearch ((t (:foreground "#2e3436" :background "#f57900"))))
 '(isearch-fail ((((class color) (min-colors 88) (background light)) (:background "RosyBrown1")) (((class color) (min-colors 88) (background dark)) (:background "red4")) (((class color) (min-colors 16)) (:background "red")) (((class color) (min-colors 8)) (:background "red")) (((class color grayscale)) (:foreground "grey")) (t (:inverse-video t))))
 '(ivy-current-match ((t (:background "forest green" :foreground "white"))))
 '(ivy-minibuffer-match-face-1 ((t (:background "HotPink4"))))
 '(ivy-minibuffer-match-face-2 ((t (:background "DarkOrange3" :weight bold))))
 '(ivy-remote ((t (:foreground "dark orange"))))
 '(lazy-highlight ((t (:foreground "#2e3436" :background "#e9b96e"))))
 '(link ((t (:foreground "dodger blue" :underline (:color foreground-color :style line)))))
 '(link-visited ((default (:inherit (link))) (((class color) (background light)) (:foreground "magenta4")) (((class color) (background dark)) (:foreground "violet"))))
 '(match ((t (:weight bold :foreground "#2e3436" :background "#e9b96e"))))
 '(message-cited-text-1 ((t (:foreground "#edd400"))))
 '(minibuffer-prompt ((t (:foreground "#729fcf" :bold t))))
 '(mode-line ((t (:background "gray10" :foreground "white"))))
 '(mode-line-highlight ((t nil)))
 '(next-error ((t (:inherit (region)))))
 '(org-agenda-date ((t (:foreground "#6ac214"))))
 '(org-agenda-date-today ((t (:weight bold :foreground "#edd400"))))
 '(org-agenda-date-weekend ((t (:weight normal :foreground "dodger blue"))))
 '(org-agenda-structure ((t (:weight bold :foreground "tomato"))))
 '(org-block ((t (:foreground "#bbbbbc"))))
 '(org-block-background ((t (:background "#262626"))))
 '(org-block-begin-line ((t (:background "blue4" :foreground "#888a85"))))
 '(org-block-end-line ((t (:background "blue4" :foreground "#888a85"))))
 '(org-date ((t (:foreground "DarkOrange4" :underline t))))
 '(org-done ((t (:bold t :foreground "ForestGreen"))))
 '(org-footnote ((t (:foreground "gray44" :underline t))))
 '(org-hide ((t (:foreground "#2e3436"))))
 '(org-level-1 ((t (:foreground "gold" :weight bold :height 1.2))))
 '(org-level-2 ((t (:foreground "DodgerBlue1" :weight bold :height 1.1))))
 '(org-level-3 ((t (:foreground "olive drab" :weight bold :height 1.0))))
 '(org-level-4 ((t (:foreground "saddle brown" :weight bold :height 0.9))))
 '(org-level-5 ((t (:foreground "dark magenta" :height 0.85))))
 '(org-level-6 ((t (:foreground "goldenrod" :height 0.75))))
 '(org-level-7 ((t (:foreground "SlateBlue1" :height 0.65))))
 '(org-link ((t (:foreground "skyblue2" :underline t))))
 '(org-quote ((t (:inherit org-block :slant italic))))
 '(org-scheduled-previously ((t (:weight normal :foreground "#edd400"))))
 '(org-special-keyword ((t (:inherit org-meta-line))))
 '(org-todo ((t (:bold t :foreground "Red"))))
 '(org-verbatim ((t (:foreground "#eeeeec" :underline t :slant italic))))
 '(org-verse ((t (:inherit org-block :slant italic))))
 '(query-replace ((t (:inherit (isearch)))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "cyan"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "green"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "pink"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "purple"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "orange"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "blue"))))
 '(rainbow-delimiters-unmatched-face ((t (:background "yellow" :foreground "red"))))
 '(region ((t (:background "#bf5700"))))
 '(secondary-selection ((((class color) (min-colors 88) (background light)) (:background "yellow1")) (((class color) (min-colors 88) (background dark)) (:background "dark slate blue")) (((class color) (min-colors 16) (background light)) (:background "yellow")) (((class color) (min-colors 16) (background dark)) (:background "dark slate blue")) (((class color) (min-colors 8)) (:foreground "black" :background "cyan")) (t (:inverse-video t))))
 '(shadow ((((class color grayscale) (min-colors 88) (background light)) (:foreground "grey50")) (((class color grayscale) (min-colors 88) (background dark)) (:foreground "grey70")) (((class color) (min-colors 8) (background light)) (:foreground "green")) (((class color) (min-colors 8) (background dark)) (:foreground "yellow"))))
 '(show-paren-match ((t (:foreground "#2e3436" :background "#73d216"))))
 '(show-paren-mismatch ((t (:background "dark orange" :foreground "#2e3436"))))
 '(term-color-blue ((t (:background "DodgerBlue1" :foreground "DodgerBlue1"))))
 '(tooltip ((t (:background "lightyellow" :foreground "black" :inherit 'variable-pitch))))
 '(trailing-whitespace ((((class color) (background light)) (:background "red1")) (((class color) (background dark)) (:background "red1")) (t (:inverse-video t))))
 '(visible-mark-active ((t (:background "goldenrod" :foreground "black"))))
 '(which-func ((t (:inherit (font-lock-function-name-face) :weight normal))))
 '(widget-button ((t (:bold t))))
 '(widget-field ((t (:foreground "orange" :background "gray30"))))
 '(widget-mouse-face ((t (:bold t :foreground "white" :background "brown4"))))
 '(widget-single-line-field ((t (:foreground "orange" :background "gray30")))))
