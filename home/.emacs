(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

;;;dired copy to other dired in split window
(setq dired-dwim-target t)

;;; required: installation of clojure-mode

;; no dialog to open files
(setq use-file-dialog nil)

;;; haskell
(require 'haskell-mode)
(find-file user-init-file)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(require 'evil-mode)
(evil-mode 1)

(require 'evil-org)

;;; frege
(add-to-list 'auto-mode-alist '("\\.fr$" . haskell-mode))

;;; git
;;(require 'magit)

;;; autocomplete
(require 'auto-complete)
(global-auto-complete-mode t)
;;;(setq ac-modes '(org-mode))

;;ido! 
(require 'ido)
(ido-mode t)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

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

;;; clojure setup
;;; taken from http://nakkaya.com/2009/12/01/adding-inferior-lisp-support-for-clojure-mode/
(require 'clojure-mode)
(setq auto-mode-alist (cons '("\\.cljs$" . clojure-mode) auto-mode-alist))
;(setq inferior-lisp-program "lein repl")
;(setq inferior-lisp-program "sbcl")

;;markus temp
(add-hook 'clojure-mode-hook
          '(lambda ()
             (define-key clojure-mode-map 
               "\C-c\C-e" '(lambda ()
                             (interactive)
                             (let ((curr (point)))
                               (end-of-defun)
                               (lisp-eval-last-sexp)
                               (goto-char curr))))
             (define-key clojure-mode-map 
               "\C-x\C-e" 'lisp-eval-last-sexp)
             (define-key clojure-mode-map 
               "\C-c\C-r" 'lisp-eval-region)
             (define-key clojure-mode-map 
               "\C-c\C-c" '(lambda ()
                             (interactive)
                             (lisp-eval-string (buffer-string))))
             (define-key clojure-mode-map 
               "\C-c\C-z" 'run-lisp)))

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
      
(tool-bar-mode -1)
(menu-bar-mode 1)

(require 'saveplace)
(setq-default save-place t)

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

(defun next-user-buffer ()
  "Switch to the next user buffer.
User buffers are those whose name does not start with *."
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (string-equal "*" (substring (buffer-name) 0 1)) (< i 20))
      (setq i (1+ i)) (next-buffer))))

(defun previous-user-buffer ()
  "Switch to the previous user buffer.
User buffers are those whose name does not start with *."
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (string-equal "*" (substring (buffer-name) 0 1)) (< i 20))
      (setq i (1+ i)) (previous-buffer) )))
      
(defun fullscreen (&optional f)
       (interactive)
       (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
               '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
       (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
               '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0)))

(setq confirm-nonexistent-file-or-buffer nil)    

(savehist-mode 1)

;; enable recent files mode.
;;(recentf-mode t)
 
; 50 files ought to be enough.
;;(setq recentf-max-saved-items 50)

;;Irc client
(require 'erc)

(erc-autojoin-mode t)
(setq erc-autojoin-channels-alist
  '((".*\\.freenode.net" "#emacs" "#clojure" "#lisp" "#ubuntu-de" "##java" "#nixos" "#haskell" "#frege")
     ))

(erc-track-mode t)
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"

                                 "324" "329" "332" "333" "353" "477"))
;; don't show any of this
(setq erc-hide-list '("JOIN" "PART" "QUIT" "NICK"))

(defun djcb-erc-start-or-switch ()
  "Connect to ERC, or switch to last active buffer"
  (interactive)
  (if (get-buffer "irc.freenode.net:6667") ;; ERC already active?

    (erc-track-switch-buffer 1) ;; yes: switch to last active
    (when (y-or-n-p "Start ERC? ") ;; no: maybe start ERC
      (erc :server "irc.freenode.net" :port 6667 :nick "MarkusBarthlen" :full-name "Markus" :password "mark" )
      )))

(global-set-key (kbd "C-c i") 'djcb-erc-start-or-switch) 
(global-set-key [f1] 'occur)
(global-set-key "\C-V" 'yank)
(global-set-key "\C-cc" 'kill-ring-save)
(require 'goto-last-change)
(global-set-key (kbd "C-c l") 'goto-last-change)

(fullscreen)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#657b83" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#fdf6e3"))
 '(custom-enabled-themes (quote (sanityinc-solarized-dark)))
 '(custom-safe-themes
   (quote
    ("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" default)))
 '(fci-rule-color "#eee8d5")
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/Ideen/Ideen.org" "~/git/configs/Dates.org" "~/git/configs/Public.org")))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#cb4b16")
     (60 . "#b58900")
     (80 . "#859900")
     (100 . "#2aa198")
     (120 . "#268bd2")
     (140 . "#d33682")
     (160 . "#6c71c4")
     (180 . "#dc322f")
     (200 . "#cb4b16")
     (220 . "#b58900")
     (240 . "#859900")
     (260 . "#2aa198")
     (280 . "#268bd2")
     (300 . "#d33682")
     (320 . "#6c71c4")
     (340 . "#dc322f")
     (360 . "#cb4b16"))))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;helper function
(defun fourasterisks ()
  "Insert ****"
  (interactive)
  (insert "**** "))

(global-set-key (kbd "C-c 4") 'fourasterisks)

;;; chrome default
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium")
