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

;; Remap local buffer zoom to global zoom

(global-set-key (kbd "s-+") #'global-text-scale-adjust)
(global-set-key (kbd "s-=") #'global-text-scale-adjust)
(global-set-key (kbd "s--") #'global-text-scale-adjust)
(global-set-key (kbd "s-0") #'global-text-scale-adjust)

;; Decouple frame resizing from font size resizing

(setq global-text-scale-adjust-resizes-frames nil)

;; Mode line

(set-face-attribute 'mode-line nil :height 1.1)
(set-face-attribute 'mode-line-inactive nil :height 1.0)

;; Scale the Mode line to match the originating buffer (proportinally)

(defvar-local mode-line-scale-cookies nil)

(defun scale-mode-line()
  "Match the mode line's scale to the current buffer."
  (dolist (cookie mode-line-scale-cookies)
    (face-remap-remove-relative cookie))
  (setq mode-line-scale-cookies nil)

  (when text-scale-mode
    (let ((factor (expt text-scale-mode-step
			text-scale-mode-amount)))
      (dolist (face '(mode-line
		      mode-line-active
		      mode-line-inactive))
	(when (facep face)
	  (push (face-remap-add-relative face :height factor)
		mode-line-scale-cookies))))))

(add-hook 'text-scale-mode-hook #'scale-mode-line)

;; Scale the minibuffer to match the originating buffer

(defun scale-minibuffer ()
  "Use the originating buffer's text scale in the minibuffer."
  (let ((window (minibuffer-selected-window)))
    (when (window-live-p window)
      (let ((level
             (with-current-buffer (window-buffer window)
               (if text-scale-mode
                   text-scale-mode-amount
                 0))))
        (text-scale-set level)))))

(add-hook 'minibuffer-setup-hook #'scale-minibuffer)

;; Line numbers mode

(setq display-line-numbers-type 'relative)

(defmacro line-numbers-for-mode (mode)
  (let ((hook-name (intern (format "%s-hook" mode))))
    `(add-hook ',hook-name (lambda () (display-line-numbers-mode 1)))))

(line-numbers-for-mode c-mode)
(line-numbers-for-mode c++-mode)
(line-numbers-for-mode python-mode)
(line-numbers-for-mode js-mode)
(line-numbers-for-mode rust-mode)
(line-numbers-for-mode emacs-lisp-mode)
(line-numbers-for-mode sh-mode)
(line-numbers-for-mode go-mode)
(line-numbers-for-mode typescript-ts-mode)
(line-numbers-for-mode tide-lang-mode)


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

;; Writable Dired mode -- enable

(require 'wdired)
(setq wdired-allow-to-change-permissions t)

(define-key dired-mode-map (kbd "M-e") #'wdired-change-to-wdired-mode)
(define-key wdired-mode-map (kbd "s-s") #'wdired-finish-edit)
(define-key wdired-mode-map (kbd "M-c") #'wdired-abort-changes)

;; Markdown mode -- Install

(install-pkg 'markdown-mode)

(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

(add-hook 'markdown-mode-hook (lambda () (setq markdown-command "pandoc")))
(add-hook 'markdown-mode-hook (lambda () (visual-line-mode 1)))

;; Valign mode -- Install

(install-pkg 'valign)
(add-hook 'markdown-mode-hook #'valign-mode)

;; Org mode -- Install

(unless (package-installed-p 'org)
  (package-refresh-contents)
  (package-install 'org))
(require 'org)

;; Org mode -- Settings

;; Org Babel

(setq org-babel-python-command "python3")
(setq org-babel-js-cmd "node")

;; Swift support

(install-pkg 'ob-swift)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)
   (python . t)
   (swift . t)
   (R . t)
   (js . t)
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
(add-hook 'markdown-mode-hook #'visual-line-mode)
(add-hook 'markdown-mode-hook #'mixed-pitch-mode)

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

(evil-ex-define-cmd "q[uit]" #'kill-current-buffer)

(define-key wdired-mode-map [remap evil-write] #'wdired-finish-edit)

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

;; Tide-lang-mode -- Install

(let ((dir (expand-file-name "lisp/tide-syntax" user-emacs-directory)))
  (unless (file-directory-p dir)
    (make-directory (file-name-directory dir) t)
    (shell-command
     (format "git clone https://github.com/paoloanzn/tide-syntax.git %s"
             (shell-quote-argument dir))))
  (add-to-list 'load-path (expand-file-name "emacs" dir)))

(require 'tide-lang-mode)

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

(with-eval-after-load 'tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

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
  "Open ChatGPT with the selected text and an optional question."
  (interactive "sAsk a question: ")
  (let* ((selection (when (use-region-p)
                      (buffer-substring-no-properties
                       (region-beginning) (region-end))))
         (text (concat
                (if selection (format "```\n%s\n```\n\n" selection) "")
                prompt)))
    (navigate-to
     (if (string-empty-p text)
         "https://chatgpt.com"
       (format "https://chatgpt.com/?q=%s"
               (url-hexify-string text))))))

(defun open-claude(prompt)
  "Open Claude with the selected text and an optional question."
  (interactive "sAsk a question: ")
  (let* ((selection (when (use-region-p)
                      (buffer-substring-no-properties
                       (region-beginning) (region-end))))
         (text (concat
                (if selection (format "```\n%s\n```\n\n" selection) "")
                prompt)))
    (navigate-to
     (if (string-empty-p text)
         "https://claude.ai"
       (format "https://claude.ai/new?q=%s"
               (url-hexify-string text))))))

;; Keybinds remaps

(keymap-global-set "M-k" 'kill-buffer)
(keymap-global-set "M-s" 'switch-to-buffer)
(keymap-global-set "M-o" 'other-window)
(keymap-global-set "M-0" 'delete-window)
