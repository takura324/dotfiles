;;; Javascript
;;; https://code.google.com/p/js2-mode/downloads/detail?name=js2-mode.el

;;;package-list-packagesでインストールした場合の設定
(package-initialize)
 
;;;js2-modeの設定
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
