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
;; (define-key helm-map (kbd "C-h") 'delete-backward-char)
;; (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)

;; キーバインド
;;(global-set-key (kbd "C-x b")   'helm-buffers-list)
(global-set-key (kbd "C-x b")   'helm-for-files)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x")     'helm-M-x)
(global-set-key (kbd "M-y")     'helm-show-kill-ring)

(global-set-key (kbd "C-;")     'helm-mini)
(global-set-key (kbd "C-c b")   'helm-descbinds)
(global-set-key (kbd "C-c o")   'helm-occur)
(global-set-key (kbd "M-o")     'helm-occur)
(global-set-key (kbd "C-c i")   'helm-imenu)
(global-set-key (kbd "C-c a")   'helm-apropos)

(global-set-key (kbd "C-M-g")   'helm-ag)
(global-set-key (kbd "M-g M-g") 'helm-ag)
(global-set-key (kbd "C-M-k")   'backward-kill-sexp) ;推奨

(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
;;(define-key helm-M-x-map (kbd "TAB") 'helm-execute-persistent-action)

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
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)

;;; 検索結果をcycleしない、お好みで
(setq helm-swoop-move-to-line-cycle nil)

(cl-defun helm-swoop-nomigemo (&key $query ($multiline current-prefix-arg))
  "シンボル検索用Migemo無効版helm-swoop"
  (interactive)
  (let ((helm-swoop-pre-input-function
         (lambda () (format "\\_<%s\\_> " (thing-at-point 'symbol)))))
    (helm-swoop :$source (delete '(migemo) (copy-sequence (helm-c-source-swoop)))
                :$query $query :$multiline $multiline)))
;;; C-M-:に割り当て
(global-set-key (kbd "C-M-:") 'helm-swoop-nomigemo)

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
       (16 'helm-swoop-nomigemo)))))
(global-set-key (kbd "C-s") 'isearch-forward-or-helm-swoop)

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
(global-set-key (kbd "M-g M-n") 'helm-resume-and-next)
(global-set-key (kbd "M-g M-p") 'helm-resume-and-previous)


;;----------------------------------------------
;; helm-c-yasnipet
;;
;; yasnipet の helm インターフェース
;; http://emacs.rubikitch.com/helm-c-yasnippet/
;;----------------------------------------------
(require 'yasnippet)
(require 'helm-c-yasnippet)
(setq helm-yas-space-match-any-greedy t)
(global-set-key (kbd "C-c y") 'helm-yas-complete)
(push '("emacs.+/snippets/" . snippet-mode) auto-mode-alist)
(yas-global-mode 1)


;;----------------------------------------------
;; ac-helm
;;
;; auto-complete の helm インターフェース
;;----------------------------------------------
(require 'ac-helm) ;; Not necessary if using ELPA package
(global-set-key (kbd "C-:") 'ac-complete-with-helm)
(define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-helm)


;;----------------------------------------------
;; helm-ag
;;
;; 高速Grep の helm インターフェース
;; http://emacs.rubikitch.com/helm-ag/
;;----------------------------------------------
;;(package-install "helm-ag")

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

(define-key helm-map (kbd "`") 'ace-jump-helm-line--with-error-fallback)
(define-key helm-map (kbd "@") 'ace-jump-helm-line-and-execute-action)

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
