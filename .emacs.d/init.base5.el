;;----------------------------------------------------------------------
;;50.1 occurの基本機能 - バッファの検索 (2008/08/13)
;;----------------------------------------------------------------------
;;     * C-c C-c や RET：バッファのその行へジャンプ
;;     * C-c C-f：現在の一致箇所を別ウィンドウに表示
;;     * C-o：別ウィンドウに該当箇所を表示
;;     * M-p：前の一致箇所へ
;;     * M-n：次の一致箇所へ
;;     * r：バッファ名を変更


;;----------------------------------------------------------------------
;;50.3.4 occur の結果で keep-line (2005/02/18)
;;----------------------------------------------------------------------
;;;Occur - Kin Cho <kin@dynarc.com>
(define-key occur-mode-map "F"
  (lambda (str) (interactive "sflush: ")
    (let ((buffer-read-only))
      (save-excursion
        (beginning-of-buffer)
        (forward-line 1)
        (beginning-of-line)
        (flush-lines str)))))
(define-key occur-mode-map "K"
  (lambda (str) (interactive "skeep: ")
    (let ((buffer-read-only))
      (save-excursion
        (beginning-of-buffer)
        (forward-line 1)
        (beginning-of-line)
        (keep-lines str)))))


;;----------------------------------------------------------------------
;;50.4 検索に一致した行の一括削除 (2005/02/18)
;;----------------------------------------------------------------------
;;M-x flush-lines，M-x keep-lines
;; 通常はカーソル移行が対象になりますが，常にバッファ全体を対象にしたければ

;; (defadvice flush-lines
;;   (before beginning-of-buffer-before-flush-lines activate)
;;   (beginning-of-buffer))
;; (defadvice keep-lines
;;   (before beginning-of-buffer-before-keep-lines activate)
;;   (beginning-of-buffer))

;; と設定しておきます．


;;----------------------------------------------------------------------
;;50.5 すべてのバッファ/ファイルに occur / grep を ― color-moccur (2010/07/24)
;;----------------------------------------------------------------------
;;50.5.2 color-moccur のインストール (2007/12/18)
;;----------------------------------------------------------------------
(load "color-moccur")

;;     * M-x moccur : ファイルバッファのみを検索 (正規表現)
;;     * C-u M-x moccur : すべてのバッファを検索 (正規表現)
;;     * M-x dmoccur : 指定したディレクトリ下のファイルを検索 (正規表現)
;;     * C-u M-x dmoccur : あらかじめ指定しておいたディレクトリ下のファイルを検索できる (正規表現)
;;     * M-x moccur-grep : grep のようにファイルを検索 (正規表現)
;;     * M-x moccur-grep-find : grep+find のようにファイルを検索 (正規表現)
;;     * M-x search-buffers : すべてのバッファを全文検索．
;;     * M-x grep-buffers : 開いているファイルを対象に grep ．
;;     * バッファリストで M-x Buffer-menu-moccur : m でマークをつけたバッファのみを対象に検索
;;     * dired で M-x dired-do-moccur : m でマークをつけたファイルのみを対象に検索
;;     * moccur の結果でs:一致したバッファのみで再検索
;;     * moccur の結果でu:一つ前の条件で検索


;;----------------------------------------------------------------------
;;50.5.3.1 color-moccur によるバッファ検索 (2007/12/22)
;;----------------------------------------------------------------------

;;     * SPC:ファイルバッファをスクロール (C-v)
;;     * b:ファイルバッファを逆方向にスクロール (M-v)
;;     * <:ファイルバッファの先頭を表示
;;     * >:ファイルバッファの最後を表示
;;     * 上カーソル，k，p:前の一致項目へ
;;     * 下カーソル，j，n:次の一致項目へ
;;     * M-p:前のバッファの一致項目へ
;;     * M-n:次のバッファの一致項目へ

;;     * s:検索に一致したバッファのみを対象に moccur を行う
;;     * u:一つ前の条件で moccur を行う
;;     * g:moccur バッファを更新する(同じ条件で該当バッファを再検索)．

