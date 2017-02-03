(require 'bind-key)

(setq line-move-visual nil)

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
;;全角スペースとタブを表示
;;----------------------------------------------------------------------
(setq whitespace-style
      '(tabs tab-mark spaces space-mark))
(setq whitespace-space-regexp "\\(\x3000+\\)")
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□])
        (tab-mark   ?\t   [?\xBB ?\t])
        ))
(require 'whitespace)
(global-whitespace-mode 1)
(set-face-foreground 'whitespace-space "LightSlateGray")
(set-face-background 'whitespace-space "DarkSlateGray")
(set-face-foreground 'whitespace-tab "LightSlateGray")
(set-face-background 'whitespace-tab "DarkSlateGray")

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
(defalias 'ffo 'ff-find-other-file)
(bind-key "<f12>" 'ff-find-other-file)

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
(setq mark-ring-max 32)

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

;;----------------------------------------------------------------------
;; モードライン
;; リージョン内の行数と文字数をモードラインに表示する (pp.89)
;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
;;----------------------------------------------------------------------

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



;;----------------------------------------------------------------------
;; 入力の効率化
;;----------------------------------------------------------------------

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

;;----------------------------------------------------------------------
;; 矩形編集──cua-mode
;;----------------------------------------------------------------------

;; cua-modeの設定
(cua-mode t)
(setq cua-enable-cua-keys nil)
;;(setq cua-rectangle-mark-key "<M-return>")

;; Ctrl-Enter

;;----------------------------------------------------------------------
;; visual-regexp: 正規表現置換を対話的に行う
;; http://emacs.rubikitch.com/sd1501-packages/
;;----------------------------------------------------------------------

(when (require 'visual-regexp)
  (require 'visual-regexp-steroids)
  (setq vr/engine 'pcre2el)
  (bind-key "C-M-%" 'vr/query-replace)
  ;;(bind-key "C-j" 'skk-insert vr/minibuffer-keymap)
  )

;;----------------------------------------------------------------------
;; ez-query-replace.el : 【置換】ちょっと賢くなったM-x query-replace (C-M-%)
;;----------------------------------------------------------------------
;;(package-install 'ez-query-replace)
(require 'ez-query-replace)
(defun my-ez-query-replace (repeat)
  (interactive "P")
  (funcall (if repeat 'ez-query-replace-repeat 'ez-query-replace)))
(bind-key "M-%" 'my-ez-query-replace)

;;----------------------------------------------------------------------
;; re-builder
;;----------------------------------------------------------------------
;; C-c C-i で正規表現の文法を設定
;; C-c C-w でキルリングに入れる
;; C-c C-q で終了

;;----------------------------------------------------------------------
;; pcre2el
;;----------------------------------------------------------------------

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
(require 'mwim)
(bind-key "C-a" 'mwim-beginning-of-code-or-line)
(bind-key "C-e" 'mwim-end-of-code-or-line)
;; (bind-key "C-a" 'mwim-beginning-of-line-or-code)
;; (bind-key "C-e" 'mwim-end-of-line-or-code)


;;-----------------------------------------------------------------------------
;; diffview
;;-----------------------------------------------------------------------------
;;(package-install 'diffview)
(require 'diffview)
(defun diffview-dwim ()
  (interactive)
  (if (region-active-p)
      (diffview-region)
    (diffview-current)))

;; M-x diffview-current はカレントバッファ全体、
;; M-x diffview-region はregionをside by sideで表示します、

(setq ediff-split-window-function 'split-window-vertically)

;;-----------------------------------------------------------------------------
;; paren-completer.el :
;; 自動判別で対応する閉括弧を入力する
;;-----------------------------------------------------------------------------
;;(package-install 'paren-completer)
(require 'paren-completer)
(bind-key "M-)" 'paren-completer-add-single-delimiter)

;;-----------------------------------------------------------------------------
;; shrink-whitespace.el :
;; 【M-＼拡張】カーソル周りの複数のホワイトスペースを1つ→除去する
;;-----------------------------------------------------------------------------
;;(package-install 'shrink-whitespace)
(require 'shrink-whitespace)
(bind-key "M-\\" 'shrink-whitespace)


;; ;;-----------------------------------------------------------------------------
;; ;; smart-newline.el :
;; ;; 改行の入力方法(C-o, C-j, C-mなど)をRETに統一する
;; ;;-----------------------------------------------------------------------------
;; ;;(package-install 'smart-newline)
;; (require 'smart-newline)

;; (bind-key (kbd "C-m") 'smart-newline)
;; (add-hook 'ruby-mode-hook 'smart-newline-mode)
;; (add-hook 'emacs-lisp-mode-hook 'smart-newline-mode)
;; (add-hook 'org-mode-hook 'smart-newline-mode)
;; (add-hook 'c-mode-common-hook 'smart-newline-mode)

;; (defadvice smart-newline (around C-u activate)
;;   "C-uを押したら元のC-mの挙動をするようにした。
;; org-modeなどで活用。"
;;   (if (not current-prefix-arg)
;;       ad-do-it
;;     (let (current-prefix-arg)
;;       (let (smart-newline-mode)
;;         (call-interactively (key-binding (kbd "C-m")))))))

;;-----------------------------------------------------------------------------
;; electric-operator.el :
;; 【改良版】演算子(=や+=)の前後に自動でスペースを入れる
;;-----------------------------------------------------------------------------
;;(package-install 'electric-operator)
(require 'electric-operator)

;;; ruby-modeの場合、===の設定が必要
(electric-operator-add-rules-for-mode
 'ruby-mode
 (cons "===" " === "))

;;; 使うメジャーモードごとにフックを設定しよう
(add-hook 'ruby-mode-hook #'electric-operator-mode)
(add-hook 'c-mode-common-hook #'electric-operator-mode)
(add-hook 'python-mode-hook #'electric-operator-mode)
