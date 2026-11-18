;;; jetbrains-mono.el --- Install JetBrains Mono -*- lexical-binding: t; -*-

(require 'url)

(defun jetbrains-mono-installed-p ()
  (find-font (font-spec :family "JetBrains Mono")))

(defun jetbrains-mono-install ()
  "Download JetBrains Mono into the user font folder."
  (let* ((url "https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip")
         (font-dir (expand-file-name
                    (if (eq system-type 'darwin)
                        "~/Library/Fonts/"
                      "~/.local/share/fonts/")))
         (tmp (make-temp-file "jbmono" t))
         (zip (expand-file-name "font.zip" tmp)))
    (make-directory font-dir t)
    (url-copy-file url zip t)
    (call-process "unzip" nil nil nil "-o" "-j" zip "fonts/ttf/*.ttf" "-d" font-dir)
    (unless (eq system-type 'darwin)
      (call-process "fc-cache" nil nil nil "-f"))
    (delete-directory tmp t)
    (message "JetBrains Mono installed. Restart Emacs if it doesn't show up.")))

(provide 'jetbrains-mono)
;;; jetbrains-mono.el ends here
