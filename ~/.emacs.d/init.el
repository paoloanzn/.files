;;; .init.el --- Global settings -*- lexical-binding: t; -*-

;; Default behavior override

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq sentence-end-double-space nil)

;; Horizontal scrolling

;; Long lines
(setq-default truncate-lines t)

;; Horizontal trackpad scrolling
(setq mouse-wheel-tilt-scroll t
      mouse-wheel-progressive-speed nil)
(setq mouse-wheel-flip-direction t)

;; Avoid interfering with horizontal wheel events
(pixel-scroll-precision-mode -1)

;; Smooth automatic horizontal repositioning
(setq auto-hscroll-mode t
      hscroll-margin 2
      hscroll-step 1)

;; macOS: increase trackpad sensitivity
(when (boundp 'ns-mwheel-line-height)
  (setq ns-mwheel-line-height 12))

;; Set TAB width

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)

;; Install macro

(defmacro install-pkg (pkg-name &optional repo-url)
  "Install and require PKG-NAME, using REPO-URL when supplied."
  `(progn
     (unless (package-installed-p ,pkg-name)
       ,(if repo-url
            `(package-vc-install (list ,pkg-name :url ,repo-url))
          `(package-install ,pkg-name)))
     (require ,pkg-name)))

;; Theme

;; Install custom themes from MELPA
(install-pkg 'solarized-theme)

;; Load custom themes from `~/.emacs.d/themes/`
(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))

;; Set active theme
(load-theme 'gruber-darker t)

;; Font -- JetBrains Mono (download if missing)

(load (expand-file-name "util/jetbrains-mono.el" user-emacs-directory))

(when (and (display-graphic-p) (not (jetbrains-mono-installed-p)))
  (jetbrains-mono-install))

(set-face-attribute 'default nil :family "JetBrains Mono" :height 140)
(set-face-attribute 'fixed-pitch nil :family "JetBrains Mono")

;; Startup buffer

(setq inhibit-startup-screen t)

(defun welcome--active-vms ()
  "Return a list of (NAME STATE) for the active VMs reported by vm-power."
  (when (executable-find "vm-power")
    (let ((lines (ignore-errors (process-lines "vm-power" "list" "--cached"))))
      (when (and lines (string-prefix-p "NAME" (car lines)))
        (let* ((header (car lines))
               (state-col (string-match "STATE" header))
               (ip-col (string-match "IP ADDRESS" header)))
          (delq nil
                (mapcar
                 (lambda (line)
                   (when (> (length line) state-col)
                     (list (car (split-string line))
                           (string-trim
                            (substring line state-col
                                       (min ip-col (length line)))))))
                 (cdr lines))))))))

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
	      (add-link-button "Email Inbox" "https://mail.google.com/mail/u/1/#inbox" 'external)

	      ;; Virtual machines (home folders over TRAMP sshx)
	      (let ((vms (welcome--active-vms)))
	        (when vms
	          (insert "\n\n" (propertize "Virtual machines\n" 'face '(:weight bold)))
	          (dolist (vm vms)
	            (insert-text-button
	             (car vm)
	             'vm-path (format "/sshx:%s:~/" (car vm))
	             'action (lambda (button) (find-file (button-get button 'vm-path)))
	             'follow-link t)
	            (insert (format "  (%s)\n" (cadr vm))))))

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
(line-numbers-for-mode svelte-mode)
(line-numbers-for-mode zig-mode)

;; Packages

(require 'package)
(when (>= (string-to-number emacs-version) 24)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t))
;; (package-refresh-contents) ;; This is too slow to be done at every startup
(package-initialize)

;; Hide `Custom` generated cofiguration

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; Exc -- Install

(install-pkg 'ecss "https://github.com/emacs-taf/ecss.git")
(install-pkg 'ebox "https://github.com/emacs-taf/ebox.git")
(install-pkg 'etaf "https://github.com/emacs-taf/etaf.git")
(install-pkg 'exc "https://github.com/yibie/exc.el.git")

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
   (C . t)
   (dot . t)
   (plantuml . t)
   (ditaa . t)))

;; Inline diagrams

;; Keep rendered diagrams out of note directories.  A block can still
;; specify its own :output-dir when its output belongs to a project.
(dolist (headers '(org-babel-default-header-args:dot
                   org-babel-default-header-args:plantuml
                   org-babel-default-header-args:ditaa))
  (setf (alist-get :output-dir (symbol-value headers))
        (expand-file-name "~/.local/share/org/diagrams/")))

;; Requires `brew install graphviz plantuml ditaa`
(setq org-plantuml-exec-mode 'plantuml)

;; Org runs ditaa via its JAR, not the Homebrew launcher.
(let* ((prefix (or (getenv "HOMEBREW_PREFIX") "/opt/homebrew"))
       (jar (car (file-expand-wildcards
                  (expand-file-name "opt/ditaa/libexec/ditaa-*.jar" prefix))))
       (java (expand-file-name "opt/openjdk/bin/java" prefix)))
  (when jar (setq org-ditaa-jar-path jar))
  (when (file-executable-p java) (setq org-babel-ditaa-java-cmd java)))

(add-hook 'org-babel-after-execute-hook #'org-redisplay-inline-images)

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
;; (add-hook 'markdown-mode-hook #'visual-line-mode)
;; (add-hook 'markdown-mode-hook #'mixed-pitch-mode)

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
(setq org-preview-latex-default-process 'dvisvgm
      org-preview-latex-image-directory (expand-file-name "~/.local/share/org/ltximg/"))
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
      evil-want-C-i-jump nil
      evil-want-integration t
      evil-want-keybinding nil)

(require 'evil)
(evil-mode 1)

(evil-ex-define-cmd "q[uit]" #'kill-current-buffer)

(define-key wdired-mode-map [remap evil-write] #'wdired-finish-edit)

;; Evil collection -- Install

(install-pkg 'evil-collection)
(evil-collection-init '(magit dired))

;; Exc -- Evil bindings while navigating a grid

(evil-set-initial-state 'exc-etaf-mode 'normal)
(with-eval-after-load 'exc-etaf
  ;; Exc's type-to-edit map takes precedence over Evil's normal-state map.
  ;; Keep its native typing behavior outside normal state.
  (dolist (entry '(("h" . exc-cell-left) ("j" . exc-next-line)
                   ("k" . exc-previous-line) ("l" . exc-cell-right)
                   ("0" . exc-move-beginning-of-line) ("$" . exc-move-end-of-line)
                   ("i" . exc-edit-cell) ("y" . exc-etaf-copy)
                   ("p" . exc-etaf-paste) ("u" . exc-etaf-undo)))
    (define-key exc-etaf-typing-map (kbd (car entry))
                `(menu-item "" ,(cdr entry) :filter
                            ,(lambda (command)
                               (if (and evil-local-mode (evil-normal-state-p))
                                   command
                                 #'exc-etaf-self-insert))))))

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

;; Zig-mode -- Install

(install-pkg 'zig-mode)

(add-to-list 'auto-mode-alist '("\\.zig\\'" . zig-mode))
(add-to-list 'auto-mode-alist '("\\.zon\\'" . zig-mode))

;; Tide-lang-mode -- Install

(let ((dir (expand-file-name "lisp/tide-syntax" user-emacs-directory)))
  (unless (file-directory-p dir)
    (make-directory (file-name-directory dir) t)
    (shell-command
     (format "git clone https://github.com/paoloanzn/tide-syntax.git %s"
             (shell-quote-argument dir))))
  (add-to-list 'load-path (expand-file-name "emacs" dir)))

(require 'tide-lang-mode)

;; Typescript mode -- Install

(require 'typescript-ts-mode)

(require 'treesit)

(add-to-list 'auto-mode-alist
             '("\\.ts\\'" . typescript-ts-mode))

(add-to-list 'auto-mode-alist
             '("\\.tsx\\'" . tsx-ts-mode))

(setq typescript-ts-mode-indent-offset 2)

;; Tree-sitter grammars
(add-to-list 'treesit-language-source-alist
             '(typescript
               "https://github.com/tree-sitter/tree-sitter-typescript"
               "master"
               "typescript/src"))

(add-to-list 'treesit-language-source-alist
             '(tsx
               "https://github.com/tree-sitter/tree-sitter-typescript"
               "master"
               "tsx/src"))

;; Automatically install missing grammars
(when (treesit-available-p)
  (dolist (lang '(typescript tsx))
    (unless (treesit-language-available-p lang)
      (treesit-install-language-grammar lang))))

;; Svelte mode -- Install

(install-pkg 'typescript-mode) ;; This does NOT get used in .ts files.
(install-pkg 'svelte-mode)

(add-to-list 'auto-mode-alist
             '("\\.svelte\\'" . svelte-mode))

(setq svelte-basic-offset 2)

;; Vterm -- Install

(install-pkg 'vterm)

(with-eval-after-load 'vterm
  (dolist (key '("M-s" "M-k"))
    (add-to-list 'vterm-keymap-exceptions key)
    (define-key vterm-mode-map (kbd key) nil)))

;; Tramp -- ssh setup

(require 'tramp)

(setq tramp-default-method "sshx")
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

;; Save buffer contents as a new note

(defun save-buffer-as-note (name)
  "Save the current buffer's text to a new file in ~/Documents/Notes/ and open it."
  (interactive "sNote file name: ")
  (when (string-empty-p (string-trim name))
    (user-error "File name cannot be empty"))
  (let* ((dir (expand-file-name "~/Documents/Notes/"))
         (file (expand-file-name name dir))
         (text (buffer-substring-no-properties (point-min) (point-max))))
    (make-directory dir t)
    (when (and (file-exists-p file)
               (not (y-or-n-p (format "%s already exists. Overwrite? " file))))
      (user-error "Cancelled"))
    (write-region text nil file)
    (find-file file)))

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

;; Autocomplete configuration

(require 'cl-lib)
(load (expand-file-name "util/eglot-typescript.el" user-emacs-directory))
(load (expand-file-name "util/eglot-svelte.el" user-emacs-directory))

;; Define language servers
(defvar eglot-servers
  ;; C/C++
  '(((c-mode c++-mode c-ts-mode c++-ts-mode)
     ("clangd"))

    ;; Python
    ((python-mode python-ts-mode)
     ("basedpyright-langserver" "--stdio")
     ("pyright-langserver" "--stdio")
     ("pylsp"))

    ;; Rust
    ((rust-mode rust-ts-mode)
     ("rust-analyzer"))

    ;; Svelte
    ((svelte-mode)
     eglot-svelte-command)

    ;; Javascript & Typescript
    ((js-mode js-ts-mode typescript-mode
              typescript-ts-mode tsx-ts-mode)
     eglot-typescript-command)))

;; Find the first available server
(defun eglot-pick-server (commands _interactive &optional _project)
  (cl-loop
   for candidate in commands
   for command =
   (if (functionp candidate)
       (funcall candidate)
     (when (executable-find
            (car candidate)
            (file-remote-p default-directory))
       candidate))
   when command return command))

;; Register language servers with Eglot
(with-eval-after-load 'eglot
  (dolist (entry eglot-servers)
    (add-to-list
     'eglot-server-programs
     (cons (car entry)
           (apply-partially #'eglot-pick-server
                            (cdr entry))))))

;; Enable Eglot automatically when a server exists.
(defun eglot-auto-start ()
  (when (and buffer-file-name
             (cl-some
              (lambda (entry)
                (and (apply #'derived-mode-p (car entry))
                     (eglot-pick-server
                      (cdr entry) nil)))
              eglot-servers))
    (eglot-ensure)))

;; Temporary disabled.
;; (add-hook 'prog-mode-hook #'eglot-auto-start)

;; Eglot -- install

(require 'eglot)
(setq eglot-autoshutdown t)

;; Silently ignore unsupported configuration registration.
(cl-defmethod eglot-register-capability
  (_server (_method (eql workspace/didChangeConfiguration))
           _id &rest _params)
  nil)

;; Completion popup.
(install-pkg 'corfu)
(require 'corfu-popupinfo)

(setq corfu-auto t)
(setq corfu-auto-delay 0.25)
(setq corfu-auto-prefix 2)
(setq corfu-cycle t)

(global-corfu-mode 1)
(corfu-popupinfo-mode 1)

;; Word and file completion without LSP

(install-pkg 'cape)
(add-hook 'completion-at-point-functions #'cape-dabbrev)
(add-hook 'completion-at-point-functions #'cape-file)

;; TAB can indent or trigger completion.

(setq tab-always-indent 'complete)
