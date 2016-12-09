;; ウィンドウサイズ変更
(when (>= (display-pixel-height) 1080)
  (setq default-frame-alist
        (append '((width                . 120) ; フレーム幅
                  (height               . 56 ) ; フレーム高
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
  (setq initial-frame-alist default-frame-alist))

