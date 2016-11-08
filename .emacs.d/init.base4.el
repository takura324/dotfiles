;;----------------------------------------------------------------------
;;41.3.1 Ruby モードを使う (2003/06/08)
;;----------------------------------------------------------------------
;; (autoload 'ruby-mode "ruby-mode"
;;   "Mode for editing ruby source files" t)

;; (setq auto-mode-alist
;;        (append '(
;;                  ("\\.rb$" . ruby-mode))
;;                auto-mode-alist))

;; (setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
;;                                      interpreter-mode-alist))

;;----------------------------------------------------------------------
;;41.4.1 Perl モードを使う － cperl-mode (2006/07/31)
;;----------------------------------------------------------------------
(autoload 'cperl-mode "cperl-mode" "alternate mode for editing Perl programs" t)

(setq auto-mode-alist
      (append '(
                  ("\\.\\([pP][Llm]\\|al\\)$" . cperl-mode))
                                    auto-mode-alist ))

(setq interpreter-mode-alist (append interpreter-mode-alist
                                     '(("miniperl" . cperl-mode))))
(add-hook 'cperl-mode-hook
          (lambda ()
            (set-face-bold-p 'cperl-array-face nil)
            (set-face-background 'cperl-array-face "black")
            (set-face-bold-p 'cperl-hash-face nil)
            (set-face-italic-p 'cperl-hash-face nil)
            (set-face-background 'cperl-hash-face "black")
            ))


;; (add-hook 'cperl-mode-hook
;;           (lambda ()
;;             (require 'perlplus)
;;             (local-set-key "\M-\t" 'perlplus-complete-symbol)
;;             (perlplus-setup)))


;;----------------------------------------------------------------------
;;41.7 bat / ini ファイルをカラフルに － generic.el (2003/06/08)
;;----------------------------------------------------------------------
(require 'generic-x)
;; (setq auto-mode-alist
;;       (append '(
;;                 ("\\.bat$" . bat-generic-mode)
;;                 ("\\.ini$" . ini-generic-mode))
;;               auto-mode-alist))


;;----------------------------------------------------------------------
;;42.3.2 indent-tabs-maybe
;;----------------------------------------------------------------------
;;(require 'indent-tabs-maybe)


;;----------------------------------------------------------------------
;;42.4 タグジャンプ － 関数定義へジャンプ etags (2003/11/18)
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

;;----------------------------------------------------------------------
;;42.4.1 タグファイルの自動生成 (2003/11/18)
;;----------------------------------------------------------------------
(defadvice find-tag (before c-tag-file activate)
  "Automatically create tags file."
  (let ((tag-file (concat default-directory "TAGS")))
    (unless (file-exists-p tag-file)
      (shell-command "etags *.[ch] *.el .*.el -o TAGS 2>/dev/null"))
    (visit-tags-table tag-file)))


;;----------------------------------------------------------------------
;;42.5 タグジャンプ － gtags ， global (2007/11/29)
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

(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\M-t" 'gtags-find-tag)
         (local-set-key "\M-r" 'gtags-find-rtag)
         (local-set-key "\M-s" 'gtags-find-symbol)
         (local-set-key "\C-t" 'gtags-pop-stack)
         ))

(add-hook 'c-mode-common-hook
          '(lambda()
             (gtags-mode 1)
             (gtags-make-complete-list)
             ))

;;----------------------------------------------------------------------
;;42.6 関数定義へジャンプ  imenu (2003/11/21)
;;----------------------------------------------------------------------
(require 'imenu)
(defcustom imenu-modes
  '(emacs-lisp-mode c-mode c++-mode makefile-mode)
  "List of major modes for which Imenu mode should be used."
  :group 'imenu
  :type '(choice (const :tag "All modes" t)
                 (repeat (symbol :tag "Major mode"))))
(defun my-imenu-ff-hook ()
  "File find hook for Imenu mode."
  (if (member major-mode imenu-modes)
      (imenu-add-to-menubar "imenu")))
(add-hook 'find-file-hooks 'my-imenu-ff-hook t)

(global-set-key "\C-cg" 'imenu)

;; (defadvice imenu--completion-buffer
;;   (around mcomplete activate preactivate)
;;   "Support for mcomplete-mode."
;;   (require 'mcomplete)
;;   (let ((imenu-always-use-completion-buffer-p 'never)
;;         (mode mcomplete-mode)
;;         ;; the order of completion methods
;;         (mcomplete-default-method-set '(mcomplete-substr-method
;;                                         mcomplete-prefix-method))
;;         ;; when to display completion candidates in the minibuffer
;;         (mcomplete-default-exhibit-start-chars 0)
;;         (completion-ignore-case t))
;;     ;; display *Completions* buffer on entering the minibuffer
;;     (setq unread-command-events
;;           (cons (funcall (if (fboundp 'character-to-event)
;;                              'character-to-event
;;                            'identity)
;;                          ?\?)
;;                 unread-command-events))
;;     (turn-on-mcomplete-mode)
;;     (unwind-protect
;;         ad-do-it
;;       (unless mode
;;         (turn-off-mcomplete-mode)))))



;;----------------------------------------------------------------------
;;42.7 関数を一覧表示する navi.el (2004/02/03)
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


;;----------------------------------------------------------------------
;;42.9 対応する括弧が知りたい (2006/03/16)
;;----------------------------------------------------------------------
;;42.9.1 括弧単位，関数単位でのカーソル移動 (2003/06/08)
;;----------------------------------------------------------------------
;; * C-M-f, C-M-b : 現在のインデントで，式単位で移動
;; * C-M-n, C-M-p : 括弧単位で移動する
;; * C-M-u, C-M-d : インデントを 1 つ上がる (下がる)
;; * M-a, M-e : 文単位で移動
;; * C-M-a, C-M-e : 関数単位での移動
;; * C-M-SPC : 式をリージョンで選択
;; * C-M-k : 式を切り取る
;; * C-M-h : 関数全体をリージョンで選択します． 
;; * C-M-\:リージョン内を再インデント 

;;----------------------------------------------------------------------
;;42.9.2 括弧をハイライトする show-paren (2003/06/08)
;;----------------------------------------------------------------------
(show-paren-mode t)

(setq show-paren-style 'parenthesis)
;;(set-face-background 'show-paren-match-face "gray10")
;;(set-face-foreground 'show-paren-match-face "SkyBlue")

;;----------------------------------------------------------------------
;;42.9.3 mic-paren (2003/06/08)
;;----------------------------------------------------------------------
;; (if window-system
;;     (progn
;;       (require 'mic-paren)
;;       (paren-activate)     ; activating
;; ;;      (setq paren-match-face 'bold)
;; ;;      (setq paren-match-face 'underline)
;;       (setq paren-sexp-mode t)
;;       ))

;; ;;----------------------------------------------------------------------
;; ;;43.3 Emacs で統計処理 (2003/11/24)
;; ;;----------------------------------------------------------------------
;; (setq ess-ask-for-ess-directory nil)
;; (setq ess-local-process-name "R64")
;; (setq ansi-color-for-comint-mode 'filter)
;; (setq comint-prompt-read-only t)
;; (setq comint-scroll-to-bottom-on-input t)
;; (setq comint-scroll-to-bottom-on-output t)
;; (setq comint-move-point-for-output t)

;; (defun my-ess-start-R ()
;;   (interactive)
;;   (if (not (member "*R*" (mapcar (function buffer-name) (buffer-list))))
;;       (progn
;;         (delete-other-windows)
;;         (setq w1 (selected-window))
;;         (setq w1name (buffer-name))
;;         (setq w2 (split-window w1))
;;         (R)
;;         (set-window-buffer w2 "*R*")
;;         (set-window-buffer w1 w1name))))

;; (defun my-ess-eval ()
;;   (interactive)
;;   ;;(my-ess-start-R)
;;   (if (and transient-mark-mode mark-active)
;;       (call-interactively 'ess-eval-region)
;;     (call-interactively 'ess-eval-line-and-step)))

;; (add-hook 'ess-mode-hook
;;           '(lambda()
;;              (local-set-key "\C-j" 'my-ess-eval)))

;; (require 'ess-site)
;; ;;(setq inferior-R-args "--internet2")




;;----------------------------------------------------------------------
;;46.1.1 キーボードマクロを Lisp に変換 macro-generate (2005/03/24)
;;----------------------------------------------------------------------
(autoload 'gen-start-generating
  "macro-generate" nil t)
(autoload 'gen-stop-generating
  "macro-generate" nil t)


;;----------------------------------------------------------------------
;;49.4 漢字変換せずに日本語インクリメンタルサーチ migemo (2006/02/07)
;;----------------------------------------------------------------------
;;http://d.hatena.ne.jp/zqwell-ss/20091129/1259489661

(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)

;;(setq migemo-command "migemo"
;;      migemo-options '("-t" "emacs"  "-i" "▼a"))
;;      migemo-options '("-t" "emacs"  "-i" "▼a"))
;;(setenv "RUBYLIB" "/Applications/Emacs.app/Contents/Resources/lib/ruby/site_ruby/")
;;(require 'migemo)

;;----------------------------------------------------------------------
;;49.4.2 C/migemo を使いたい (2003/11/05)
;;----------------------------------------------------------------------
;; * C-d : 一文字検索語に追加する
;; * C-w : 一単語を検索語に追加する
;; * C-y : カーソル位置から行末までを検索語に追加する
;; * M-m : migemo をオン/オフする．

;; (if (eq system-type 'windows-nt)
;;     (lambda()
;;      ;; 基本設定
;;      (setq migemo-command "cmigemo")
;;      (setq migemo-options '("-q" "--emacs"))
;;      ;; migemo-dict のパスを指定
;;      (setq migemo-dictionary "C:/meadow/site-lisp/cmigemo-default-win32/dict/cp932")
;;      (setq migemo-user-dictionary nil)     
;;      (setq migemo-regex-dictionary nil)

;;      ;; キャッシュ機能を利用する
;;      (setq migemo-use-pattern-alist t)
;;      (setq migemo-use-frequent-pattern-alist t)
;;      (setq migemo-pattern-alist-length 1024)
;;      ;; 辞書の文字コードを指定．
;;      ;; バイナリを利用するなら，このままで構いません
;;      (setq migemo-coding-system 'euc-jp-unix)

;;      (load-library "migemo")
;;      ;; 起動時に初期化も行う
;;      (migemo-init)
;;      ))

