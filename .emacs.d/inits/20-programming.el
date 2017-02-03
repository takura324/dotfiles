(require 'bind-key)

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
;; M-, (pop-tag-mark)
;; M-x tags-search → M-,
;; M-x tags-query-replace
;;
;; C-u M-. : 同名の関数があった場合
;;
;; M-x visit-tags-table : TAGS ファイルの切り替え
;; M-x list-tags : 関数の一覧を表示
;; M-x tags-apropos : 正規表現に一致した関数のみを表示
;; M-x tags-reset-tags-tables : タグファイルの情報をリセット

;;(bind-key "M-*" 'pop-tag-mark)

;;----------------------------------------------------------------------
;; タグファイルの自動生成
;;----------------------------------------------------------------------
;; (defadvice find-tag (before c-tag-file activate)
;;   "Automatically create tags file."
;;   (let ((tag-file (concat default-directory "TAGS")))
;;     (unless (file-exists-p tag-file)
;;       (shell-command "etags *.[ch] *.cpp *.el .*.el -o TAGS 2>/dev/null"))
;;     (visit-tags-table tag-file)))

;; (defadvice xref-find-definitions (before xref-find-definitions-file activate)
;;   "Automatically create tags file."
;;   (let ((tag-file (concat default-directory "TAGS")))
;;     (unless (file-exists-p tag-file)
;;       (shell-command "etags *.[ch] *.cpp *.el .*.el -o TAGS 2>/dev/null"))
;;     (visit-tags-table tag-file)))

;; (defun after-save-hook--ctags (&rest _)
;;   (if (and (stringp tags-file-name) (file-exists-p tags-file-name))
;;       (let ((current-dir-name (file-name-directory (buffer-file-name (current-buffer))))
;;             (tags-dir-name (file-name-directory tags-file-name)))
;;         (when (string-prefix-p tags-dir-name current-dir-name)
;;           (shell-command (format "ctags -e -R \"%s\"" tags-dir-name))
;;           (visit-tags-table tags-file-name)))))

;; (add-hook 'after-save-hook 'after-save-hook--ctags)

;;(package-install 'ctags-update)
(require 'ctags-update)
;;; 注意！exuberant-ctagsを指定する必要がある
;;; Emacs標準のctagsでは動作しない！！
;;(setq ctags-update-command "/usr/bin/ctags")
;;; 使う言語で有効にしよう
(add-hook 'c-mode-common-hook  'turn-on-ctags-auto-update-mode)
;;(add-hook 'emacs-lisp-mode-hook  'turn-on-ctags-auto-update-mode)

;;----------------------------------------------------------------------
;; タグジャンプ － gtags ， global (2007/11/29)
;; → helm-gtags で代替
;;----------------------------------------------------------------------
;; # cd source
;; # gtags -v
;;
;; * M-t : 関数の定義元へ移動
;; * M-r : 関数を参照元の一覧を表示．RET で参照元へジャンプできる
;; * M-s : 変数の定義元と参照元の一覧を表示．RET で該当箇所へジャンプできる．
;; * C-t : 前のバッファへ戻る
;; * gtags-find-pattern : 関連ファイルからの検索．
;; * gtags-find-tag-from-here : カーソル位置の関数定義へ移動．

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
;;              ;;(gtags-make-complete-list)
;;              ))

;; ;; update GTAGS
;; (defun update-gtags (&optional prefix)
;;   (interactive "P")
;;   (let ((rootdir (gtags-get-rootpath))
;;         (args (if prefix "-v" "-iv")))
;;     (when rootdir
;;       (let* ((default-directory rootdir)
;;              (buffer (get-buffer-create "*update GTAGS*")))
;;         (save-excursion
;;           (set-buffer buffer)
;;           (erase-buffer)
;;           (setq default-directory rootdir)
;;           (let ((result (process-file "gtags" nil buffer nil args)))
;;             (if (= 0 result)
;;                 (message "GTAGS successfully updated.")
;;               (message "update GTAGS error with exit status %d" result))))))))

;; ;;----------------------------------------------------------------------
;; ;; 関数を一覧表示する - navi.el
;; ;;----------------------------------------------------------------------
;; (load-library "navi")
;; (bind-key [f11] 'call-navi)
;; (bind-key "\C-x\C-l" 'call-navi)
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
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))

(add-to-list 'c-default-style '(c++-mode . "bsd"))
(add-to-list 'c-default-style '(c-mode . "bsd"))

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

;; ;;----------------------------------------------------------------------
;; ;; Flymakeによる文法チェック
;; ;;----------------------------------------------------------------------
;; (require 'flymake nil t)

;; (defun flymake-cc-init ()
;;   (let* ((temp-file   (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;          (local-file  (file-relative-name
;;                        temp-file
;;                        (file-name-directory buffer-file-name))))
;;     (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))

;; (push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)

;; ;;(add-hook 'c-mode-common-hook 'flycheck-mode)


;; エラーをミニバッファに表示する
(defun flymake-display-err-minibuf ()
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (let* ((line-no (line-number-at-pos))
         (line-err-info-list
          (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list
        (let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
               (full-file (flymake-ler-full-file (nth (1- count) line-err-info-list)))
               (text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)))
      (setq count (1- count)))))

(defun my-flymake-display-err-menu-for-current-line ()
  "Displays the error/warning for the current line via popup-tip"
  (interactive)
  (let* ((line-no (line-number-at-pos))
         (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (menu-data (flymake-make-err-menu-data line-no line-err-info-list)))
    (if menu-data
        (popup-tip (mapconcat #'(lambda (err)
                                  (nth 0 err))
                              (nth 1 menu-data) "\n")))))

(defadvice flymake-goto-prev-error (after flymake-goto-prev-error-display-message activate)
  (flymake-display-err-minibuf))
(defadvice flymake-goto-next-error (after flymake-goto-next-error-display-message activate)
  (flymake-display-err-minibuf))


;;----------------------------------------------------------------------
;; Flycheckによる文法チェック
;;----------------------------------------------------------------------
(require 'flycheck)

(setq-default flycheck-gcc-language-standard "c++11")


;;----------------------------------------------------------------------
;; Refactoring
;;----------------------------------------------------------------------
;;(package-install 'srefactor)
(require 'srefactor)

(bind-key "<M-return>" 'srefactor-refactor-at-point c-mode-map)
(bind-key "<M-return>" 'srefactor-refactor-at-point c++-mode-map)

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


;; ;;----------------------------------------------------------------------
;; ;; auto-complete-clang-async
;; ;;----------------------------------------------------------------------
;; ;;(package-install 'auto-complete-clang-async)

;; ;;----------------------------------------------------------------------
;; ;; auto-complete-clang
;; ;;----------------------------------------------------------------------
;; ;;(package-install 'auto-complete-clang)
;; (require 'auto-complete-clang)

;; (defun my-ac-cc-mode-setup ()
;;   (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
;; (add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)

;; (setq ac-clang-auto-save t)

;; (setq ac-clang-flags
;;       (mapcar (lambda (item) (concat "-I" item))
;;               (split-string
;;                "\
;;  c:/mingw/lib/gcc/mingw32/5.3.0/include/c++
;;  c:/mingw/lib/gcc/mingw32/5.3.0/include/c++/mingw32
;;  c:/mingw/lib/gcc/mingw32/5.3.0/include/c++/backward
;;  c:/mingw/lib/gcc/mingw32/5.3.0/include
;;  c:/mingw/include
;;  c:/mingw/lib/gcc/mingw32/5.3.0/include-fixed
;; " "\n" t
;; )))


;; ;; (defadvice ac-clang-call-process (before ac-clang-call-process-change-path activate)
;; ;;     (setq args
;; ;;         (mapcar (lambda (x)(replace-regexp-in-string "/" "\\\\\\\\" x))
;; ;;                 args)))

;; ;; 再定義
;; ;;   call-process -> call-process-shell-command に変更
;; ;;   call-process-region -> call-process-shell-command-on-region に変更
;; (defun my-ac-clang-call-process (prefix &rest args)
;;   (setq args
;;         (mapcar (lambda (x)(replace-regexp-in-string "/" "\\\\\\\\" x))
;;                 args))
;;   (let ((buf (get-buffer-create "*clang-output*"))
;;         res)
;;     (with-current-buffer buf (erase-buffer))
;;     (setq res (if ac-clang-auto-save
;;                   (apply 'call-process-shell-command ac-clang-executable nil buf nil args)
;;                 (apply 'call-process-shell-command-region (point-min) (point-max)
;;                        ac-clang-executable buf args)))
;;     (with-current-buffer buf
;;       (unless (eq 0 res)
;;         (ac-clang-handle-error res args))
;;       ;; Still try to get any useful input.
;;       (ac-clang-parse-output prefix))))


;; (defun call-process-shell-command-region (start end command &optional infile buffer display
;; 					   &rest args)
;;   (call-process-region start end shell-file-name
;; 		infile buffer display
;; 		shell-command-switch
;; 		(mapconcat 'identity (cons command args) " ")))

;; (advice-add 'ac-clang-call-process :override 'my-ac-clang-call-process)



;;----------------------------------------------------------------------
;; C/C++ ヘッダーとソースの切り替え
;;----------------------------------------------------------------------
;; M-x ff-find-other-file


;;----------------------------------------------------------------------
;; annotate.el : 【コードリーディング支援】ファイルを修正することなく行に注釈をつける
;;
;; http://emacs.rubikitch.com/annotate/
;;----------------------------------------------------------------------
;;(package-install 'annotate)
(require 'annotate)
(setq annotate-file "~/.emacs.d/annotations")
;;; view-modeでも使えるようにする
(defun annotate-editing-text-property (&rest them)
  (let ((bmp (buffer-modified-p))
        (inhibit-read-only t))
    (apply them)
    (set-buffer-modified-p bmp)))
(advice-add 'annotate-change-annotation :around 'annotate-editing-text-property)
(advice-add 'annotate-create-annotation :around 'annotate-editing-text-property)
;; ;;; 規約違反なキーバインドを矯正
;; (define-key annotate-mode-map (kbd "C-c C-a") nil)
;; (define-key annotate-mode-map (kbd "C-c a") 'annotate-annotate)

(require 'view)
(define-key view-mode-map (kbd "a") 'annotate-annotate)


;;; 常に使えるようにする
;(add-hook 'find-file-hook 'annotate-mode)

;; 2016-12-14
;; ediff-buffers の前に annotate-mode は外す（エラーになってしまうため）
(eval-when-compile (require 'cl))

(defun my-ediff-buffers-before (buffer-A buffer-B &optional startup-hooks job-name)
  (loop for buf in (list buffer-A buffer-B)
        do (my-annotate-shutdown buf)))

(defun my-ediff-buffers-after (buffer-A buffer-B &optional startup-hooks job-name)
  (loop for buf in (list buffer-A buffer-B)
        do (my-annotate-initialize buf)))

(defun my-annotate-shutdown (buf)
  (with-current-buffer buf
    (if annotate-mode
        (annotate-shutdown))))

(defun my-annotate-initialize (buf)
  (with-current-buffer buf
    (unless annotate-mode
        (annotate-initialize))))

(advice-add 'ediff-buffers :before 'my-ediff-buffers-before)
(advice-add 'ediff-buffers :after  'my-ediff-buffers-after)


;;----------------------------------------------------------------------
;; origami.el : elisp,Clojure,C系言語(C,Java,JavaScript,C++,Perl)でorg-mode風の折畳みをする
;;
;; http://emacs.rubikitch.com/origami/
;;----------------------------------------------------------------------
;;(package-install 'origami)

(require 'origami)
;; (makunbound 'origami-view-mode-map)
(define-minor-mode origami-view-mode
  "TABにorigamiの折畳みを割り当てる"
  nil "折紙"
  '(("\C-i" . origami-cycle))
  (or origami-mode (origami-mode 1)))

(defun origami-cycle (recursive)
  "origamiの機能をorg風にまとめる"
  (interactive "P")
  (call-interactively
   (if recursive 'origami-toggle-all-nodes 'origami-toggle-node)))

(defun view-mode-hook--origami ()
  (when (memq major-mode (mapcar 'car origami-parser-alist))
    (origami-view-mode (if view-mode 1 -1))))

(add-hook 'view-mode-hook 'view-mode-hook--origami)

;; ;;----------------------------------------------------------------------
;; ;; yafolding.el : インデントが深い部分を隠す
;; ;;
;; ;; http://emacs.rubikitch.com/yafolding/
;; ;;----------------------------------------------------------------------
;; ;;(package-install 'yafolding)
;; (add-hook 'prog-mode-hook 'yafolding-mode)

;; (require 'yafolding)
;; (defun view-mode-hook--yafolding ()
;;   (define-key view-mode-map (kbd "C-i") 'yafolding-toggle-element)
;;   (define-key view-mode-map (kbd "<backtab>") 'yafolding-hide-parent-element)
;;   (define-key view-mode-map (kbd "RET") 'yafolding-toggle-element))
;; (add-hook 'view-mode-hook 'view-mode-hook--yafolding)

;; (bind-key "<C-return>" 'yafolding-toggle-element)

