;; ----------------------------------------------------------------------------------------
;; Windows の Emacs 対策
;; (1) ghc-check.el の修正 - defun ghc-check-send
;;
;; ;; hack by Koyama 2015-06-10
;; ;;  (let ((file (buffer-file-name)))
;;   (let
;; 	  ((file (replace-regexp-in-string "^/\\([a-z]\\)/" "\\1:/" buffer-file-name)))
;;
;; (2) inf-haskell.el の修正 - defun inferior-haskell-load-file
;; ;; hack by Koyama 2015-06-10
;; ;;        (file buffer-file-name)
;;           (file (replace-regexp-in-string "^/\\([a-z]\\)/" "\\1:/" buffer-file-name))
;; ----------------------------------------------------------------------------------------

;; ghc-mod のインストール
;;   http://d.hatena.ne.jp/osyo-manga/20110928/1317190246
;; (1) cabal のインストール

;;;
;;; Haskell mode
;;;   2015-06-10
;;;   http://futurismo.biz/archives/2662
;;;
(autoload 'haskell-mode "haskell-mode" nil t)
(autoload 'haskell-cabal "haskell-cabal" nil t)
 
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
(add-to-list 'auto-mode-alist '("\\.cabal\\'" . haskell-cabal-mode))

;; indent の有効.
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)

(add-hook 'haskell-mode-hook
          '(lambda ()
             (local-set-key "\C-j" (lambda () (interactive)(insert " -> ")))
             (local-set-key "\M-j" (lambda () (interactive)(insert " => ")))
             (local-set-key "\C-l" (lambda ()(interactive)(insert " <- ")))
             ))

;; Haskell Script の編集モード
;; Haskell でかかれたスクリプトを haskell-mode で編集する.
;; #!/usr/bin/env runhaskell
(add-to-list 'interpreter-mode-alist '("runghc" . haskell-mode))
(add-to-list 'interpreter-mode-alist '("runhaskell" . haskell-mode))

;; Ghci との連携
;; M-x run-haskell で ghci が起動.
(setq haskell-program-name "ghci")
;;       "/c/Haskell/2014.2.0.0/bin/ghci")

;; C-c C-l でも起動.
(add-hook 'haskell-mode-hook 'inf-haskell-mode) ;; enable

;; ghci の起動とファイルの読み込みを一緒に行う設定.
(defadvice inferior-haskell-load-file (after change-focus-after-load)
  "Change focus to GHCi window after C-c C-l command"
  (other-window 1))
(ad-activate 'inferior-haskell-load-file)


;;; gcd-mod
;; % cabal update
;; % cabal install ghc-mod

(add-to-list 'load-path "/C/Program Files/Haskell/i386-windows-ghc-7.10.2/ghc-mod-5.4.0.0/elisp")
;;(add-to-list 'load-path "/c/Program Files/Haskell/x86_64-windows-ghc-7.8.3/ghc-mod-5.2.1.2")

(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

;; ;; flymake
;; (add-hook 'haskell-mode-hook (lambda () (flymake-mode)))

;; hlint
;; % cabal install hlint
;; C-c C-c でカーソル部のチェック.


;;; 自動補完

;; こんなの見つけた. ac-haskell-process.

;; https://github.com/purcell/ac-haskell-process
;; (require 'ac-haskell-process) ; if not installed via package.el
;; (add-hook 'interactive-haskell-mode-hook 'ac-haskell-process-setup)
;; (add-hook 'haskell-interactive-mode-hook 'ac-haskell-process-setup)
;; (eval-after-load "auto-complete"
;;   '(add-to-list 'ac-modes 'haskell-interactive-mode))

