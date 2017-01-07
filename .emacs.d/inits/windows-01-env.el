;; ウィンドウサイズ変更
(when (>= (display-pixel-height) 1080)
  (setq default-frame-alist
        (append '((width                . 120) ; フレーム幅
                  (height               . 56 ) ; フレーム高
;;                  (height               . 43 ) ; フレーム高
                  (left                 . 10 ) ; 配置左位置
                  (top                  . 10 ) ; 配置上位置
                  (line-spacing         . 0  ) ; 文字間隔
                  (left-fringe          . 10 ) ; 左フリンジ幅
                  (right-fringe         . 11 ) ; 右フリンジ幅
                  (menu-bar-lines       . 1  ) ; メニューバー
                  (tool-bar-lines       . 0  ) ; ツールバー
                  (vertical-scroll-bars . 1  ) ; スクロールバー
                  (scroll-bar-width     . 17 ) ; スクロールバー幅
                  (cursor-type          . box) ; カーソル種別
                  (alpha                . 100) ; 透明度
                  (cursor-color         . "snow") 
                  (cursor-type          . box)
                  ) default-frame-alist) )

  (when (string-equal system-name "TAKURA-NOTE")
    (add-to-list 'default-frame-alist
                 '(height . 43)      ; フレーム高
                 )) 
  
  (setq initial-frame-alist default-frame-alist))

;;----------------------------------------------------------------
;;; @ language - coding system                                      ;;;
;;----------------------------------------------------------------

;; (describe-current-coding-system)
;; (set-language-environment "Japanese")
;;(prefer-coding-system 'utf-8-unix)

;; ;; デフォルトの文字コード
;;(set-default-coding-systems 'utf-8-unix)

;; ;; テキストファイル／新規バッファの文字コード
;;(prefer-coding-system 'utf-8-unix)

;; ;; ファイル名の文字コード
(set-file-name-coding-system 'shift_jis)

;; ;; キーボード入力の文字コード
;; (set-keyboard-coding-system 'utf-8-unix)

;; ;; サブプロセスのデフォルト文字コード
(setq default-process-coding-system '(undecided-dos . utf-8-unix))

;; ;;(setq default-process-coding-system '(undecided-dos . undecided-dos))
;; ;;(setq default-process-coding-system '(sjis-dos . utf-8-unix))

