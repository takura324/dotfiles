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

(global-set-key (kbd "M-*") 'pop-tag-mark)

;;----------------------------------------------------------------------
;; タグファイルの自動生成 (2003/11/18)
;;----------------------------------------------------------------------
;; (defadvice find-tag (before c-tag-file activate)
;;   "Automatically create tags file."
;;   (let ((tag-file (concat default-directory "TAGS")))
;;     (unless (file-exists-p tag-file)
;;       (shell-command "etags *.[ch] *.cpp *.el .*.el -o TAGS 2>/dev/null"))
;;     (visit-tags-table tag-file)))

(defadvice xref-find-definitions (before xref-find-definitions-file activate)
  "Automatically create tags file."
  (let ((tag-file (concat default-directory "TAGS")))
    (unless (file-exists-p tag-file)
      (shell-command "etags *.[ch] *.cpp *.el .*.el -o TAGS 2>/dev/null"))
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


;; ;;----------------------------------------------------------------------
;; ;; 関数を一覧表示する - navi.el
;; ;;----------------------------------------------------------------------
;; (load-library "navi")
;; (global-set-key [f11] 'call-navi)
;; (global-set-key "\C-x\C-l" 'call-navi)
;; (defun call-navi ()
;;   (interactive)
;;   (navi (buffer-name)))

;; (setq navi-search-exp-text
;;       "^\\([ \t]*[・●○0-9]+.*\\)$")

;; (setq navi-search-exp-lisp
;;   "^\\([ \t]*(defun[ \t]+.*\\|;+[0-9]+.*\\)$")


;;----------------------------------------------------------------------
;; cc-mode
;;----------------------------------------------------------------------
(add-to-list 'c-default-style '(c++-mode . "bsd"))

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

;;----------------------------------------------------------------------
;; Flymakeによる文法チェック
;;----------------------------------------------------------------------
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

;;----------------------------------------------------------------------
;; Flycheckによる文法チェック
;;----------------------------------------------------------------------
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



;;----------------------------------------------------------------------
;; Refactoring
;;----------------------------------------------------------------------
;;(package-install 'srefactor)
(require 'srefactor)

(define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
(define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)

;;----------------------------------------------------------------------
;; auto-complete (C ヘッダーファイル)
;;----------------------------------------------------------------------
;;(package-install 'auto-complete-c-headers)

(require 'auto-complete-c-headers)
(defun my:ac-c-header-init ()　
       (add-to-list 'ac-sources 'ac-source-c-headers))
(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)

;;これでheaderが補完されない場合は、terminalで"gcc -xc++ -E -v -"と入
;;力してincludeファイルの場所を確認してinit.elに上記のdefunのカッコ内
;;に以下を加える。
;;(add-to-list 'achead:include-directoies '"includeファイルのある場所/include")

;;----------------------------------------------------------------------
;; iedit
;;
;; 同じ変数名を同時に変更できる。
;;----------------------------------------------------------------------
;; (package-install 'iedit)
(define-key global-map (kbd "C-c C-;") 'iedit-mode)


;;----------------------------------------------------------------------
;; auto-complete-clang-async
;;----------------------------------------------------------------------
;;(package-install 'auto-complete-clang-async)

;;----------------------------------------------------------------------
;; auto-complete-clang
;;----------------------------------------------------------------------
;;(package-install 'auto-complete-clang)
(require 'auto-complete-clang)
(defun my-ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)

(setq ac-clang-executable "clang")
(setq ac-clang-auto-save t)

(setq ac-clang-flags
      (mapcar (lambda (item) (concat "-I" item))
              (split-string
               "\
 c:/mingw/lib/gcc/mingw32/5.3.0/include/c++
 c:/mingw/lib/gcc/mingw32/5.3.0/include/c++/mingw32
 c:/mingw/lib/gcc/mingw32/5.3.0/include/c++/backward
 c:/mingw/lib/gcc/mingw32/5.3.0/include
 c:/mingw/include
 c:/mingw/lib/gcc/mingw32/5.3.0/include-fixed
" "\n" t
               )))


;; (defadvice ac-clang-call-process (before ac-clang-call-process-change-path activate)
;;   (setq ac-clang-executable "bash.exe")
;;   (let ((clang-cmd (format "%s %s"
;;                            "clang"
;;                            (mapconcat (lambda (x)
;;                                         (replace-regexp-in-string "/" "\\\\\\\\" x))
;;                                       args " ")
;;                            )))
;;     (princ (stringp clang-cmd))
;;     ;;(setq args '("-c" clang-cmd))
;;     (ad-set-args 1 "-c")
;;     (ad-set-args 2 clang-cmd)
;;     )
;;   ;;(princ args)
;;   )

