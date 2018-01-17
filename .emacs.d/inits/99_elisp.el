(require 'bind-key)

;;;-----------------------------------------------------------------------------
;;; 試行錯誤用ファイルを開くための設定
;;;-----------------------------------------------------------------------------
(require 'open-junk-file)
;; C-x C-z で試行錯誤ファイルを開く
(bind-key "C-x C-z" 'open-junk-file)
(setq open-junk-file-format "~/memo/junk/%Y/%m/%Y-%m-%d-%H%M%S.")

;;;-----------------------------------------------------------------------------
;;; 式の評価結果を注釈するための設定
;;;-----------------------------------------------------------------------------
(require 'lispxmp)
;; emacs-lisp-mode で C-C C-d を押すと注釈される
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)

;;;-----------------------------------------------------------------------------
;;; 括弧の対応を保持して編集する設定
;;;-----------------------------------------------------------------------------
(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)

;; M-(  paredit-wrap-round    括弧で囲む
;; M-s  paredit-splice-sexp   括弧を外す

;;;-----------------------------------------------------------------------------
;;; 自動バイトコンパイルの設定
;;;-----------------------------------------------------------------------------
(require 'auto-async-byte-compile)
;; 自動バイトコンパイルを無効にするファイル名の正規表現
(setq auto-async-byte-compile-exclude-files-regexp "\\(/junk/\\|/inits/\\|/Dropbox/\\)")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(setq eldoc-idle-delay 0.2)             ; すぐに表示したい
(setq eldoc-minor-mode-string "")       ; モードラインにEldocと表示しない

;; find-function をキー割り当てする
(find-function-setup-keys)


;;; Emacs lisp コマンド
;; C-M-f    paredit-forward
;; C-M-b    paredit-backward
;; C-M-d    paredit-forward-down
;; C-M-u    paredit-backward-up
;; C-M-SPC  mark-sexp
;; C-M-k    kill-sexp
;; C-M-t    transpose-sexps


;; init.el レスポンス測定
;;(package-install 'esup)
;;(package-install 'noflet)


;; キーボードマクロの保存
(defvar kmacro-save-file "~/.emacs.d/inits/99_elisp.el"
  "キーボードマクロを保存するファイル。")

(defun kmacro-save (symbol)
  (interactive "SName for last kbd macro: ")
  (name-last-kbd-macro symbol)
  (with-current-buffer (find-file-noselect kmacro-save-file)
    (goto-char (point-max))
    (insert-kbd-macro symbol)
    (basic-save-buffer)))