;;     * M-x moccur-flush-lines:flush-lines と同じ．
;;     * M-x moccur-keep-lines:keep-lines と同じ．
;;     * M-x moccur-kill-line，C-k，d:kill-line と同じ．
;;     * /:Undo ． ee を利用していると，一番最初の状態まで戻ってしまいます

;;     * t:別ウィンドウに該当行を表示する/しないを切り替える
;;     * RETかC-c C-c:該当行へ移動
;;     * q:moccur の終了


;;----------------------------------------------------------------------
;;50.5.3.2 dmoccur によるディレクトリ下検索 (2007/12/19)
;;----------------------------------------------------------------------
;; M-x dmoccur
;; M-x clean-dmoccur-buffers


;;----------------------------------------------------------------------
;;50.5.3.3 dmoccur で指定ディレクトリを検索
;;----------------------------------------------------------------------
(setq dmoccur-list
      '(
        ("delphi" "/d/Project/PharmIB/PharmClt/" ("\\.pas$") nil)
        ("elisp" "~/elisp" ("\\.el$") nil)
        ("config" "~/mylisp/"  ("\\.js" "\\.el$") nil)
        ("1.99" "e:/unix/Meadow2/1.99a6/" (".*") sub)
        ("dir" default-directory (".*") dir nil my-dmoccur-word)

        ("node" "~/www/soft/" ("\\.texi$") nil
         (nil t) "\\(@cha\\|@sec\\)")
        ))

(defun my-dmoccur-word ()
  (message "d) ate w) ord")
  (let ((c (char-to-string (read-char))) (co))
    (cond
     ((string-match "d" c)
      (format-time-string "%Y/%m/%d"))
     ((string-match "w" c)
      (read-from-minibuffer "Input word: "))
     (t
      (message "Illegal char")
      (sleep-for 1)
      ;; 再入力をうながす
      (my-dmoccur-word)))))


;;----------------------------------------------------------------------
;;50.5.3.4 color-moccur で occur を代替 (2007/12/18)
;;----------------------------------------------------------------------
;; M-x occur-by-moccur

;;----------------------------------------------------------------------
;;50.5.3.5 isearch の単語で occur を実行 (2007/12/18)
;;----------------------------------------------------------------------
;; C-s で検索中に，M-o とします．


;;----------------------------------------------------------------------
;;50.6 すべてのバッファを検索し，編集したい ― moccur-edit (2008/07/29)
;;----------------------------------------------------------------------
(load "moccur-edit")

;; * 編集モードに入る
;; r(あるいはC-c C-i か C-x C-q でもいい) 

;; * 編集を適用する
;; C-x C-s (あるいは C-c C-c か C-c C-f でも可能)

;; * 一部の変更のみ適用したくない
;; 適用したくない部分をリージョンで選択し，C-c C-r

;; * すべての変更を破棄する
;; C-x k(あるいは C-c C-k か C-c k か C-c C-u でも可能)


;;----------------------------------------------------------------------
;;51.1.1 サブディレクトリのファイルも検索 (2005/11/22)
;;----------------------------------------------------------------------
(setq grep-use-null-device nil)
(setq grep-find-use-xargs t)

;;----------------------------------------------------------------------
;;51.3 文字コードを自動判別する grep － lgrep (2005/11/22)
;;----------------------------------------------------------------------
;; (setq grep-command "lgrep -n -Ou8 ")
;; ;;(setq grep-command "lgrep -n -As ")
;; (setq grep-program "lgrep")

;; shell-quote-argumentの問題回避 
(defvar quote-argument-for-windows-p t "enables `shell-quote-argument' workaround for windows.") 
(defadvice shell-quote-argument (around shell-quote-argument-for-win activate) 
"workaround for windows." 
(if quote-argument-for-windows-p 
(let ((argument (ad-get-arg 0))) 
(setq argument (replace-regexp-in-string "\\\\" "\\\\" argument nil t)) 
(setq argument (replace-regexp-in-string "'" "'\\''" argument nil t)) 
(setq ad-return-value (concat "'" argument "'"))) 
ad-do-it)) 

