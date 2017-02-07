;;----------------------------------------------------------------------
;; 【Google＠Emacs 25.1】M-s M-wでサーチエンジンによる検索が使える
;;
;; http://emacs.rubikitch.com/eww-search-words-emacs25/
;;----------------------------------------------------------------------

;; M-s M-w (eww-search-words) は検索エンジンによる検索結果をEWWで表示します。
(setq eww-search-prefix "https://www.google.co.jp/search?btnI&q=")

;; (add-hook 'eww-mode-hook
;;           '(lambda()
;;              (view-mode 1)))

;;----------------------------------------------
;; helm-google.el :
;; Google検索結果をhelmで表示する(HTML・API両対応)
;;----------------------------------------------
;;(package-install 'helm-google)
(require 'helm-google)

(require 'xml)
(setq helm-google-tld "co.jp")
;;; Google側のサイトデザイン変更で動かなくなったらAPI検索に切替える
;; (setq helm-google-search-function 'helm-google-api-search)
;;; ブラウザをEWWにすればEmacs内で完結する
(setq browse-url-browser-function 'eww-browse-url)


;;----------------------------------------------
;; google-this.el :
;; Emacsからググるたった1つのコマンド
;;----------------------------------------------
;; (package-install 'google-this)

;;; マイナーモードとして使いたいならば以下の設定
(setq google-this-keybind (kbd "C-x g"))
(google-this-mode 1)
(require 'google-this)
(setq google-this-location-suffix "co.jp")
(defun google-this-url () "URL for google searches."
  ;; 100件/日本語ページ/5年以内ならこのように設定する
  (concat google-this-base-url google-this-location-suffix
          "/search?q=%s&hl=ja&num=100&as_qdr=y5&lr=lang_ja"))
