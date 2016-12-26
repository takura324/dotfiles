;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;;; Elisp配置用のディレクトリを作成
;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;; init-loader
(require 'init-loader)
(init-loader-load)

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(ansi-color-names-vector
;;    ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#657b83"])
;;  '(background-color "#002b36")
;;  '(background-mode dark)
;;  '(cursor-color "#839496")
;;  '(custom-enabled-themes (quote (deeper-blue)))
;;  '(custom-safe-themes
;;    (quote
;;     ("fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
;;  '(foreground-color "#839496")
;;  '(package-selected-packages
;;    (quote
;;     (color-theme redo+ migemo howm color-moccur browse-kill-ring))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helm-flycheck diffview "diffview" "diffview" bind-key mwim magit dired-k which-key yafolding origami noflet esup auto-complete-clang annotate helm-gtags key-chord dired-launch iedit ace-jump-helm-line dumb-jump helm-ag projectile el-expectations save-load-path popwin ac-helm helm-c-yasnippet pcre2el auto-async-byte-compile paredit lispxmp open-junk-file helm-anything ace-isearch helm-migemo helm-swoop package-utils visual-regexp-steroids visual-regexp bm goto-chg ace-jump-mode recentf-ext helm-descbinds helm flycheck auto-complete-c-headers srefactor point-undo undo-tree wgrep auto-complete anything-replace-string anything-git-files anything-exuberant-ctags anything auto-install redo+ migemo howm color-theme color-moccur browse-kill-ring))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-diff-added ((t (:background "black" :foreground "green"))))
 '(magit-diff-added-highlight ((t (:background "white" :foreground "green"))))
 '(magit-diff-removed ((t (:background "black" :foreground "blue"))))
 '(magit-diff-removed-hightlight ((t (:background "white" :foreground "blue"))))
 '(magit-hash ((t (:foreground "red")))))
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
