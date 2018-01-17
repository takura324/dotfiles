;; python-mode
;;(package-install 'python-mode)

;; pip
;; # pip install pep8
;; # pip install pyflakes
;; # pip install flake8
;; # pip install pylint

;; conda
;; # conda list

;;----------------------------------------------------------------------
;; Anaconda mode
;;----------------------------------------------------------------------
;;(package-install 'anaconda-mode)

;;----------------------------------------------------------------------
;; Flymake
;;----------------------------------------------------------------------
;;(package-install 'flymake-python-pyflakes)
(require 'flymake-python-pyflakes)
(add-hook 'python-mode-hook 'flymake-python-pyflakes-load)
(setq flymake-python-pyflakes-executable "pep8")
;;(setq flymake-python-pyflakes-extra-arguments '("--ignore=E501"))

(defun python-mode-hooks ()
  (electric-pair-mode 1)
  (local-set-key "\C-c\C-v" 'flymake-start-syntax-check)
  (local-set-key "\C-c\C-p" 'flymake-goto-prev-error)
  (local-set-key "\C-c\C-n" 'flymake-goto-next-error))
(add-hook 'python-mode-hook 'python-mode-hooks)


;;----------------------------------------------------------------------
;; autopep8
;;----------------------------------------------------------------------
;;(package-install 'py-autopep8)
;; # pip install autopep8
(require 'py-autopep8)
(setq py-autopep8-options '("--max-line-length=200"))
(setq flycheck-flake8-maximum-line-length 200)

;; (defun python-mode-hooks-autopep8 ()
;;   (py-autopep8-enable-on-save))
;; (add-hook 'python-mode-hook 'python-mode-hooks-autopep8)

;;(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)


;;----------------------------------------------------------------------
;; jedi
;;----------------------------------------------------------------------
;;(package-install 'jedi)
(require 'epc)
(require 'auto-complete-config)
(require 'python-mode)

;;(jedi:install-server)

;;;;; PYTHONPATH上のソースコードがauto-completeの補完対象になる ;;;;;
(setenv "PYTHONPATH" "D:/anaconda3/lib/site-packages")
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)


;;; Misc
(setq py-keep-windows-configuration t)
(bind-key "S-<f8>" 'py-autopep8 python-mode-map)
