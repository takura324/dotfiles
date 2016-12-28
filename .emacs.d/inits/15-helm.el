(require 'bind-key)

;;
;; helm
;;
(require 'helm-config)
(require 'helm-descbinds)
(require 'helm-ag)

(helm-mode 1)
(helm-migemo-mode 1)

;; (defadvice helm-M-x (after before-helm-M-x activate)
;;   "M-x ではIMEを常にオフにする。"
;;   (deactivate-input-method))

;; C-hで前の文字削除
;; (bind-key "C-h" 'delete-backward-char helm-map)
;; (bind-key "C-h" 'delete-backward-char helm-find-files-map)

;; キーバインド
;;(bind-key "C-x b"   'helm-buffers-list)
(bind-key "C-x b"   'helm-for-files)
(bind-key "C-x C-f" 'helm-find-files)
(bind-key "M-x"     'helm-M-x)
(bind-key "M-y"     'helm-show-kill-ring)

(bind-key "C-;"     'helm-mini)
(bind-key "C-c b"   'helm-descbinds)
(bind-key "C-c o"   'helm-occur)
(bind-key "M-s o"   'helm-occur)
(bind-key "C-c i"   'helm-imenu)
(bind-key "C-c a"   'helm-apropos)

(bind-key "C-M-g"   'helm-ag)
(bind-key "M-g M-g" 'helm-ag)
(bind-key "C-M-k"   'backward-kill-sexp) ;推奨

(bind-key "TAB" 'helm-execute-persistent-action helm-find-files-map)
(bind-key "TAB" 'helm-execute-persistent-action helm-read-file-map)
;;(bind-key "TAB" 'helm-execute-persistent-action helm-M-x-map)

;; Emulate `kill-line' in helm minibuffer
(setq helm-delete-minibuffer-contents-from-point t)
(defadvice helm-delete-minibuffer-contents (before emulate-kill-line activate)
  "Emulate `kill-line' in helm minibuffer"
  (kill-new (buffer-substring (point) (field-end))))

;; Disable helm in some functions
;; (add-to-list 'helm-completing-read-handlers-alist '(find-file . nil))
;; (add-to-list 'helm-completing-read-handlers-alist '(write-file . nil))
(add-to-list 'helm-completing-read-handlers-alist '(find-alternate-file . nil))
(add-to-list 'helm-completing-read-handlers-alist '(find-tag . nil))


;;----------------------------------------------
;; helm-for-filesを快適に使う設定
;;----------------------------------------------
;; 最近のファイル500個を保存する
(setq recentf-max-saved-items 500)
;; 最近使ったファイルに加えないファイルを
;; 正規表現で指定する
(setq recentf-exclude
      '("/TAGS$" "/var/tmp/"))
;; recentfをディレクトリにも拡張した上に、
;; 「最近開いたファイル」を「最近使ったファイル」に進化させる
(require 'recentf-ext)
(setq helm-for-files-preferred-list
      '(helm-source-buffers-list
        helm-source-recentf
        helm-source-bookmarks
        helm-source-file-cache
        helm-source-files-in-current-dir
        ;; 必要とあれば
        helm-source-bookmark-set
        helm-source-locate))


;;----------------------------------------------
;; helm-swoop
;;   helm-occur、helm-multi-occur の強化版
;;   http://emacs.rubikitch.com/helm-swoop/
;;----------------------------------------------
;; (helm-swoop)             ;; 起動
;; (helm-swoop-nomigemo)    ;; 起動
;;   C-n, C-n で行移動
;;   RET で行にジャンプ（helm-swoop終了）
;;   C-x c b で helm-swoopを復元
;;
;; isearch から M-iでhelm-swoopに移行できる

(require 'helm-swoop)
;;; isearchからの連携を考えるとC-r/C-sにも割り当て推奨
(bind-key "C-r" 'helm-previous-line helm-swoop-map)
(bind-key "C-s" 'helm-next-line helm-swoop-map)

;;; 検索結果をcycleしない、お好みで
(setq helm-swoop-move-to-line-cycle nil)

;; (cl-defun helm-swoop-nomigemo (&key $query ($multiline current-prefix-arg))
;;   "シンボル検索用Migemo無効版helm-swoop"
;;   (interactive)
;;   (let ((helm-swoop-pre-input-function
;;          (lambda () (format "\\_<%s\\_> " (thing-at-point 'symbol)))))
;;     (helm-swoop :$source (delete '(migemo) (copy-sequence (helm-c-source-swoop)))
;;                 :$query $query :$multiline $multiline)))
;;; C-M-:に割り当て
;;(bind-key "M-o" 'helm-swoop-nomigemo)
(bind-key "M-o" 'helm-swoop)

;;; [2014-11-25 Tue]
(when (featurep 'helm-anything)
  (defadvice helm-resume (around helm-swoop-resume activate)
    "helm-anything-resumeで復元できないのでその場合に限定して無効化"
    ad-do-it))

;;; [2015-03-23 Mon]C-u C-s / C-u C-u C-s
(eval-when-compile (require 'cl))
(defun isearch-forward-or-helm-swoop (use-helm-swoop)
  (interactive "p")
  (let (current-prefix-arg
        (helm-swoop-pre-input-function 'ignore))
    (call-interactively
     (case use-helm-swoop
       (1 'isearch-forward)
       (4 'helm-swoop)
       ;; (16 'helm-swoop-nomigemo)))))
       (16 'helm-swoop)))))
(bind-key "C-s" 'isearch-forward-or-helm-swoop)

;;----------------------------------------------
;; ace-isearch.el
;;   超isearch＝isearch＋ace-jump-mode＋helm-swoop　カーソル移動と検索を統合！
;;   http://emacs.rubikitch.com/ace-isearch/
;;----------------------------------------------
;; isearchのクエリ文字数によって、以下の挙動を行います。
;; 1文字→ace-jump-mode
;; 2〜5文字→isearch
;; 6文字以上→helm-swoop
;;(global-ace-isearch-mode 1)


;;----------------------------------------------
;; helm/anything.el検索結果を次々と辿る方法
;;   http://emacs.rubikitch.com/helm-next-error/
;;----------------------------------------------
;; M-g M-n (M-x next-error)
;; M-g M-p (M-x previous-error)
(require 'helm-anything nil t)
;;(require 'helm)

;;; resumable helm/anything buffers
(defvar helm-resume-goto-buffer-regexp
  (rx (or (regexp "Helm Swoop") "helm imenu" (regexp "helm.+grep") "helm-ag"
          "occur"
          "*anything grep" "anything current buffer")))
(defvar helm-resume-goto-function nil)
(defun helm-initialize--resume-goto (resume &rest _)
  (when (and (not (eq resume 'noresume))
             (ignore-errors
               (string-match helm-resume-goto-buffer-regexp helm-last-buffer)))
    (setq helm-resume-goto-function
          (list 'helm-resume helm-last-buffer))))
(advice-add 'helm-initialize :after 'helm-initialize--resume-goto)
(defun anything-initialize--resume-goto (resume &rest _)
  (when (and (not (eq resume 'noresume))
             (ignore-errors
               (string-match helm-resume-goto-buffer-regexp anything-last-buffer)))
    (setq helm-resume-goto-function
          (list 'anything-resume anything-last-buffer))))
(advice-add 'anything-initialize :after 'anything-initialize--resume-goto)

;;; next-error/previous-error
(defun compilation-start--resume-goto (&rest _)
  (setq helm-resume-goto-function 'next-error))
(advice-add 'compilation-start :after 'compilation-start--resume-goto)
(advice-add 'occur-mode :after 'compilation-start--resume-goto)
(advice-add 'occur-mode-goto-occurrence :after 'compilation-start--resume-goto)
(advice-add 'compile-goto-error :after 'compilation-start--resume-goto)


(defun helm-resume-and- (key)
  (unless (eq helm-resume-goto-function 'next-error)
    (if (fboundp 'helm-anything-resume)
        (setq helm-anything-resume-function helm-resume-goto-function)
      (setq helm-last-buffer (cadr helm-resume-goto-function)))
    (execute-kbd-macro
     (kbd (format "%s %s RET"
                  (key-description (car (where-is-internal
                                         (if (fboundp 'helm-anything-resume)
                                             'helm-anything-resume
                                           'helm-resume))))
                  key)))
    (message "Resuming %s" (cadr helm-resume-goto-function))
    t))
(defun helm-resume-and-previous ()
  "Relacement of `previous-error'"
  (interactive)
  (or (helm-resume-and- "C-p")
      (call-interactively 'previous-error)))
(defun helm-resume-and-next ()
  "Relacement of `next-error'"
  (interactive)
  (or (helm-resume-and- "C-n")
      (call-interactively 'next-error)))

;;; Replace: next-error / previous-error
;;(require 'helm-config)
(ignore-errors (helm-anything-set-keys))
(bind-key "M-g M-n" 'helm-resume-and-next)
(bind-key "M-g M-p" 'helm-resume-and-previous)


;;----------------------------------------------
;; helm-c-yasnipet
;;
;; yasnipet の helm インターフェース
;; http://emacs.rubikitch.com/helm-c-yasnippet/
;;----------------------------------------------
(require 'yasnippet)
(require 'helm-c-yasnippet)
(setq helm-yas-space-match-any-greedy t)
(bind-key "C-c y" 'helm-yas-complete)
(push '("emacs.+/snippets/" . snippet-mode) auto-mode-alist)
(yas-global-mode 1)

(defun view-mode-hook1 ()
  (define-many-keys view-mode-map pager-keybind)
  ;;(hl-line-mode 1)
  ;;(bind-key " " 'scroll-up view-mode-map)
  )
(add-hook 'view-mode-hook 'view-mode-hook1)


;;----------------------------------------------
;; ac-helm
;;
;; auto-complete の helm インターフェース
;;----------------------------------------------
(require 'ac-helm) ;; Not necessary if using ELPA package
(bind-key "C-:" 'ac-complete-with-helm)
(bind-key "C-:" 'ac-complete-with-helm ac-complete-mode-map)

;;----------------------------------------------
;; helm-ag
;;
;; 高速Grep の helm インターフェース
;; http://emacs.rubikitch.com/helm-ag/
;;----------------------------------------------
;;(package-install 'helm-ag)

;;; ag以外の検索コマンドも使える
;; (setq helm-ag-base-command "grep -rin")
;; (setq helm-ag-base-command "csearch -n")
;; (setq helm-ag-base-command "pt --nocolor --nogroup")
(setq helm-ag-base-command "rg --vimgrep --no-heading")

;;; 現在のシンボルをデフォルトのクエリにする
(setq helm-ag-insert-at-point 'symbol)

(defun helm-ag-dot-emacs ()
  ".emacs.d以下を検索"
  (interactive)
  (helm-ag "~/.emacs.d/"))
(defalias 'agem 'helm-ag-dot-emacs)

(defun helm-ag-dot-emacs-inits ()
  ".emacs.d/inits以下を検索"
  (interactive)
  (helm-ag "~/.emacs.d/inits/"))
(defalias 'agemi 'helm-ag-dot-emacs-inits)

(require 'projectile nil t)
(defun helm-projectile-ag ()
  "Projectileと連携"
  (interactive)
  (helm-ag (projectile-project-root)))
;; (helm-ag "~/.emacs.d/")


;;----------------------------------------------
;; ace-jump-helm-line.el :
;;
;; 画面内のhelmの候補を直接選択する
;; http://emacs.rubikitch.com/ace-jump-helm-line/
;;----------------------------------------------
;; M-x package-install ace-jump-helm-line

(require 'ace-jump-helm-line)

(bind-key "`" 'ace-jump-helm-line--with-error-fallback helm-map)
(bind-key "@" 'ace-jump-helm-line-and-execute-action helm-map)

;;; anything-shortcut-keys-alistと同じように設定
(setq avy-keys (append "asdfghjklzxcvbnmqwertyuiop" nil))

;;; ちょっとアレンジ
(defun ajhl--insert-last-char ()
  (insert (substring (this-command-keys) -1)))
(defun ace-jump-helm-line--with-error-fallback ()
  "ヒント文字以外の文字が押されたらその文字を挿入するように修正"
  (interactive)
  (condition-case nil
      (ace-jump-helm-line)
    (error (ajhl--insert-last-char))))
(defun ace-jump-helm-line-and-execute-action ()
  "anything-select-with-prefix-shortcut互換"
  (interactive)
  (condition-case nil
      (progn (ace-jump-helm-line)
             (helm-exit-minibuffer))
    (error (ajhl--insert-last-char))))


;;----------------------------------------------
;; helm gtags
;;----------------------------------------------
;; (add-hook 'helm-gtags-mode-hook
;;           '(lambda ()
;;              ;;入力されたタグの定義元へジャンプ
;;              (local-set-key "M-t" 'helm-gtags-find-tag)

;;              ;;入力タグを参照する場所へジャンプ
;;              (local-set-key "M-r" 'helm-gtags-find-rtag)  

;;              ;;入力したシンボルを参照する場所へジャンプ
;;              (local-set-key "M-s" 'helm-gtags-find-symbol)

;;              ;;タグ一覧からタグを選択し, その定義元にジャンプする
;;              (local-set-key "M-l" 'helm-gtags-select)

;;              ;;ジャンプ前の場所に戻る
;;              (local-set-key "C-t" 'helm-gtags-pop-stack)))

(require 'helm-gtags)
(bind-keys :map helm-gtags-mode-map
             ("M-t" . helm-gtags-find-tag)    ;入力されたタグの定義元へジャンプ
             ("M-r" . helm-gtags-find-rtag)   ;入力タグを参照する場所へジャンプ  
             ("M-s" . helm-gtags-find-symbol) ;入力したシンボルを参照する場所へジャンプ
             ("M-l" . helm-gtags-select)      ;タグ一覧からタグを選択し, その定義元にジャンプする
             ("C-t" . helm-gtags-pop-stack)   ;ジャンプ前の場所に戻る
             )

;; (add-hook 'php-mode-hook 'helm-gtags-mode)
;; (add-hook 'ruby-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-common-hook 'helm-gtags-mode)


;;----------------------------------------------
;; helm flycheck
;;----------------------------------------------
;;(package-install 'helm-flycheck)
(require 'helm-flycheck)
(eval-after-load 'flycheck
  '(define-key flycheck-mode-map (kbd "C-c ! h") 'helm-flycheck))


