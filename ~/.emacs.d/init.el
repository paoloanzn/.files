;;; .init.el --- Global settings -*- lexical-binding: t; -*-

;; Default behavior override

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq sentence-end-double-space nil)

;; Theme

(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
(load-theme 'leuven-zen t)

;; Startup buffer

(setq inhibit-startup-screen t)

(defun welcome ()
  "Create startup buffer"
  (defmacro add-link-button (text dest type)
    (let ((actual-type (eval type)))
      (cond ((eq actual-type 'file)
             `(insert-text-button
               ,text
               'action ,`(lambda (_) (find-file ,dest))
               'follow-link t))
            ((eq actual-type 'external)
             `(progn
		(setq-local browse-url-browser-function 'browse-url-generic
                      browse-url-generic-program "chrome")
		(insert-text-button
		 ,text
		 'action ,`(lambda (_) (browse-url-default-browser ,dest))
		 'follow-link t))))))

  (let ((buffer (get-buffer-create "*Welcome*")))
    (with-current-buffer buffer
      (let ((inhibit-read-only t))
	(erase-buffer)
	;; Title
	(let ((hour (string-to-number (format-time-string "%H"))))
	    (let ((msg (cond
		    ((< hour 12) "Good morning")
		    ((< hour 17) "Good afternoon")
		    (t "Good evening"))))
		(insert (propertize (format "%s, Paolo\n" msg)
				    'face '(:height 1.3 :weight bold)))))
	;; Date
	(insert (format-time-string "%A, %B %d, %Y\n\n"))
	;; Links
	(add-link-button "Open configuration" "~/.emacs.d/init.el" 'file)
	(insert "\n")
	(add-link-button "Open Org" "~/Org" 'file)
	(insert "\n")
	(add-link-button "Email Inbox" "https://mail.google.com/mail/u/1/#inbox" 'external)

	(special-mode))
      (goto-char (point-min)))
    buffer))

(setq initial-buffer-choice #'welcome)

;; GUI Window element

(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Mode line

(set-face-attribute 'mode-line nil :height 1.1)
(set-face-attribute 'mode-line-inactive nil :height 1.0)

;; Packages

(require 'package)
(when (>= (string-to-number emacs-version) 24)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t))
;; (package-refresh-contents) ;; This is too slow to be done at every startup
(package-initialize)

;; Install macro

(defmacro install-pkg (pkg-name)
  `(progn
     (unless (package-installed-p ,pkg-name)
       (package-install ,pkg-name))
     (require ,pkg-name)))

;; Hide `Custom` generated cofiguration

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; Org mode -- Install

(unless (package-installed-p 'org)
  (package-refresh-contents)
  (package-install 'org))
(require 'org)

;; Org mode -- Settings

;; Org Babel

(setq org-babel-python-command "python3")

;; Swift support

(install-pkg 'ob-swift)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)
   (python . t)
   (swift . t)
   (R . t)
   (C . t)))

;; Mixed Fonts

(setq org-startup-indented t)

(unless (package-installed-p 'mixed-pitch)
  (package-install 'mixed-pitch))

(require 'mixed-pitch)

(set-face-attribute 'variable-pitch nil :font "System Font-12")

(setq mixed-pitch-variable-pitch-cursor nil
      mixed-pitch-set-height nil)

(setq mixed-pitch-fixed-pitch-faces
      (remove 'org-indent mixed-pitch-fixed-pitch-faces))

(add-hook 'org-mode-hook #'visual-line-mode)
(add-hook 'org-mode-hook #'mixed-pitch-mode)

;; Ox-gfm -- Install -- Markdown code blocks rendering

(install-pkg 'ox-gfm)

;; Images and Formulas rendering

;; External Images support
(if (not (file-directory-p (expand-file-name "lisp/org-remoteimg")))
    (shell-command "
mkdir -p ~/.emacs.d/lisp
git clone https://github.com/gaoDean/org-remoteimg.git \
  ~/.emacs.d/lisp/org-remoteimg
"))

;; Compatibility with Org < 9.8
(unless (boundp 'org-link-preview-overlays)
  (defvaralias 'org-link-preview-overlays
    'org-inline-image-overlays))

(add-to-list 'load-path
	     (expand-file-name "lisp/org-remoteimg" user-emacs-directory))
(require 'org-remoteimg)
(setq org-startup-with-inline-images t)
(setq org-display-remote-inline-images 'cache)

;; Support image size control
(setq org-image-actual-width nil)

;; Note: `latex` and `dvisvgm` must be installed on the system
(setq org-preview-latex-default-process 'dvisvgm)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2))

;; Org-fragtog -- Install -- Make Latex preview editable by hovering with cursor

(install-pkg 'org-fragtog)
(add-hook 'org-mode-hook #'org-fragtog-mode)

;; Default directory

(shell-command "mkdir -p ~/Org")
(setq org-directory "~/Org")

;; Default notes file

(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-default-journal-file (concat org-directory "/journal.org"))

;; Org Capture settings

(define-key global-map "\C-cc" 'org-capture)
(setq org-export-coding-system 'utf-8)

(setq org-capture-templates
      ;; Todos
      '(("t"
	 "Todo list item"
	 entry
	 (file+headline org-default-notes-file "Tasks")
	 "* TODO %?\n %i\n %a")
	;; Journal
	("j"
	 "Journal entry"
	 entry (file+datetree org-default-journal-file)
	 (file "~/.emacs.d/org-templates/journal.orgcaptmpl"))))

;; Evil mode -- Install

(unless (package-installed-p 'evil)
  (package-install 'evil))

(setq evil-want-C-u-scroll t
      evil-want-C-i-jump nil)

(require 'evil)
(evil-mode 1)

;; Which-key -- Install

(install-pkg 'which-key)
(which-key-mode 1)

;; Vertico -- Install

(install-pkg 'vertico)
(vertico-mode 1)

;; Orderless -- Install

(install-pkg 'orderless)
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles basic partial-completion))))

;; Marginalia -- Install

(install-pkg 'marginalia)
(marginalia-mode 1)

;; Magit -- Install

(install-pkg 'magit)

;; Swift-mode -- Install

(install-pkg 'swift-mode)

;; Rust-mode -- Install

(install-pkg 'rust-mode)

(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))

;; Vterm -- Install

(install-pkg 'vterm)

(with-eval-after-load 'vterm
  (dolist (key '("M-s" "M-k"))
    (add-to-list 'vterm-keymap-exceptions key)
    (define-key vterm-mode-map (kbd key) nil)))

;; Tramp -- ssh setup

(require 'tramp)

(setq tramp-default-method "ssh")
(setq remote-file-name-inhibit-cache 60)

;; Interactive commands & Macros

;; Interactive Compile

(defun compile-interactive()
  "Run compilation with interactive input enabled and focus its window."
  (interactive)
  (let ((buffer (compile (compilation-read-command compile-command) t)))
    (when-let ((window (get-buffer-window buffer)))
      (select-window window))))

;; Files shortcuts

(defun open-init-file()
  (interactive)
  (find-file user-init-file))

(defun open-org-home()
  (interactive)
  (find-file org-directory))

(defmacro navigate-to(url)
  `(progn
     (setq-local browse-url-browser-function 'browse-url-generic
		 browse-url-generic-program "chrome")
     (browse-url-default-browser ,url)))

(defun open-chatgpt(prompt)
  "Open a new browser page and navigate to chatgpt.com"
  (interactive "sAsk a question: ")
  (cond ((eq prompt nil)
	 (navigate-to "https://chatgpt.com"))
	(t
	 (navigate-to (format "https://chatgpt.com?q=%s" prompt)))))

(defun open-claude(prompt)
  "Open a new browser page and navigate to claude.ai"
  (interactive "sAsk a question: ")
  (cond ((eq prompt nil)
	 (navigate-to "https://claude.ai/new"))
	(t
	 (navigate-to (format "https://claude.ai/new?q=%s" prompt)))))

;; Keybinds remaps

(keymap-global-set "M-k" 'kill-buffer)
(keymap-global-set "M-s" 'switch-to-buffer)
