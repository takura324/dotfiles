;;----------------------------------------------------------------------
;;12.1.1 ファイル名とモードの関連付け (2004/01/21)
;;----------------------------------------------------------------------
(setq auto-mode-alist
       (append '(
                ("\\.wl" . emacs-lisp-mode)
                ("\\.abbrev_defs" . emacs-lisp-mode)
                ("\\.log$" . text-mode))
               auto-mode-alist))


;;----------------------------------------------------------------------
;;15.3 画面表示 (サイズや表示色) の設定 (2004/11/13)
;;----------------------------------------------------------------------
(scroll-bar-mode t)

;;----------------------------------------------------------------------
;;15.3.6 タイトルバー・ツールバーの設定 (2004/01/15)
;;----------------------------------------------------------------------
;;タイトルバーにファイル名を表示
(setq frame-title-format "%b")

;; ツールバーを表示しない
(tool-bar-mode 0)

;;---------------------------------------------------------------------- 	
;;15.3.8 ミニバッファのサイズを変更 (2004/11/13)
;;---------------------------------------------------------------------- 	
(setq resize-mini-windows nil)

;;----------------------------------------------------------------------
;;15.3.9 起動時の画面を表示しない (2004/01/15)
;;----------------------------------------------------------------------
;; 起動時の画面はいらない
(setq inhibit-startup-message t)


;;----------------------------------------------------------------------
;;15.6 キーバインドの変更 (2004/01/30)
;;----------------------------------------------------------------------
;;15.6.1 キーバインドについて (2004/01/30)
;;----------------------------------------------------------------------
(load "term/bobcat")
(when (fboundp 'terminal-init-bobcat) (terminal-init-bobcat))
;;(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\M-?" 'help-for-help)
(global-set-key "\C-x?" 'help-for-help)
(global-set-key [f1] 'help-for-help)
(global-set-key "\C-xj" 'goto-line) ;; M-g で指定行へ移動

(define-key emacs-lisp-mode-map "\C-c\C-r" 'eval-region)

;; 改行キーでオートインデント
(define-key global-map "\C-m" 'newline-and-indent)
(setq indent-line-function 'indent-relative-maybe) ;;インデント方法. お好みで. . .

;;----------------------------------------------------------------------
;;16.2 ファイルに色をつけよう − font-lock (2003/07/12)
;;----------------------------------------------------------------------
(if window-system
    (global-font-lock-mode t) ;; フォントロックを使用する
  )

(setq font-lock-support-mode
      '((emacs-lisp-mode . jit-lock-mode) ;; モードによって切りかえたい時
;;        (c++-mode . fast-lock-mode)
        (t . jit-lock-mode))) ;; デフォルト
;;コメントの色
;;(set-face-foreground 'font-lock-comment-face "medium purple")
;;name の色
;;(set-face-foreground 'font-lock-function-name-face "LightSkyBlue")


;;----------------------------------------------------------------------
;;16.3 タブ幅の設定 (2004/02/18)
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
;;16.4 カーソル位置の表示 (2003/06/27)
;;----------------------------------------------------------------------
;;モードラインにカーソルがある行の行数を表示
(line-number-mode 1)
;;モードラインにカーソルがある位置の文字数を表示
(column-number-mode 1)


;;----------------------------------------------------------------------
;;16.7 リージョンをカスタマイズしよう (2005/03/20)
;;----------------------------------------------------------------------
;;16.7.1 リージョン部に色をつける & リージョン部のみ置換 (2005/03/20)
;;----------------------------------------------------------------------
(setq transient-mark-mode t)
;;(setq highlight-nonselected-windows nil)

;;----------------------------------------------------------------------
;;16.7.2 カーソルキーでリージョンを選択 (2003/11/05)
;;----------------------------------------------------------------------
(delete-selection-mode 1)


;;----------------------------------------------------------------------
;;16.8 便利に編集するための設定 (2003/11/24)
;;----------------------------------------------------------------------
;;16.8.1 一行まるごとカット (2003/04/13)
;;----------------------------------------------------------------------
(setq kill-whole-line t)

;;----------------------------------------------------------------------
;;16.8.2 同一ファイル名のバッファ名を分かりやすく — uniquify (2003/04/13)
;;----------------------------------------------------------------------
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;;(setq uniquify-ignore-buffers-re "*[^*]+*")


;;----------------------------------------------------------------------
;;16.9 yes or no を入力したくない (2003/04/13)
;;----------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)


;;----------------------------------------------------------------------
;;17.4 パーサ semantic — ライブラリ (2003/10/20)
;;----------------------------------------------------------------------
;;(setq semantic-load-turn-everything-on t)
;;(require 'semantic-load)


