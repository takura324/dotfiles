;;----------------------------------------
;; Win32: dired からエクスプローラを開く
;;----------------------------------------
;; dired で "E" で開く。
(add-hook 'dired-mode-hook
          (lambda ()
            (local-set-key "E" 'dired-exec-explorer)))

(defun dired-exec-explorer ()
  "In dired, execute Explorer"
  (interactive)
  (explorer (dired-current-directory)))

(defun explorer (&optional path)
  "引数があればそのパスの、引数が省略されていれば現在のバッファのファイルを、explorerで開きます。"
  (interactive)
  (setq path (expand-file-name (or path (file-name-directory (buffer-file-name)))))
  (cond
    ((not (file-exists-p path))
     (message "path %s isn't exist" path))
    (t
     (let ((dos-path (replace-regexp-in-string "/" "\\\\" path)))
       (message dos-path)
       (w32-shell-execute "open" "explorer.exe" (concat "/e," dos-path))))))

(defun cmdprompt (&optional path)
  "コマンドプロンプトを開きます。"
  (interactive)
  (setq path (expand-file-name (or path (file-name-directory (buffer-file-name)))))
  (cond
    ((not (file-exists-p path))
     (message "path %s isn't exist" path))
    (t
     (let ((dos-path (replace-regexp-in-string "/" "\\\\" path)))
       (message dos-path)
       (w32-shell-execute "open" "cmd.exe" (concat "/k cd " dos-path))))))

;;----------------------------------------------------------------
;; カレントバッファのファイルをWindows標準コマンドで開く
;;----------------------------------------------------------------
(defun w32-shell-execute-open-current-buffer-file ()
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (file-exists-p filename)
        (w32-shell-execute "open" filename nil 1))
    ))

