;; package-install
;;   (list-packages)

;;;
;;;�wEmacs ���H����x
;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �L�[�o�C���h (pp.81)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; �܂�Ԃ��g�O���R�}���h
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;; C-t �ŃE�B���h�E��؂�ւ���itranspose-chars �𖳌��j
(define-key global-map (kbd "C-t") 'other-window)

(define-key global-map [f9] 'japanese-zenkaku-region)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �p�X�̐ݒ� (pp.83)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'exec-path "/usr/local/bin")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �����R�[�h�̎w�� (pp.85)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (describe-current-coding-system)
;; (set-language-environment "Japanese")
;; (prefer-coding-system 'utf-8)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; �t�@�C�����̈��� (pp.86)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mac OS X �̏ꍇ�̃t�@�C�����̐ݒ�
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))

;; Windows �̏ꍇ�̃t�@�C�����̐ݒ�
(when (eq system-type 'w32)
  (set-file-name-coding-system 'cp932)
  (setq locale-coding-system 'cp932))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���[�h���C��
;; ���[�W�������̍s���ƕ����������[�h���C���ɕ\������ (pp.89)
;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines,%d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
    ;; ���ꂾ�ƃG�R�[�G���A���`����
    ;;(count-lines-region (region-beginning) (region-end))
    ""))

(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))

;; �s�ԍ�����ɕ\������
;; (global-linum-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �\���e�[�} (pp.96)
;; (package-install 'color-theme)
;; (color-theme-select)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (require 'color-theme nil t)
  ;; �e�[�}��ǂݍ��ނ��߂̐ݒ�
  (color-theme-initialize)
  ;; �e�[�} deep-blue �ɕύX����B
  ;;(color-theme-deep-blue)
  ;;(color-theme-word-perfect)
  ;;(color-theme-arjen)
  (color-theme-dark-laptop)
)

;;; P97-99 �t�H���g�̐ݒ�
(when (eq window-system 'ns)
  ;; ascii�t�H���g��Menlo��
  (set-face-attribute 'default nil
                      :family "Menlo"
                      :height 150)
  ;; ���{��t�H���g���q���M�m���� Pro��
  (set-fontset-font
   nil 'japanese-jisx0208
   ;; �p�ꖼ�̏ꍇ
   ;; (font-spec :family "Hiragino Mincho Pro"))
   (font-spec :family "Hiragino Kaku Gothic Pro"))
   ;;(font-spec :family "�q���M�m���� Pro"))
  ;; �Ђ炪�ȂƃJ�^�J�i�����g���V�[�_��
  ;; U+3000-303F    CJK�̋L������ы�Ǔ_
  ;; U+3040-309F    �Ђ炪��
  ;; U+30A0-30FF    �J�^�J�i
  (set-fontset-font
   nil '(#x3040 . #x30ff)
   (font-spec :family "NfMotoyaCedar"))
  ;; �t�H���g�̉����𒲐߂���
  (setq face-font-rescale-alist
        '((".*Menlo.*" . 1.0)
          (".*Hiragino_Mincho_Pro.*" . 1.2)
          (".*Hiragino_.*Gothic_Pro.*" . 1.2)
          (".*nfmotoyacedar-bold.*" . 1.2)
          (".*nfmotoyacedar-medium.*" . 1.2)
          ("-cdac$" . 1.3))))


(when (eq system-type 'cygwin)
  ;; �t�H���g��Consolas��
  (set-face-attribute 'default nil
                      :family "Consolas"
                      :height 108)

  ;; ���{��t�H���g�����C���I��
  (set-fontset-font
   nil
   'japanese-jisx0208
   (font-spec :family "MeiryoKe_Console"))
;;   (font-spec :family "���C���I"))
;;   (font-spec :family "MS Gothic"))
  ;; �t�H���g�̉����𒲐߂���
  (setq face-font-rescale-alist
        '((".*Consolas.*" . 1.0)
          (".*���C���I.*" . 1.15)
          (".*MS Gothic*" . 1.15)
          (".*MeiryoKe_Console*" . 1.08)
          ("-cdac$" . 1.3))))

;; | ���� | �A���t�@�x�b�g | ���{��     |
;; | 012  | abcdefghijklmn | ����ɂ��� |



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �t�b�N (pp.104)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; �t�@�C���� #! ����n�܂�ꍇ�A+x �����ĕۑ�����
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; emacs-lisp-mode �p
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

;; ;; auto-install�̐ݒ�
;; (when (require 'auto-install nil t)     ; ��1��
;;   ;; 2���C���X�g�[���f�B���N�g����ݒ肷�� �����l�� ~/.emacs.d/auto-install/
;;   (setq auto-install-directory "~/.emacs.d/site-lisp/")
;;   ;; EmacsWiki�ɓo�^����Ă���elisp �̖��O���擾����
;;   (auto-install-update-emacswiki-package-name t)
;;   ;; �K�v�ł���΃v���L�V�̐ݒ���s��
;;   ;; (setq url-proxy-services '(("http" . "localhost:8339")))
;;   ;; 3��install-elisp �̊֐��𗘗p�\�ɂ���
;;   (auto-install-compatibility-setup)) ; 4��


;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
;; (package-install "redo+")
(when (require 'redo+ nil t)
  ;; C-' �Ƀ��h�D�����蓖�Ă�
  ;;(global-set-key (kbd "C-'") 'redo)
  ;; ���{��L�[�{�[�h�̏ꍇC-. �Ȃǂ��悢����
  (global-set-key (kbd "C-.") 'redo)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.2 ���ꂵ���C���^�t�F�[�X�ł̑���                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���v�g���@�\�C���X�g�[����
;;; P122-129 ���I���^�C���^�t�F�[�X����Anything
;; (auto-install-batch "anything")
;;(require 'anything-startup)

(when (require 'anything nil t)
  (define-key global-map (kbd "C-;") 'anything)
  
  (setq
   ;; ����\������܂ł̎��ԁB�f�t�H���g��0.5
   anything-idle-delay 0.3
   ;; �^�C�v���čĕ`�ʂ���܂ł̎��ԁB�f�t�H���g��0.1
   anything-input-idle-delay 0.5
   ;; ���̍ő�\�����B�f�t�H���g��50
   ;; anything-candidate-number-limit 100
   ;; ��₪�����Ƃ��ɑ̊����x�𑁂�����
   ;;anything-quick-update t
   ;; ���I���V���[�g�J�b�g���A���t�@�x�b�g��
   ;; anything-enable-shortcuts 'alphabet
   anything-enable-shortcuts 't
   )

  (when (require 'anything-config nil t)
    ;; root�����ŃA�N�V���������s����Ƃ��̃R�}���h
    ;; �f�t�H���g��"su"
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
    ;; lisp�V���{���̕⊮���̍Č�������
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    ;; describe-bindings��Anything�ɒu��������
    (descbinds-anything-install)))


;;; P127-128 �ߋ��̗�������y�[�X�g����anything-show-kill-ring
;; M-y��anything-show-kill-ring�����蓖�Ă�
(define-key global-map (kbd "M-y") 'anything-show-kill-ring)

;; ;;; P128-129 moccur�𗘗p���鄟��anything-c-moccur
(when (require 'anything-c-moccur nil t)
  (setq
   ;; anything-c-moccur�p `anything-idle-delay'
   anything-c-moccur-anything-idle-delay 0.1
   ;; �o�b�t�@�̏����n�C���C�g����
   anything-c-moccur-higligt-info-line-flag t
   ;; ���ݑI�𒆂̌��̈ʒu���ق���window�ɕ\������
   anything-c-moccur-enable-auto-look-flag t
   ;; �N�����Ƀ|�C���g�̈ʒu�̒P��������p�^�[���ɂ���
   anything-c-moccur-enable-initial-pattern t)

  ;; �L�[�o�C���h�̊���(�D�݂ɍ��킹�Đݒ肵�Ă�������)
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
;;; anything-bookmarks�𗘗p����B
;;;
(define-key global-map "\C-xrl" 'anything-bookmarks)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.3 ���͂̌�����                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���v�g���@�\�C���X�g�[����
;; (package-install 'auto-complete)
;;; P130-131 ���p�\�ɂ���
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
    "~/.emacs.d/site-lisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;;; P136 grep�̌��ʂ𒼐ڕҏW����wgrep
;; wgrep�̐ݒ�
;; (package-install 'wgrep)
(require 'wgrep nil t)
;; C-c C-p   wgrep-change-to-wgrep-mode
;; C-c C-k   wgrep-abort-changes
;; C-c C-c   wgrep-finish-edit
;; M-x wgrep-save-all-buffers


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.5 ���܂��܂ȗ����Ǘ�                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P137-138 �ҏW�������L�����鄟��undohist
;; (package-install 'undohist)
;; undohist�̐ݒ�
(when (require 'undohist nil t)
  (undohist-initialize))

;;; P138 �A���h�D�̕��򗚗�����undo-tree
;; (package-install 'undo-tree)
;; undo-tree�̐ݒ�
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))


;;; P139-140 �J�[�\���̈ړ���������point-undo
;; (package-install 'point-undo)
;; point-undo�̐ݒ�
(when (require 'point-undo nil t)
  (define-key global-map [f5] 'point-undo)
  (define-key global-map [f6] 'point-redo)
  ;; �M�҂̂����߃L�[�o�C���h
  (define-key global-map (kbd "M-[") 'point-undo)
  (define-key global-map (kbd "M-]") 'point-redo)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.6 �E�B���h�E�Ǘ�                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (package-install 'apel)
;; (package-install 'elscreen)
;;
;;; P141-143 �E�B���h�E�̕�����Ԃ��Ǘ�����ElScreen
;; ElScreen�̃v���t�B�b�N�X�L�[��ύX����i�����l��C-z�j
;; (setq elscreen-prefix-key (kbd "C-t"))

(when (or (eq system-type 'darwin))
  (when (require 'elscreen nil t)
    ;; C-z C-z���^�C�v�����ꍇ�Ƀf�t�H���g��C-z�𗘗p����
    (if window-system
        (define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
      (define-key elscreen-map (kbd "C-z") 'suspend-emacs))
    (global-set-key (kbd "<C-tab>") 'elscreen-next))

  (defadvice elscreen-jump (around elscreen-last-command-char-event activate)
    (let ((last-command-char last-command-event))
      ad-do-it))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.8 ����Ȕ͈͂̕ҏW                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P151 ��`�ҏW����cua-mode
;; cua-mode�̐ݒ�
(cua-mode t) ; cua-mode���I��
(setq cua-enable-cua-keys nil) ; CUA�L�[�o�C���h�𖳌��ɂ���



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P169 �R���� �֗��ȃG�C���A�X
;; dtw��delete-trailing-whitespace�̃G�C���A�X�ɂ���
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

;;; P172-173 Ruby�ҏW�p�֗̕��ȃ}�C�i�[���[�h
;; ���ʂ̎����}������ruby-electric
(require 'ruby-electric nil t)
;; end�ɑΉ�����s�̃n�C���C�g����ruby-block
(when (require 'ruby-block nil t)
  (setq ruby-block-highlight-toggle t))

;; �C���^���N�e�B�uRuby�𗘗p���鄟��inf-ruby
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



;; ruby-mode-hook�p�̊֐����`
(defun ruby-mode-hooks ()
;;  (inf-ruby-keys)
  (ruby-electric-mode t)
  (ruby-block-mode t))
;; ruby-mode-hook�ɒǉ�
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
;; 7.2 Flymake�ɂ�镶�@�`�F�b�N                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'flymake nil t)

;;; P186 Ruby
;; Ruby�pFlymake�̐ݒ�
(defun flymake-ruby-init ()
  (list "ruby" (list "-c" (flymake-init-create-temp-buffer-copy
                           'flymake-create-temp-inplace))))

(add-to-list 'flymake-allowed-file-name-masks
             '("\\.rb\\'" flymake-ruby-init))

(add-to-list 'flymake-err-line-patterns
             '("\\(.*\\):(\\([0-9]+\\)): \\(.*\\)" 1 2 nil 3))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.3 �^�O�ɂ��R�[�h���[�f�B���O                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���v�g���@�\�C���X�g�[����
;;; P189-190 gtags��Emacs�Ƃ̘A�g
;; gtags-mode�̃L�[�o�C���h��L��������
;;(setq gtags-suggested-key-mapping t) ; ����������ꍇ�̓R�����g�A�E�g
;;(require 'gtags nil t)


;;; P190-191 ctags��Emacs�Ƃ̘A�g
;; http://ctags.sourceforge.net/
;; (package-install "ctags")
;;

;;(install-elisp "https://raw.githubusercontent.com/jdhore/emacs.d/master/elpa/ctags-1.1.1/ctags.el")

;; ctags.el�̐ݒ�
(require 'ctags nil t)
(setq tags-revert-without-query t)
;; ctags���Ăяo���R�}���h���C���B�p�X���ʂ��Ă���΃t���p�X�łȂ��Ă��悢
;; etags�݊��^�O�𗘗p����ꍇ�̓R�����g���O��
;; (setq ctags-command "ctags -e -R ")
;; anything-exuberant-ctags.el�𗘗p���Ȃ��ꍇ�̓R�����g�A�E�g����
;;(setq ctags-command "/usr/local/bin/ctags -R --fields=\"+afikKlmnsSzt\" ")
(setq ctags-command "ctags -R --fields=\"+afikKlmnsSzt\" ")
(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P192-193 Anything�ƃ^�O�̘A�g
;;
;; (package-install 'anything-exuberant-ctags)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Anything����TAGS�𗘗p���₷������R�}���h�쐬
;;(when (and (require 'anything-exuberant-ctags nil t)
;;           (require 'anything-gtags nil t))
(when (require 'anything-exuberant-ctags nil t)
  ;; anything-for-tags�p�̃\�[�X���`
  (setq anything-for-tags
        (list anything-c-source-imenu
              ;;anything-c-source-gtags-select
              ;; etags�𗘗p����ꍇ�̓R�����g���O��
              ;; anything-c-source-etags-select
              anything-c-source-exuberant-ctags-select
              ))

  ;; anything-for-tags�R�}���h���쐬
  (defun anything-for-tags ()
    "Preconfigured `anything' for anything-for-tags."
    (interactive)
    (anything anything-for-tags
              (thing-at-point 'symbol)
              nil nil nil "*anything for tags*"))

  ;; M-t��anything-for-current�����蓖��
  (define-key global-map (kbd "M-t") 'anything-for-tags)
  (global-set-key "\M-." 'anything-for-tags)

  ;; ��񂾂��ƌ��̏ꏊ�ɖ߂肽���ꍇ��"C-u C-SPC"�ł��D
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
;;       '((space-mark ?\x3000 [?\��])
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

