;; exwm stuff
(setq display-time-default-load-average nil)
;;(setq display-time-mode t)
(server-start)

(require 'exwm)
(require 'exwm-config)
(require 'exwm-randr)

(define-prefix-command 'wm-map)
(global-set-key (kbd "C-t") 'wm-map)

(add-hook 'exwm-update-class-hook
          (lambda ()
            (exwm-workspace-rename-buffer exwm-class-name)))

(exwm-input-set-key (kbd "C-t r") #'exwm-reset)
(exwm-input-set-key (kbd "H-r")   #'exwm-reset)
(exwm-input-set-key (kbd "C-t w") #'exwm-workspace-switch)

(dotimes (i exwm-workspace-number)
  (exwm-input-set-key (kbd (format "C-t %d" i))
                      `(lambda () (interactive) (exwm-workspace-switch ,i))))

(exwm-input-set-key (kbd "C-t &")
                    (lambda (command)
                      (interactive (list (read-shell-command "$ ")))
                      (start-process-shell-command command nil command)))

(push ?\C-q exwm-input-prefix-keys)
(define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

(setq exwm-workspace-show-all-buffers t)

;; Line-editing shortcuts
(exwm-input-set-simulation-keys
 '(([?\C-b] . left)
   ([?\C-f] . right)
   ([?\C-p] . up)
   ([?\C-n] . down)
   ([?\C-a] . home)
   ([?\C-e] . end)
   ([?\M-v] . prior)
   ([?\C-v] . next)
   ([?\C-d] . delete)
   ([?\C-k] . (S-end delete))))

(setq exwm-randr-workspace-output-plist '(0 "LVDS1" 1 "VGA1"))
;;(add-hook 'exwm-randr-screen-change-hook
;;          (lambda ()
;;            (start-process-shell-command
;;             "xrandr" nil "xrandr --output VGA1 --above LVDS1 --auto")))
(exwm-randr-enable)
(exwm-enable)