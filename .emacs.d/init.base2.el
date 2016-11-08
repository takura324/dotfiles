;;----------------------------------------------------------------------
;;22.1 いろんなものを階層化して表示 ― ee (2003/08/08)
;;----------------------------------------------------------------------
;; (require 'ee-autoloads)
;; (setq ee-textfile-changelog-name-regexp
;;       "[(].*[)][ ]*\\([^<(]+?\\) [ \t]*[(<]\\([A-Za-z0-9_.-]+@[A-Za-z0-9_.-]+\\) [>)]")

;;(setq max-lisp-eval-depth 1000)
;;(setq max-specpdl-size 6000)


;;----------------------------------------------------------------------
;;23.1 ファイルを開く基本操作 (2005/03/20)
;;----------------------------------------------------------------------
;;指定した拡張子は補完候補に出ないようになる
(setq completion-ignored-extensions
      (append completion-ignored-extensions
              '(".exe" ".com" ".o")))

;;----------------------------------------------------------------------
;;23.2 ファイル名補完関連 (2005/03/20)
;;----------------------------------------------------------------------
;;23.2.1 ファイル名の一部と拡張子で補完 (2005/03/20)
;;----------------------------------------------------------------------
;;(partial-completion-mode t)

;;----------------------------------------------------------------------
;;23.2.3 ファイル名を自動で補完 ― highlight-completion (2003/08/06)
;;----------------------------------------------------------------------
;; (setq hc-ctrl-x-c-is-completion t)
;; (require 'highlight-completion)
;; (highlight-completion-mode 1)
;; (global-set-key "\C-\\" 'toggle-input-method)


;;----------------------------------------------------------------------
;;23.2.4 migemo で find-file ― 小菊 (2004/02/13)
;;----------------------------------------------------------------------
(if (eq system-type 'windows-nt)
    (lambda()
     (require 'kogiku)
     ))

;;----------------------------------------------------------------------
;;23.2.7 余計な部分を暗く ― rfn-eshadow (2005/03/18)
;;----------------------------------------------------------------------
(file-name-shadow-mode t)

;;----------------------------------------------------------------------
;;23.6.3 Word や Excel をテキストに変換 ― xdoc2txt (2005/02/17)
;;----------------------------------------------------------------------
;;23.6.3.1 Word や Excel のファイル内容を表示 (2005/02/17)
;;----------------------------------------------------------------------
(if (eq system-type 'windows-nt)
    (lambda()
     ;; Customize 用のグループを追加．
     (defgroup Meadow-Memo nil
       "Meadow Memo が配布するパッケージ関連の設定"
       :group 'emacs)

     (defcustom YAMA-binary-files-editor t
       "nil 以外であれば，バイナリファイルを開く際に
バイナリエディタとして編集するかどうかを選択できる"
       :type 'boolean
       :group 'Meadow-Memo)

     (defcustom YAMA-binary-use-xdoc2txt
       (if
           (and
            (or
             (locate-library
              shell-file-name nil exec-path)
             (locate-library
              (concat shell-file-name ".exe")
              nil exec-path))
            (locate-library
             "xdoc2txt.exe" nil exec-path))
           t
         nil)
       "nil 以外であれば，doc などの拡張子でバイナリ
ファイルの場合には，xdoc2txt を使って開くようにする．"
       :type 'boolean
       :group 'Meadow-Memo)

     (defcustom YAMA-file-not-binary-extensions '()
       "バイナリとみなさないファイルの拡張子を指定する．
  ただし，すべて小文字で指定する"
       :type '(repeat string)
       :group 'Meadow-Memo)

     (defcustom YAMA-file-not-binary-files
       '("tags" "gsyms" "gpath" "grtags" "gsyms" "gtags")
       "バイナリとみなさないファイル名を指定する．
ただし，すべて小文字で指定のこと"
       :type '(repeat string)
       :group 'Meadow-Memo)

     (defcustom YAMA-binary-xdoc2txt-exts
       '(
         "\\.rtf" "\\.doc" "\\.xls" "\\.ppt"
         "\\.jaw" "\\.jtw" "\\.jbw" "\\.juw"
         "\\.jfw" "\\.jvw" "\\.jtd" "\\.jtt"
         "\\.oas" "\\.oa2" "\\.oa3" "\\.bun"
         "\\.wj2" "\\.wj3" "\\.wk3" "\\.wk4"
         "\\.123" "\\.wri" "\\.pdf" "\\.mht")
       "*List of file extensions which are handled by xdoc2txt.
ただし，すべて小文字で指定のこと"
       :type '(repeat string)
       :group 'Meadow-Memo)

     (defun Yama-file-correspond-ext-p (filename list)
       (let ((ret nil))
         (while list
           (when (string-match (car list) filename)
             (setq ret t))
           (setq list (cdr list)))
         ret))

     (defun YAMA-file-binary-p (file &optional full)
       "Return t if FILE contains binary data.  If optional FULL
 is non-nil, check for the whole contents of FILE, otherwise
 check for the first 1000-byte."
       (let ((coding-system-for-read 'binary)
             default-enable-multibyte-characters)
         (if (or
              (not YAMA-binary-files-editor)
              (and
               (boundp 'image-types)
               (not (Yama-file-correspond-ext-p
                     file YAMA-binary-xdoc2txt-exts))
               (or
                (memq (intern (upcase (file-name-extension file)))
                      image-types)
                (memq (intern (downcase
                               (file-name-extension file)))
                      image-types)))
              (member (downcase (file-name-extension file))
                      YAMA-file-not-binary-extensions)
              (member (downcase (file-name-nondirectory file))
                      YAMA-file-not-binary-files))
             nil
           (with-temp-buffer
             (insert-file-contents file nil 0
                                   (if full nil 2000))
             (goto-char (point-min))
             (cond
              ((re-search-forward
                "[\000-\010\016-\032\034-\037]"
                nil t)
               (if (and YAMA-binary-use-xdoc2txt
                        (Yama-file-correspond-ext-p
                         file YAMA-binary-xdoc2txt-exts))
                   1
                 0))
              (t nil))))))

     (defvar mmemo-buffer-file-name nil)
     (make-variable-buffer-local
      'mmemo-buffer-file-name)

     (defun Yama-binary-file-view (file)
       (let ((dummy-buff
              (generate-new-buffer
               (concat "xdoc2txt:"
                       (file-name-nondirectory
                        file))))
             (coding-system-for-write 'binary)
             (coding-system-for-read 'binary))
         (set-buffer dummy-buff)
         (make-variable-buffer-local
          'mmemo-buffer-file-name)
         (setq mmemo-buffer-file-name file)
         (let ((fn (concat
                    (expand-file-name
                     (make-temp-name "xdoc2")
                     temporary-file-directory)
                    "."
                    (file-name-extension file)))
               (str nil)
               )
           (set-buffer-file-coding-system 'euc-japan)

           (copy-file file fn t)
           (insert
            "XDOC2TXT FILE: " (file-name-nondirectory file) "\n"
            "----------------------------------------------------\n"
            (shell-command-to-string
             (concat
              "cd " (file-name-directory fn) ";"
              "xdoc2txt" " -e " (file-name-nondirectory fn))))
           (goto-char (point-min))
           (end-of-line)
           (decode-coding-region (point) (point-max)
                                 'euc-jp)
           (while (re-search-forward "\r" nil t)
             (delete-region (match-beginning 0)
                            (match-end 0)))
           (goto-char (point-min))
           (while (re-search-forward
                   "\\([\n ]+\\)\n[ ]*\n" nil t)
             (delete-region (match-beginning 1)
                            (match-end 1)))
           (delete-file fn)
           )
         (setq buffer-read-only t)
         (set-window-buffer (selected-window) dummy-buff))
       (goto-char (point-min))
       (view-mode t))

     (defadvice find-file
       (around YAMA-find-file (file &optional wild))
       (let ((bn (condition-case nil
                     (YAMA-file-binary-p file) (error nil))))
         (cond
          ((and
            (not coding-system-for-read)
            (eq bn 1)
            (y-or-n-p
             "バイナリデータの内容を xdoc2txt で表示しますか?"))
           (Yama-binary-file-view file))
          ((and
            (not coding-system-for-read)
            (eq bn 0)
            (y-or-n-p "バイナリデータとして編集しますか?"))
           (hexl-find-file file))
          (t
           ad-do-it))))

     (ad-activate 'find-file)
     ))

;;----------------------------------------------------------------------
;;23.8 Windows/Cygwin などとの連携 (2005/03/18)
;;----------------------------------------------------------------------
;;23.8.1 送るや関連付けでファイルを開きたい ― gnuserv (2004/10/02)
;;----------------------------------------------------------------------
(if (eq system-type 'windows-nt)
    (lambda()
     (load "gnuserv")
     (gnuserv-start)
     (setq gnuserv-frame (selected-frame))
     ))

;;----------------------------------------------------------------------
;;23.8.2 関連付けで現在バッファを開く (2005/02/17)
;;----------------------------------------------------------------------
;; (defun buffer-fiber-exe ()
;;   (interactive)
;;   (let ((file (buffer-file-name)))
;;     (cond
;;      ((string= major-mode 'dired-mode)
;;       (if (string-match "^\\([a-z]:\\)/$" default-directory)
;;           (start-process "explorer" "diredfiber" "explorer.exe"
;;                          (match-string 1  default-directory))
;;         (start-process "explorer" "diredfiber" "explorer.exe"
;;                        (unix-to-dos-filename
;;                         (directory-file-name
;;                          default-directory)))))
;;      ((and mmemo-buffer-file-name
;;            (file-exists-p mmemo-buffer-file-name))
;;       (start-process "fiber" "diredfiber" "fiber.exe"
;;                      mmemo-buffer-file-name))
;;      ((not file)
;;       (error
;;        "現在のバッファはファイルではありません"))
;;      ((file-directory-p file)
;;       (start-process
;;        "explorer" "diredfiber" "explorer.exe"
;;        (unix-to-dos-filename file)))
;;      ((file-exists-p file)
;;       (start-process
;;        "fiber" "diredfiber" "fiber.exe" file))
;;      ((not (file-exists-p file))
;;       (error "ファイルが存在しません")))))

;;----------------------------------------------------------------------
;;23.9 ファイルを開く関連の便利ツール (2005/03/18)
;;----------------------------------------------------------------------
;;23.9.1 最近使ったファイルを記憶させる (2004/01/17)
;;----------------------------------------------------------------------
(recentf-mode 1)

;;----------------------------------------------------------------------
;;23.9.2 開いていたファイルなどを記憶させる ― desktop (2003/08/07)
;;----------------------------------------------------------------------
;; 保存しないファイルの正規表現
(setq desktop-files-not-to-save "\\(^/[^/:]*:\\|\\.diary$\\)")
(autoload 'desktop-save "desktop" nil t)
(autoload 'desktop-clear "desktop" nil t)
(autoload 'desktop-load-default "desktop" nil t)
(autoload 'desktop-remove "desktop" nil t)

;;     * desktop-clear:開いているバッファを消す
;;     * desktop-load-default:~/に保存した desktop ファイルを読み込む
;;     * desktop-remove:保存した desktop ファイルを消す

;;----------------------------------------------------------------------
;;25.1 ディレクトリ表示 ― dired (2005/02/17)
;;----------------------------------------------------------------------
;;25.1.1 dired を拡張する － dired-x (2005/02/17)
;;----------------------------------------------------------------------
(load "dired-x")

;; ;; dired-dd: http://www.asahi-net.or.jp/~pi9s-nnb/dired-dd-home.html
;; (add-hook 'dired-load-hook
;;           (function
;;            (lambda ()
;;              ;; Set dired-x variables here.
;;              ;; To and flo...
;;              (if window-system
;;                  (progn
;;                    (setq dired-dd-no-fancy-stuff t)
;;                    (require 'dired-dd)
;;                    ;;(require 'dired-dd-mime)

;;                    )))))



;;----------------------------------------------------------------------
;;25.3 dired のコマンドを追加/拡張する (2009/03/30)
;;----------------------------------------------------------------------
;;25.3.1 マークをトグル式にする (2005/02/17)
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
;;25.3.3 ファイルの文字コードを一括変換 (2003/11/18)
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
;;25.3.4 dired で再帰コピー，再帰削除 (2005/02/17)
;;----------------------------------------------------------------------
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

;;----------------------------------------------------------------------
;;25.3.5 フォルダを開く時, 新しいバッファを作成しない ― dired (2003/07/11)
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
;;25.3.7 dired から関連付けられたソフトで開く (2003/11/18)
;;----------------------------------------------------------------------
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map
              "z" 'dired-fiber-find)))

(defun dired-fiber-find ()
  (interactive)
  (let ((file (dired-get-filename)))
    (if (file-directory-p file)
        (start-process "explorer" "diredfiber" "explorer.exe"
                       (unix-to-dos-filename file))
      (start-process "fiber" "diredfiber" "fiber.exe" file))))

;;----------------------------------------
;; Win32: dird からエクスプローラを開く
;;----------------------------------------
(if (eq system-type 'windows-nt)
    (lambda()
     ;; dired で "E" で開く。
     (add-hook 'dired-mode-hook
               (lambda ()
                 (local-set-key "E" 'dired-exec-explorer)))
     ;;
     (defun dired-exec-explorer ()
       "In dired, execute Explorer"
       (interactive)
       (explorer (dired-current-directory)))
     ;;
     ;; M-x explorer で現在のカレントディレクトリをもとにエクスプローラ
     ;; を立ち上げる設定。
     ;;
     (define-process-argument-editing "/explorer\\.exe$"
       (lambda (x)
         (general-process-argument-editing-function x nil nil nil)))
     (defun explorer (&optional dir)
       (interactive)
       (setq dir (expand-file-name (or dir default-directory)))
       (if (or (not (file-exists-p dir))
               (and (file-exists-p dir)
                    (not (file-directory-p dir))))
           (message "%s can't open." dir)
         (setq dir (unix-to-dos-filename dir))
         (let ((w32-start-process-show-window t))
           (apply (function start-process)
                  "explorer" nil "explorer.exe" (list (concat "/e,/root," dir))))))
     ))

;;----------------------------------------------------------------------
;;25.3.8 dired で Windows のリンクを扱う ― w32-symlinks (2005/02/17)
;;----------------------------------------------------------------------
(if (eq system-type 'windows-nt)
    (lambda()
     (require 'w32-symlinks)

     ;; dired で S としても現在選択しているファイルに対するリンクを作成できます．
     (setq w32-symlinks-make-using 'wsh)
     (setq w32-symlinks-ln-script
           (expand-file-name "~/w32-symlinks-ln-s.js"))

     (defadvice w32-symlinks-make-using-wsh
       (around make-shortcut activate)
       (w32-symlinks-check-ln-script)
       (if (not (string= (substring newname -4) ".lnk"))
           (setq newname (concat newname ".lnk")))
       (start-process "makelink" "makelink" w32-symlinks-ln-script
                      (unix-to-dos-filename (expand-file-name file))
                      (unix-to-dos-filename (expand-file-name newname)))
       )

     (defun dired-make-symbolic-link (newname)
       (interactive "\FName for link to : \n")
       (if (string= "" (file-name-nondirectory newname))
           (error "Input filename for link"))
       (if (not (string= (substring newname -4) ".lnk"))
           (setq newname (concat newname ".lnk")))
       (let ((file (dired-get-filename)))
         (make-symbolic-link file newname)))

     (add-hook 'dired-mode-hook
               '(lambda ()
                  (define-key dired-mode-map "S" (function dired-make-symbolic-link))
                  ))
     ))

;;----------------------------------------------------------------------
;;25.3.9 tar/lzh の内容表示/展開 (2005/02/17)
;;----------------------------------------------------------------------
(defun dired-do-tar-zvtf (arg)
  "Only one file line can be processed. If ARG, execute vzxf"
  (interactive "P")
  (let ((files (dired-get-marked-files t current-prefix-arg)))
    (if arg
        (dired-do-shell-command "tar zvxf * &" nil files)
      (dired-do-shell-command "tar zvtf * &" nil files))))

(defun dired-do-lha-v (arg)
  "Only one file line can be processed. If ARG, execute lha x"
  (interactive "P")
  (let ((files (dired-get-marked-files t current-prefix-arg)))
    (if arg
        (dired-do-shell-command "lha x * &" nil files)
      (dired-do-shell-command "lha v * &" nil files))))

(defun dired-do-mandoc (arg)
  "man source is formatted with col -xbf. If ARG, executes without col -xbf."
  (interactive "P")
  (let ((files (dired-get-marked-files t current-prefix-arg)))
    (if arg
        (dired-do-shell-command "groff -Tnippon -mandoc * &" nil files)
      (dired-do-shell-command "groff -Tnippon -mandoc * | col -xbf &" nil files))))

(define-key dired-mode-map "t" 'dired-do-tar-zvtf)
(define-key dired-mode-map "\eT" 'dired-do-lha-v)


;;----------------------------------------------------------------------
;;25.4 今日変更したファイルに色をつける (2005/02/17)
;;----------------------------------------------------------------------
;;25.4.1 今週・先週変更したファイルに色をつける (2005/02/17)
;;----------------------------------------------------------------------
(defface face-file-edited-today
  '((((class color)
      (background dark))
     (:foreground "GreenYellow"))
    (((class color)
      (background light))
     (:foreground "magenta"))
    (t
     ())) nil)
(defface face-file-edited-this-week
  '((((class color)
      (background dark))
     (:foreground "LimeGreen"))
    (((class color)
      (background light))
     (:foreground "violet red"))
    (t
     ())) nil)
(defface face-file-edited-last-week
  '((((class color)
      (background dark))
     (:foreground "saddle brown"))
    (((class color)
      (background light))
     (:foreground "maroon"))
    (t
     ())) nil)
(defvar face-file-edited-today
  'face-file-edited-today)
(defvar face-file-edited-this-week
  'face-file-edited-this-week)
(defvar face-file-edited-last-week
  'face-file-edited-last-week)
(defun my-dired-today-search (arg)
  "Fontlock search function for dired."
  (search-forward-regexp
   (concat "\\(" (format-time-string "%b %e" (current-time))
           "\\|"(format-time-string "%m-%d" (current-time))
           "\\)"
           " [0-9]....") arg t))
(defun my-dired-date (time)
  "Fontlock search function for dired."
  (let ((now (current-time))
        (days (* -1 time))
        dateh datel daysec daysh daysl dir
        (offset 0))
    (setq daysec (* -1.0 days 60 60 24))
    (setq daysh (floor (/ daysec 65536.0)))
    (setq daysl (round (- daysec (* daysh 65536.0))))
    (setq dateh (- (nth 0 now) daysh))
    (setq datel (- (nth 1 now) (* offset 3600) daysl))
    (if (< datel 0)
        (progn
          (setq datel (+ datel 65536))
          (setq dateh (- dateh 1))))
    ;;(floor (/ offset 24))))))
    (if (< dateh 0)
        (setq dateh 0))
    ;;(insert (concat (int-to-string dateh) ":"))
    (list dateh datel)))
(defun my-dired-this-week-search (arg)
  "Fontlock search function for dired."
  (let ((youbi
         (string-to-int
          (format-time-string "%w" (current-time))))
        this-week-start this-week-end day ;;regexp
        (flg nil))
    (setq youbi (+ youbi 1))
    (setq regexp
          (concat "\\("))
    (while (not (= youbi 0))
      (setq regexp
            (concat
             regexp
             (if flg
                 "\\|")
             (format-time-string
              "%b %e"
              (my-dired-date youbi))
             "\\|"
             (format-time-string
              "%m-%d"
              (my-dired-date youbi))
             ))
      ;;(insert (concat (int-to-string youbi) "\n"))
      (setq flg t)
      (setq youbi (- youbi 1))))
  (setq regexp
        (concat regexp "\\)"))
  (search-forward-regexp
   (concat regexp " [0-9]....") arg t))
(defun my-dired-last-week-search (arg)
  "Fontlock search function for dired."
  (let ((youbi
         (string-to-int
          (format-time-string "%w" (current-time))))
        this-week-start this-week-end day ;;regexp
        lyoubi
        (flg nil))
    (setq youbi (+ youbi 0))
    (setq lyoubi (+ youbi 7))
    (setq regexp
          (concat "\\("))
    (while (not (= lyoubi youbi))
      (setq regexp
            (concat
             regexp
             (if flg
                 "\\|")
             (format-time-string
              "%b %e"
              (my-dired-date lyoubi))
             "\\|"
             (format-time-string
              "%m-%d"
              (my-dired-date lyoubi))
             ))
      ;;(insert (concat (int-to-string youbi) "\n"))
      (setq flg t)
      (setq lyoubi (- lyoubi 1))))
  (setq regexp
        (concat regexp "\\)"))
  (search-forward-regexp
   (concat regexp " [0-9]....") arg t))

(font-lock-add-keywords
 major-mode
 (list
  '(my-dired-today-search . face-file-edited-today)
  '(my-dired-this-week-search . face-file-edited-this-week)
  '(my-dired-last-week-search . face-file-edited-last-week)
  ))

;;----------------------------------------------------------------------
;;25.5 dired の並び換え関連 (2007/11/24)
;;----------------------------------------------------------------------
;;25.5.1 dired の並び換え方法を保存 (2005/02/17)
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
;;25.5.2 dired でサイズ，拡張子で並び換え (2007/11/24)
;;----------------------------------------------------------------------
(add-hook 'dired-load-hook
          (lambda ()
            (require 'sorter)))


;;----------------------------------------------------------------------
;;25.5.4 ディレクトリを先に表示する (2005/02/17)
;;----------------------------------------------------------------------
(setq ls-lisp-dirs-first t)

;;----------------------------------------------------------------------
;;25.6.2 dired バッファを編集 ― 一括リネーム wdired (2005/02/17)
;;----------------------------------------------------------------------
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)


;;----------------------------------------------------------------------
;;24.2.3 バックアップファイルの保存場所 (2003/08/07)
;;----------------------------------------------------------------------
(setq make-backup-files t)
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/backup"))
            backup-directory-alist))


;;----------------------------------------------------------------------
;;24.2.5 前回編集していた場所を記憶させるには ― saveplace (2003/08/07)
;;----------------------------------------------------------------------
(load "saveplace")
(setq-default save-place t)



;;----------------------------------------------------------------------
;;26.3.1 タブ, 全角スペースを表示する (2003/10/02)
;;----------------------------------------------------------------------
;; ;;(defface my-face-r-1 '((t (:background "gray15"))) nil)
;; (defface my-face-b-1 '((t (:background "gray"))) nil)
;; (defface my-face-b-2 '((t (:background "gray26"))) nil)
;; (defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
;; (defface my-face-u-2 '((t (:foreground "gray" :underline t))) nil)
;; ;;(defvar my-face-r-1 'my-face-r-1)
;; (defvar my-face-b-1 'my-face-b-1)
;; (defvar my-face-b-2 'my-face-b-2)
;; (defvar my-face-u-1 'my-face-u-1)
;; (defvar my-face-u-2 'my-face-u-2)

;; (defadvice font-lock-mode (before my-font-lock-mode ())
;;   (font-lock-add-keywords
;;    major-mode
;;    '(;;("\t" 0 my-face-b-2 append)
;;      ("　" 0 my-face-u-2 append)
;;      ;;("[ \t]+$" 0 my-face-u-1 append)
;;      ;;("[\r]*\n" 0 my-face-r-1 append)
;;      )))
;; (ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
;; (ad-activate 'font-lock-mode)

;;----------------------------------------------------------------------
;;27.3.1 ミニバッファを isearch － minibuf-isearch (2004/02/22)
;;----------------------------------------------------------------------
;;(require 'minibuf-isearch)

;;----------------------------------------------------------------------
;;27.3.2 ヒストリの自動保存 ― session (2007/11/15)
;;----------------------------------------------------------------------
;; ;; (require 'session)
;; ;; (add-hook 'after-init-hook 'session-initialize)
;; ;; (setq session-undo-check -1)

;;----------------------------------------------------------------------
;;27.3.3 先頭文字の一致する M-x ヒストリを辿る ― tails-history (2003/09/27)
;;----------------------------------------------------------------------
(load-library "tails-history")

;;----------------------------------------------------------------------
;;27.3.4 ヒストリから重複を削除 (2004/02/03)
;;----------------------------------------------------------------------
;; history から重複したのを消す
(require 'cl)
(defun minibuffer-delete-duplicate ()
  (let (list)
    (dolist (elt (symbol-value minibuffer-history-variable))
      (unless (member elt list)
        (push elt list)))
    (set minibuffer-history-variable (nreverse list))))
(add-hook 'minibuffer-setup-hook 'minibuffer-delete-duplicate)

;;----------------------------------------------------------------------
;;28.1.2 バッファの移動 ― electric-buffer-list (2004/09/26)
;;----------------------------------------------------------------------
(global-set-key "\C-xe" 'electric-buffer-list)
;;(global-set-key "\C-x\C-b" 'buffer-menu)


;;----------------------------------------------------------------------
;;28.1.4 さらに便利なバッファリスト― ibuffer (2007/11/10)
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
;;28.1.4.3 ibuffer で文字コードを指定して保存 (2007/11/06)
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
;;28.2 バッファの切換えをもっと楽にしたい (2010/07/17)
;;----------------------------------------------------------------------
;;28.2.1 バッファの切換えをもっと楽にしたい － iswitchb (2008/03/24)
;;----------------------------------------------------------------------
(iswitchb-mode 1)

(add-hook 'iswitchb-define-mode-map-hook
          'iswitchb-my-keys)

(defun iswitchb-my-keys ()
  "Add my keybindings for iswitchb."
  (define-key iswitchb-mode-map [right] 'iswitchb-next-match)
  (define-key iswitchb-mode-map [left] 'iswitchb-prev-match)
  (define-key iswitchb-mode-map "\C-f" 'iswitchb-next-match)
  (define-key iswitchb-mode-map " " 'iswitchb-next-match)
  (define-key iswitchb-mode-map "\C-b" 'iswitchb-prev-match)
  )

;;----------------------------------------------------------------------
;;28.2.1.1 iswitchb で選択中の内容を表示 (2004/06/27)
;;----------------------------------------------------------------------
(defadvice iswitchb-exhibit
  (after
   iswitchb-exhibit-with-display-buffer
   activate)
  "選択している buffer を window に表示してみる。"
  (when (and
         (eq iswitchb-method iswitchb-default-method)
         iswitchb-matches)
    (select-window
     (get-buffer-window (cadr (buffer-list))))
    (let ((iswitchb-method 'samewindow))
      (iswitchb-visit-buffer
       (get-buffer (car iswitchb-matches))))
    (select-window (minibuffer-window))))

;;----------------------------------------------------------------------
;;28.2.1.3 iswitchb で migemo を使う (2005/03/01)
;;----------------------------------------------------------------------
(setq iswitchb-regexp t)
(setq iswitchb-use-migemo-p t)
(defadvice iswitchb-get-matched-buffers
  (before iswitchb-use-migemo activate)
  "iswitchb で migemo を使ってみる。"
  (when iswitchb-use-migemo-p
    (ad-set-arg
     0 (migemo-get-pattern
        (ad-get-arg 0)))))


;;----------------------------------------------------------------------
;;29.4.2 *scratch*バッファを kill できないように (2003/04/09)
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
;;29.6 scratch バッファの内容を保存 (2003/10/27)
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


