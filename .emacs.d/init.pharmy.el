;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pascal-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(autoload 'opascal-mode "opascal")
;;(add-to-list 'auto-mode-alist
;;             '("\\.\\(pas\\|dpr\\|dpk\\)\\'" . opascal-mode))

(add-hook 'opascal-mode-hook
          '(lambda()
             (setq opascal-indent-level 2)
             (auto-complete-mode t)
             (prefer-coding-system 'cp932)
             (set-terminal-coding-system 'utf-8)
             ;; タブの無効化
             (setq indent-tabs-mode nil)
             ))


;;(modify-coding-system-alist 'file "\\.pas$\\'" 'cp932)
(add-hook 'pascal-mode-hook
          '(lambda()
             (setq pascal-exclude-str-start "{--------------------")
             (setq pascal-exclude-str-end " --------------------}")
             (setq-local  comment-start "//")
             (setq-local  comment-end "")
             (setq pascal-indent-level 2)
             (auto-complete-mode t)
             (prefer-coding-system 'cp932)
             ;;(set-terminal-coding-system 'utf-8)
             ;; タブの無効化
             (setq indent-tabs-mode nil)
             ))


(autoload 'delphi-mode "delphi")
;;(add-to-list 'auto-mode-alist '("\\.\\(pas\\|dpr\\)$" . delphi-mode))

(add-hook 'delphi-mode-hook
          '(lambda ()
             (setq comment-start "// ")
             (loop for c from ?! to ?' do (modify-syntax-entry  c "."))
             (loop for c from ?* to ?/ do (modify-syntax-entry  c "."))
             (loop for c from ?: to ?@ do (modify-syntax-entry  c "."))
             (modify-syntax-entry  ?\ ".")
             (modify-syntax-entry  ?^ ".")
             (modify-syntax-entry  ?` ".")
             (modify-syntax-entry  ?~ ".")
             (modify-syntax-entry  ?| ".")
             (local-set-key (kbd "<RET>")
                            '(lambda ()
                               (interactive)
                               (indent-according-to-mode)
                               (newline-and-indent)))
             (turn-on-lazy-lock)
             (setq delphi-indent-level 2)
             (add-hook 'compilation-mode-hook
                       '(lambda ()
                          (add-to-list 'compilation-error-regexp-alist
                                       '("^\\([^(]+\\)(\\([0-9]+\\)" 1 2))))
             (add-hook 'speedbar-mode-hook
                       '(lambda ()
                          (setq speedbar-file-unshown-regexp
                                (concat
                                 speedbar-file-unshown-regexp
                                 "\\|\\.dfm\\|\\.ddp\\|\\.dcu\\|\\.dof"))
                          (speedbar-add-supported-extension ".pas")))
             
             (abbrev-mode 1)
             (define-abbrev local-abbrev-table
               "beg" t '(lambda ()
                          (skeleton-insert '(nil "in" > \n
                                                 _ \n
                                                 "end;" > \n))
                          (setq skeleton-abbrev-cleanup (point))
                          (add-hook 'post-command-hook
                                    'skeleton-abbrev-cleanup
                                    nil t)))
             (define-abbrev local-abbrev-table
               "bege" t '(lambda ()
                           (skeleton-insert '(nil -1 "in" > \n
                                                  _ \n
                                                  "end" > \n
                                                  "else" > \n
                                                  "begin" > \n \n
                                                  "end;" > \n))
                           (setq skeleton-abbrev-cleanup (point))
                           (add-hook 'post-command-hook
                                     'skeleton-abbrev-cleanup
                                     nil t)))
             (define-abbrev local-abbrev-table
               "if" t '(lambda ()
                         (skeleton-insert '(nil _ " then" > \n))))
             (define-abbrev local-abbrev-table
               "ife" t '(lambda ()
                          (skeleton-insert '(nil -1 _ " then" > \n \n
                                                 "else" > \n))))
             (define-abbrev local-abbrev-table
               "ifb" t '(lambda ()
                          (skeleton-insert '(nil -1 _ " then" > \n
                                                 "begin" > \n \n
                                                 "end;" > \n))))
             (define-abbrev local-abbrev-table
               "ifbe" t '(lambda ()
                           (backward-delete-char 1)
                           (skeleton-insert '(nil -1 _ " then" > \n
                                                  "begin" > \n \n
                                                  "end" > \n
                                                  "else" > \n
                                                  "begin" > \n \n
                                                  "end;" > \n))))
             (define-abbrev local-abbrev-table
               "proc" t '(lambda ()
                           (skeleton-insert '(nil "edure" _ ";" > \n
                                                  "var" > \n \n
                                                  "begin" > \n \n
                                                  "end;" > \n))))
             (define-abbrev local-abbrev-table
               "func" t '(lambda ()
                           (skeleton-insert '(nil "tion" _ " : ;" > \n
                                                  "var" > \n \n
                                                  "begin" > \n \n
                                                  "end;" > \n))))
             (define-abbrev local-abbrev-table
               "for" t '(lambda ()
                          (skeleton-insert '(nil _ " to do" > \n))))
             (define-abbrev local-abbrev-table
               "forb" t '(lambda ()
                           (skeleton-insert '(nil -1 _ " to do" > \n
                                                  "begin" > \n \n
                                                  "end;" > \n))))
             ))

;; (add-hook 'delphi-mode-hook 'turn-on-font-lock)

;; (add-hook 'delphi-mode-hook
;;           '(lambda()
;;              (setq pascal-indent-level 2)
;;              (auto-complete-mode t)
;;              (prefer-coding-system 'cp932)
;;              ;;(set-terminal-coding-system 'utf-8)
;;              ;; タブの無効化
;;              (setq indent-tabs-mode nil)
;;              ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; キーボードマクロ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; M-x gen-start-generating キーボードマクロの定義を開始
;;; M-x gen-stop-generating  キーボードマクロの定義を終了
;;; M-x gen-expand-macro     バッファに書き出し

(defun pharmy-format-oldstyle-table-info ()
  """macroised by U-KOYAMA-PC\koyama @ Thu Jul 23 16:22:52 2015
社長が作成したテーブルPDF資料を Excel に貼り付けられるように文字列整形する。"""
(interactive)
(goto-char (point-min))
(replace-regexp "\\([^ ]\\)\\([A-Z].*\\)" "\\1	\\2" nil)
(goto-char (point-min))
(replace-regexp " [CN][0-9.]+" "	" nil)
(goto-char (point-min))
(replace-regexp " L\( |$\)" "	" nil)
(replace-regexp "\tNo *" "Ｎｏ\t" nil)
)

