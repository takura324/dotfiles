(require 'bind-key)

;;----------------------------------------------------------------------
;; 書き散らかしメモツール — howm 
;;----------------------------------------------------------------------
(setq howm-menu-lang 'ja)
(bind-key "C-c ,," 'howm-menu)
(mapc
 (lambda (f)
   (autoload f "howm" "Hitori Otegaru Wiki Modoki" t))
 '(howm-menu howm-list-all howm-list-recent
             howm-list-grep howm-create
             howm-keyword-to-kill-ring))

;; リンクを TAB で辿る
(eval-after-load "howm-mode"
  '(progn
     (define-key howm-mode-map [tab] 'action-lock-goto-next-link)
     (define-key howm-mode-map [(control tab)] 'action-lock-goto-previous-link)))
;; 「最近のメモ」一覧時にタイトル表示
(setq howm-list-recent-title t)
;; 全メモ一覧時にタイトル表示
(setq howm-list-all-title t)
;; メニューを 2 時間キャッシュ
(setq howm-menu-expiry-hours 2)

;; howm の時は auto-fill で
(add-hook 'howm-mode-on-hook 'auto-fill-mode)

;; RET でファイルを開く際, 一覧バッファを消す
;; C-u RET なら残る
(setq howm-view-summary-persistent nil)

;; メニューの予定表の表示範囲
;; 10 日前から
(setq howm-menu-schedule-days-before 10)
;; 3 日後まで
(setq howm-menu-schedule-days 7)

;; howm のファイル名
;; 以下のスタイルのうちどれかを選んでください
;; で，不要な行は削除してください
;; 1 メモ 1 ファイル (デフォルト)
(setq howm-file-name-format "%Y/%m/%Y-%m-%d-%H%M%S.howm")
;; 1 日 1 ファイルであれば
;;(setq howm-file-name-format "%Y/%m/%Y-%m-%d.howm")

(setq howm-view-grep-parse-line
      "^\\(\\([a-zA-Z]:/\\)?[^:]*\\.howm\\):\\([0-9]*\\):\\(.*\\)$")
;; 検索しないファイルの正規表現
(setq
 howm-excluded-file-regexp
 "/\\.#\\|[~#]$\\|\\.bak$\\|/CVS/\\|\\.doc$\\|\\.pdf$\\|\\.ppt$\\|\\.xls$")

;; いちいち消すのも面倒なので
;; 内容が 0 ならファイルごと削除する
(if (not (memq 'delete-file-if-no-contents after-save-hook))
    (setq after-save-hook
          (cons 'delete-file-if-no-contents after-save-hook)))
(defun delete-file-if-no-contents ()
  (when (and
         (buffer-file-name (current-buffer))
         (string-match "\\.howm" (buffer-file-name (current-buffer)))
         (= (point-min) (point-max)))
    (delete-file
     (buffer-file-name (current-buffer)))))

;; http://howm.sourceforge.jp/cgi-bin/hiki/hiki.cgi?SaveAndKillBuffer
;; C-cC-c で保存してバッファをキルする
(defun my-save-and-kill-buffer ()
  (interactive)
  (when (and
         (buffer-file-name)
         (string-match "\\.howm"
                       (buffer-file-name)))
    (save-buffer)
    (kill-buffer nil)))
(eval-after-load "howm"
  '(progn
     (bind-key "C-c C-c" 'my-save-and-kill-buffer howm-mode-map)))

;; メニューを自動更新しない
(setq howm-menu-refresh-after-save nil)
;; 下線を引き直さない
(setq howm-refresh-after-save nil)

	
(eval-after-load "calendar"
  '(progn
     (bind-key "\C-m" 'my-insert-day calendar-mode-map)
     (defun my-insert-day ()
       (interactive)
       (let ((day nil)
             (calendar-date-display-form
         '("[" year "-" (format "%02d" (string-to-int month))
           "-" (format "%02d" (string-to-int day)) "]")))
         (setq day (calendar-date-string
                    (calendar-cursor-to-date t)))
         (calendar-exit)
         (insert day)))))

;;----------------------------------------------------------------------
;; howm と カレンダの併用 
;;----------------------------------------------------------------------
(require 'calendar)
(require 'howm-mode)
(setq
 calendar-date-display-form
 '("[" year "-" (format "%02d" (string-to-int month))
   "-" (format "%02d" (string-to-int day)) "]"))
(setq diary-file
      (expand-file-name "diary" howm-directory))

(defun howm-mark-calendar-date ()
  (interactive)
  (require 'howm-reminder)
  (let* ((today (howm-reminder-today 0))
         (limit (howm-reminder-today 1))
         (howm-schedule-types
          howm-schedule-menu-types)
         (raw (howm-reminder-search
               howm-schedule-types))
         (str nil) (yy nil) (mm nil) (dd nil))
    (while raw
      (setq str (nth 1 (car raw)))
      (when
          (string-match
           "\\([0-9]+\\)-\\([0-9]+\\)-\\([0-9]+\\)"
           str)
        (setq yy (match-string 1 str))
        (setq mm (match-string 2 str))
        (setq dd (match-string 3 str)))
      (when (and yy mm dd)
        (mark-calendar-date-pattern
         (string-to-int mm)
         (string-to-int dd)
         (string-to-int yy)))
      (setq mm nil)
      (setq dd nil)
      (setq yy nil)
      (setq raw (cdr raw))
      )))

(defadvice mark-diary-entries
  (after mark-howm-entry activate)
  (howm-mark-calendar-date))

(setq
 howm-menu-display-rules
 (cons
  (cons "%hdiary[\n]?" 'howm-menu-diary)
  howm-menu-display-rules
   ))

(defun howm-menu-diary ()
  (require 'diary-lib)
  (message "scanning diary...")
  (delete-region
   (match-beginning 0) (match-end 0))
  (let* ((now (decode-time (current-time)))
         (diary-date
          (list (nth 4 now) (nth 3 now) (nth 5 now)))
         (diary-display-hook 'ignore)
         (cbuf (current-buffer))
         (howm-diary-entry nil)
         (howm-diary-entry-day nil)
         (str nil))
    (unwind-protect
        (setq howm-diary-entry
              (list-diary-entries
               diary-date howm-menu-schedule-days))
      (save-excursion
        (set-buffer
         (find-buffer-visiting diary-file))
        (subst-char-in-region
         (point-min) (point-max) ?\^M ?\n t)
        (setq selective-display nil)))

    (while howm-diary-entry
      (setq howm-diary-entry-day (car howm-diary-entry))
      (setq mm (nth 0 (car howm-diary-entry-day)))
      (setq dd (nth 1 (car howm-diary-entry-day)))
      (setq yy (nth 2 (car howm-diary-entry-day)))
      (setq str (nth 1 howm-diary-entry-day))
      (setq howm-diary-entry (cdr howm-diary-entry))
      (insert
       (format
        ">>d [%04d-%02d-%02d] %s\n" yy mm dd str))))
  (message "scanning diary...done")
  )

(setq diary-date-forms
      '((month "/" day "[^/0-9]")
        (month "/" day "/" year "[^0-9]")
        ("\\[" year "-" month "-" day "\\]" "[^0-9]")
        (monthname " *" day "[^,0-9]")
        (monthname " *" day ", *" year "[^0-9]")
        (dayname "\\W")))

(defun howm-open-diary (&optional dummy)
  (interactive)
  (let ((date-str nil) (str nil))
    (save-excursion
      (beginning-of-line)
      (when (re-search-forward
             ">>d \\(\\[[-0-9]+\\]\\) " nil t)
        (setq str
              (concat
               "^.+"
               (buffer-substring-no-properties
                (point) (line-end-position))))
        (setq date-str
              (concat
               "^.+"
               (buffer-substring-no-properties
                (match-beginning 1)
                (match-end 1))
               " " str))
        (find-file
         (substitute-in-file-name diary-file))
        (howm-mode t)
        (goto-char (point-min))
        (if (re-search-forward date-str nil t)
            ()
          (re-search-forward str nil t))))))

(defun add-diary-action-lock-rule ()
  (let ((rule
         (action-lock-general
          'howm-open-diary
          "^\\(>>d\\) "
          1 1)))
    (if (not (member rule action-lock-default-rules))
        (progn
          (setq action-lock-default-rules
                (cons rule action-lock-default-rules))
          (action-lock-set-rules
           action-lock-default-rules)))))

(add-hook 'action-lock-mode-on-hook
          'add-diary-action-lock-rule)

(defadvice make-diary-entry
  (after howm-mode activate)
  (text-mode)
  (howm-mode t))


	

;; M-x calendar しといて M-x howm-from-calendar
;;         → その日付を検索
(defun howm-from-calendar ()
  (interactive)
  (require 'howm-mode)
  (let* ((mdy (calendar-cursor-to-date t))
         (m (car mdy))
         (d (second mdy))
         (y (third mdy))
         (key (format-time-string
               howm-date-format
               (encode-time 0 0 0 d m y))))
    (howm-keyword-search key)))

;;カレンダーの上で d を押すと grep
(add-hook 'initial-calendar-window-hook
          '(lambda ()
             (local-set-key
              "d" 'howm-from-calendar)))

;;howm のメニューで d でカレンダー
(add-hook 'howm-menu-hook
          '(lambda ()
             (local-set-key "d" 'calendar)))
