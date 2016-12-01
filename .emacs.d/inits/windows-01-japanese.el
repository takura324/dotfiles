;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IME 設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; モードラインの表示文字列
(setq-default w32-ime-mode-line-state-indicator "[Aa] ")
(setq w32-ime-mode-line-state-indicator-list '("[Aa]" "[あ]" "[Aa]"))

;; IME初期化
(w32-ime-initialize)

;; デフォルトIME
(setq default-input-method "W32-IME")

;; ;; IME変更
;; (global-set-key (kbd "C-\\") 'toggle-input-method)

;; ;; 漢字/変換キー入力時のエラーメッセージ抑止
;; ;;(global-set-key (kbd "<M-kanji>") 'ignore)
;; ;;(global-set-key (kbd "<kanji>") 'ignore)

;; Altキーを使用せずにMetaキーを使用
(setq w32-alt-is-meta t)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フォント設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
        ("-cdac$" . 1.3)))

;; | 数字 | アルファベット | 日本語     |
;; | 012  | abcdefghijklmn | こんにちは |

