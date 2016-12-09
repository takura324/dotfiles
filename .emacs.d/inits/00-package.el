;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; package.elの設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)

;; Add package-archives
;;(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; MELPA-stableを追加
;;(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
;; Marmaladeを追加
;;(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/") t)
;; Orgを追加
;;(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

;;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

(package-initialize)

; Initialize
;;(package-initialize)

;; (progn
;;   (switch-to-buffer
;;    (url-retrieve-synchronously
;;     "https://raw.github.com/milkypostman/melpa/master/melpa.el"))
;;   (package-install-from-buffer  (package-buffer-info) 'single))

; melpa.el
;; (require 'melpa)


;;--------------------------------------
;; how to install or upgrade package
;;--------------------------------------
;; M-x package-install helm-swoop
;; M-x package-install package-utils (初めてアップグレードする場合のみ)
;; M-x package-utils-upgrade-by-name helm-swoop


(require 'auto-install)
