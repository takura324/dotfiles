;;----------------------------------------------------------------------
;; occurの基本機能 - バッファの検索 
;;----------------------------------------------------------------------
;;     * C-c C-c や RET：バッファのその行へジャンプ
;;     * C-c C-f：現在の一致箇所を別ウィンドウに表示
;;     * C-o：別ウィンドウに該当箇所を表示
;;     * M-p：前の一致箇所へ
;;     * M-n：次の一致箇所へ
;;     * r：バッファ名を変更


;;----------------------------------------------------------------------
;; occur の結果で keep-line 
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
;; 検索に一致した行の一括削除 
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
;; すべてのバッファ/ファイルに occur / grep を ― color-moccur 
;;----------------------------------------------------------------------
;; color-moccur のインストール 
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
;; color-moccur によるバッファ検索 
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
;; dmoccur によるディレクトリ下検索 
;;----------------------------------------------------------------------
;; M-x dmoccur
;; M-x clean-dmoccur-buffers


;;----------------------------------------------------------------------
;; dmoccur で指定ディレクトリを検索
;;----------------------------------------------------------------------
(setq dmoccur-list
      '(
        ("inits" "~/.emacs.d/inits" ("\\.el$") nil)
        ("junk" "~/memo/junk" ("\\.el$") nil)
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
;; color-moccur で occur を代替 
;;----------------------------------------------------------------------
;; M-x occur-by-moccur

;;----------------------------------------------------------------------
;; isearch の単語で occur を実行 
;;----------------------------------------------------------------------
;; C-s で検索中に，M-o とします．


;;----------------------------------------------------------------------
;; すべてのバッファを検索し，編集したい ― moccur-edit 
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
