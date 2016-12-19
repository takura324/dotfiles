(require 'bind-key)

;;----------------------------------------------------------------------
;;タブ幅の設定
;;----------------------------------------------------------------------
;;タブ幅を 4 に設定
(setq-default tab-width 4)
;;タブ幅の倍数を設定
(setq tab-stop-list
  '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
;;タブではなくスペースを使う
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe)


;;----------------------------------------------------------------------
;;便利に編集するための設定
;;----------------------------------------------------------------------
(show-paren-mode)

;; リージョンを上書きできるようにする。
(delete-selection-mode t)

;; ファイルの更新を監視する。
(global-auto-revert-mode 1)

;;----------------------------------------------------------------------
;;一行まるごとカット
;;----------------------------------------------------------------------
(setq kill-whole-line t)

;;--------------------------------------------------------------------------------
;; hippie-expand
;;
;; http://emacs.rubikitch.com/sd1409-migemo-ace-jump-mode-dabbrev/
;;--------------------------------------------------------------------------------
(bind-key "C-@" 'hippie-expand)

(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill))

;;----------------------------------------------------------------------
;; 便利なエイリアス
;; dtwをdelete-trailing-whitespaceのエイリアスにする
;;----------------------------------------------------------------------
(defalias 'dtw 'delete-trailing-whitespace)

(defalias 'areg 'align-regexp)
;;(setq align-default-spacing 0)


;; ;;----------------------------------------------------------------------
;; ;; 貼り付けのカスタマイズ
;; ;;----------------------------------------------------------------------
;; ;;貼り付けの拡張 — browse-kill-ring
;; ;;----------------------------------------------------------------------
;; (require 'browse-kill-ring)
;; (bind-key "\M-y" 'browse-kill-ring)

;; ;; kill-ring の内容を表示する際の区切りを指定する
;; (setq browse-kill-ring-separator "-------")
;; ;; 現在選択中の kill-ring のハイライトする
;; (setq browse-kill-ring-highlight-current-entry t)


;;----------------------------------------------------------------------
;; アンドゥの分岐履歴──undo-tree
;;----------------------------------------------------------------------
;; (package-install 'undo-tree)
;; undo-treeの設定
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))


;;----------------------------------------------------------------------
;; やり直し — redo
;;----------------------------------------------------------------------
(require 'redo+)
(bind-key "\M-]" 'redo)


;;----------------------------------------------------------------------
;;; カーソルの移動履歴──point-undo
;;----------------------------------------------------------------------
;; (package-install 'point-undo)
;; point-undoの設定
(when (require 'point-undo nil t)
  (bind-key "<f7>" 'point-undo global-map)
  (bind-key "M-<f7>" 'point-redo global-map)
  )

;;----------------------------------------------------------------------
;; goto-chg: 編集箇所の履歴をたどる
;; http://emacs.rubikitch.com/sd1501-packages/
;;----------------------------------------------------------------------
(when (require 'goto-chg)
  (bind-key "<f8>" 'goto-last-change)
  (bind-key "M-<f8>" 'goto-last-change-reverse)
  )

;;----------------------------------------------------------------------
;; bm: 現在位置をハイライト付きで永続的に記憶させる
;; http://emacs.rubikitch.com/sd1501-packages/
;;----------------------------------------------------------------------
(setq-default bm-buffer-persistence nil)
(setq bm-restore-repository-on-load t)
(when (require 'bm)
  (add-hook 'find-file-hook 'bm-buffer-restore)
  (add-hook 'kill-buffer-hook 'bm-buffer-save)
  (add-hook 'after-save-hook 'bm-buffer-save)
  (add-hook 'after-revert-hook 'bm-buffer-restore)
  (add-hook 'vc-before-checkin-hook 'bm-buffer-save)
  (add-hook 'kill-emacs-hook '(lambda nil
                                (bm-buffer-save-all)
                                (bm-repository-save)))
  (bind-key "M-SPC" 'bm-toggle)
  (bind-key "M-[" 'bm-previous)
  (bind-key "M-]" 'bm-next)
)

;;----------------------------------------------------------------------
;; mark-ring
;; http://emacs.rubikitch.com/set-mark-command-repeat-pop/
;;  \C-u \C-SPC で戻る
;;  下記設定で、\C-u \C-SPC \C-SPC \C-SPC ... の連打が可能
;;----------------------------------------------------------------------
(setq set-mark-command-repeat-pop t)


;;----------------------------------------------------------------------
;; 適当
;;----------------------------------------------------------------------
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

(defun escape-win-path (start end)
  "windows のパス文字列をエスケープする（C言語用）"
  (interactive "r")
  (save-excursion
    (when (/= (char-after start) ?\")
      (if (search-backward "\"" nil t)
          (setq start (point))        ))
    (when (or (/= (char-before end) ?\")
              (= start end))
      (if (search-forward "\"")
          (setq end (point))))

    (if (and start end)
        (replace-regexp "\\\\" "\\\\\\\\" nil start end))
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; モードライン
;; リージョン内の行数と文字数をモードラインに表示する (pp.89)
;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines,%d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
    ;; これだとエコーエリアがチラつく
    ;;(count-lines-region (region-beginning) (region-end))
    ""))

(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 入力の効率化
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (package-install 'auto-complete)
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
               "~/.emacs.d/elisp/ac-dict")
  (bind-key "M-TAB" 'auto-complete ac-mode-map)
  (ac-config-default))

;; M-p M-n で候補を選択

;; 全てのバッファで共通の設定
;; * ファイル名補完を追加
(setq-default ac-sources (cons 'ac-source-filename ac-sources))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 矩形編集──cua-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cua-modeの設定
(cua-mode t)
(setq cua-enable-cua-keys nil)
;;(setq cua-rectangle-mark-key "<M-return>")

;; Ctrl-Enter

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; visual-regexp: 正規表現置換を対話的に行う
;; http://emacs.rubikitch.com/sd1501-packages/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (require 'visual-regexp)
  (require 'visual-regexp-steroids)
  (setq vr/engine 'pcre2el)
  (bind-key "M-%" 'vr/query-replace)
  ;;(bind-key "C-j" 'skk-insert vr/minibuffer-keymap)
  )


;;;-----------------------------------------------------------------------------
;;; re-builder
;;;-----------------------------------------------------------------------------
;; C-c C-i で正規表現の文法を設定
;; C-c C-w でキルリングに入れる
;; C-c C-q で終了

;;;-----------------------------------------------------------------------------
;;; pcre2el
;;;-----------------------------------------------------------------------------

;; M-x rxt-mode でRegular eXpression Translationマイナーモードを
;; 有効にすると、以下のコマンドが使えます。
;; C-c / /     rxt-explain 正規表現を解説
;; C-c / c     rxt-convert-syntax Emacs/PCRE間の変換し、kill-ringへ
;; C-c / x     rxt-convert-to-rx rxへの変換
;; C-c / ′     rxt-convert-to-strings 文字列集合へ分解


;;-----------------------------------------------------------------------------
;; mwim.el : コードの先頭・末尾を認識したC-a/C-eを定義する
;;
;; http://emacs.rubikitch.com/mwim/
;;-----------------------------------------------------------------------------
;;(package-install 'mwim)

(bind-key "C-a" 'mwim-beginning-of-code-or-line)
(bind-key "C-e" 'mwim-end-of-code-or-line)
;; (bind-key "C-a" 'mwim-beginning-of-line-or-code)
;; (bind-key "C-e" 'mwim-end-of-line-or-code)
