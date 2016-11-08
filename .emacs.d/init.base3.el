;;----------------------------------------------------------------------
;;30.6.1 分割情報を保存 — windows (2004/01/24)
;;----------------------------------------------------------------------
;; キーバインドを変更．
;; デフォルトは C-c C-w
;; 変更しない場合」は，以下の 3 行を削除する
;; (setq win:switch-prefix "\C-z")
;; (define-key global-map win:switch-prefix nil)
;; (define-key global-map "\C-z1" 'win-switch-to-window)

;; (setq win:switch-prefix "\C-z")
;; (define-key global-map win:switch-prefix nil)
;; (setq win:base-key ?`) ;; ` は「直前の状態」
;; (setq win:max-configs 27) ;; ` 〜 z は 27 文字
;; (setq win:quick-selection nil) ;; C-c 英字 に割り当てない

(require 'windows)
;; 新規にフレームを作らない
(setq win:use-frame nil)
(win:startup-with-window)
(define-key ctl-x-map "C" 'see-you-again)

(setq revive:ignore-buffer-pattern "^ \\*")


;;----------------------------------------------------------------------
;;31.2.1 マウスカーソルを編集中に消す (2005/03/01)
;;----------------------------------------------------------------------
;; 0=消さない それ以外=消えるまでの時間 (ミリ秒)
(setq w32-hide-mouse-timeout 1000)
;; nil=消さない t=キー入力でマウスカーソルが消える
(setq w32-hide-mouse-on-key t)

(blink-cursor-mode 0)


;;----------------------------------------------------------------------
;;32.1.5 読み込み専用のテキストをキル (2005/03/19)
;;----------------------------------------------------------------------
(setq kill-read-only-ok t)

;;----------------------------------------------------------------------
;;32.2 貼り付けのカスタマイズ (2003/11/14)
;;----------------------------------------------------------------------
;;32.2.1.1 貼り付けの拡張 — browse-kill-ring (2003/07/12)
;;----------------------------------------------------------------------
(require 'browse-kill-ring)
(global-set-key "\M-y" 'browse-kill-ring)

;; ;; kill-ring を一行で表示
;; (setq browse-kill-ring-display-style 'one-line)
;; ;; browse-kill-ring 終了時にバッファを kill する
;; (setq browse-kill-ring-quit-action 'kill-and-delete-window)
;; ;; 必要に応じて browse-kill-ring のウィンドウの大きさを変更する
;; (setq browse-kill-ring-resize-window t)
;; kill-ring の内容を表示する際の区切りを指定する
(setq browse-kill-ring-separator "-------")
;; 現在選択中の kill-ring のハイライトする
(setq browse-kill-ring-highlight-current-entry t)
;; ;; 区切り文字のフェイスを指定する
;; (setq browse-kill-ring-separator-face 'region)
;; ;; 一覧で表示する文字数を指定する． nil ならすべて表示される．
;; (setq browse-kill-ring-maximum-display-length 100)

;;----------------------------------------------------------------------
;;32.2.1.2 貼り付けの拡張 — kill-summary (2003/11/14)
;;----------------------------------------------------------------------
;;(autoload 'kill-summary "kill-summary" nil t)
;;(global-set-key "\M-y" 'kill-summary)


;;----------------------------------------------------------------------
;;32.2.1.3 貼り付けの拡張 — browse-yank (2003/11/14)
;;----------------------------------------------------------------------
;;(load "browse-yank")
;;(global-set-key "\M-y" 'browse-yank)


;;----------------------------------------------------------------------
;;32.4 拡張クリップボード — レジスタ (2003/11/24)
;;----------------------------------------------------------------------
;; C-x r s a (copy-to-register)
;; C-x r i a (insert-register)

;; C-x r r a (copy-rectangle-to-register)

;; C-x r SPC a (point-to-register)
;; C-x r j a (jump-to-register)

;;----------------------------------------------------------------------
;;32.4.2 レジスタを一覧表示 — list-register (2003/11/18)
;;----------------------------------------------------------------------
(require 'list-register)



;;----------------------------------------------------------------------
;;33.6 やり直し — redo (2003/11/05)
;;----------------------------------------------------------------------
(require 'redo)
(global-set-key "\C-]" 'redo)

;;----------------------------------------------------------------------
;;33.10 連続する同じ行を 1 行に— uniq (2003/10/08)
;;----------------------------------------------------------------------
(load "uniq")

;;----------------------------------------------------------------------
;;34.1 定型句の登録 — abbrev-mode (2007/11/18)
;;----------------------------------------------------------------------
;; # C-x a +:モード固有の略語を設定
;; # C-x a g:グローバルな略語を設定
;; # C-x a ':略語を展開 (上記の設定をしていれば M-SPC でもいい) 

;; 保存先を指定する
(setq abbrev-file-name "~/.abbrev_defs")
;; 略称展開のキーバインドを指定する
(define-key esc-map  " " 'expand-abbrev) ;; M-SPC
;; 起動時に保存した略称を読み込む
(quietly-read-abbrev-file)
;; 略称を保存する
(setq save-abbrevs t)

;;----------------------------------------------------------------------
;;34.1.1.1 勝手に abbrev を展開しないようにする (2007/11/18)
;;----------------------------------------------------------------------
(add-hook 'pre-command-hook
          (lambda ()
            (setq abbrev-mode nil)))

;;----------------------------------------------------------------------
;;34.2.1 日本語で dabbrev を使う — dabbrev-ja (2007/12/22)
;;----------------------------------------------------------------------
(load "dabbrev-ja")

;;----------------------------------------------------------------------
;;34.2.2 該当箇所が強調される dabbrev — dabbrev-highlight (2008/03/15)
;;----------------------------------------------------------------------
(require 'dabbrev-highlight)


;;----------------------------------------------------------------------
;;35.1 構造的な文書を書く − アウトラインモード (2005/03/25)
;;----------------------------------------------------------------------
;;(setq outline-minor-mode-prefix "\M-")

;;----------------------------------------------------------------------
;;35.1.1 階層を正常に判断させる方法 (2005/03/25)
;;----------------------------------------------------------------------
(add-hook 'yahtml-mode-hook
          '(lambda ()
             (setq outline-regexp "<\\(h1\\|h2>\\|h3>.\\|h4>..\\|h5>...\\|h6>....\\)")
             (outline-minor-mode t)))


;;----------------------------------------------------------------------
;;35.2 テキストの一部だけを表示 − ナロイング (2005/03/30)
;;----------------------------------------------------------------------
;;C-x n n
;;C-x n w

;;----------------------------------------------------------------------
;;35.2.1 ナロイングを入れ子に使う — narrow-stack (2005/03/25)
;;----------------------------------------------------------------------
;;(require 'narrow-stack)
;;(narrow-stack-mode)


;;----------------------------------------------------------------------
;;35.4.1 isearch で検索中の単語をハイライト (2004/01/14)
;;----------------------------------------------------------------------
(require 'hi-lock)

(defun highlight-isearch-word ()
  (interactive)
  (let ((case-fold-search isearch-case-fold-search))
    (isearch-exit)
    (hi-lock-face-buffer-isearch
     (if (and (featurep 'migemo) migemo-isearch-enable-p)
         (migemo-get-pattern isearch-string)
       isearch-string))))

(defun hi-lock-face-buffer-isearch (regexp)
  (interactive)
  (let ((face
         (hi-lock-read-face-name)))
    (or (facep face) (setq face 'rwl-yellow))
    (unless hi-lock-mode (hi-lock-mode))
    (hi-lock-set-pattern
     (list regexp (list 0 (list 'quote face) t)))))

(define-key isearch-mode-map (kbd "C-l") 'highlight-isearch-word)


;;----------------------------------------------------------------------
;;35.5 特定の行に色をつける — hi-lock (2004/03/07)
;;----------------------------------------------------------------------
;;M-x hi-lock-mode
;;M-x highlight-regexp
;;M-x unhighlight-regexp
;;M-x highlight-phrase
;;M-x hi-lock-write-interactive-patterns

;; 起動時から hi-lock を有効にする
(global-hi-lock-mode 1)
(define-key hi-lock-map "\C-z\C-h" 'highlight-lines-matching-regexp)
(define-key hi-lock-map "\C-zi" 'hi-lock-find-patterns)
(define-key hi-lock-map "\C-zh" 'highlight-regexp)
(define-key hi-lock-map "\C-zp" 'highlight-phrase)
(define-key hi-lock-map "\C-zr" 'unhighlight-regexp)
(define-key hi-lock-map "\C-zb" 'hi-lock-write-interactive-patterns)


;;----------------------------------------------------------------------
;;38.6 書き散らかしメモツール — howm (2006/01/18)
;;----------------------------------------------------------------------
(setq howm-menu-lang 'ja)
(global-set-key "\C-c,," 'howm-menu)
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
     (define-key howm-mode-map [(meta tab)] 'action-lock-goto-previous-link)))
;; 「最近のメモ」一覧時にタイトル表示
(setq howm-list-recent-title t)
;; 全メモ一覧時にタイトル表示
(setq howm-list-all-title t)
;; メニューを 2 時間キャッシュ
(setq howm-menu-expiry-hours 2)

;; howm の時は auto-fill で
(add-hook 'howm-mode-on-hook 'auto-fill-mode)
(setq fill-column 100)

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
;;(setq howm-file-name-format "%Y/%m/%Y-%m-%d-%H%M%S.howm")
;; 1 日 1 ファイルであれば
(setq howm-file-name-format "%Y/%m/%Y-%m-%d.howm")

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
     (define-key howm-mode-map
       "\C-c\C-c" 'my-save-and-kill-buffer)))

;; メニューを自動更新しない
(setq howm-menu-refresh-after-save nil)
;; 下線を引き直さない
(setq howm-refresh-after-save nil)

	
(eval-after-load "calendar"
  '(progn
     (define-key calendar-mode-map
       "\C-m" 'my-insert-day)
     (defun my-insert-day ()
       (interactive)
       (let ((day nil)
             (calendar-date-display-form
         '("[" year "-" (format "%02d" (string-to-int month))
           "-" (format "%02d" (string-to-int day)) "]")))
         (setq day (calendar-date-string
                    (calendar-cursor-to-date t)))
         (exit-calendar)
         (insert day)))))

;;----------------------------------------------------------------------
;;38.6.1 howm と カレンダの併用 (2005/04/11)
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


;;----------------------------------------------------------------------
;;39.1 野鳥 − TeX ， HTML の編集 (2005/05/21)
;;----------------------------------------------------------------------
;; ;; オートロード
;; (autoload 'yahtml-mode
;;   "yahtml" "Yet Another HTML mode" t)

;; ;; YaHtml モードの関連付けを指定
;; (setq auto-mode-alist
;;        (append '(
;;                 ("\\.\\(html$\\|htm$\\)" . yahtml-mode))
;;                auto-mode-alist))


;; ;; YaHtml 関連の設定
;; ;; ブラウザの設定
;; (setq yahtml-www-browser "start.exe")
;; (setq yahtml-p-prefered-env-regexp "^\\(div\\|body\\|dl\\|blockquote\\)")
;; ;; Web ページの連想リスト
;; (setq yahtml-path-url-alist
;;       '(("~/WWW" . "http://www.bookshelf.jp/")
;;         )) ;; 環境に合わせて変更してください

;; ;;C-c s list で補完するもの
;; (setq yahtml-form-table
;;       '(("img") ("input") ("a") ("body") ("form") ("select")
;;         ("p") ("textarea") ("table") ("font")
;;         )) ;;好みにより調整してください

;; ;;ここから新規作成時のテンプレート設定。お好みで
;; (load "autoinsert")
;; (add-hook 'find-file-hooks 'auto-insert)
;; (setq
;;  auto-insert-alist
;;  (append
;;   '((yahtml-mode
;;      "Input title: "
;;      "<!doctype html public \"-//W3C//DTD HTML 3.2//EN\">\n"
;;      "<html>\n"
;;      "<head>\n"
;;      "<title>" str "\n"
;;      "<meta http-equiv=\"Content-Type\""
;;      " content=\"text/html; charset=ISO-2022-JP\">\n"
;;      "</head>\n"
;;      "<BODY>\n\n"
;;      "\n\n\n"
;;      "</BODY>\n\n"
;;      "</html>\n"))
;;   auto-insert-alist)) ;;好みにより調整してください
;; ;;ここまで新規作成時のテンプレート設定

