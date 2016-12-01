;;----------------------------------------------------------------------
;;51.1.1 サブディレクトリのファイルも検索 (2005/11/22)
;;----------------------------------------------------------------------
(setq grep-use-null-device nil)
(setq grep-find-use-xargs t)

;;----------------------------------------------------------------------
;;51.3 文字コードを自動判別する grep － lgrep (2005/11/22)
;;----------------------------------------------------------------------
;;(setq grep-command "lgrep -nk -Ou8 ")
;;(setq grep-command "lgrep -n -As ")
;;(setq grep-program "lgrep")

;; ;; shell-quote-argumentの問題回避 
;; (defvar quote-argument-for-windows-p t "enables `shell-quote-argument' workaround for windows.") 
;; (defadvice shell-quote-argument (around shell-quote-argument-for-win activate) 
;; "workaround for windows." 
;; (if quote-argument-for-windows-p 
;; (let ((argument (ad-get-arg 0))) 
;; (setq argument (replace-regexp-in-string "\\\\" "\\\\" argument nil t)) 
;; (setq argument (replace-regexp-in-string "'" "'\\''" argument nil t)) 
;; (setq ad-return-value (concat "'" argument "'"))) 
;; ad-do-it)) 

;; ;; lgrep で Shift_JIS を使うように設定 
;; (setq grep-host-defaults-alist nil) ;; これはおまじないだと思ってください 
;; ;;(setq grep-template "lgrep -Ks -Os <C> -n <R> <F> <N>")
;; (setq grep-template "lgrep -Is -Ou8 <C> -n <R> <F> <N>")
;; ;;(setq grep-template "lgrep -Ou8 <C> -n <R> <F> <N>") 
;; ;;(setq grep-find-template "find . <X> -type f <F> -print0 | xargs -0 -e lgrep -Ks -Os <C> -n <R> <N>") 
;; (setq grep-find-template "find . <X> -type f <F> -print0 | xargs -0 -e lgrep -Is -Ou8 <C> -n <R> <N>")

;; ;;----------------------------------------------------------------------
;; ;;51.4 grep の一致項目に色付け，絞り込み ― color-grep (2007/11/07)
;; ;;----------------------------------------------------------------------
;; (require 'color-grep)
;; ;; grep バッファを kill 時に，開いたバッファを消す
;; (setq color-grep-sync-kill-buffer t)

;; ;;----------------------------------------------------------------------
;; ;;51.5 grep を便利にしたい ― igrep (2005/11/22)
;; ;;----------------------------------------------------------------------
;; (autoload 'igrep "igrep"
;;   "*Run `grep` PROGRAM to match EXPRESSION in FILES..." t)
;; (autoload 'igrep-find "igrep"
;;   "*Run `grep` via `find`..." t)
;; (autoload 'dired-do-igrep "igrep"
;;   "*Run `grep` on the marked (or next prefix ARG) files." t)
;; (autoload 'igrep-insinuate "igrep"
;;   "Define `grep' aliases for the corresponding `igrep' commands." t)
;; (autoload 'igrep-visited-files "igrep"
;;   "*Run `grep` ... on all visited files." t)
;; (autoload 'dired-do-igrep-find "igrep"
;;   "*Run `grep` via `find` on the marked (or next prefix ARG) directories." t)
;; (autoload 'Buffer-menu-igrep "igrep"
;;   "*Run `grep` on the files visited in buffers marked with '>'." t)

;; ;; 以下は lgrep を使うための設定
;; ;; (if (eq system-type 'cygwin)
;; ;;     (lambda()
;; ;;      (setq igrep-program "lgrep")
;; ;;      (setq igrep-expression-option "-n -Ou")
;; ;;      ))

;; ;; * M-x igrep
;; ;;   普通の grep です．対話式なので，普通の grep よりは馴染みやすいです．
;; ;; 
;; ;; * M-x igrep-find
;; ;;   grep-find です．サブディレクトリまで検索することができます．
;; ;; 
;; ;; * M-x dired-do-igrep
;; ;;   dired で m によりマークをつけたものだけを対象に grep ができます．
;; ;; 
;; ;; * M-x dired-do-igrep-find
;; ;;   dired-do-igrep の find 版です
;; ;; 
;; ;; * M-x igrep-visited-files
;; ;;   今開いているファイルのみを対象に grep ができます．
;; ;; 
;; ;; * M-x Buffer-menu-igrep
;; ;;   C-x C-b でバッファリストを表示し，m でマークをつけてから，M-x Buffer-menu-igrep とすると，
;; ;;   マークをつけたバッファのみを対象に grep ができます．

;; ;;----------------------------------------------------------------------
;; ;;51.6 メモを grep ― mgrep (2004/02/03)
;; ;;----------------------------------------------------------------------
;; (require 'mgrep)
;; (if (eq system-type 'windows-nt)
;;     (lambda()
;;      (setq mgrep-list
;;            '(
;;              ;; name directory file find
;;              ("site-lisp" "c:/meadow/site-lisp" "*.el" t)
;;              ("packages-lisp" "c:/meadow/packages/lisp" "*.el" t)
;;              ("texi" "~/www/soft" "*.texi" nil)
;;              ("2ch" "~/navi2ch/html/" "*.html" sub)
;;              ("find2ch" "~/navi2ch/html/" "*.html" subfind)
;;              ))))

;;----------------------------------------------------------------------
;;grep の検索結果を直接編集する ― wgrep
;;----------------------------------------------------------------------
;; (package-install 'wgrep)
(require 'wgrep nil t)

(setq wgrep-change-readonly-file t)
(setq wgrep-enable-key "e")

;; C-c C-p   wgrep-change-to-wgrep-mode
;; C-c C-k   wgrep-abort-changes
;; C-c C-c   wgrep-finish-edit
;; M-x wgrep-save-all-buffers