;; lgrep で Shift_JIS を使うように設定 
(setq grep-host-defaults-alist nil) ;; これはおまじないだと思ってください 
;;(setq grep-template "lgrep -Ks -Os <C> -n <R> <F> <N>")
(setq grep-template "lgrep -Is -Ou8 <C> -n <R> <F> <N>")
;;(setq grep-template "lgrep -Ou8 <C> -n <R> <F> <N>") 
;;(setq grep-find-template "find . <X> -type f <F> -print0 | xargs -0 -e lgrep -Ks -Os <C> -n <R> <N>") 
(setq grep-find-template "find . <X> -type f <F> -print0 | xargs -0 -e lgrep -Is -Ou8 <C> -n <R> <N>")

;;----------------------------------------------------------------------
;;51.4 grep の一致項目に色付け，絞り込み ― color-grep (2007/11/07)
;;----------------------------------------------------------------------
(require 'color-grep)
;; grep バッファを kill 時に，開いたバッファを消す
(setq color-grep-sync-kill-buffer t)

;;----------------------------------------------------------------------
;;51.5 grep を便利にしたい ― igrep (2005/11/22)
;;----------------------------------------------------------------------
(autoload 'igrep "igrep"
  "*Run `grep` PROGRAM to match EXPRESSION in FILES..." t)
(autoload 'igrep-find "igrep"
  "*Run `grep` via `find`..." t)
(autoload 'dired-do-igrep "igrep"
  "*Run `grep` on the marked (or next prefix ARG) files." t)
(autoload 'igrep-insinuate "igrep"
  "Define `grep' aliases for the corresponding `igrep' commands." t)
(autoload 'igrep-visited-files "igrep"
  "*Run `grep` ... on all visited files." t)
(autoload 'dired-do-igrep-find "igrep"
  "*Run `grep` via `find` on the marked (or next prefix ARG) directories." t)
(autoload 'Buffer-menu-igrep "igrep"
  "*Run `grep` on the files visited in buffers marked with '>'." t)

;; 以下は lgrep を使うための設定
;; (if (eq system-type 'cygwin)
;;     (lambda()
;;      (setq igrep-program "lgrep")
;;      (setq igrep-expression-option "-n -Ou")
;;      ))

;; * M-x igrep
;;   普通の grep です．対話式なので，普通の grep よりは馴染みやすいです．
;; 
;; * M-x igrep-find
;;   grep-find です．サブディレクトリまで検索することができます．
;; 
;; * M-x dired-do-igrep
;;   dired で m によりマークをつけたものだけを対象に grep ができます．
;; 
;; * M-x dired-do-igrep-find
;;   dired-do-igrep の find 版です
;; 
;; * M-x igrep-visited-files
;;   今開いているファイルのみを対象に grep ができます．
;; 
;; * M-x Buffer-menu-igrep
;;   C-x C-b でバッファリストを表示し，m でマークをつけてから，M-x Buffer-menu-igrep とすると，
;;   マークをつけたバッファのみを対象に grep ができます．

;;----------------------------------------------------------------------
;;51.6 メモを grep ― mgrep (2004/02/03)
;;----------------------------------------------------------------------
(require 'mgrep)
(if (eq system-type 'windows-nt)
    (lambda()
     (setq mgrep-list
           '(
             ;; name directory file find
             ("site-lisp" "c:/meadow/site-lisp" "*.el" t)
             ("packages-lisp" "c:/meadow/packages/lisp" "*.el" t)
             ("texi" "~/www/soft" "*.texi" nil)
             ("2ch" "~/navi2ch/html/" "*.html" sub)
             ("find2ch" "~/navi2ch/html/" "*.html" subfind)
             ))))

;;----------------------------------------------------------------------
;;51.7.1 grep の検索結果を直接編集する ― grep-edit (2010/07/22)
;;----------------------------------------------------------------------
(require 'grep-edit)

;;C-c C-e: 変更のみ適用
;;C-c C-u: 変更の破棄
;;C-c C-r: リージョン内の変更のみ破棄

;;----------------------------------------------------------------------
;;52.2.1 namazu で検索 ― namazu.el (2005/02/18)
;;----------------------------------------------------------------------
(setq namazu-search-num 100) ;; 1 ページに表示する結果数
(setq namazu-auto-turn-page t) 
(autoload 'namazu "namazu" nil t)
;; インデックスのディレクトリ
;; 複数あればスペースで区切る
(setq namazu-default-dir "~/Namazu/index")

(setq namazu-dir-alist 
  '(("mail" . "~/Namazu/index")))

;;----------------------------------------------------------------------
;;52.3 namazu.el の検索結果に色をつける ― color-namazu (2005/02/18)
;;----------------------------------------------------------------------
(load "color-namazu")

;;----------------------------------------------------------------------
;;55.4 URL をブラウザで開く ― browse-url (2003/05/24)
;;----------------------------------------------------------------------
;;(global-set-key [S-mouse-2] 'browse-url-at-mouse)
(if (eq system-type 'windows-nt)
    (lambda()
     (global-set-key "\C-c\C-j" 'browse-url-at-point)
     (setq browse-url-browser-function 'browse-url-firefox)
     (setq browse-url-firefox-program "C:\\Program Files\\Mozilla Firefox\\firefox.exe")
     ))


;; Visual Basic Mode
(autoload 'visual-basic-mode "visual-basic-mode" "Visual Basic mode." t)
(setq auto-mode-alist (append '(("\\.\\(frm\\|bas\\|cls\\|vbs\\|rss\\)$" . 
                                 visual-basic-mode)) auto-mode-alist))
(setq visual-basic-mode-indent 4)


;;----------------------------------------------------------------------
;;55.9 2ch ブラウザ ― navi2ch (2004/09/08)
;;----------------------------------------------------------------------
(autoload 'navi2ch "navi2ch" "Navigator for 2ch for Emacs" t)

;; 終了時に訪ねない
(setq navi2ch-ask-when-exit nil)
;; スレのデフォルト名を使う
(setq navi2ch-message-user-name "")
;; あぼーんがあったたき元のファイルは保存しない
(setq navi2ch-net-save-old-file-when-aborn nil)
;; 送信時に訪ねない
(setq navi2ch-message-ask-before-send nil)
;; kill するときに訪ねない
(setq navi2ch-message-ask-before-kill nil)
;; バッファは 5 つまで
(setq navi2ch-article-max-buffers 5)
;; navi2ch-article-max-buffers を超えたら古いバッファは消す
(setq navi2ch-article-auto-expunge t)
;; Board モードのレス数欄にレスの増加数を表示する。
(setq navi2ch-board-insert-subject-with-diff t)
;; Board モードのレス数欄にレスの未読数を表示する。
(setq navi2ch-board-insert-subject-with-unread t)
;; 既読スレはすべて表示
(setq navi2ch-article-exist-message-range '(1 . 1000))
;; 未読スレもすべて表示
(setq navi2ch-article-new-message-range '(1000 . 1))
;; 3 ペインモードでみる
;;(setq navi2ch-list-stay-list-window t)
;; C-c 2 で起動
;;(global-set-key "\C-c2" 'navi2ch)

(setq navi2ch-net-http-proxy "10.144.31.36:8080")
(setq navi2ch-display-splash-screen nil)



;; 適当
(defun camelize-region (start end)
  "Camelize word"
  (interactive "r")
  (save-excursion
    (capitalize-region start end)
    (goto-char start)
    (re-search-forward "[a-zA-Z]")
    (downcase-region (- (point) 1) (point))
    (replace-string "_" "" nil start end)))

(defun hiphenize-region (start end)
  "Hiphenize word"
  (interactive "r")
  (save-excursion
    (save-restriction
      (replace-regexp "\\([A-Z]\\)" "_\\1" nil start end)
      (upcase-region (point-min) (point-max)))))


