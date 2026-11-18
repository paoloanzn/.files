;;; eglot-typescript.el --- Project-specific TypeScript server -*- lexical-binding: t; -*-

(defun eglot-typescript-command ()
  "Choose a language server for the project's installed TypeScript."
  (let* ((root (locate-dominating-file
                default-directory "node_modules/.bin/tsc"))
         (tsc (and root
                   (expand-file-name "node_modules/.bin/tsc" root))))
    (when tsc
      (let* ((default-directory root)
             (major
              (with-temp-buffer
                (unless (and
                         (eq 0 (process-file
                                (file-local-name tsc)
                                nil t nil "--version"))
                         (progn
                           (goto-char (point-min))
                           (re-search-forward
                            "^Version \\([0-9]+\\)\\." nil t)))
                  (error "Cannot determine TypeScript version: %s"
                         (buffer-string)))
                (string-to-number (match-string 1)))))
        (if (>= major 7)
            (list (file-local-name tsc) "--lsp" "--stdio")
          (let* ((tsserver
                  (expand-file-name
                   "node_modules/typescript/lib/tsserver.js" root))
                 (local-server
                  (expand-file-name
                   "node_modules/.bin/typescript-language-server" root))
                 (server
                  (if (file-executable-p local-server)
                      (file-local-name local-server)
                    (when (executable-find
                           "typescript-language-server"
                           (file-remote-p default-directory))
                      "typescript-language-server"))))
            (unless (file-exists-p tsserver)
              (error "TypeScript %s: missing %s" major tsserver))
            (unless server
              (error "Install typescript-language-server on %s"
                     (or (file-remote-p default-directory) "this machine")))
            (list server "--stdio"
                  :initializationOptions
                  (list :tsserver
                        (list :path (file-local-name tsserver))))))))))

(provide 'eglot-typescript)
;;; eglot-typescript.el ends here
