;; python-mode
;;(package-install 'python-mode)
(require 'python-mode)
(setq py-shell-name "d:/Anaconda3/python")

;; PyChecker
(setq py-pychecker-command "pychecker.bat")

;; IPython
(setq py-ipython-command-args "-i d:/Anaconda3/Scripts/ipython-script.py console --pylab=qt")

;;----------------------------------------------------------------------
;; elpy
;;----------------------------------------------------------------------
;; (elpy-enable)

;; (elpy-use-ipython)
;; (setq elpy-rpc-backend "jedi")

;; (setq python-shell-interpreter "D:\\Anaconda3\\python.exe"
;;        python-shell-interpreter-args
;;        "-i D:\\Anaconda3\\Scripts\\ipython-script.py console --pylab=qt")


