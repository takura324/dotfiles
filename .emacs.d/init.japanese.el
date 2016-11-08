;;(require 'un-define)
;;(require 'jisx0213)

;;15.1 日本語の編集 (2004/01/15)
;;(set-language-environment "Japanese")
;;(setq default-input-method "MW32-IME")

;; default-input-method の設定を有効にする
;;(mw32-ime-initialize)


;;15.2.2 東雲フォントを使う (2004/01/25)
(load "shinonome-setup")

;;15.2.3 MS ゴシックなどの設定 
;;(load "windows-fonts-setup")


;;21.7.1 文書整形 (機種依存文字の削除) — text-adjust (2003/06/27)
(load-library "text-adjust")
(setq adaptive-fill-regexp "[ \t]*")
(setq adaptive-fill-mode t)


;;辞書登録
(defalias 'toroku-region 'mw32-ime-toroku-region)
