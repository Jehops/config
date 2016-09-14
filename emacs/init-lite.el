(setq gc-cons-threshold most-positive-fixnum)

;; enable some functions that are disabled by default --------------------------
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)

(defun jrm/sort-lines-nocase ()
  "Sort lines ignoring case."
  (interactive)
  (let ((sort-fold-case t))
    (call-interactively 'sort-lines)))

;; -----------------------------------------------------------------------------
(defadvice kill-buffer (around kill-buffer-around-advice activate)
  "Bury the scratch buffer, do not kill it."
  (let ((buffer-to-kill (ad-get-arg 0)))
    (if (equal buffer-to-kill "*scratch*")
        (bury-buffer)
      ad-do-it)))

;; custom set varaibles --------------------------------------------------------
;; tell customize to use ' instead of (quote ..) and #' instead of (function ..)
(advice-add 'custom-save-all
            :around (lambda (orig) (let ((print-quoted t)) (funcall orig))))

(setq custom-file "~/.emacs.d/custom-lite.el")
(load custom-file)

(setq gc-cons-threshold 800000)