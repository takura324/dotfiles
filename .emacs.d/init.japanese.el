;;(require 'un-define)
;;(require 'jisx0213)

;;15.1 ���{��̕ҏW (2004/01/15)
;;(set-language-environment "Japanese")
;;(setq default-input-method "MW32-IME")

;; default-input-method �̐ݒ��L���ɂ���
;;(mw32-ime-initialize)


;;15.2.2 ���_�t�H���g���g�� (2004/01/25)
(load "shinonome-setup")

;;15.2.3 MS �S�V�b�N�Ȃǂ̐ݒ� 
;;(load "windows-fonts-setup")


;;21.7.1 �������` (�@��ˑ������̍폜) �\ text-adjust (2003/06/27)
(load-library "text-adjust")
(setq adaptive-fill-regexp "[ \t]*")
(setq adaptive-fill-mode t)


;;�����o�^
(defalias 'toroku-region 'mw32-ime-toroku-region)
