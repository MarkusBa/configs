(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;(cua-mode t)


(require 'package)
(add-to-list 'package-archives 
      '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(defvar my-packages '(starter-kit
                      starter-kit-lisp
                      starter-kit-bindings
                      starter-kit-eshell
                      clojure-mode
                      clojure-test-mode
                      nrepl))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(setq-default inhibit-startup-screen t)

;;ido!
(require 'ido)
(ido-mode t)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

;;pabbrev

;;evil
(require 'evil)
;(evil-mode 1)


;;become root before saving file
(defun jesus-must-save-you ()
  (interactive)
  (let ((bname (expand-file-name (or buffer-file-name
                                     default-directory)))
        (pt (point)))
    (setq bname (or (file-remote-p bname 'localname)
                    (concat "/sudo::" bname)))
    (cl-flet ((server-buffer-done
               (buffer &optional for-killing)
               nil))
      (find-alternate-file bname))
    (goto-char pt)))

(defface find-file-root-header-face
  '((t (:foreground "white" :background "red3")))
  "*Face use to display header-lines for files opened as root.")

(defun find-file-root-header-warning ()
  "*Display a warning in header line of the current buffer.
This function is suitable to add to `find-file-hook'."
  (when (string-equal
         (file-remote-p (or buffer-file-name default-directory) 'user)
         "root")
    (let* ((warning "WARNING: EDITING FILE AS ROOT!")
           (space (+ 6 (- (window-width) (length warning))))
           (bracket (make-string (/ space 2) ?-))
           (warning (concat bracket warning bracket)))
      (setq header-line-format
            (propertize  warning 'face 'find-file-root-header-face)))))

(add-hook 'find-file-hook 'find-file-root-header-warning)
(add-hook 'dired-mode-hook 'find-file-root-header-warning)

;;avy
;;like vimperator
(require 'avy)
(global-set-key (kbd "M-g f") 'avy-goto-line)

(require 'goto-last-change)
(global-set-key (kbd "C-c l") 'goto-last-change)

(require 'recentf)
;; enable recent files mode.
(recentf-mode t)
; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

;; Of course, don't uncomment the line below -- doing so would
;; stop Emacs from helpfully leaving "foo~" (backup) files all
;; over the place.
;(setq make-backup-files nil)

;; Use only spaces (no tabs at all).
(setq-default indent-tabs-mode nil)

;; Always show column numbers.
(setq-default column-number-mode t)

;; Display full pathname for files.
(add-hook 'find-file-hooks
          '(lambda ()
             (setq mode-line-buffer-identification 'buffer-file-truename)))

;; For easy window scrolling up and down.
(global-set-key "\M-n" 'scroll-up-line)
(global-set-key "\M-p" 'scroll-down-line)

;; For easier regex search/replace.
(defalias 'qrr 'query-replace-regexp)

;; My own preference. Change or comment out the following lines if you like.
;;(load-theme 'deeper-blue t)
;;(set-background-color "#383838")
(require 'rainbow-delimiters)

(global-rainbow-delimiters-mode)

(require 'paredit)
(paredit-mode 1)

(load-theme 'solarized-light t)

;; haskell
;;(load "/usr/share/emacs24/site-lisp/haskell-mode/haskell-mode.elc")

;; haskell
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode 
;;   'turn-on-haskell-indent)

;; evil
;;(add-to-list 'load-path "~/.emacs.d/elpa/evil-1.0.6")
;;(require 'evil)
;;(evil-mode 1)

(tool-bar-mode 0)
(menu-bar-mode 1)


;; nrepl
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
(setq nrepl-popup-stacktraces nil)
(add-to-list 'same-window-buffer-names "*nrepl*")
(add-hook 'nrepl-mode-hook 'paredit-mode)

(global-set-key [f9] 'nrepl-jack-in)

;; Auto complete
(require 'auto-complete-config)
(ac-config-default)
(define-key ac-completing-map "\M-/" 'ac-stop) ; use M-/ to stop completion

;; ac-nrepl
(require 'ac-nrepl)
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
(add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete" '(add-to-list 'ac-modes 'nrepl-mode))

(package-initialize)
(require 'auto-complete)
(global-auto-complete-mode)

;; clojurescript
;;(defun cljs-repl ()
;;    (interactive)
;;    (setq inferior-lisp-program "cljs-repl")
;;    (run-lisp))

;;(setq inferior-lisp-program "/home/markus/clojurescript/script/browser-repl")
;;(setq inferior-lisp-program "/usr/local/bin/sbcl --noinform")


;; scheme
;;(set-variable (quote scheme-program-name) "gsi")


(global-hl-line-mode t)
;; Shows in modeline where in the file you are
;;(sml-modeline-mode)
;; Pretty symbols
(require 'pretty-mode-plus)
(global-pretty-mode 1)
;; Autocomplete
(require 'auto-complete)
;; Disable annoying bell sound
;;(setq visible-bell t)
;; Disables scrollbar
;;(setq scroll-bar-mode nil)
;; Disables toolbar
;;(setq tool-bar-mode nil)
;; Optional: If you've installed solarized-theme
;;(require 'solarized-dark-theme) ;; Also as solarized-light-theme
 
;; ido completion
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
;;(setq ido-mode (quote both) nil (ido))
(setq ido-ubiquitous-mode t)
 
;; Enable SMEX, an enhancement for M-x completion
(global-set-key [(meta x)] (lambda ()
(interactive)
(or (boundp 'smex-cache)
(smex-initialize))
(global-set-key [(meta x)] 'smex)
(smex)))
(global-set-key [(shift meta x)] (lambda ()
(interactive)
(or (boundp 'smex-cache)
(smex-initialize))
(global-set-key [(shift meta x)] 'smex-major-mode-commands)
(smex-major-mode-commands)))
 
;; Unicode as default
;; set up unicode
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; This from a japanese individual. I hope it works.
(setq default-buffer-file-coding-system 'utf-8)
;; From Emacs wiki
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))




;; clj-refactor: Use C-c C-m. See https://github.com/magnars/clj-refactor.el
(defun clj-refactor-hooks ()
(clj-refactor-mode 1)
(cljr-add-keybindings-with-prefix "C-c C-m"))
 
;; nREPL: The new Clojure network REPL. See https://github.com/kingtim/nrepl.el
(require 'nrepl)
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
 
;; Autocompletion for nREPL; From https://github.com/purcell/ac-nrepl
(require 'ac-nrepl)
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
(add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete"
'(add-to-list 'ac-modes'nrepl-mode))
;; Probably gets in the way of yasnippet?
(defun set-auto-complete-as-completion-at-point-function ()
(setq completion-at-point-functions '(auto-complete)))
(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'nrepl-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'nrepl-interaction-mode-hook 'set-auto-complete-as-completion-at-point-function)
;; Popup documentation change
(define-key nrepl-interaction-mode-map (kbd "C-c C-d") 'ac-nrepl-popup-doc)
 
;; Glue code: Bring it all together...
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
(add-hook 'clojure-mode-hook 'auto-indent-mode)
(add-hook 'clojure-mode-hook 'clj-refactor-hooks)
(add-hook 'clojure-mode-hook 'auto-complete-mode)
(add-to-list 'auto-mode-alist '("\\.cljs\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljx\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.clj\\'" . clojure-mode))

;; turn off asking for server, login etc.
(require 'sql)
(defalias 'sql-get-login 'ignore)

(defvar mysql-user "root")
(defvar mysql-password "mark")


(setq sql-user "root")
(setq sql-password "mark")

(require 'mysql)


   (require 'sql-completion)
   (setq sql-interactive-mode-hook
         (lambda ()
           (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
           (sql-mysql-completion-init)))

;; mysql history
 (defun my-sql-save-history-hook ()
    (let ((lval 'sql-input-ring-file-name)
          (rval 'sql-product))
      (if (symbol-value rval)
          (let ((filename 
                 (concat "~/.emacs.d/sql/"
                         (symbol-name (symbol-value rval))
                         "-history.sql")))
            (set (make-local-variable lval) filename))
        (error
         (format "SQL history will not be saved because %s is nil"
                 (symbol-name rval))))))
 
  (add-hook 'sql-interactive-mode-hook 'my-sql-save-history-hook)


(require 'saveplace)
(setq-default save-place t)

;;immer my
(sql-set-product 'mysql)

(custom-set-variables
 '(org-agenda-files (list "~/Downloads/Ideen/Todo.org" "~/git/configs/Public.org" "~/git/configs/Dates.org" )))

;;java
;(add-to-list 'load-path "~/.emacs.d/lisp/")
  (add-to-list 'load-path "~/.emacs.d/jdee/lisp" )
  (autoload 'jde-mode "jde" "JDE mode" t)
  (setq auto-mode-alist
        (append '(("\\.java\\'" . jde-mode)) auto-mode-alist))

(setq org-startup-indented t)

 (global-set-key "\C-cs" 'shell)
 (global-set-key "\C-cc" 'global-font-lock-mode)
 (global-set-key "\C-cq" 'sql-mode)
 (global-set-key "\C-cj" 'jde-mode)
 (global-set-key "\C-cv" 'evil-mode)
 (global-set-key "\C-cp" 'paredit-mode)
 (global-set-key "\C-cd" 'dired)
 (global-set-key "\C-co" 'org-mode)
; (global-set-key (kbd "C-v") 'yank) 


;fuck colors
(global-font-lock-mode nil)

