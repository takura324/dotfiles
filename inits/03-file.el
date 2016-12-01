;;----------------------------------------------------------------------
;;ファイルを開く関連の便利ツール
;;----------------------------------------------------------------------
;;最近使ったファイルを記憶させる
;;----------------------------------------------------------------------
(recentf-mode 1)

;;----------------------------------------------------------------------
;;ディレクトリ表示 — dired
;;----------------------------------------------------------------------
;;dired を拡張する − dired-x
;;----------------------------------------------------------------------
(load "dired-x")

;;----------------------------------------------------------------------
;;dired のコマンドを追加/拡張する
;;----------------------------------------------------------------------
;;マークをトグル式にする
;;----------------------------------------------------------------------
;; スペースでマークする (FD like)
(define-key dired-mode-map " " 'dired-toggle-mark)
(defun dired-toggle-mark (arg)
  "Toggle the current (or next ARG) files."
  ;; S.Namba Sat Aug 10 12:20:36 1996
  (interactive "P")
  (let ((dired-marker-char
         (if (save-excursion (beginning-of-line)
                             (looking-at " "))
             dired-marker-char ?\040)))
    (dired-mark arg)
    (dired-previous-line 1)))


;;----------------------------------------------------------------------
;;ファイルの文字コードを一括変換
;;----------------------------------------------------------------------
;;; dired を使って、一気にファイルの coding system (漢字) を変換する
(require 'dired-aux)
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key (current-local-map) "T"
              'dired-do-convert-coding-system)))

(defvar dired-default-file-coding-system nil
  "*Default coding system for converting file (s).")

(defvar dired-file-coding-system 'no-conversion)

(defun dired-convert-coding-system ()
  (let ((file (dired-get-filename))
        (coding-system-for-write dired-file-coding-system)
        failure)
    (condition-case err
        (with-temp-buffer
          (insert-file file)
          (write-region (point-min) (point-max) file))
      (error (setq failure err)))
    (if (not failure)
        nil
      (dired-log "convert coding system error for %s:\n%s\n" file failure)
      (dired-make-relative file))))

(defun dired-do-convert-coding-system (coding-system &optional arg)
  "Convert file (s) in specified coding system."
  (interactive
   (list (let ((default (or dired-default-file-coding-system
                            buffer-file-coding-system)))
           (read-coding-system
            (format "Coding system for converting file (s) (default, %s): "
                    default)
            default))
         current-prefix-arg))
  (check-coding-system coding-system)
  (setq dired-file-coding-system coding-system)
  (dired-map-over-marks-check
   (function dired-convert-coding-system) arg 'convert-coding-system t))

;; dired で m でマークを付け，T とします．これで，マークを付けたファイルの文字コードを変換できます．
;; デフォルトの文字コードは
;; (setq dired-default-file-coding-system 'euc-jp-unix)
;; のように指定できます．

;;----------------------------------------------------------------------
;;dired で再帰コピー，再帰削除
;;----------------------------------------------------------------------
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

;;----------------------------------------------------------------------
;;フォルダを開く時, 新しいバッファを作成しない — dired
;;----------------------------------------------------------------------
(defvar my-dired-before-buffer nil)
(defadvice dired-advertised-find-file
  (before kill-dired-buffer activate)
  (setq my-dired-before-buffer (current-buffer)))

(defadvice dired-advertised-find-file
  (after kill-dired-buffer-after activate)
  (if (eq major-mode 'dired-mode)
      (kill-buffer my-dired-before-buffer)))

(defadvice dired-up-directory
  (before kill-up-dired-buffer activate)
  (setq my-dired-before-buffer (current-buffer)))

(defadvice dired-up-directory
  (after kill-up-dired-buffer-after activate)
  (if (eq major-mode 'dired-mode)
      (kill-buffer my-dired-before-buffer)))



;;----------------------------------------------------------------------
;;dired の並び換え関連
;;----------------------------------------------------------------------
;;dired の並び換え方法を保存
;;----------------------------------------------------------------------
(defadvice dired-advertised-find-file
  (around dired-sort activate)
  (let ((sw dired-actual-switches))
    ad-do-it
    (if (string= major-mode 'dired-mode)
        (progn
          (setq dired-actual-switches sw)
          (dired-sort-other dired-actual-switches)))
    ))

(defadvice dired-my-up-directory
  (around dired-sort activate)
  (let ((sw dired-actual-switches))
    ad-do-it
    (if (string= major-mode 'dired-mode)
        (progn
          (setq dired-actual-switches sw)
          (dired-sort-other dired-actual-switches)))
    ))


;;----------------------------------------------------------------------
;;dired でサイズ，拡張子で並び換え
;;----------------------------------------------------------------------
(add-hook 'dired-load-hook
          (lambda ()
            (require 'sorter)))


;;----------------------------------------------------------------------
;;ディレクトリを先に表示する
;;----------------------------------------------------------------------
(setq ls-lisp-dirs-first t)

;;----------------------------------------------------------------------
;;dired バッファを編集 — 一括リネーム wdired 
;;----------------------------------------------------------------------
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
(define-key dired-mode-map "e" 'wdired-change-to-wdired-mode)


;;----------------------------------------------------------------------
;;バッファの移動 — electric-buffer-list
;;----------------------------------------------------------------------
(global-set-key "\C-xe" 'electric-buffer-list)
;;(global-set-key "\C-x\C-b" 'buffer-menu)


;;----------------------------------------------------------------------
;;さらに便利なバッファリスト— ibuffer 
;;----------------------------------------------------------------------
(require 'ibuffer)
(global-set-key "\C-x\C-b" 'ibuffer)

(setq ibuffer-formats
      '((mark modified read-only " " (name 30 30)
              " " (size 6 -1) " " (mode 16 16) " " filename)
        (mark " " (name 30 -1) " " filename)))

;;(setq ibuffer-never-show-regexps '("\\.el" "messages"))

(setq ibuffer-directory-abbrev-alist
      '(("c:/Meadow/site-lisp/" . "meadow")))


;;----------------------------------------------------------------------
;;ibuffer で文字コードを指定して保存 
;;----------------------------------------------------------------------
(define-key ibuffer-mode-map
  "T" 'ibuffer-do-convert-coding-system)
(defun ibuffer-do-convert-coding-system
  (coding-system &optional arg)
  "Convert file (s) in specified coding system."
  (interactive
   (list
    (let ((default (or
                    (and (boundp 'dired-default-file-coding-system)
                         dired-default-file-coding-system)
                    buffer-file-coding-system)))
      (read-coding-system
       (format
        "Coding system for converting file (s) (default, %s): "
        default)
       default))
    current-prefix-arg))
  (if (= (ibuffer-count-marked-lines) 0)
      (message
       "No buffers marked; use 'm' to mark a buffer")
    (let ((ibuffer-do-bufs nil))
      (ibuffer-map-marked-lines
       #'(lambda (buf mark)
           (push buf ibuffer-do-bufs)))
      (ibuffer-unmark-all 62)
      (while ibuffer-do-bufs
        (set-buffer (car ibuffer-do-bufs))
        (set-buffer-file-coding-system coding-system arg)
        (if (buffer-file-name)
            (let ((coding-system-for-write coding-system))
              (save-buffer arg)))
        (setq ibuffer-do-bufs (cdr ibuffer-do-bufs))))))

;;----------------------------------------------------------------------
;;バッファの切換えをもっと楽にしたい
;;----------------------------------------------------------------------
;;バッファの切換えをもっと楽にしたい − iswitchb
;;----------------------------------------------------------------------
;;(iswitchb-mode 1)
;;(icomplete-mode 1)

;;----------------------------------------------------------------------
;;*scratch*バッファを kill できないように
;;----------------------------------------------------------------------
(defun my-make-scratch (&optional arg)
  (interactive)
  (progn
    ;; "*scratch*" を作成して buffer-list に放り込む
    (set-buffer (get-buffer-create "*scratch*"))
    (funcall initial-major-mode)
    (erase-buffer)
    (when (and initial-scratch-message (not inhibit-startup-message))
      (insert initial-scratch-message))
    (or arg (progn (setq arg 0)
                   (switch-to-buffer "*scratch*")))
    (cond ((= arg 0) (message "*scratch* is cleared up."))
          ((= arg 1) (message "another *scratch* is created")))))

(defun my-buffer-name-list ()
  (mapcar (function buffer-name) (buffer-list)))

(add-hook 'kill-buffer-query-functions
    ;; *scratch* バッファで kill-buffer したら内容を消去するだけにする
          (function (lambda ()
                      (if (string= "*scratch*" (buffer-name))
                          (progn (my-make-scratch 0) nil)
                        t))))

(add-hook 'after-save-hook
;; *scratch* バッファの内容を保存したら *scratch* バッファを新しく作る
          (function (lambda ()
                      (unless (member "*scratch*" (my-buffer-name-list))
                        (my-make-scratch 1)))))


;;----------------------------------------------------------------------
;;scratch バッファの内容を保存
;;----------------------------------------------------------------------
(defun save-scratch-data ()
  (let ((str (progn
               (set-buffer (get-buffer "*scratch*"))
               (buffer-substring-no-properties
                (point-min) (point-max))))
        (file "~/.scratch"))
    (if (get-file-buffer (expand-file-name file))
        (setq buf (get-file-buffer (expand-file-name file)))
      (setq buf (find-file-noselect file)))
    (set-buffer buf)
    (erase-buffer)
    (insert str)
    (save-buffer)))

(defadvice save-buffers-kill-emacs
  (before save-scratch-buffer activate)
  (save-scratch-data))

(defun read-scratch-data ()
  (let ((file "~/.scratch"))
    (when (file-exists-p file)
      (set-buffer (get-buffer "*scratch*"))
      (erase-buffer)
      (insert-file-contents file))
    ))

(read-scratch-data)


;; ファイルが #! から始まる場合、+x をつけて保存する
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)


