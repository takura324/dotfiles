;; find-file で SPC 補完
(define-key minibuffer-local-filename-completion-map " " 'minibuffer-complete-word)

;;
;; 自動コンパイル
;; (install-elisp-from-emacswiki 'auto-async-byte-compile.el)
;;
;;(require 'auto-async-byte-compile)
;;(setq auto-async-byte-compile-exclude-files-regexp "/hoge")
;;(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)


;; ;;; grep-find
;; (setq grep-command "grep -aniH -e ")
;; (setq grep-template "grep <X> <C> -aniH -e <R> <F>")
;; (setq grep-find-template "find . <X> -type f <F> -print | \"xargs\" grep <C> -aniH -e <R>")


