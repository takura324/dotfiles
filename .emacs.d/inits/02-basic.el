;;; 同じ内容を履歴に記録しないようにする
(setq history-delete-duplicates t)

;;; ファイルを開いた位置を保存する
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (concat user-emacs-directory "places"))

;;; ミニバッファ履歴を次回Emacs起動時にも保存する
(savehist-mode 1)

;;; ログの記録行数を増やす
(setq message-log-max 10000)
;;; 履歴をたくさん保存する
(setq history-length 1000)

;;----------------------------------------------------------------------
;; Emacsからの質問をy/nで回答する
;;----------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)

;;----------------------------------------------------------------------
;;キー設定
;;----------------------------------------------------------------------
;; C-h を backspace にする
(keyboard-translate ?\C-h ?\C-?)

(define-key global-map (kbd "C-x ?") 'help-command)

;; C-x j  で指定行へ移動
(define-key global-map (kbd "C-x j") 'goto-line)

;; 改行キーでオートインデント
(define-key global-map "\C-m" 'newline-and-indent)
(setq indent-line-function 'indent-relative-maybe) ;;インデント方法. お好みで. . .

;; 折り返しトグルコマンド
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;; C-t でウィンドウを切り替える（transpose-chars を無効）
(define-key global-map (kbd "C-t") 'other-window)

;;(define-key global-map [f9] 'japanese-zenkaku-region)

(define-key global-map (kbd "<home>") 'beginning-of-buffer)
(define-key global-map (kbd "<end>") 'end-of-buffer)

;;(global-set-key (kbd "C-@") 'dabbrev-expand)
;;(define-key global-map (kbd "C-z") 'undo)
(global-unset-key "\C-z")
(global-set-key "\C-z" 'undo)

;;----------------------------------------------------------------------
;;タブ幅の設定
;;----------------------------------------------------------------------
;;タブ幅を 4 に設定
(setq-default tab-width 4)
;;タブ幅の倍数を設定
(setq tab-stop-list
  '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
;;タブではなくスペースを使う
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe)


;;----------------------------------------------------------------------
;;便利に編集するための設定
;;----------------------------------------------------------------------
(show-paren-mode)

;; リージョンを上書きできるようにする。
(delete-selection-mode t)

;;----------------------------------------------------------------------
;;一行まるごとカット
;;----------------------------------------------------------------------
(setq kill-whole-line t)

;; ;;----------------------------------------------------------------------
;; ;;同一ファイル名のバッファ名を分かりやすく — uniquify
;; ;;----------------------------------------------------------------------
;; (require 'uniquify)
;; (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;; ;;(setq uniquify-ignore-buffers-re "*[^*]+*")

;;--------------------------------------------------------------------------------
;; hippie-expand
;;
;; http://emacs.rubikitch.com/sd1409-migemo-ace-jump-mode-dabbrev/
;;--------------------------------------------------------------------------------
(global-set-key (kbd "C-@") 'hippie-expand)

(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill))
