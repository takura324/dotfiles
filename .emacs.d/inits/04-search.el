(require 'bind-key)

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ search - isearch                                              ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

;; 大文字・小文字を区別しないでサーチ
(setq-default case-fold-search t)

;; インクリメンタルサーチ時には大文字小文字の区別をしない
(setq isearch-case-fold-search t)

;; インクリメント検索時に縦スクロールを有効化
(setq isearch-allow-scroll nil)

;; C-dで検索文字列を一文字削除
(define-key isearch-mode-map (kbd "C-d") 'isearch-delete-char)

;; C-yで検索文字列にヤンク貼り付け
(define-key isearch-mode-map (kbd "C-y") 'isearch-yank-kill)

;; C-eで検索文字列を編集
(define-key isearch-mode-map (kbd "C-e") 'isearch-edit-string)

;; Tabで検索文字列を補完
(define-key isearch-mode-map (kbd "TAB") 'isearch-yank-word)

;; C-gで検索を終了
(define-key isearch-mode-map (kbd "C-g")
  '(lambda() (interactive) (isearch-done)))


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ search - migemo                                               ;;;
;;;   https://github.com/emacs-jp/migemo                            ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
(require 'migemo)

(defvar migemo-command nil)
(setq migemo-command "cmigemo")

(defvar migemo-options nil)
(setq migemo-options '("-q" "--emacs"))

(defvar migemo-dictionary nil)
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

(defvar migemo-user-dictionary nil)

(defvar migemo-regex-dictionary nil)

(defvar migemo-coding-system nil)
(setq migemo-coding-system 'utf-8-unix)

(load-library "migemo")
;;(migemo-init)

;;--------------------------------------------------------------------------------
;; ace-jump-mode
;;
;; http://emacs.rubikitch.com/sd1409-migemo-ace-jump-mode-dabbrev/
;;--------------------------------------------------------------------------------
(require 'ace-jump-mode)
(setq ace-jump-mode-gray-background t)
(setq ace-jump-word-mode-use-query-char nil)
(setq ace-jump-mode-move-keys
      (append "asdfghjkl;:]qwertyuiop@zxcvbnm,." nil))
(bind-key "C-c ;" 'ace-jump-word-mode)
(bind-key "C-c :" 'ace-jump-line-mode)
(bind-key "C-c ]" 'ace-jump-char-mode)


;;--------------------------------------------------------------------------------
;; dumb-jump.el
;;
;; Ｃ言語、Ｃ＋＋対応！すぐ使える多言語対応関数・変数定義ジャンパー
;; http://emacs.rubikitch.com/dumb-jump/
;;--------------------------------------------------------------------------------
;; M-x package-install dumb-jump

;; マイナーモード M-x dumb-jump-mode を有効にしたら、()内のキーバインドが使えます。
;; dumb-jump-go         (C-M-g) 定義にジャンプする
;; dumb-jump-back       (C-M-p) ジャンプ前の場所に戻る
;; dumb-jump-quick-look (C-M-q) 定義位置をエコーエリアに表示する
