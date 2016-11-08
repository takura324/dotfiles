;;----------------------------------------------------------------------
;;22.1 �����Ȃ��̂��K�w�����ĕ\�� �\ ee (2003/08/08)
;;----------------------------------------------------------------------
;; (require 'ee-autoloads)
;; (setq ee-textfile-changelog-name-regexp
;;       "[(].*[)][ ]*\\([^<(]+?\\) [ \t]*[(<]\\([A-Za-z0-9_.-]+@[A-Za-z0-9_.-]+\\) [>)]")

;;(setq max-lisp-eval-depth 1000)
;;(setq max-specpdl-size 6000)


;;----------------------------------------------------------------------
;;23.1 �t�@�C�����J����{���� (2005/03/20)
;;----------------------------------------------------------------------
;;�w�肵���g���q�͕⊮���ɏo�Ȃ��悤�ɂȂ�
(setq completion-ignored-extensions
      (append completion-ignored-extensions
              '(".exe" ".com" ".o")))

;;----------------------------------------------------------------------
;;23.2 �t�@�C�����⊮�֘A (2005/03/20)
;;----------------------------------------------------------------------
;;23.2.1 �t�@�C�����̈ꕔ�Ɗg���q�ŕ⊮ (2005/03/20)
;;----------------------------------------------------------------------
;;(partial-completion-mode t)

;;----------------------------------------------------------------------
;;23.2.3 �t�@�C�����������ŕ⊮ �\ highlight-completion (2003/08/06)
;;----------------------------------------------------------------------
;; (setq hc-ctrl-x-c-is-completion t)
;; (require 'highlight-completion)
;; (highlight-completion-mode 1)
;; (global-set-key "\C-\\" 'toggle-input-method)


;;----------------------------------------------------------------------
;;23.2.4 migemo �� find-file �\ ���e (2004/02/13)
;;----------------------------------------------------------------------
(if (eq system-type 'windows-nt)
    (lambda()
     (require 'kogiku)
     ))

;;----------------------------------------------------------------------
;;23.2.7 �]�v�ȕ������Â� �\ rfn-eshadow (2005/03/18)
;;----------------------------------------------------------------------
(file-name-shadow-mode t)

;;----------------------------------------------------------------------
;;23.6.3 Word �� Excel ���e�L�X�g�ɕϊ� �\ xdoc2txt (2005/02/17)
;;----------------------------------------------------------------------
;;23.6.3.1 Word �� Excel �̃t�@�C�����e��\�� (2005/02/17)
;;----------------------------------------------------------------------
(if (eq system-type 'windows-nt)
    (lambda()
     ;; Customize �p�̃O���[�v��ǉ��D
     (defgroup Meadow-Memo nil
       "Meadow Memo ���z�z����p�b�P�[�W�֘A�̐ݒ�"
       :group 'emacs)

     (defcustom YAMA-binary-files-editor t
       "nil �ȊO�ł���΁C�o�C�i���t�@�C�����J���ۂ�
�o�C�i���G�f�B�^�Ƃ��ĕҏW���邩�ǂ�����I���ł���"
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
       "nil �ȊO�ł���΁Cdoc �Ȃǂ̊g���q�Ńo�C�i��
�t�@�C���̏ꍇ�ɂ́Cxdoc2txt ���g���ĊJ���悤�ɂ���D"
       :type 'boolean
       :group 'Meadow-Memo)

     (defcustom YAMA-file-not-binary-extensions '()
       "�o�C�i���Ƃ݂Ȃ��Ȃ��t�@�C���̊g���q���w�肷��D
  �������C���ׂď������Ŏw�肷��"
       :type '(repeat string)
       :group 'Meadow-Memo)

     (defcustom YAMA-file-not-binary-files
       '("tags" "gsyms" "gpath" "grtags" "gsyms" "gtags")
       "�o�C�i���Ƃ݂Ȃ��Ȃ��t�@�C�������w�肷��D
�������C���ׂď������Ŏw��̂���"
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
�������C���ׂď������Ŏw��̂���"
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
             "�o�C�i���f�[�^�̓��e�� xdoc2txt �ŕ\�����܂���?"))
           (Yama-binary-file-view file))
          ((and
            (not coding-system-for-read)
            (eq bn 0)
            (y-or-n-p "�o�C�i���f�[�^�Ƃ��ĕҏW���܂���?"))
           (hexl-find-file file))
          (t
           ad-do-it))))

     (ad-activate 'find-file)
     ))

;;----------------------------------------------------------------------
;;23.8 Windows/Cygwin �ȂǂƂ̘A�g (2005/03/18)
;;----------------------------------------------------------------------
;;23.8.1 �����֘A�t���Ńt�@�C�����J������ �\ gnuserv (2004/10/02)
;;----------------------------------------------------------------------
(if (eq system-type 'windows-nt)
    (lambda()
     (load "gnuserv")
     (gnuserv-start)
     (setq gnuserv-frame (selected-frame))
     ))

;;----------------------------------------------------------------------
;;23.8.2 �֘A�t���Ō��݃o�b�t�@���J�� (2005/02/17)
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
;;        "���݂̃o�b�t�@�̓t�@�C���ł͂���܂���"))
;;      ((file-directory-p file)
;;       (start-process
;;        "explorer" "diredfiber" "explorer.exe"
;;        (unix-to-dos-filename file)))
;;      ((file-exists-p file)
;;       (start-process
;;        "fiber" "diredfiber" "fiber.exe" file))
;;      ((not (file-exists-p file))
;;       (error "�t�@�C�������݂��܂���")))))

;;----------------------------------------------------------------------
;;23.9 �t�@�C�����J���֘A�֗̕��c�[�� (2005/03/18)
;;----------------------------------------------------------------------
;;23.9.1 �ŋߎg�����t�@�C�����L�������� (2004/01/17)
;;----------------------------------------------------------------------
(recentf-mode 1)

;;----------------------------------------------------------------------
;;23.9.2 �J���Ă����t�@�C���Ȃǂ��L�������� �\ desktop (2003/08/07)
;;----------------------------------------------------------------------
;; �ۑ����Ȃ��t�@�C���̐��K�\��
(setq desktop-files-not-to-save "\\(^/[^/:]*:\\|\\.diary$\\)")
(autoload 'desktop-save "desktop" nil t)
(autoload 'desktop-clear "desktop" nil t)
(autoload 'desktop-load-default "desktop" nil t)
(autoload 'desktop-remove "desktop" nil t)

;;     * desktop-clear:�J���Ă���o�b�t�@������
;;     * desktop-load-default:~/�ɕۑ����� desktop �t�@�C����ǂݍ���
;;     * desktop-remove:�ۑ����� desktop �t�@�C��������

;;----------------------------------------------------------------------
;;25.1 �f�B���N�g���\�� �\ dired (2005/02/17)
;;----------------------------------------------------------------------
;;25.1.1 dired ���g������ �| dired-x (2005/02/17)
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
;;25.3 dired �̃R�}���h��ǉ�/�g������ (2009/03/30)
;;----------------------------------------------------------------------
;;25.3.1 �}�[�N���g�O�����ɂ��� (2005/02/17)
;;----------------------------------------------------------------------
;; �X�y�[�X�Ń}�[�N���� (FD like)
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
;;25.3.3 �t�@�C���̕����R�[�h���ꊇ�ϊ� (2003/11/18)
;;----------------------------------------------------------------------
;;; dired ���g���āA��C�Ƀt�@�C���� coding system (����) ��ϊ�����
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

;; dired �� m �Ń}�[�N��t���CT �Ƃ��܂��D����ŁC�}�[�N��t�����t�@�C���̕����R�[�h��ϊ��ł��܂��D
;; �f�t�H���g�̕����R�[�h��
;; (setq dired-default-file-coding-system 'euc-jp-unix)
;; �̂悤�Ɏw��ł��܂��D

;;----------------------------------------------------------------------
;;25.3.4 dired �ōċA�R�s�[�C�ċA�폜 (2005/02/17)
;;----------------------------------------------------------------------
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

;;----------------------------------------------------------------------
;;25.3.5 �t�H���_���J����, �V�����o�b�t�@���쐬���Ȃ� �\ dired (2003/07/11)
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
;;25.3.7 dired ����֘A�t����ꂽ�\�t�g�ŊJ�� (2003/11/18)
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
;; Win32: dird ����G�N�X�v���[�����J��
;;----------------------------------------
(if (eq system-type 'windows-nt)
    (lambda()
     ;; dired �� "E" �ŊJ���B
     (add-hook 'dired-mode-hook
               (lambda ()
                 (local-set-key "E" 'dired-exec-explorer)))
     ;;
     (defun dired-exec-explorer ()
       "In dired, execute Explorer"
       (interactive)
       (explorer (dired-current-directory)))
     ;;
     ;; M-x explorer �Ō��݂̃J�����g�f�B���N�g�������ƂɃG�N�X�v���[��
     ;; �𗧂��グ��ݒ�B
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
;;25.3.8 dired �� Windows �̃����N������ �\ w32-symlinks (2005/02/17)
;;----------------------------------------------------------------------
(if (eq system-type 'windows-nt)
    (lambda()
     (require 'w32-symlinks)

     ;; dired �� S �Ƃ��Ă����ݑI�����Ă���t�@�C���ɑ΂��郊���N���쐬�ł��܂��D
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
;;25.3.9 tar/lzh �̓��e�\��/�W�J (2005/02/17)
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
;;25.4 �����ύX�����t�@�C���ɐF������ (2005/02/17)
;;----------------------------------------------------------------------
;;25.4.1 ���T�E��T�ύX�����t�@�C���ɐF������ (2005/02/17)
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
;;25.5 dired �̕��ъ����֘A (2007/11/24)
;;----------------------------------------------------------------------
;;25.5.1 dired �̕��ъ������@��ۑ� (2005/02/17)
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
;;25.5.2 dired �ŃT�C�Y�C�g���q�ŕ��ъ��� (2007/11/24)
;;----------------------------------------------------------------------
(add-hook 'dired-load-hook
          (lambda ()
            (require 'sorter)))


;;----------------------------------------------------------------------
;;25.5.4 �f�B���N�g�����ɕ\������ (2005/02/17)
;;----------------------------------------------------------------------
(setq ls-lisp-dirs-first t)

;;----------------------------------------------------------------------
;;25.6.2 dired �o�b�t�@��ҏW �\ �ꊇ���l�[�� wdired (2005/02/17)
;;----------------------------------------------------------------------
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)


;;----------------------------------------------------------------------
;;24.2.3 �o�b�N�A�b�v�t�@�C���̕ۑ��ꏊ (2003/08/07)
;;----------------------------------------------------------------------
(setq make-backup-files t)
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/backup"))
            backup-directory-alist))


;;----------------------------------------------------------------------
;;24.2.5 �O��ҏW���Ă����ꏊ���L��������ɂ� �\ saveplace (2003/08/07)
;;----------------------------------------------------------------------
(load "saveplace")
(setq-default save-place t)



;;----------------------------------------------------------------------
;;26.3.1 �^�u, �S�p�X�y�[�X��\������ (2003/10/02)
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
;;      ("�@" 0 my-face-u-2 append)
;;      ;;("[ \t]+$" 0 my-face-u-1 append)
;;      ;;("[\r]*\n" 0 my-face-r-1 append)
;;      )))
;; (ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
;; (ad-activate 'font-lock-mode)

;;----------------------------------------------------------------------
;;27.3.1 �~�j�o�b�t�@�� isearch �| minibuf-isearch (2004/02/22)
;;----------------------------------------------------------------------
;;(require 'minibuf-isearch)

;;----------------------------------------------------------------------
;;27.3.2 �q�X�g���̎����ۑ� �\ session (2007/11/15)
;;----------------------------------------------------------------------
;; ;; (require 'session)
;; ;; (add-hook 'after-init-hook 'session-initialize)
;; ;; (setq session-undo-check -1)

;;----------------------------------------------------------------------
;;27.3.3 �擪�����̈�v���� M-x �q�X�g����H�� �\ tails-history (2003/09/27)
;;----------------------------------------------------------------------
(load-library "tails-history")

;;----------------------------------------------------------------------
;;27.3.4 �q�X�g������d�����폜 (2004/02/03)
;;----------------------------------------------------------------------
;; history ����d�������̂�����
(require 'cl)
(defun minibuffer-delete-duplicate ()
  (let (list)
    (dolist (elt (symbol-value minibuffer-history-variable))
      (unless (member elt list)
        (push elt list)))
    (set minibuffer-history-variable (nreverse list))))
(add-hook 'minibuffer-setup-hook 'minibuffer-delete-duplicate)

;;----------------------------------------------------------------------
;;28.1.2 �o�b�t�@�̈ړ� �\ electric-buffer-list (2004/09/26)
;;----------------------------------------------------------------------
(global-set-key "\C-xe" 'electric-buffer-list)
;;(global-set-key "\C-x\C-b" 'buffer-menu)


;;----------------------------------------------------------------------
;;28.1.4 ����ɕ֗��ȃo�b�t�@���X�g�\ ibuffer (2007/11/10)
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
;;28.1.4.3 ibuffer �ŕ����R�[�h���w�肵�ĕۑ� (2007/11/06)
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
;;28.2 �o�b�t�@�̐؊����������Ɗy�ɂ����� (2010/07/17)
;;----------------------------------------------------------------------
;;28.2.1 �o�b�t�@�̐؊����������Ɗy�ɂ����� �| iswitchb (2008/03/24)
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
;;28.2.1.1 iswitchb �őI�𒆂̓��e��\�� (2004/06/27)
;;----------------------------------------------------------------------
(defadvice iswitchb-exhibit
  (after
   iswitchb-exhibit-with-display-buffer
   activate)
  "�I�����Ă��� buffer �� window �ɕ\�����Ă݂�B"
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
;;28.2.1.3 iswitchb �� migemo ���g�� (2005/03/01)
;;----------------------------------------------------------------------
(setq iswitchb-regexp t)
(setq iswitchb-use-migemo-p t)
(defadvice iswitchb-get-matched-buffers
  (before iswitchb-use-migemo activate)
  "iswitchb �� migemo ���g���Ă݂�B"
  (when iswitchb-use-migemo-p
    (ad-set-arg
     0 (migemo-get-pattern
        (ad-get-arg 0)))))


;;----------------------------------------------------------------------
;;29.4.2 *scratch*�o�b�t�@�� kill �ł��Ȃ��悤�� (2003/04/09)
;;----------------------------------------------------------------------
(defun my-make-scratch (&optional arg)
  (interactive)
  (progn
    ;; "*scratch*" ���쐬���� buffer-list �ɕ��荞��
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
    ;; *scratch* �o�b�t�@�� kill-buffer ��������e���������邾���ɂ���
          (function (lambda ()
                      (if (string= "*scratch*" (buffer-name))
                          (progn (my-make-scratch 0) nil)
                        t))))

(add-hook 'after-save-hook
;; *scratch* �o�b�t�@�̓��e��ۑ������� *scratch* �o�b�t�@��V�������
          (function (lambda ()
                      (unless (member "*scratch*" (my-buffer-name-list))
                        (my-make-scratch 1)))))


;;----------------------------------------------------------------------
;;29.6 scratch �o�b�t�@�̓��e��ۑ� (2003/10/27)
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


