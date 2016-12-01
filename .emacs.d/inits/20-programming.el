;;----------------------------------------------------------------------
;; bat / ini ファイルをカラフルに － generic.el
;;----------------------------------------------------------------------
(require 'generic-x)


;;----------------------------------------------------------------------
;; タグジャンプ － 関数定義へジャンプ etags (2003/11/18)
;;----------------------------------------------------------------------
;; # etags *.el
;; # etags mylisp/*.el bin/*.[hc]
;;
;; M-. (find-tag)
;; M-* (pop-tag-mark)
;; M-x tags-search → M-,
;; M-x tags-query-replace
;;
;; C-u M-. : 同名の関数があった場合
;;
;; M-x visit-tags-table : TAGS ファイルの切り替え
;; M-x list-tags : 関数の一覧を表示
;; M-x tags-apropos : 正規表現に一致した関数のみを表示
;; M-x tags-reset-tags-tables : タグファイルの情報をリセット

(global-set-key "\M-*" 'pop-tag-mark)

;;----------------------------------------------------------------------
;; タグファイルの自動生成 (2003/11/18)
;;----------------------------------------------------------------------
(defadvice find-tag (before c-tag-file activate)
  "Automatically create tags file."
  (let ((tag-file (concat default-directory "TAGS")))
    (unless (file-exists-p tag-file)
      (shell-command "etags *.[ch] *.el .*.el -o TAGS 2>/dev/null"))
    (visit-tags-table tag-file)))


;; ;;----------------------------------------------------------------------
;; ;; タグジャンプ － gtags ， global (2007/11/29)
;; ;;----------------------------------------------------------------------
;; ;; # cd source
;; ;; # gtags -v
;; ;;
;; ;; * M-t : 関数の定義元へ移動
;; ;; * M-r : 関数を参照元の一覧を表示．RET で参照元へジャンプできる
;; ;; * M-s : 変数の定義元と参照元の一覧を表示．RET で該当箇所へジャンプできる．
;; ;; * C-t : 前のバッファへ戻る 
;; ;; * gtags-find-pattern : 関連ファイルからの検索．
;; ;; * gtags-find-tag-from-here : カーソル位置の関数定義へ移動． 

;; (autoload 'gtags-mode "gtags" "" t)
;; (setq gtags-mode-hook
;;       '(lambda ()
;;          (local-set-key "\M-t" 'gtags-find-tag)
;;          (local-set-key "\M-r" 'gtags-find-rtag)
;;          (local-set-key "\M-s" 'gtags-find-symbol)
;;          (local-set-key "\C-t" 'gtags-pop-stack)
;;          ))

;; (add-hook 'c-mode-common-hook
;;           '(lambda()
;;              (gtags-mode 1)
;;              (gtags-make-complete-list)
;;              ))


;;----------------------------------------------------------------------
;; 関数を一覧表示する - navi.el
;;----------------------------------------------------------------------
(load-library "navi")
(global-set-key [f11] 'call-navi)
(global-set-key "\C-x\C-l" 'call-navi)
(defun call-navi ()
  (interactive)
  (navi (buffer-name)))

(setq navi-search-exp-text
      "^\\([ \t]*[・●○0-9]+.*\\)$")

(setq navi-search-exp-lisp
  "^\\([ \t]*(defun[ \t]+.*\\|;+[0-9]+.*\\)$")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cc-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq-default c-basic-offset 4     ;;基本インデント量4
              tab-width 4          ;;タブ幅4
              indent-tabs-mode nil)
(defun c-mode-hooks ()
  '(lambda()
     (c-toggle-auto-newline t)
     (c-set-style 'bsd)
     (auto-revert-mode t)
     ;; (flymake-mode t)                   
     ))

(add-hook 'c-mode-hook 'c-mode-hooks)
(add-hook 'c++-mode-hook 'c-mode-hooks)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flymakeによる文法チェック                          
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'flymake nil t)

(defun flymake-cc-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))

(push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)

;;(add-hook 'c-mode-common-hook 'flycheck-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flycheckによる文法チェック                          
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'flycheck)

(flycheck-define-checker c/c++
  "A C/C++ checker using g++."
  :command ("g++" "-Wall" "-Wextra" source)
  :error-patterns  ((error line-start
                           (file-name) ":" line ":" column ":" " エラー: " (message)
                           line-end)
                    (warning line-start
                           (file-name) ":" line ":" column ":" " 警告: " (message)
                           line-end))
  :modes (c-mode c++-mode))

;;(flycheck-select-checker 'c/c++) 
(add-hook 'c-mode-common-hook
          '(lambda()
             (flycheck-select-checker 'c/c++)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Refactoring
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(package-install 'srefactor)
(require 'srefactor)

(define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
(define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Refactoring
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(package-install 'auto-complete-c-headers)

(require 'auto-complete-c-headers)
(add-hook 'c++-mode-hook
          '(setq ac-sources (append ac-sources '(ac-source-c-headers))))
(add-hook 'c-mode-hook
          '(setq ac-sources (append ac-sources '(ac-source-c-headers))))


