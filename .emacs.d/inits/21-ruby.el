;;----------------------------------------------------------------------
;; enh-ruby-mode
;;----------------------------------------------------------------------
;;(package-install 'enh-ruby-mode)

;;----------------------------------------------------------------------
;; ruby-modeのインデント設定
;;----------------------------------------------------------------------
(setq 
 ruby-deep-indent-paren-style nil ; 改行時のインデントを調整する
 ;; ruby-mode実行時にindent-tabs-modeを設定値に変更
 ;; ruby-indent-tabs-mode t ; タブ文字を使用する。初期値はnil
 ) 

;;----------------------------------------------------------------------
;; 括弧の自動挿入──ruby-electric
;;----------------------------------------------------------------------
;;(package-install 'ruby-electric)
(require 'ruby-electric nil t)

;;----------------------------------------------------------------------
;; endに対応する行のハイライト──ruby-block
;;----------------------------------------------------------------------
;;(package-install 'ruby-block)
(when (require 'ruby-block nil t)
  (setq ruby-block-highlight-toggle t))

;;----------------------------------------------------------------------
;; インタラクティブRubyを利用する──inf-ruby
;;----------------------------------------------------------------------
;; ;;(package-install 'inf-ruby)
;; (autoload 'run-ruby "inf-ruby"
;;   "Run an inferior Ruby process")
;; (autoload 'inf-ruby-keys "inf-ruby"
;;   "Set local key defs for inf-ruby in ruby-mode")

;; ;; ruby-mode-hook用の関数を定義
;; (defun ruby-mode-hooks ()
;;   (inf-ruby-keys)
;;   (ruby-electric-mode t)
;;   (ruby-block-mode t))
;; ;; ruby-mode-hookに追加
;; (add-hook 'ruby-mode-hook 'ruby-mode-hooks)

(autoload 'inf-ruby "inf-ruby" "Run an inferior Ruby process" t)
(add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)


;; rcodetools ( xmpfilter )
(require 'rcodetools)
(setq rct-find-tag-if-available nil)
(defun ruby-mode-hook-rcodetools ()
  (define-key ruby-mode-map "\M-\C-i" 'rct-complete-symbol)
  (define-key ruby-mode-map "\C-c\C-t" 'ruby-toggle-buffer)
  (define-key ruby-mode-map "\C-c\C-f" 'rct-ri)
  (define-key ruby-mode-map (kbd "C-c C-d") 'xmp))
(add-hook 'ruby-mode-hook 'ruby-mode-hook-rcodetools)
