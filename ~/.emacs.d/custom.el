(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(eat evil magit marginalia mixed-pitch ob-swift obswift orderless org
	 org-fragtog org-remoteimg ox-gfm package-name pkg-name
	 rust-mode swift-mode vertico vterm))
 '(safe-local-variable-values
   '((eval progn (org-babel-goto-named-src-block "vm_power_interactive")
	   (org-babel-execute-src-block))
     (eval progn
	   (org-babel-goto-name-src-block "vm_power_interactive")
	   (org-babel-execute-src-block))
     (eval setq-local org-confirm-babel-evaluate nil)
     (org-confirm-babel-evaluate lambda (_) nil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
