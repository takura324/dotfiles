;; package-install
;;   (list-packages)

;;;
;;;『Emacs 実践入門』
;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; キーバインド (pp.81)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 折り返しトグルコマンド
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;; C-t でウィンドウを切り替える（transpose-chars を無効）
(define-key global-map (kbd "C-t") 'other-window)

(define-key global-map [f9] 'japanese-zenkaku-region)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; パスの設定 (pp.83)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'exec-path "/usr/local/bin")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 文字コードの指定 (pp.85)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (describe-current-coding-system)
;; (set-language-environment "Japanese")
;; (prefer-coding-system 'utf-8)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ファイル名の扱い (pp.86)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mac OS X の場合のファイル名の設定
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))

;; Windows の場合のファイル名の設定
(when (eq system-type 'w32)
  (set-file-name-coding-system 'cp932)
  (setq locale-coding-system 'cp932))

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

;; 行番号を常に表示する
;; (global-linum-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 表示テーマ (pp.96)
;; (package-install 'color-theme)
;; (color-theme-select)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (require 'color-theme nil t)
  ;; テーマを読み込むための設定
  (color-theme-initialize)
  ;; テーマ deep-blue に変更する。
  ;;(color-theme-deep-blue)
  ;;(color-theme-word-perfect)
  ;;(color-theme-arjen)
  (color-theme-dark-laptop)
)

;;; P97-99 フォントの設定
(when (eq window-system 'ns)
  ;; asciiフォントをMenloに
  (set-face-attribute 'default nil
                      :family "Menlo"
                      :height 150)
  ;; 日本語フォントをヒラギノ明朝 Proに
  (set-fontset-font
   nil 'japanese-jisx0208
   ;; 英語名の場合
   ;; (font-spec :family "Hiragino Mincho Pro"))
   (font-spec :family "Hiragino Kaku Gothic Pro"))
   ;;(font-spec :family "ヒラギノ明朝 Pro"))
  ;; ひらがなとカタカナをモトヤシーダに
  ;; U+3000-303F    CJKの記号および句読点
  ;; U+3040-309F    ひらがな
  ;; U+30A0-30FF    カタカナ
  (set-fontset-font
   nil '(#x3040 . #x30ff)
   (font-spec :family "NfMotoyaCedar"))
  ;; フォントの横幅を調節する
  (setq face-font-rescale-alist
        '((".*Menlo.*" . 1.0)
          (".*Hiragino_Mincho_Pro.*" . 1.2)
          (".*Hiragino_.*Gothic_Pro.*" . 1.2)
          (".*nfmotoyacedar-bold.*" . 1.2)
          (".*nfmotoyacedar-medium.*" . 1.2)
          ("-cdac$" . 1.3))))


(when (eq system-type 'cygwin)
  ;; フォントをConsolasに
  (set-face-attribute 'default nil
                      :family "Consolas"
                      :height 108)

  ;; 日本語フォントをメイリオに
  (set-fontset-font
   nil
   'japanese-jisx0208
   (font-spec :family "MeiryoKe_Console"))
;;   (font-spec :family "メイリオ"))
;;   (font-spec :family "MS Gothic"))
  ;; フォントの横幅を調節する
  (setq face-font-rescale-alist
        '((".*Consolas.*" . 1.0)
          (".*メイリオ.*" . 1.15)
          (".*MS Gothic*" . 1.15)
          (".*MeiryoKe_Console*" . 1.08)
          ("-cdac$" . 1.3))))

;; | 数字 | アルファベット | 日本語     |
;; | 012  | abcdefghijklmn | こんにちは |



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; フック (pp.104)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ファイルが #! から始まる場合、+x をつけて保存する
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; emacs-lisp-mode 用
(defun elisp-mode-hooks()
  "lisp-mode-hooks"
  (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))

(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; auto-install (pp.110)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(package-install 'auto-install)

;; byte-compile
;; emacs -batch -f batch-byte-compile <file-path>
;; /Applications/Emacs.app/Contents/MacOS/Emacs ...

;; ;; auto-installの設定
;; (when (require 'auto-install nil t)     ; ←1●
;;   ;; 2●インストールディレクトリを設定する 初期値は ~/.emacs.d/auto-install/
;;   (setq auto-install-directory "~/.emacs.d/site-lisp/")
;;   ;; EmacsWikiに登録されているelisp の名前を取得する
;;   (auto-install-update-emacswiki-package-name t)
;;   ;; 必要であればプロキシの設定を行う
;;   ;; (setq url-proxy-services '(("http" . "localhost:8339")))
;;   ;; 3●install-elisp の関数を利用可能にする
;;   (auto-install-compatibility-setup)) ; 4●


;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
;; (package-install "redo+")
(when (require 'redo+ nil t)
  ;; C-' にリドゥを割り当てる
  ;;(global-set-key (kbd "C-'") 'redo)
  ;; 日本語キーボードの場合C-. などがよいかも
  (global-set-key (kbd "C-.") 'redo)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.2 統一したインタフェースでの操作                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P122-129 候補選択型インタフェース──Anything
;; (auto-install-batch "anything")
;;(require 'anything-startup)

(when (require 'anything nil t)
  (define-key global-map (kbd "C-;") 'anything)
  
  (setq
   ;; 候補を表示するまでの時間。デフォルトは0.5
   anything-idle-delay 0.3
   ;; タイプして再描写するまでの時間。デフォルトは0.1
   anything-input-idle-delay 0.5
   ;; 候補の最大表示数。デフォルトは50
   ;; anything-candidate-number-limit 100
   ;; 候補が多いときに体感速度を早くする
   ;;anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   ;; anything-enable-shortcuts 'alphabet
   anything-enable-shortcuts 't
   )

  (when (require 'anything-config nil t)
    ;; root権限でアクションを実行するときのコマンド
    ;; デフォルトは"su"
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
    ;; lispシンボルの補完候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnythingに置き換える
    (descbinds-anything-install)))


;;; P127-128 過去の履歴からペースト──anything-show-kill-ring
;; M-yにanything-show-kill-ringを割り当てる
(define-key global-map (kbd "M-y") 'anything-show-kill-ring)

;; ;;; P128-129 moccurを利用する──anything-c-moccur
(when (require 'anything-c-moccur nil t)
  (setq
   ;; anything-c-moccur用 `anything-idle-delay'
   anything-c-moccur-anything-idle-delay 0.1
   ;; バッファの情報をハイライトする
   anything-c-moccur-higligt-info-line-flag t
   ;; 現在選択中の候補の位置をほかのwindowに表示する
   anything-c-moccur-enable-auto-look-flag t
   ;; 起動時にポイントの位置の単語を初期パターンにする
   anything-c-moccur-enable-initial-pattern t)

  ;; キーバインドの割当(好みに合わせて設定してください)
  (global-set-key (kbd "M-o") 'anything-c-moccur-occur-by-moccur)
  (global-set-key (kbd "C-M-o") 'anything-c-moccur-dmoccur)
  (add-hook 'dired-mode-hook
            '(lambda ()
               (local-set-key (kbd "O") 'anything-c-moccur-dired-do-moccur-by-moccur)))
  (global-set-key (kbd "C-M-s") 'anything-c-moccur-isearch-forward)
  (global-set-key (kbd "C-M-r") 'anything-c-moccur-isearch-backward)

  (define-key anything-c-moccur-anything-map (kbd "<down>")  'anything-c-moccur-next-line)
  (define-key anything-c-moccur-anything-map (kbd "<up>")  'anything-c-moccur-previous-line)

)

;;;
;;; anything-bookmarksを利用する。
;;;
(define-key global-map "\C-xrl" 'anything-bookmarks)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.3 入力の効率化                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;; (package-install 'auto-complete)
;;; P130-131 利用可能にする
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
    "~/.emacs.d/site-lisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;;; P136 grepの結果を直接編集──wgrep
;; wgrepの設定
;; (package-install 'wgrep)
(require 'wgrep nil t)
;; C-c C-p   wgrep-change-to-wgrep-mode
;; C-c C-k   wgrep-abort-changes
;; C-c C-c   wgrep-finish-edit
;; M-x wgrep-save-all-buffers


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.5 さまざまな履歴管理                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P137-138 編集履歴を記憶する──undohist
;; (package-install 'undohist)
;; undohistの設定
(when (require 'undohist nil t)
  (undohist-initialize))

;;; P138 アンドゥの分岐履歴──undo-tree
;; (package-install 'undo-tree)
;; undo-treeの設定
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))


;;; P139-140 カーソルの移動履歴──point-undo
;; (package-install 'point-undo)
;; point-undoの設定
(when (require 'point-undo nil t)
  (define-key global-map [f5] 'point-undo)
  (define-key global-map [f6] 'point-redo)
  ;; 筆者のお勧めキーバインド
  (define-key global-map (kbd "M-[") 'point-undo)
  (define-key global-map (kbd "M-]") 'point-redo)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.6 ウィンドウ管理                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (package-install 'apel)
;; (package-install 'elscreen)
;;
;;; P141-143 ウィンドウの分割状態を管理──ElScreen
;; ElScreenのプレフィックスキーを変更する（初期値はC-z）
;; (setq elscreen-prefix-key (kbd "C-t"))

(when (or (eq system-type 'darwin))
  (when (require 'elscreen nil t)
    ;; C-z C-zをタイプした場合にデフォルトのC-zを利用する
    (if window-system
        (define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
      (define-key elscreen-map (kbd "C-z") 'suspend-emacs))
    (global-set-key (kbd "<C-tab>") 'elscreen-next))

  (defadvice elscreen-jump (around elscreen-last-command-char-event activate)
    (let ((last-command-char last-command-event))
      ad-do-it))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.8 特殊な範囲の編集                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P151 矩形編集──cua-mode
;; cua-modeの設定
(cua-mode t) ; cua-modeをオン
(setq cua-enable-cua-keys nil) ; CUAキーバインドを無効にする



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P169 コラム 便利なエイリアス
;; dtwをdelete-trailing-whitespaceのエイリアスにする
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defalias 'dtw 'delete-trailing-whitespace)

(defalias 'areg 'align-regexp)
;;(setq align-default-spacing 0)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ruby
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; http://blog.shibayu36.org/entry/2013/03/18/192651
;;
;; (package-install 'ruby-electric)
;; (package-install 'inf-ruby)
;; (package-install 'ruby-block)

;;; P172-173 Ruby編集用の便利なマイナーモード
;; 括弧の自動挿入──ruby-electric
(require 'ruby-electric nil t)
;; endに対応する行のハイライト──ruby-block
(when (require 'ruby-block nil t)
  (setq ruby-block-highlight-toggle t))

;; インタラクティブRubyを利用する──inf-ruby
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")

;; inf-ruby
(autoload 'inf-ruby "inf-ruby" "Run an inferior Ruby process" t)
(add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
;;   (eval-after-load 'inf-ruby
;;     '(define-key inf-ruby-minor-mode-map
;;        (kbd "C-c C-s") 'inf-ruby-console-auto))



;; ruby-mode-hook用の関数を定義
(defun ruby-mode-hooks ()
;;  (inf-ruby-keys)
  (ruby-electric-mode t)
  (ruby-block-mode t))
;; ruby-mode-hookに追加
(add-hook 'ruby-mode-hook 'ruby-mode-hooks)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cc-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c-mode-hooks ()
  '(lambda()
     (c-toggle-auto-newline t)
     ))

(add-hook 'c-mode--hook 'c-mode-hooks)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.2 Flymakeによる文法チェック                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'flymake nil t)

;;; P186 Ruby
;; Ruby用Flymakeの設定
(defun flymake-ruby-init ()
  (list "ruby" (list "-c" (flymake-init-create-temp-buffer-copy
                           'flymake-create-temp-inplace))))

(add-to-list 'flymake-allowed-file-name-masks
             '("\\.rb\\'" flymake-ruby-init))

(add-to-list 'flymake-err-line-patterns
             '("\\(.*\\):(\\([0-9]+\\)): \\(.*\\)" 1 2 nil 3))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.3 タグによるコードリーディング                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P189-190 gtagsとEmacsとの連携
;; gtags-modeのキーバインドを有効化する
;;(setq gtags-suggested-key-mapping t) ; 無効化する場合はコメントアウト
;;(require 'gtags nil t)


;;; P190-191 ctagsとEmacsとの連携
;; http://ctags.sourceforge.net/
;; (package-install "ctags")
;;

;;(install-elisp "https://raw.githubusercontent.com/jdhore/emacs.d/master/elpa/ctags-1.1.1/ctags.el")

;; ctags.elの設定
(require 'ctags nil t)
(setq tags-revert-without-query t)
;; ctagsを呼び出すコマンドライン。パスが通っていればフルパスでなくてもよい
;; etags互換タグを利用する場合はコメントを外す
;; (setq ctags-command "ctags -e -R ")
;; anything-exuberant-ctags.elを利用しない場合はコメントアウトする
;;(setq ctags-command "/usr/local/bin/ctags -R --fields=\"+afikKlmnsSzt\" ")
(setq ctags-command "ctags -R --fields=\"+afikKlmnsSzt\" ")
(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P192-193 Anythingとタグの連携
;;
;; (package-install 'anything-exuberant-ctags)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; AnythingからTAGSを利用しやすくするコマンド作成
;;(when (and (require 'anything-exuberant-ctags nil t)
;;           (require 'anything-gtags nil t))
(when (require 'anything-exuberant-ctags nil t)
  ;; anything-for-tags用のソースを定義
  (setq anything-for-tags
        (list anything-c-source-imenu
              ;;anything-c-source-gtags-select
              ;; etagsを利用する場合はコメントを外す
              ;; anything-c-source-etags-select
              anything-c-source-exuberant-ctags-select
              ))

  ;; anything-for-tagsコマンドを作成
  (defun anything-for-tags ()
    "Preconfigured `anything' for anything-for-tags."
    (interactive)
    (anything anything-for-tags
              (thing-at-point 'symbol)
              nil nil nil "*anything for tags*"))

  ;; M-tにanything-for-currentを割り当て
  (define-key global-map (kbd "M-t") 'anything-for-tags)
  (global-set-key "\M-." 'anything-for-tags)

  ;; 飛んだあと元の場所に戻りたい場合は"C-u C-SPC"です．
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; key-combo
;; (package-install 'key-combo)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'key-combo)
;; (key-combo-load-default)

(add-hook 'haskell-mode-hook
          '(lambda ()
             (key-combo-mode)
             (key-combo-define-local (kbd "-") '("-" " -> " "-- "))
             (key-combo-define-local (kbd "<") '("<" " <- " " <= " " =<< " "<<" "<"))
             (key-combo-define-local (kbd ">") '(">" " >= " " >>= " ">>"))
             (key-combo-define-local (kbd "=") '(" = " " == " "=="))
             (key-combo-define-local (kbd "=>") " => ")
             (key-combo-define-local (kbd ":") '(":" " :: " "::"))
             ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; whitespace
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq whitespace-style
;;       '(tabs tab-mark spaces space-mark))
;; (setq whitespace-space-regexp "\\(\x3000+\\)")
;; (setq whitespace-display-mappings
;;       '((space-mark ?\x3000 [?\□])
;;         (tab-mark   ?\t   [?\xBB ?\t])
;;         ))
;; (require 'whitespace)
;; (global-whitespace-mode 1)
;; (set-face-foreground 'whitespace-space "LightSlateGray")
;; (set-face-background 'whitespace-space "DarkSlateGray")
;; (set-face-foreground 'whitespace-tab "LightSlateGray")
;; (set-face-background 'whitespace-tab "DarkSlateGray")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P218 Git
;;
;;(package-install 'egg)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (executable-find "git")
  (require 'egg nil t))

;; usage
;;   C-x v s (egg-staus)
;;   C-x v l (egg-log)

