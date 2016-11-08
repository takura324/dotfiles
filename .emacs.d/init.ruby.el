;;----------------------------------------------------------------------
;; Ruby モード
;; http://futurismo.biz/archives/2213
;;
;; (package-install 'enh-ruby-mode)
;;
;;----------------------------------------------------------------------

;;----------------------------------------------------------------------
;; 2 入力支援
;;----------------------------------------------------------------------
;; 2.1 ruby-mode/enhanced-ruby-mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(add-to-list 'auto-mode-alist '("\\.rb$latex " . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))


(add-hook 'ruby-mode-hook
          '(lambda ()
             (setq tab-width 2)
             (setq ruby-indent-level tab-width)
             (setq ruby-deep-indent-paren-style nil)
             ;;(define-key ruby-mode-map [return] 'ruby-reindent-then-newline-and-indent)
             ))

;; 2.2 ruby-electric
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))
(setq ruby-electric-expand-delimiters-list nil)

;; 2.3 ruby-block
;; ruby-block.el --- highlight matching block
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)


;;----------------------------------------------------------------------
;; 3 コードリーディング
;;----------------------------------------------------------------------
;; 3.1 ctags/ripper-tags

;; 3.2 rcodetools ( xmpfilter )
;; gem install rcodetools
;;
;; <sites>
;; http://qiita.com/ironsand/items/ce7c02eb46fcc25a438b
;;
;; パスに以下を追加
;;   D:\gnupack\home\.gem\ruby\gems\rcodetools-0.8.5.0\bin
;;
(require 'rcodetools)
(setq rct-find-tag-if-available nil)
(defun ruby-mode-hook-rcodetools ()
;;  (define-key ruby-mode-map "\M-\C-i" 'rct-complete-symbol)
  (define-key ruby-mode-map (kbd "<C-tab>") 'rct-complete-symbol)
  (define-key ruby-mode-map "\C-c\C-t" 'ruby-toggle-buffer)
  (define-key ruby-mode-map "\C-c\C-f" 'rct-ri)
  (define-key ruby-mode-map "\C-c\C-d" 'xmp)
  (define-key ruby-mode-map "\M-p" 'xmp)
  )
(add-hook 'ruby-mode-hook 'ruby-mode-hook-rcodetools)


(defun make-ruby-scratch-buffer ()
  (with-current-buffer (get-buffer-create "*ruby scratch*")
    (ruby-mode)
    (current-buffer)))
(defun ruby-scratch ()
  (interactive)
  (pop-to-buffer (make-ruby-scratch-buffer)))

;; https://github.com/sho-h/dot-emacs-dot-d/blob/master/conf/init-anything-rcodetools.el
;; (install-elisp-from-emacswiki "anything-rcodetools.el")
(require 'anything-rcodetools)

;; 3.3 rdefs
;; 3.4 highlight-symbol, auto-highlight-symbol

;;----------------------------------------------------------------------
;; 4 リファクタリング
;;----------------------------------------------------------------------
;; 4.1 anzu
;; 4.2 ruby-refactor

;;----------------------------------------------------------------------
;; 5 コーディング支援
;;----------------------------------------------------------------------
;; 5.1 inf-ruby
;; 5.2 SmartCompile
;; 5.3 auto-complite-ruby/RSense
;; 5.4 yasnippet-ruby

;;----------------------------------------------------------------------
;; 6 静的解析
;;----------------------------------------------------------------------
;; 6.1 flymake-ruby
;; 6.2 flycheck
;; 6.3 rubocop
;; 6.4 ruby-lint
