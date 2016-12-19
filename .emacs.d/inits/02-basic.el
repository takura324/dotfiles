;;----------------------------------------------------------------------
;; bind-key
;;
;; http://emacs.rubikitch.com/bind-key/
;;----------------------------------------------------------------------
;;(package-install 'bind-key)
;;
;; <sample>
;;
;; (global-set-key (kbd "C-c x") 'my-ctrl-c-x-command)
;; ↓
;; (bind-key "C-c x" 'my-ctrl-c-x-command)
;;
;; (define-key some-other-mode-map (kbd "C-c x") 'my-ctrl-c-x-command)
;; ↓
;; (bind-key "C-c x" 'my-ctrl-c-x-command some-other-mode-map)
;;
;; (define-key dired-mode-map "o" 'dired-omit-mode)
;; (define-key dired-mode-map "a" 'some-other-mode-map)
;; ↓
;; (bind-keys :map dired-mode-map
;;            ("o" . dired-omit-mode)
;;            ("a" . some-custom-dired-function))
;;
;; (describe-personal-keybindings)
(require 'bind-key)

;;; 同じ内容を履歴に記録しないようにする
(setq history-delete-duplicates t)

;;; ファイルを開いた位置を保存する
;; (require 'saveplace)
;; (setq-default save-place t)
(save-place-mode 1)
;;(setq save-place-file (concat user-emacs-directory "places"))

;;; ミニバッファ履歴を次回Emacs起動時にも保存する
(savehist-mode 1)

;;; ログの記録行数を増やす
(setq message-log-max 10000)
;;; 履歴をたくさん保存する
(setq history-length 1000)

;;----------------------------------------------------------------------
;; Emacsからの質問をy/nで回答する
;;----------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)

;;----------------------------------------------------------------------
;;キー設定
;;----------------------------------------------------------------------
;; C-h を backspace にする
(keyboard-translate ?\C-h ?\C-?)

(bind-key "C-x ?" 'help-command)

;; C-x j  で指定行へ移動
(bind-key "C-x j" 'goto-line)

;; 改行キーでオートインデント
(bind-key "\C-m" 'newline-and-indent)
(setq indent-line-function 'indent-relative-maybe) ;;インデント方法. お好みで. . .

;; 折り返しトグルコマンド
(bind-key "C-c l" 'toggle-truncate-lines)

;; C-t でウィンドウを切り替える（transpose-chars を無効）
(bind-key "C-t" 'other-window)

;;(bind-key [f9] 'japanese-zenkaku-region)

(bind-key "<home>" 'beginning-of-buffer)
(bind-key "<end>" 'end-of-buffer)

;;(global-set-key (kbd "C-@") 'dabbrev-expand)
;;(global-set-key "\C-z" 'undo)
(global-unset-key "\C-z")
(global-unset-key (kbd "C-x i"))

;;----------------------------------------------------------------------
;;キー同時押し
;;----------------------------------------------------------------------
;;(package-install 'key-chord)
(require 'key-chord)
;;; タイムラグを設定
(setq key-chord-two-keys-delay 0.04)
(setq key-chord-one-key-delay 0.15)
(key-chord-mode 1)

(key-chord-define-global "jk" 'view-mode)
(key-chord-define-global "fd" 'ff-find-other-file)

;;----------------------------------------------------------------------
;; which-key.el : 【guide-key改】次のキー操作をよりわかりやすく教えてくれるぞ！
;;
;; http://emacs.rubikitch.com/which-key/
;;----------------------------------------------------------------------
;;(package-install 'which-key)

;;; 3つの表示方法どれか1つ選ぶ
(which-key-setup-side-window-bottom)    ;ミニバッファ
;;(which-key-setup-side-window-right)     ;右端
;;(which-key-setup-side-window-right-bottom) ;両方使う

(which-key-mode 1)

;; ;;----------------------------------------------------------------------
;; ;;同一ファイル名のバッファ名を分かりやすく — uniquify
;; ;;----------------------------------------------------------------------
;; (require 'uniquify)
;; (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;; ;;(setq uniquify-ignore-buffers-re "*[^*]+*")

;;--------------------------------------------------------------------------------
;; popwin
;;--------------------------------------------------------------------------------
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(bind-key "C-z" 'popwin:keymap)

(add-to-list 'popwin:special-display-config "*trace-output*")
(add-to-list 'popwin:special-display-config "*xref*")

