;;; leuven-zen-theme.el --- Leuven, dark, in shades of Zenburn -*- lexical-binding: t -*-

;; Copyright (C) 2003-2025 Free Software Foundation, Inc.

;; Author: Fabrice Niessen <(concat "fniessen" at-sign "pirilampo.org")>
;; URL: https://github.com/fniessen/emacs-leuven-theme
;; Version: 1.2.0
;; Last-Updated: 2024-03-04 10:45
;; Keywords: color theme

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; "leuven-zen" is a dark port of the "leuven" theme: same faces, same
;; structure (colored headline bands, tinted code blocks, blue mode line),
;; recolored on a Zenburn palette (#3F3F3F background, #DCDCCC foreground,
;; muted pastel accents).

;; To use it, put this file in a directory listed in
;; `custom-theme-load-path' and add:

;;   (load-theme 'leuven-zen t)

;; This will load and activate the theme.

;; Requirements:
;; - Emacs 24 or later.

;; For more information and updates, visit the theme's GitHub repository at:
;; https://github.com/fniessen/emacs-leuven-theme

;;; Code:

;;; Options.

(defgroup leuven-zen nil
  "Leuven-zen theme options.
The theme has to be reloaded after changing anything in this group."
  :group 'faces)

(defcustom leuven-zen-scale-org-document-title t
  "Scale Org document title.
This can be nil for unscaled, t for using the theme default, or a scaling
number."
  :type '(choice
          (const :tag "Unscaled" nil)
          (const :tag "Default provided by theme" t)
          (number :tag "Set scaling")))

(defcustom leuven-zen-scale-outline-headlines t
  "Scale `outline' (and `org') level-1 headlines.
This can be nil for unscaled, t for using the theme default, or a scaling
number."
  :type '(choice
          (const :tag "Unscaled" nil)
          (const :tag "Default provided by theme" t)
          (number :tag "Set scaling")))

(defcustom leuven-zen-scale-org-agenda-structure t
  "Scale Org agenda structure lines, like dates.
This can be nil for unscaled, t for using the theme default, or a scaling
number."
  :type '(choice
          (const :tag "Unscaled" nil)
          (const :tag "Default provided by theme" t)
          (number :tag "Set scaling")))

(defcustom leuven-zen-scale-volatile-highlight t
  "Increase size in the `next-error' face.
This can be nil for unscaled, t for using the theme default, or a scaling
number."
  :type '(choice
          (const :tag "Unscaled" nil)
          (const :tag "Default provided by theme" t)
          (number :tag "Set scaling")))

;;;###autoload
(defun leuven-zen-scale-font (control default-height)
  "Function for splicing optional font heights into face descriptions.
CONTROL can be a number, nil, or t.  When t, use DEFAULT-HEIGHT."
  (cond
   ((numberp control) (list :height control))
   ((eq t control) (list :height default-height))
   (t nil)))

;;; Theme Faces.

;;;###theme-autoload
(deftheme leuven-zen
  "Face colors with a dark, Zenburn-like background.
Basic, Font Lock, Isearch, Gnus, Message, Org mode, Diff, Ediff,
Flyspell, Semantic, and Ansi-Color faces are included -- and much
more..."
  :background-mode 'dark
  :kind 'color-scheme
  :family 'leuven)

(let ((class '((class color) (min-colors 89)))

      ;; Leuven generic colors.
      (cancel '(:slant italic :strike-through t :foreground "#7F7F70"))
      ;; (clock-line '(:box (:line-width 1 :color "#B6C3D7") :foreground "#E3E3DD" :background "#786F3A"))
      (code-block '(:foreground "#DCDCCC" :background "#383834"))
      (code-inline '(:foreground "#9FC59F" :background "#393D39"))
      (column '(:height 1.0 :weight normal :slant normal :underline nil :strike-through unspecified :foreground "#DFAF8F" :background "#4A4238"))
      (completion-inline '(:weight normal :foreground "#7F7F70" :inherit hl-line)) ; Like Google.
      (completion-other-candidates '(:foreground "#DCDCCC" :background "#4F4F4F"))
      (completion-selected-candidate '(:weight bold :foreground "#FFFFEF" :background "#4C6672"))
      (diff-added '(:background "#3E4A3E"))
      (diff-changed '(:foreground "#94BFF3" :background "#3D4552"))
      (diff-header '(:weight bold :foreground "#F0DFAF" :background "#4A4535"))
      (diff-hunk-header '(:foreground "#DC8CC3" :background "#4A3D47"))
      (diff-none '(:foreground "#989890"))
      (diff-refine-added '(:background "#4F6F4F"))
      (diff-refine-removed '(:background "#7C4343"))
      (diff-removed '(:background "#4D3B3B"))
      (directory '(:weight bold :foreground "#94BFF3" :background "#3F3F3F"))
      (file '(:foreground "#DCDCCC"))
      (function-param '(:foreground "#8CD0D3"))
      (grep-file-name '(:weight bold :foreground "#94BFF3")) ; Used for grep hits.
      (grep-line-number '(:weight bold :foreground "#DC8CC3"))
      (highlight-blue '(:background "#4C5C66"))
      (highlight-gray '(:background "#4F4F4F"))
      ;; (highlight-green '(:background "#3F563B"))
      ;; (highlight-red '(:background "#673232"))
      (highlight-yellow '(:background "#464640"))
      (link '(:weight normal :underline t :foreground "#8CD0D3"))
      (link-no-underline '(:weight normal :foreground "#8CD0D3"))
      (mail-header-name '(:family "Sans Serif" :weight normal :foreground "#95957D"))
      (mail-header-other '(:family "Sans Serif" :slant normal :foreground "#B6B6A5"))
      (mail-read '(:foreground "#A1A18C"))
      (mail-read-high '(:foreground "#A8A894"))
      (mail-ticked '(:foreground "#E4AEA1"))
      (mail-to '(:family "Sans Serif" :underline unspecified :foreground "#8CD0D3"))
      (mail-unread '(:weight bold :foreground "#FFFFEF"))
      (mail-unread-high '(:weight bold :foreground "#94BFF3"))
      (marked-line '(:foreground "#ECB3B3" :background "#6C3333"))
      (match '(:weight bold :foreground "#3F3F3F" :background "#D0BF8F")) ; occur patterns + match in helm for files + match in Org files.
      (ol1 `(,@(leuven-zen-scale-font leuven-zen-scale-outline-headlines 1.3) :weight bold :overline "#6F6F6F" :foreground "#FFFFEF" :background "#4A4A4A"))
      (ol2 '(:height 1.0 :weight bold :overline "#6CA0A3" :foreground "#93E0E3" :background "#3B4B4D"))
      (ol3 '(:height 1.0 :weight bold :foreground "#9FC59F" :background "#3D4A3D"))
      (ol4 '(:height 1.0 :weight bold :slant normal :foreground "#DFAF8F"))
      (ol5 '(:height 1.0 :weight bold :slant normal :foreground "#DC8CC3"))
      (ol6 '(:height 1.0 :weight bold :slant italic :foreground "#94BFF3"))
      (ol7 '(:height 1.0 :weight bold :slant italic :foreground "#AFD8AF"))
      (ol8 '(:height 1.0 :weight bold :slant italic :foreground "#F0DFAF"))
      (paren-matched '(:weight bold :foreground "#FFFFEF" :background "#5F7F5F")) ; Or take that green for region?
      (paren-unmatched '(:weight bold :underline "#CC9393" :foreground "#FFFFEF" :background "#8C5353"))
      (region '(:background "#2F4F5F"))
      (shadow '(:foreground "#8F8F80"))
      (string '(:foreground "#CC9393")) ; or #D0372D
      (subject '(:family "Sans Serif" :weight bold :foreground "#FFFFEF"))
      (symlink '(:foreground "#93E0E3"))
      (tab '(:foreground "#4F4F4F" :background "#3F3F3F"))
      (trailing '(:foreground "#4F4F4F" :background "#5C4A3A"))
      (volatile-highlight '(:underline unspecified :foreground "#FFFFEF" :background "#6B4A63"))
      (volatile-highlight-supersize `(,@(leuven-zen-scale-font leuven-zen-scale-volatile-highlight 1.1) :underline unspecified :foreground "#FFFFEF" :background "#6B4A63")) ; flash-region
      (vc-branch '(:box (:line-width 1 :color "#7F9F7F") :foreground "#BFEBBF" :background "#3F5F3F"))
      (xml-attribute '(:foreground "#DFAF8F"))
      (xml-tag '(:foreground "#DC8CC3"))
      (highlight-current-tag '(:background "#45454F")) ; #EEF3F6 or #FFEB26
  )

  (custom-theme-set-faces
   'leuven-zen
   `(default ((,class (:foreground "#DCDCCC" :background "#3F3F3F"))))
   `(bold ((,class (:weight bold :foreground "#FFFFEF"))))
   `(bold-italic ((,class (:weight bold :slant italic :foreground "#FFFFEF"))))
   `(italic ((,class (:slant italic :foreground "#E8E8D8"))))
   `(underline ((,class (:underline t))))
   `(cursor ((,class (:background "#FFFFEF"))))

   ;; Lucid toolkit emacs menus.
   `(menu ((,class (:foreground "#DCDCCC" :background "#2B2B2B"))))

   ;; Highlighting faces.
   `(fringe ((,class (:foreground "#6CA0A3" :background "#3F3F3F"))))
   `(highlight ((,class ,highlight-blue)))
   `(region ((,class ,region)))
   `(secondary-selection ((,class ,match))) ; Used by Org-mode for highlighting matched entries and keywords.
   `(isearch ((,class (:weight bold :foreground "#2B2B2B" :background "#F0DFAF"))))
   `(isearch-fail ((,class (:weight bold :foreground "#FFFFEF" :background "#8C5353"))))
   `(lazy-highlight ((,class (:foreground "#FFFFEF" :background "#5F5F5F")))) ; Isearch others (see `match').
   `(trailing-whitespace ((,class ,trailing)))
   `(query-replace ((,class (:inherit isearch))))
   `(whitespace-hspace ((,class (:foreground "#777762")))) ; see also `nobreak-space'
   `(whitespace-indentation ((,class ,tab)))
   `(whitespace-line ((,class (:foreground "#DFAF8F" :background "#4A4238"))))
   `(whitespace-tab ((,class ,tab)))
   `(whitespace-trailing ((,class ,trailing)))

   ;; Mode line faces.
   `(mode-line ((,class (:box (:line-width 1 :color "#2B3A45") :foreground "#BDE0F3" :background "#3B5568"))))
   `(mode-line-inactive ((,class (:box (:line-width 1 :color "#383838") :foreground "#989890" :background "#4A4A4A"))))
   `(mode-line-buffer-id ((,class (:weight bold :foreground "#FFFFEF"))))
   `(mode-line-emphasis ((,class (:weight bold :foreground "#FFFFEF"))))
   `(mode-line-highlight ((,class (:foreground "#F0DFAF"))))

   ;; Escape and prompt faces.
   `(minibuffer-prompt ((,class (:weight bold :foreground "#2B2B2B" :background "#E0CF9F"))))
   `(minibuffer-noticeable-prompt ((,class (:weight bold :foreground "#2B2B2B" :background "#E0CF9F"))))
   `(escape-glyph ((,class (:foreground "#93E0E3"))))
   `(error ((,class (:foreground "#E89393"))))
   `(warning ((,class (:weight bold :foreground "#DFAF8F"))))
   `(success ((,class (:foreground "#9FC59F"))))

   ;; Font lock faces.
   `(font-lock-builtin-face ((,class (:foreground "#94BFF3"))))
   `(font-lock-comment-delimiter-face ((,class (:foreground "#7F9F7F")))) ; #696969
   `(font-lock-comment-face ((,class (:slant italic :foreground "#7F9F7F")))) ; #696969
   `(font-lock-constant-face ((,class (:foreground "#DCA3A3"))))
   `(font-lock-doc-face ((,class (:foreground "#9FC59F"))))
   `(font-lock-function-name-face ((,class (:weight normal :foreground "#93E0E3"))))
   `(font-lock-keyword-face ((,class (:weight bold :foreground "#F0DFAF")))) ; #3654DC
   `(font-lock-preprocessor-face ((,class (:foreground "#BFA0D0"))))
   `(font-lock-regexp-grouping-backslash ((,class (:weight bold :inherit unspecified))))
   `(font-lock-regexp-grouping-construct ((,class (:weight bold :inherit nil))))
   `(font-lock-string-face ((,class ,string)))
   `(font-lock-type-face ((,class (:weight normal :foreground "#7CB8BB"))))
   `(font-lock-variable-name-face ((,class (:weight normal :foreground "#DFAF8F")))) ; #800080
   `(font-lock-warning-face ((,class (:weight bold :foreground "#E89393"))))

   ;; Button and link faces.
   `(link ((,class ,link)))
   `(link-visited ((,class (:underline t :foreground "#DC8CC3"))))
   `(button ((,class (:underline t :foreground "#8CD0D3"))))
   `(header-line ((,class (:box (:line-width 1 :color "#2B2B2B") :foreground "#F0DFAF" :background "#2B2B2B"))))

   ;; Gnus faces.
   `(gnus-button ((,class (:weight normal))))
   `(gnus-cite-attribution-face ((,class (:foreground "#B3B3D1"))))
   `(gnus-cite-1 ((,class (:foreground "#B3B3D1" :background "#474742"))))
   `(gnus-cite-2 ((,class (:foreground "#EAB8EA" :background "#474742"))))
   `(gnus-cite-3 ((,class (:foreground "#B8EAEA" :background "#474742"))))
   `(gnus-cite-4 ((,class (:foreground "#E9B5B5" :background "#474742"))))
   `(gnus-cite-5 ((,class (:foreground "#B5B5E9" :background "#474742"))))
   `(gnus-cite-6 ((,class (:foreground "#E8CEAE" :background "#474742"))))
   `(gnus-cite-7 ((,class (:foreground "#B3B3D1" :background "#474742"))))
   `(gnus-cite-8 ((,class (:foreground "#EAB8EA" :background "#474742"))))
   `(gnus-cite-9 ((,class (:foreground "#B8EAEA" :background "#474742"))))
   `(gnus-cite-10 ((,class (:foreground "#E9B5B5" :background "#474742"))))
   `(gnus-emphasis-bold ((,class (:weight bold))))
   `(gnus-emphasis-highlight-words ((,class (:foreground "#E4E4A1" :background "#696963"))))
   `(gnus-group-mail-1 ((,class (:weight bold :foreground "#DF92BC"))))
   `(gnus-group-mail-1-empty ((,class (:foreground "#B3B3D1"))))
   `(gnus-group-mail-2 ((,class (:weight bold :foreground "#E4A1BC"))))
   `(gnus-group-mail-2-empty ((,class (:foreground "#EAB8EA"))))
   `(gnus-group-mail-3 ((,class ,mail-unread)))
   `(gnus-group-mail-3-empty ((,class ,mail-read)))
   `(gnus-group-mail-low ((,class ,cancel)))
   `(gnus-group-mail-low-empty ((,class ,cancel)))
   `(gnus-group-news-1 ((,class (:weight bold :foreground "#DF92BC"))))
   `(gnus-group-news-1-empty ((,class (:foreground "#B3B3D1"))))
   `(gnus-group-news-2 ((,class (:weight bold :foreground "#E4A1BC"))))
   `(gnus-group-news-2-empty ((,class (:foreground "#EAB8EA"))))
   `(gnus-group-news-3 ((,class ,mail-unread)))
   `(gnus-group-news-3-empty ((,class ,mail-read)))
   `(gnus-group-news-4 ((,class (:weight bold :foreground "#E4A1A1"))))
   `(gnus-group-news-4-empty ((,class (:foreground "#E9B5B5"))))
   `(gnus-group-news-5 ((,class (:weight bold :foreground "#E4A1C9"))))
   `(gnus-group-news-5-empty ((,class (:foreground "#B5B5E9"))))
   `(gnus-group-news-6 ((,class (:weight bold :foreground "#A8A895"))))
   `(gnus-group-news-6-empty ((,class (:foreground "#A8A894"))))
   `(gnus-header-content ((,class ,mail-header-other)))
   `(gnus-header-from ((,class (:family "Sans Serif" :foreground "#E3E3DD"))))
   `(gnus-header-name ((,class ,mail-header-name)))
   `(gnus-header-newsgroups ((,class (:family "Sans Serif" :foreground "#AEC9D6"))))
   `(gnus-header-subject ((,class ,subject)))
   `(gnus-picon ((,class (:foreground "#E4E4A1" :background "#444440"))))
   `(gnus-picon-xbm ((,class (:foreground "#E4E4A1" :background "#444440"))))
   `(gnus-server-closed ((,class (:slant italic :foreground "#A1A1E4" :background "#444440"))))
   `(gnus-server-denied ((,class (:weight bold :foreground "#E4A1A1" :background "#444440"))))
   `(gnus-server-opened ((,class (:family "Sans Serif" :foreground "#6B6B57" :foreground "#A8B4D5"))))
   `(gnus-signature ((,class (:slant italic :foreground "#A1A18C"))))
   `(gnus-splash ((,class (:foreground "#E4C6A1"))))
   `(gnus-summary-cancelled ((,class ,cancel)))
   `(gnus-summary-high-ancient ((,class ,mail-unread-high)))
   `(gnus-summary-high-read ((,class ,mail-read-high)))
   `(gnus-summary-high-ticked ((,class ,mail-ticked)))
   `(gnus-summary-high-unread ((,class ,mail-unread-high)))
   `(gnus-summary-low-ancient ((,class (:slant italic :foreground "#E3E3DD"))))
   `(gnus-summary-low-read ((,class (:slant italic :foreground "#9A9A84" :background "#4C4C48"))))
   `(gnus-summary-low-ticked ((,class ,mail-ticked)))
   `(gnus-summary-low-unread ((,class (:slant italic :foreground "#E3E3DD"))))
   `(gnus-summary-normal-ancient ((,class ,mail-read)))
   `(gnus-summary-normal-read ((,class ,mail-read)))
   `(gnus-summary-normal-ticked ((,class ,mail-ticked)))
   `(gnus-summary-normal-unread ((,class ,mail-unread)))
   `(gnus-summary-selected ((,class (:foreground "#6B6B57" :background "#3B647A"))))
   `(gnus-x-face ((,class (:foreground "#E3E3DD" :background "#444440"))))

   ;; Message faces.
   `(message-header-name ((,class ,mail-header-name)))
   `(message-header-cc ((,class ,mail-to)))
   `(message-header-other ((,class ,mail-header-other)))
   `(message-header-subject ((,class ,subject)))
   `(message-header-to ((,class ,mail-to)))
   `(message-cited-text ((,class (:foreground "#B3B3D1" :background "#474742"))))
   `(message-separator ((,class (:family "Sans Serif" :weight normal :foreground "#82826B"))))
   `(message-header-newsgroups ((,class (:family "Sans Serif" :foreground "#AEC9D6"))))
   `(message-header-xheader ((,class ,mail-header-other)))
   `(message-mml ((,class (:foreground "#BCDDBC"))))

   ;; ANSI colors.
   `(ansi-color-bold ((,class (:weight bold))))
   `(ansi-color-black ((,class (:foreground "#2B2B2B" :background "#2B2B2B"))))
   `(ansi-color-red ((,class (:foreground "#CC9393" :background "#CC9393"))))
   `(ansi-color-green ((,class (:foreground "#7F9F7F" :background "#7F9F7F"))))
   `(ansi-color-yellow ((,class (:foreground "#F0DFAF" :background "#F0DFAF"))))
   `(ansi-color-blue ((,class (:foreground "#6CA0A3" :background "#6CA0A3"))))
   `(ansi-color-magenta ((,class (:foreground "#DC8CC3" :background "#DC8CC3"))))
   `(ansi-color-cyan ((,class (:foreground "#93E0E3" :background "#93E0E3"))))
   `(ansi-color-white ((,class (:foreground "#DCDCCC" :background "#DCDCCC"))))
   `(ansi-color-bright-black ((,class (:foreground "#6F6F6F" :background "#6F6F6F"))))
   `(ansi-color-bright-red ((,class (:foreground "#DCA3A3" :background "#DCA3A3"))))
   `(ansi-color-bright-green ((,class (:foreground "#BFEBBF" :background "#BFEBBF"))))
   `(ansi-color-bright-yellow ((,class (:foreground "#FFFFEF" :background "#FFFFEF"))))
   `(ansi-color-bright-blue ((,class (:foreground "#94BFF3" :background "#94BFF3"))))
   `(ansi-color-bright-magenta ((,class (:foreground "#EC93D3" :background "#EC93D3"))))
   `(ansi-color-bright-cyan ((,class (:foreground "#ACE0E3" :background "#ACE0E3"))))
   `(ansi-color-bright-white ((,class (:foreground "#FFFFEF" :background "#FFFFEF"))))

   ;; Diff.
   `(diff-added ((,class ,diff-added)))
   `(diff-changed ((,class ,diff-changed)))
   `(diff-context ((,class ,diff-none)))
   `(diff-file-header ((,class ,diff-header)))
   `(diff-file1-hunk-header ((,class (:foreground "#EAB8EA" :background "#3C494D"))))
   `(diff-file2-hunk-header ((,class (:foreground "#C0DBC0" :background "#3C494D"))))
   `(diff-function ((,class (:foreground "#C8A3C8"))))
   `(diff-header ((,class ,diff-header)))
   `(diff-hunk-header ((,class ,diff-hunk-header)))
   `(diff-index ((,class ,diff-header)))
   `(diff-indicator-added ((,class (:foreground "#BAD6BA" :background "#31673D"))))
   `(diff-indicator-changed ((,class (:background "#314B65"))))
   `(diff-indicator-removed ((,class (:foreground "#D6AEAE" :background "#653137"))))
   `(diff-refine-added ((,class ,diff-refine-added)))
   `(diff-refine-change ((,class (:background "#313165"))))
   `(diff-refine-removed ((,class ,diff-refine-removed)))
   `(diff-removed ((,class ,diff-removed)))

   ;; SMerge.
   `(smerge-mine ((,class ,diff-changed)))
   `(smerge-other ((,class ,diff-added)))
   `(smerge-base ((,class ,diff-removed)))
   `(smerge-markers ((,class (:background "#674B31"))))
   `(smerge-refined-change ((,class (:background "#333369"))))

   ;; Ediff.
   `(ediff-current-diff-A ((,class (:background "#653131"))))
   `(ediff-current-diff-B ((,class (:background "#316531"))))
   `(ediff-current-diff-C ((,class (:background "#397777"))))
   `(ediff-even-diff-A ((,class (:background "#50504B"))))
   `(ediff-even-diff-B ((,class (:background "#50504B"))))
   `(ediff-fine-diff-A ((,class (:background "#693333"))))
   `(ediff-fine-diff-B ((,class (:background "#367036"))))
   `(ediff-odd-diff-A ((,class (:background "#50504B"))))
   `(ediff-odd-diff-B ((,class (:background "#50504B"))))

   ;; Flyspell.
   (if (version< emacs-version "24.4")
       `(flyspell-duplicate ((,class (:underline "#D7D191" :inherit unspecified))))
     `(flyspell-duplicate ((,class (:underline (:style wave :color "#D7D191") :background "#605D35" :inherit nil)))))
   (if (version< emacs-version "24.4")
       `(flyspell-incorrect ((,class (:underline "#D68987" :inherit nil))))
     `(flyspell-incorrect ((,class (:underline (:style wave :color "#D68987") :background "#563A3D":inherit nil)))))

   ;; ;; Semantic faces.
   ;; `(semantic-decoration-on-includes ((,class (:underline ,cham-4))))
   ;; `(semantic-decoration-on-private-members-face ((,class (:background ,alum-2))))
   ;; `(semantic-decoration-on-protected-members-face ((,class (:background ,alum-2))))
   `(semantic-decoration-on-unknown-includes ((,class (:background "#633030"))))
   ;; `(semantic-decoration-on-unparsed-includes ((,class (:underline ,orange-3))))
   `(semantic-highlight-func-current-tag-face ((,class ,highlight-current-tag)))
   `(semantic-tag-boundary-face ((,class (:overline "#ACAC9A")))) ; Method separator.
   ;; `(semantic-unmatched-syntax-face ((,class (:underline ,red-1))))

   `(Info-title-1-face ((,class ,ol1)))
   `(Info-title-2-face ((,class ,ol2)))
   `(Info-title-3-face ((,class ,ol3)))
   `(Info-title-4-face ((,class ,ol4)))
   `(ace-jump-face-foreground ((,class (:weight bold :foreground "#E3E3DD" :background "#776239"))))
   `(ahs-face ((,class (:background "#303065"))))
   `(ahs-definition-face ((,class (:background "#68323E"))))
   `(ahs-plugin-default-face ((,class (:background "#653065")))) ; Current.
   `(anzu-match-1 ((,class (:foreground "#E3E3DD" :background "#346D5A"))))
   `(anzu-match-2 ((,class (:foreground "#E3E3DD" :background "#397758"))))
   `(anzu-match-3 ((,class (:foreground "#E3E3DD" :background "#773939"))))
   `(anzu-mode-line ((,class (:foreground "#E3E3DD" :background "#346D34"))))
   `(anzu-mode-line-no-match ((,class (:foreground "#E3E3DD" :background "#6D3434"))))
   `(anzu-replace-highlight ((,class (:inherit query-replace))))
   `(anzu-replace-to ((,class (:weight bold :foreground "#C998E0" :background "#726038"))))
   `(auto-dim-other-buffers-face ((,class (:background "#464642"))))
   `(avy-background-face ((,class (:background "#5A5A55"))))
   `(avy-lead-face ((,class (:weight bold :foreground "#E3E3DD" :background "#75753B"))))
   `(avy-lead-face-0 ((,class (:weight bold :foreground "#6B6B57" :background "#5B7543"))))
   `(bbdb-company ((,class (:slant italic :foreground "#B4C4D2"))))
   `(bbdb-field-name ((,class (:weight bold :foreground "#B4C4D2"))))
   `(bbdb-field-value ((,class (:foreground "#B4C4D2"))))
   `(bbdb-name ((,class (:underline t :foreground "#E1AA97"))))
   `(bmkp-light-autonamed ((,class (:background "#484844"))))
   `(bmkp-light-fringe-autonamed ((,class (:foreground "#BCBCAD" :background "#4F4F4B"))))
   `(bmkp-light-fringe-non-autonamed ((,class (:foreground "#D8D87A" :background "#397776")))) ; default
   `(bmkp-light-non-autonamed ((,class (:background "#326867"))))
   `(bmkp-no-local ((,class (:background "#68323B"))))
   `(browse-kill-ring-separator-face ((,class (:foreground "#E4A1A1"))))
   `(calendar-month-header ((,class (:weight bold :foreground "#DCD6C5" :background "#676731"))))
   `(calendar-today ((,class (:weight bold :foreground "#DCD6C5" :background "#676731"))))
   `(calendar-weekday-header ((,class (:weight bold :foreground "#B3CAE0"))))
   `(calendar-weekend-header ((,class (:weight bold :foreground "#C3C3B5"))))
   `(cfw:face-annotation ((,class (:foreground "#A1E4A1" :background "#773939"))))
   `(cfw:face-day-title ((,class (:foreground "#7D7D67"))))
   `(cfw:face-default-content ((,class (:foreground "#B7C3DB"))))
   `(cfw:face-default-day ((,class (:weight bold))))
   `(cfw:face-disable ((,class (:foreground "#919179"))))
   `(cfw:face-grid ((,class (:foreground "#70705C"))))
   `(cfw:face-header ((,class (:foreground "#B3CAE0" :background "#444440" :weight bold))))
   `(cfw:face-holiday ((,class (:foreground "#ACAC9A" :background "#323F62"))))
   `(cfw:face-periods ((,class (:foreground "#6B6B57" :background "#404B62" :slant italic))))
   `(cfw:face-saturday ((,class (:foreground "#C3C3B5" :background "#444440" :weight bold))))
   `(cfw:face-select ((,class (:foreground "#9EBAD9" :background "#384154"))))
   `(cfw:face-sunday ((,class (:foreground "#C3C3B5" :background "#444440" :weight bold))))
   `(cfw:face-title ((,class (:height 2.0 :foreground "#B5B5A5" :weight bold :inherit variable-pitch))))
   `(cfw:face-today ((,class (:foreground "#DCD6C5" :background "#676731"))))
   `(cfw:face-today-title ((,class (:foreground "#6B6B57" :background "#415A72"))))
   `(cfw:face-toolbar ((,class (:background "#444440"))))
   `(cfw:face-toolbar-button-off ((,class (:foreground "#797963" :background "#444440"))))
   `(cfw:face-toolbar-button-on ((,class (:foreground "#BABAAB" :background "#474742"))))
   `(change-log-date ((,class (:foreground "#C7A2DE"))))
   `(change-log-file ((,class (:weight bold :foreground "#B0C2D3"))))
   `(change-log-list ((,class (:foreground "#E3E3DD" :background "#3A6658"))))
   `(change-log-name ((,class (:foreground "#B8EAB8"))))
   `(circe-highlight-all-nicks-face ((,class (:foreground "#A1A1E4" :background "#484844")))) ; other nick names
   `(circe-highlight-nick-face ((,class (:foreground "#B6EAB6" :background "#484844")))) ; messages with my nick cited
   `(circe-my-message-face ((,class (:foreground "#A2A28D" :background "#484844"))))
   `(circe-originator-face ((,class (:foreground "#A1A1E4"))))
   `(circe-prompt-face ((,class (:foreground "#E4A1A1"))))
   `(circe-server-face ((,class (:foreground "#9ABACC"))))

   ;; `(ac-selection-face ((,class ,completion-selected-candidate)))
   `(ac-selection-face ((,class (:weight bold :foreground "#6B6B57" :background "#776139")))) ; TEMP For diff'ing AC from Comp.
   `(ac-candidate-face ((,class ,completion-other-candidates)))
   `(ac-completion-face ((,class ,completion-inline)))
   `(ac-candidate-mouse-face ((,class (:inherit highlight))))
   `(popup-scroll-bar-background-face ((,class (:background "#324861"))))
   `(popup-scroll-bar-foreground-face ((,class (:background "#3F464E")))) ; Scrollbar (visible).

   ;; Company.
   `(company-tooltip-common-selection ((,class (:weight bold :foreground "#B0D2E6" :inherit company-tooltip-selection)))) ; Prefix + common part in tooltip (for selection).
   `(company-tooltip-selection ((,class ,completion-selected-candidate))) ; Suffix in tooltip (for selection).
   `(company-tooltip-annotation-selection ((,class (:weight bold :foreground "#A7A793")))) ; Annotation (for selection).
   `(company-tooltip-common ((,class (:weight normal :foreground "#B0D2E6" :inherit company-tooltip)))) ; Prefix + common part in tooltip.
   `(company-tooltip ((,class ,completion-other-candidates))) ; Suffix in tooltip.
   `(company-tooltip-annotation ((,class (:weight normal :foreground "#A7A793")))) ; Annotation.
   `(company-preview ((,class ,completion-inline)))
   `(company-preview-common ((,class ,completion-inline)))
   `(company-scrollbar-bg ((,class (:background "#324861"))))
   `(company-scrollbar-fg ((,class (:background "#3F464E")))) ; Scrollbar (visible).

   ;; Centaur Tabs
   ;; With the addition of tab-mode, centaur tabs looks there first for how the tabline should look
   (if (version<= "27.0" emacs-version)
       `(tab-line ((t (:background ,"#4A4D5A" :foreground ,"#B5BCD2")))))
   `(centaur-tabs-default ((t (:background ,"#465266" :foreground ,"#6B6B57" :box nil))))
   `(centaur-tabs-background-color ((t (:background ,"#4A4D5A" :foreground ,"#B5BCD2" :box nil))))
   `(centaur-tabs-active-bar-face ((t (:background ,"#465266" :foreground ,"#6B6B57"  :box nil))))
   `(centaur-tabs-selected ((t (:foreground ,"#D1D1C7" :background ,"#675638" :box nil))))
   `(centaur-tabs-unselected ((t (:foreground ,"#6B6B57" :background ,"#4B5262" :box nil))))
   `(centaur-tabs-selected-modified ((t (:foreground ,"#D1D1C7" :background ,"#675638" :weight ,'bold :box nil))))
   `(centaur-tabs-unselected-modified ((t (:foreground ,"#6B6B57" :background ,"#4B5262" :weight ,'bold :box nil))))
   `(centaur-tabs-modified-marker-selected ((t (:foreground ,"#D1D1C7" :background ,"#675638" :weight ,'bold :box nil))))
   `(centaur-tabs-modified-marker-unselected ((t (:foreground ,"#6B6B57" :background ,"#4B5262" :weight ,'bold :box nil))))

   ;; doom-modeline
   `(doom-modeline-bar ((t (:background ,"#4A4D5A"))))
   `(doom-modeline-info ((t (:inherit ,'mode-line-emphasis))))
   `(doom-modeline-urgent ((t (:inherit ,'mode-line-emphasis))))
   `(doom-modeline-warning ((t (:inherit ,'mode-line-emphasis))))
   `(doom-modeline-debug ((t (:inherit ,'mode-line-emphasis))))
   `(doom-modeline-buffer-minor-mode ((t (:inherit ,'mode-line-emphasis :weight ,'bold))))
   `(doom-modeline-project-dir ((t (:inherit ,'mode-line-emphasis :weight ,'bold))))
   `(doom-modeline-project-parent-dir ((t (:inherit ,'mode-line-emphasis :weight ,'bold))))
   `(doom-modeline-persp-name ((t (:inherit ,'mode-line-emphasis :weight ,'bold))))
   `(doom-modeline-buffer-file ((t (:inherit ,'mode-line-emphasis :weight ,'bold))))
   `(doom-modeline-buffer-modified ((t (:inherit ,'mode-line-emphasis :weight ,'bold))))
   `(doom-modeline-lsp-success ((t (:inherit ,'mode-line-emphasis :weight ,'bold))))
   `(doom-modeline-buffer-path ((t (:inherit ,'mode-line-emphasis :weight ,'bold))))
   `(doom-modeline-buffer-project-root ((t (:inherit ,'mode-line-emphasis))))

   `(compare-windows ((,class (:background "#777739"))))
   ;; `(completions-common-part ((,class (:foreground "#E4A1A1" :weight bold))))
   ;; `(completions-first-difference ((,class (:foreground "#A1E4A1" :weight bold))))
   `(compilation-error ((,class (:weight bold :foreground "#E4A1A1")))) ; Used for grep error messages.
   `(compilation-info ((,class (:weight bold :foreground "#A5B0D1"))))
   `(compilation-line-number ((,class ,grep-line-number)))
   `(compilation-warning ((,class (:weight bold :foreground "#E4CCA1"))))
   `(compilation-mode-line-exit ((,class (:weight bold :foreground "#A1E4A1")))) ; :exit[matched]
   `(compilation-mode-line-fail ((,class (:weight bold :foreground "#D495D4")))) ; :exit[no match]
   `(compilation-mode-line-run ((,class (:weight bold :foreground "#E4CCA1")))) ; :run
   `(css-property ((,class (:foreground "#B2E9B2"))))
   `(css-selector ((,class (:weight bold :foreground "#A1A1E4"))))
   `(custom-button ((,class (:box (:line-width 2 :style released-button) :foreground "#E3E3DD" :background "#50504B"))))
   `(custom-button-mouse ((,class (:box (:line-width 2 :style released-button) :foreground "#E3E3DD" :background "#4B4B47"))))
   `(custom-button-pressed ((,class (:box (:line-width 2 :style pressed-button) :foreground "#E3E3DD" :background "#50504B"))))
   `(custom-button-pressed-unraised ((,class (:underline t :foreground "#EAB8EA"))))
   `(custom-button-unraised ((,class (:underline t))))
   `(custom-changed ((,class (:foreground "#6B6B57" :background "#393977"))))
   `(custom-comment ((,class (:background "#4E4E4A"))))
   `(custom-comment-tag ((,class (:foreground "#B8B8EA"))))
   `(custom-documentation ((,class (nil))))
   `(custom-face-tag ((,class (:family "Sans Serif" :height 1.2 :weight bold))))
   `(custom-group-tag ((,class (:height 1.2 :weight bold :foreground "#A1A1E4"))))
   `(custom-group-tag-1 ((,class (:family "Sans Serif" :height 1.2 :weight bold :foreground "#E4A1A1"))))
   `(custom-invalid ((,class (:foreground "#E4E4A1" :background "#773939"))))
   `(custom-link ((,class (:underline t :foreground "#A1A1E4"))))
   `(custom-modified ((,class (:foreground "#6B6B57" :background "#393977"))))
   `(custom-rogue ((,class (:foreground "#D97C8C" :background "#696963"))))
   `(custom-saved ((,class (:underline t))))
   `(custom-set ((,class (:foreground "#A1A1E4" :background "#444440"))))
   `(custom-state ((,class (:foreground "#B8EAB8"))))
   `(custom-themed ((,class (:foreground "#6B6B57" :background "#393977"))))
   `(custom-variable-button ((,class (:weight bold :underline t))))
   `(custom-variable-tag ((,class (:family "Sans Serif" :height 1.2 :weight bold :foreground "#A1A1E4"))))
   `(custom-visibility ((,class ,link)))
   `(diff-hl-change ((,class (:foreground "#ABABE7" :background "#314B65"))))
   `(diff-hl-delete ((,class (:foreground "#E7ABAB" :background "#653137"))))
   `(diff-hl-dired-change ((,class (:weight bold :foreground "#E3E3DD" :background "#735837"))))
   `(diff-hl-dired-delete ((,class (:weight bold :foreground "#DFB4AB"))))
   `(diff-hl-dired-ignored ((,class (:weight bold :foreground "#6B6B57" :background "#514E42"))))
   `(diff-hl-dired-insert ((,class (:weight bold :foreground "#88886F"))))
   `(diff-hl-dired-unknown ((,class (:foreground "#6B6B57" :background "#474664"))))
   `(diff-hl-insert ((,class (:foreground "#B8EAB8" :background "#31673D"))))
   `(diff-hl-unknown ((,class (:foreground "#6B6B57" :background "#474664"))))
   `(diary-face ((,class (:foreground "#8AB7DA"))))
   `(dircolors-face-asm ((,class (:foreground "#E3E3DD"))))
   `(dircolors-face-backup ((,class (:foreground "#E3E3DD"))))
   `(dircolors-face-compress ((,class (:foreground "#E4A1A1"))))
   `(dircolors-face-dir ((,class ,directory)))
   `(dircolors-face-doc ((,class (:foreground "#E3E3DD"))))
   `(dircolors-face-dos ((,class (:foreground "#BCDDBC"))))
   `(dircolors-face-emacs ((,class (:foreground "#E3E3DD"))))
   `(dircolors-face-exec ((,class (:foreground "#BCDDBC"))))
   `(dircolors-face-html ((,class (:foreground "#E3E3DD"))))
   `(dircolors-face-img ((,class (:foreground "#E7ABE7"))))
   `(dircolors-face-lang ((,class (:foreground "#E3E3DD"))))
   `(dircolors-face-lang-interface ((,class (:foreground "#E3E3DD"))))
   `(dircolors-face-make ((,class (:foreground "#E3E3DD"))))
   `(dircolors-face-objet ((,class (:foreground "#E3E3DD"))))
   `(dircolors-face-package ((,class (:foreground "#E3E3DD"))))
   `(dircolors-face-paddb ((,class (:foreground "#E3E3DD"))))
   `(dircolors-face-ps ((,class (:foreground "#E3E3DD"))))
   `(dircolors-face-sound ((,class (:foreground "#A1D3E4"))))
   `(dircolors-face-tar ((,class (:foreground "#E4A1A1"))))
   `(dircolors-face-text ((,class (:foreground "#E3E3DD"))))
   `(dircolors-face-yacc ((,class (:foreground "#E3E3DD"))))
   `(dired-directory ((,class ,directory)))
   `(dired-header ((,class ,directory)))
   `(dired-ignored ((,class (:strike-through t :foreground "#E4A1A1"))))
   `(dired-mark ((,class ,marked-line)))
   `(dired-marked ((,class ,marked-line)))
   `(dired-symlink ((,class ,symlink)))
   `(diredfl-compressed-file-suffix ((,class (:foreground "#E3E3DD" :background "#6C6734"))))
   `(diredp-compressed-file-suffix ((,class (:foreground "#E4A1A1"))))
   `(diredp-date-time ((,class (:foreground "#C7A2DE"))))
   `(diredp-dir-heading ((,class ,directory)))
   `(diredp-dir-name ((,class ,directory)))
   `(diredp-dir-priv ((,class ,directory)))
   `(diredp-exec-priv ((,class (:background "#3C7B4F"))))
   `(diredp-executable-tag ((,class (:foreground "#BCDDBC" :background "#444440"))))
   `(diredp-file-name ((,class ,file)))
   `(diredp-file-suffix ((,class (:foreground "#83836B"))))
   `(diredp-flag-mark-line ((,class ,marked-line)))
   `(diredp-ignored-file-name ((,class ,shadow)))
   `(diredp-read-priv ((,class (:background "#395D76"))))
   `(diredp-write-priv ((,class (:foreground "#6B6B57" :background "#723737"))))
   `(eldoc-highlight-function-argument ((,class (:weight bold :foreground "#E4A1A1" :background "#653065"))))
   `(elfeed-search-filter-face ((,class (:foreground "#85856D"))))
   ;; `(eww-form-checkbox ((,class ())))
   ;; `(eww-form-select ((,class ())))
   ;; `(eww-form-submit ((,class ())))
   `(eww-form-text ((,class (:weight bold :foreground "#C0CDD9" :background "#394D60"))))
   ;; `(eww-form-textarea ((,class ())))
   `(file-name-shadow ((,class ,shadow)))
   `(flycheck-error ((,class (:underline (:color "#E29E9C" :style wave) :weight bold :background "#653131"))))
   `(flycheck-error-list-line-number ((,class (:foreground "#D4B5D7"))))
   `(flycheck-fringe-error ((,class (:foreground "#E29E9C"))))
   `(flycheck-fringe-info ((,class (:foreground "#BBE2BB"))))
   `(flycheck-fringe-warning ((,class (:foreground "#DDC39C"))))
   `(flycheck-info ((,class (:underline (:color "#BBE2BB" :style wave) :weight bold))))
   `(flycheck-warning ((,class (:underline (:color "#DDC39C" :style wave) :weight bold :background "#686832"))))
   `(font-latex-bold-face ((,class (:weight bold :foreground "#E3E3DD"))))
   `(fancy-narrow-blocked-face ((,class (:foreground "#979780"))))
   `(flycheck-color-mode-line-error-face ((, class (:background "#624342"))))
   `(flycheck-color-mode-line-warning-face ((, class (:background "#796F3A"))))
   `(flycheck-color-mode-line-info-face ((, class (:background "#777739"))))
   `(font-latex-italic-face ((,class (:slant italic :foreground "#DFDFD7"))))
   `(font-latex-math-face ((,class (:foreground "#A1A1E4"))))
   `(font-latex-sectioning-1-face ((,class (:family "Sans Serif" :height 2.7 :weight bold :foreground "#99AFD7"))))
   `(font-latex-sectioning-2-face ((,class ,ol1)))
   `(font-latex-sectioning-3-face ((,class ,ol2)))
   `(font-latex-sectioning-4-face ((,class ,ol3)))
   `(font-latex-sectioning-5-face ((,class ,ol4)))
   `(font-latex-sedate-face ((,class (:foreground "#E4B7A1"))))
   `(font-latex-string-face ((,class (:weight bold :foreground "#A1BCE4"))))
   `(font-latex-verbatim-face ((,class (:foreground "#B8B8EA" :background "#656531" :inherit nil))))
   `(git-commit-summary-face ((,class (:foreground "#E3E3DD"))))
   `(git-commit-comment-face ((,class (:slant italic :foreground "#B4B4A3"))))
   `(git-timemachine-commit ((,class ,diff-removed)))
   `(git-timemachine-minibuffer-author-face ((,class ,diff-added)))
   `(git-timemachine-minibuffer-detail-face ((,class ,diff-header)))
   `(google-translate-text-face ((,class (:foreground "#ACAC9A" :background "#474743"))))
   `(google-translate-phonetic-face ((,class (:inherit shadow))))
   `(google-translate-translation-face ((,class (:weight normal :foreground "#A1B8DC" :background "#3D454E"))))
   `(google-translate-suggestion-label-face ((,class (:foreground "#E4A1A1"))))
   `(google-translate-suggestion-face ((,class (:slant italic :underline t))))
   `(google-translate-listen-button-face ((,class (:height 0.8))))
   `(helm-action ((,class (:foreground "#E3E3DD"))))
   `(helm-bookmark-file ((,class ,file)))
   `(helm-bookmarks-su-face ((,class (:foreground "#E4A1A1"))))
   `(helm-buffer-directory ((,class ,directory)))
   ;; `(helm-non-file-buffer ((,class (:slant italic :foreground "#A1A1E4"))))
   ;; `(helm-buffer-file ((,class (:foreground "#D1D1C7"))))
   `(helm-buffer-modified ((,class (:slant italic :foreground "#D6B3D0"))))
   `(helm-buffer-process ((,class (:foreground "#B8EAB8"))))
   `(helm-candidate-number ((,class (:foreground "#E3E3DD" :background "#6F6F35"))))
   `(helm-dir-heading ((,class (:foreground "#A1A1E4" :background "#68323B"))))
   `(helm-dir-priv ((,class (:foreground "#EAB8B8" :background "#50504B"))))
   `(helm-ff-directory ((,class ,directory)))
   `(helm-ff-dotted-directory ((,class ,directory)))
   `(helm-ff-executable ((,class (:foreground "#ABE7AB" :background "#444440"))))
   `(helm-ff-file ((,class (:foreground "#E3E3DD"))))
   `(helm-ff-invalid-symlink ((,class (:foreground "#E4E4A1" :background "#773939"))))
   `(helm-ff-symlink ((,class ,symlink)))
   `(helm-file-name ((,class (:foreground "#A1A1E4"))))
   `(helm-gentoo-match-face ((,class (:foreground "#E4A1A1"))))
   `(helm-grep-file ((,class ,grep-file-name)))
   `(helm-grep-lineno ((,class ,grep-line-number)))
   `(helm-grep-match ((,class ,match)))
   `(helm-grep-running ((,class (:weight bold :foreground "#6B6B57"))))
   `(helm-isearch-match ((,class (:background "#316731"))))
   `(helm-lisp-show-completion ((,class ,volatile-highlight-supersize))) ; See `helm-dabbrev'.
   ;; `(helm-ls-git-added-copied-face ((,class (:foreground ""))))
   ;; `(helm-ls-git-added-modified-face ((,class (:foreground ""))))
   ;; `(helm-ls-git-conflict-face ((,class (:foreground ""))))
   ;; `(helm-ls-git-deleted-and-staged-face ((,class (:foreground ""))))
   ;; `(helm-ls-git-deleted-not-staged-face ((,class (:foreground ""))))
   ;; `(helm-ls-git-modified-and-staged-face ((,class (:foreground ""))))
   `(helm-ls-git-modified-not-staged-face ((,class (:foreground "#D6B3D0"))))
   ;; `(helm-ls-git-renamed-modified-face ((,class (:foreground ""))))
   ;; `(helm-ls-git-untracked-face ((,class (:foreground ""))))
   `(helm-match ((,class ,match)))
   `(helm-moccur-buffer ((,class (:foreground "#ABC9E7"))))
   `(helm-selection ((,class (:background "#4C6672" :foreground "#FFFFEF"))))
   `(helm-selection-line ((,class ,highlight-gray))) ; ???
   `(helm-separator ((,class (:foreground "#E4A1A1"))))
   `(helm-source-header ((,class (:weight bold :box (:line-width 1 :color "#7F7F68") :background "#4D4D48" :foreground "#E3E3DD"))))
   `(helm-swoop-target-line-block-face ((,class (:background "#7B7B3B" :foreground "#DADAD2"))))
   `(helm-swoop-target-line-face ((,class (:background "#313167"))))
   `(helm-swoop-target-word-face ((,class (:weight bold :foreground unspecified :background "#726038"))))
   `(helm-visible-mark ((,class ,marked-line)))
   `(helm-w3m-bookmarks-face ((,class (:underline t :foreground "#A1E4E4"))))
   `(highlight-changes ((,class (:foreground unspecified)))) ;; blue "#2E08B5"
   `(highlight-changes-delete ((,class (:strike-through nil :foreground unspecified)))) ;; red "#B5082E"
   `(highlight-symbol-face ((,class (:background "#6A6A33"))))
   `(hl-line ((,class ,highlight-yellow))) ; Highlight current line.
   `(hl-tags-face ((,class ,highlight-current-tag))) ; ~ Pair highlighting (matching tags).
   `(holiday-face ((,class (:foreground "#ACAC9A" :background "#323F62"))))
   `(html-helper-bold-face ((,class (:weight bold :foreground "#E3E3DD"))))
   `(html-helper-italic-face ((,class (:slant italic :foreground "#E3E3DD"))))
   `(html-helper-underline-face ((,class (:underline t :foreground "#E3E3DD"))))
   `(html-tag-face ((,class (:foreground "#A1A1E4"))))
   `(ilog-non-change-face ((,class (:height 2.0 :foreground "#C5B8D7"))))
   `(ilog-change-face ((,class (:height 2.0 :foreground "#B8EAB8"))))
   `(ilog-echo-face ((,class (:height 2.0 :foreground "#A7C6E5"))))
   `(ilog-load-face ((,class (:foreground "#D6B3D0"))))
   `(ilog-message-face ((,class (:foreground "#A8A894"))))
   `(image-dired-thumb-flagged ((,class (:background "#773939"))))
   `(image-dired-thumb-mark ((,class :background "#693333")))
   `(indent-guide-face ((,class (:foreground "#777761"))))
   `(info-file ((,class (:family "Sans Serif" :height 1.8 :weight bold :box (:line-width 1 :color "#ABABE7") :foreground "#99AFD7" :background "#314967"))))
   `(info-header-node ((,class (:underline t :foreground "#E4CCA1")))) ; nodes in header
   `(info-header-xref ((,class (:underline t :foreground "#9BBFE2")))) ; cross references in header
   `(info-index-match ((,class (:weight bold :foreground unspecified :background "#726038")))) ; when using `i'
   `(info-menu-header ((,class ,ol2))) ; menu titles (headers) -- major topics
   `(info-menu-star ((,class (:foreground "#E3E3DD")))) ; every 3rd menu item
   `(info-node ((,class (:underline t :foreground "#A1A1E4")))) ; node names
   `(info-quoted-name ((,class ,code-inline)))
   `(info-string ((,class ,string)))
   `(info-title-1 ((,class ,ol1)))
   `(info-xref ((,class (:underline t :foreground "#B1D3E8")))) ; unvisited cross-references
   `(info-xref-visited ((,class (:underline t :foreground "#EAB8EA")))) ; previously visited cross-references
   ;; js2-highlight-vars-face (~ auto-highlight-symbol)
   `(js2-error ((,class (:box (:line-width 1 :color "#E19696") :background "#673232")))) ; DONE.
   `(js2-external-variable ((,class (:foreground "#E4A1A1" :background "#633030")))) ; DONE.
   `(js2-function-param ((,class ,function-param)))
   `(js2-instance-member ((,class (:foreground "#C9AED7"))))
   `(js2-jsdoc-html-tag-delimiter ((,class (:foreground "#D8B0AD"))))
   `(js2-jsdoc-html-tag-name ((,class (:foreground "#D8B0AD"))))
   `(js2-jsdoc-tag ((,class (:weight normal :foreground "#C5B8D7"))))
   `(js2-jsdoc-type ((,class (:foreground "#B4C4D2"))))
   `(js2-jsdoc-value ((,class (:weight normal :foreground "#D6B3D0")))) ; #800080
   `(js2-magic-paren ((,class (:underline t))))
   `(js2-private-function-call ((,class (:foreground "#DCCEAB"))))
   `(js2-private-member ((,class (:foreground "#C8B5A4"))))
   `(js2-warning ((,class (:underline "#E4CCA1"))))

   ;; Org non-standard faces.
   `(leuven-org-deadline-overdue ((,class (:foreground "#DEA0B0"))))
   `(leuven-org-deadline-today ((,class (:weight bold :foreground "#F0DFAF" :background "#4A4535"))))
   `(leuven-org-deadline-tomorrow ((,class (:foreground "#C4E5B3"))))
   `(leuven-org-deadline-future ((,class (:foreground "#C4E5B3"))))
   `(leuven-gnus-unseen ((,class (:weight bold :foreground "#E3BFA2"))))
   `(leuven-gnus-date ((,class (:foreground "#DD88B2"))))
   `(leuven-gnus-size ((,class (:foreground "#BECFAE"))))
   `(leuven-todo-items-face ((,class (:weight bold :foreground "#ECB3B3" :background "#4D3B3B"))))

   `(light-symbol-face ((,class (:background "#6A6A33"))))
   `(line-number ((,class (:foreground "#6F6F6F" :background "#383838"))))
   `(line-number-current-line ((,class (:weight bold :foreground "#F0DFAF" :background "#383838"))))
   `(linum ((,class (:foreground "#6F6F6F" :background "#383838"))))
   `(log-view-file ((,class (:foreground "#ABABE7" :background "#3C494D"))))
   `(log-view-message ((,class (:foreground "#E3E3DD" :background "#66653B"))))
   `(lsp-modeline-code-actions-preferred-face ((,class (:foreground "#E3E3DD" :background "#6C6734"))))
   `(lsp-ui-doc-background ((,class (:background "#5D6532"))))
   `(lsp-ui-sideline-code-action ((,class (:foreground "#E3E3DD" :background "#6C6734"))))
   `(lui-button-face ((,class ,link)))
   `(lui-highlight-face ((,class (:box (:line-width 1 :color "#E7ABAB") :foreground "#E7ABAB" :background "#6C6C34")))) ; my nickname
   `(lui-time-stamp-face ((,class (:foreground "#C7A2DE"))))
   `(magit-blame-header ((,class (:inherit magit-diff-file-header))))
   `(magit-blame-heading ((,class (:overline "#92927A" :foreground "#E4A1A1" :background "#4B4B46"))))
   `(magit-blame-hash ((,class (:overline "#92927A" :foreground "#E4A1A1" :background "#4B4B46"))))
   `(magit-blame-name ((,class (:overline "#92927A" :foreground "#B9E9BB" :background "#4B4B46"))))
   `(magit-blame-date ((,class (:overline "#92927A" :foreground "#A1A1E4" :background "#4B4B46"))))
   `(magit-blame-summary ((,class (:overline "#92927A" :weight bold :foreground "#B0B09F" :background "#4B4B46"))))
   `(magit-branch ((,class ,vc-branch)))
   `(magit-diff-add ((,class ,diff-added)))
   `(magit-diff-del ((,class ,diff-removed)))
   `(magit-diff-file-header ((,class (:height 1.1 :weight bold :foreground "#B0C2D3"))))
   `(magit-diff-hunk-header ((,class ,diff-hunk-header)))
   `(magit-diff-none ((,class ,diff-none)))
   `(magit-header ((,class (:foreground "#6B6B57" :background "#723737"))))
   `(magit-item-highlight ((,class (:background "#3C494D"))))
   `(magit-item-mark ((,class ,marked-line)))
   `(magit-log-head-label ((,class (:box (:line-width 1 :color "#A1A1E4" :style nil)))))
   `(magit-log-tag-label ((,class (:box (:line-width 1 :color "#ABE7AB" :style nil)))))
   `(magit-section-highlight ((,class (:background  "#5D6532"))))
   `(magit-section-title ((,class (:family "Sans Serif" :height 1.8 :weight bold :foreground "#99AFD7" :inherit nil))))
   `(makefile-space-face ((,class (:background "#6F3552"))))
   `(makefile-targets ((,class (:weight bold :foreground "#A1A1E4"))))
   ;; `(markdown-blockquote-face ((,class ())))
   `(markdown-bold-face ((,class (:inherit bold))))
   ;; `(markdown-comment-face ((,class ())))
   ;; `(markdown-footnote-face ((,class ())))
   ;; `(markdown-header-delimiter-face ((,class ())))
   ;; `(markdown-header-face ((,class ())))
   `(markdown-header-face-1 ((,class ,ol1)))
   `(markdown-header-face-2 ((,class ,ol2)))
   `(markdown-header-face-3 ((,class ,ol3)))
   `(markdown-header-face-4 ((,class ,ol4)))
   `(markdown-header-face-5 ((,class ,ol5)))
   `(markdown-header-face-6 ((,class ,ol6)))
   ;; `(markdown-header-rule-face ((,class ())))
   `(markdown-inline-code-face ((,class ,code-inline)))
   `(markdown-italic-face ((,class (:inherit italic))))
   `(markdown-language-keyword-face ((,class (:inherit org-block-begin-line))))
   ;; `(markdown-line-break-face ((,class ())))
   `(markdown-link-face ((,class ,link-no-underline)))
   ;; `(markdown-link-title-face ((,class ())))
   ;; `(markdown-list-face ((,class ())))
   ;; `(markdown-math-face ((,class ())))
   ;; `(markdown-metadata-key-face ((,class ())))
   ;; `(markdown-metadata-value-face ((,class ())))
   ;; `(markdown-missing-link-face ((,class ())))
   `(markdown-pre-face ((,class (:inherit org-block-background))))
   ;; `(markdown-reference-face ((,class ())))
   ;; `(markdown-strike-through-face ((,class ())))
   `(markdown-url-face ((,class ,link)))
   `(match ((,class ,match)))           ; Used for grep matches.
   `(mc/cursor-bar-face ((,class (:height 1.0 :foreground "#AFC5E0" :background "#405671"))))
   `(mc/cursor-face ((,class (:inverse-video t))))
   `(mc/region-face ((,class (:inherit region))))
   `(mm-uu-extract ((,class ,code-block)))
   `(moccur-current-line-face ((,class (:foreground "#E3E3DD" :background "#676731"))))
   `(moccur-face ((,class (:foreground "#E3E3DD" :background "#6B6B33"))))
   `(next-error ((,class ,volatile-highlight-supersize)))
   `(nobreak-space ((,class (:background "#38505C"))))
   `(nxml-attribute-local-name-face ((,class ,xml-attribute)))
   `(nxml-attribute-value-delimiter-face ((,class (:foreground "#B8EAB8"))))
   `(nxml-attribute-value-face ((,class (:foreground "#B8EAB8"))))
   `(nxml-comment-content-face ((,class (:slant italic :foreground "#E4A1A1"))))
   `(nxml-comment-delimiter-face ((,class (:foreground "#E4A1A1"))))
   `(nxml-element-local-name ((,class ,xml-tag)))
   `(nxml-element-local-name-face ((,class (:foreground "#A1A1E4"))))
   `(nxml-processing-instruction-target-face ((,class (:foreground "#BE98E1"))))
   `(nxml-tag-delimiter-face ((,class (:foreground "#A1A1E4"))))
   `(nxml-tag-slash-face ((,class (:foreground "#A1A1E4"))))
   `(org-agenda-block-count ((,class (:weight bold :foreground "#94947C"))))
   `(org-agenda-calendar-event ((,class (:weight bold :foreground "#AEBED6" :background "#323F62"))))
   `(org-agenda-calendar-sexp ((,class (:foreground "#AEC1D7" :background "#374555"))))
   `(org-agenda-clocking ((,class (:foreground "#E3E3DD" :background "#786F3A"))))
   `(org-agenda-column-dateline ((,class ,column)))
   `(org-agenda-current-time ((,class (:underline t :foreground "#B3CAE0"))))
   `(org-agenda-date ((,class (,@(leuven-zen-scale-font leuven-zen-scale-org-agenda-structure 1.6) :weight bold :foreground "#B3CAE0"))))
   `(org-agenda-date-today ((,class (,@(leuven-zen-scale-font leuven-zen-scale-org-agenda-structure 1.6) :weight bold :foreground "#F0DFAF" :background "#4A4535"))))
   `(org-agenda-date-weekend ((,class (,@(leuven-zen-scale-font leuven-zen-scale-org-agenda-structure 1.6) :weight bold :foreground "#C3C3B5"))))
   `(org-agenda-diary ((,class (:weight bold :foreground "#B8EAB8" :background "#3D5259"))))
   `(org-agenda-dimmed-todo-face ((,class (:foreground "#E5DBA4"))))
   `(org-agenda-done ((,class (:foreground "#BFBFB0"))))
   `(org-agenda-filter-category ((,class (:weight bold :foreground "#E4CCA1"))))
   `(org-agenda-filter-effort ((,class (:weight bold :foreground "#E4CCA1"))))
   `(org-agenda-filter-regexp ((,class (:weight bold :foreground "#E4CCA1"))))
   `(org-agenda-filter-tags ((,class (:weight bold :foreground "#E4CCA1"))))
   `(org-agenda-restriction-lock ((,class (:background "#66453C"))))
   `(org-agenda-structure ((,class (,@(leuven-zen-scale-font leuven-zen-scale-org-agenda-structure 1.6) :weight bold :foreground "#ABC9DC"))))
   `(org-archived ((,class (:foreground "#8C8C72"))))
   `(org-beamer-tag ((,class (:box (:line-width 1 :color "#E1CF9F") :foreground "#D5D5CC" :background "#665E31"))))
   `(org-block ((,class ,code-block)))
   `(org-block-background ((,class (:background "#383834")))) ;; :inherit fixed-pitch))))
   `(org-block-begin-line ((,class (:underline "#5F5F5F" :foreground "#989890" :background "#333330"))))
   `(org-block-end-line ((,class (:overline "#5F5F5F" :foreground "#989890" :background "#333330"))))
   `(org-checkbox ((,class (:weight bold :box (:line-width 1 :style pressed-button) :foreground "#F0DFAF" :background "#4F4F4F"))))
   `(org-clock-overlay ((,class (:foreground "#6B6B57" :background "#4B565D"))))
   `(org-code ((,class ,code-inline)))
   `(org-column ((,class ,column)))
   `(org-column-title ((,class ,column)))
   `(org-date ((,class (:underline t :foreground "#8CD0D3"))))
   `(org-default ((,class (:foreground "#DCDCCC" :background "#3F3F3F"))))
   `(org-dim ((,class (:foreground "#919178"))))
   `(org-document-info ((,class (:foreground "#C0C0B0"))))
   `(org-document-info-keyword ((,class (:foreground "#7CB8BB" :background "#3A3F45"))))
   `(org-document-title ((,class (,@(leuven-zen-scale-font leuven-zen-scale-org-document-title 1.8)  :weight bold :foreground "#FFFFEF"))))
   `(org-done ((,class (:weight bold :box (:line-width 1 :color "#5F7F5F") :foreground "#8FB28F" :background "#3D4A3D"))))
   `(org-drawer ((,class (:weight bold :foreground "#AEE8AE" :background "#306430"))))
   `(org-ellipsis ((,class (:underline nil :foreground "#9A9A84")))) ; #FFEE62
   `(org-example ((,class (:foreground "#A1A1E4" :background "#306430"))))
   `(org-footnote ((,class (:underline t :foreground "#AAD3E6"))))
   `(org-formula ((,class (:foreground "#E2B89A"))))
   ;; org-habit colors are thanks to zenburn
   `(org-habit-ready-face ((t :background "#7F9F7F"))) ; ,zenburn-green
   `(org-habit-alert-face ((t :background "#E0CF9F" :foreground "#3F3F3F"))) ; ,zenburn-yellow-1 fg ,zenburn-bg
   `(org-habit-clear-face ((t :background "#5C888B")))                       ; ,zenburn-blue-3
   `(org-habit-overdue-face ((t :background "#9C6363")))                     ; ,zenburn-red-3
   `(org-habit-clear-future-face ((t :background "#4C7073")))                ; ,zenburn-blue-4
   `(org-habit-ready-future-face ((t :background "#5F7F5F")))                ; ,zenburn-green-2
   `(org-habit-alert-future-face ((t :background "#D0BF8F" :foreground "#3F3F3F"))) ; ,zenburn-yellow-2 fg ,zenburn-bg
   `(org-habit-overdue-future-face ((t :background "#8C5353"))) ; ,zenburn-red-4
   `(org-headline-done ((,class (:height 1.0 :weight normal :foreground "#7F7F70"))))
   `(org-hide ((,class (:foreground "#3F3F3F"))))
   `(org-inlinetask ((,class (:box (:line-width 1 :color "#6B6B57") :foreground "#ACAC9A" :background "#666631"))))
   `(org-latex-and-related ((,class (:foreground "#BAC9D8" :background "#444440"))))
   `(org-level-1 ((,class ,ol1)))
   `(org-level-2 ((,class ,ol2)))
   `(org-level-3 ((,class ,ol3)))
   `(org-level-4 ((,class ,ol4)))
   `(org-level-5 ((,class ,ol5)))
   `(org-level-6 ((,class ,ol6)))
   `(org-level-7 ((,class ,ol7)))
   `(org-level-8 ((,class ,ol8)))
   `(org-link ((,class ,link)))
   `(org-list-dt ((,class (:weight bold :foreground "#B6C3D7"))))
   `(org-macro ((,class (:weight bold :foreground "#E4D6A5"))))
   `(org-meta-line ((,class (:slant normal :foreground "#7CB8BB" :background "#3A3F45"))))
   `(org-mode-line-clock ((,class (:box (:line-width 1 :color "#B6C3D7") :foreground "#E3E3DD" :background "#735837"))))
   `(org-mode-line-clock-overrun ((,class (:weight bold :box (:line-width 1 :color "#B6C3D7") :foreground "#6B6B57" :background "#723737"))))
   `(org-number-of-items ((,class (:weight bold :foreground "#6B6B57" :background "#465846"))))
   `(org-property-value ((,class (:foreground "#B4E9B4"))))
   `(org-quote ((,class (:slant italic :foreground "#C0C0B0" :background "#383834"))))
   `(org-scheduled ((,class (:foreground "#DCDCCC"))))
   `(org-scheduled-previously ((,class (:foreground "#AEC5E0"))))
   `(org-scheduled-today ((,class (:weight bold :foreground "#F0DFAF" :background "#4A4535"))))
   `(org-sexp-date ((,class (:foreground "#AEBED6"))))
   `(org-special-keyword ((,class (:weight bold :foreground "#AEE8AE" :background "#306430"))))
   `(org-table ((,class (:foreground "#9FC59F" :background "#3A423A")))) ;; :inherit fixed-pitch))))
   `(org-tag ((,class (:weight normal :slant italic :foreground "#989890" :background "#3F3F3F"))))
   `(org-target ((,class (:foreground "#DE8CB1"))))
   `(org-time-grid ((,class (:foreground "#898970"))))
   `(org-todo ((,class (:weight bold :box (:line-width 1 :color "#9C6363") :foreground "#ECB3B3" :background "#4D3B3B"))))
   `(org-upcoming-deadline ((,class (:foreground "#DF9191"))))
   `(org-verbatim ((,class (:foreground "#94BFF3" :background "#393D45"))))
   `(org-verse ((,class (:slant italic :foreground "#C0C0B0" :background "#454545"))))
   `(org-warning ((,class (:weight bold :foreground "#FFFFEF" :background "#8C5353"))))
   `(outline-1 ((,class ,ol1)))
   `(outline-2 ((,class ,ol2)))
   `(outline-3 ((,class ,ol3)))
   `(outline-4 ((,class ,ol4)))
   `(outline-5 ((,class ,ol5)))
   `(outline-6 ((,class ,ol6)))
   `(outline-7 ((,class ,ol7)))
   `(outline-8 ((,class ,ol8)))
   `(pabbrev-debug-display-label-face ((,class (:foreground "#6B6B57" :background "#6D4454"))))
   `(pabbrev-suggestions-face ((,class (:weight bold :foreground "#6B6B57" :background "#773939"))))
   `(pabbrev-suggestions-label-face ((,class (:weight bold :foreground "#6B6B57" :background "#5C3C70"))))
   `(paren-face-match ((,class ,paren-matched)))
   `(paren-face-mismatch ((,class ,paren-unmatched)))
   `(paren-face-no-match ((,class ,paren-unmatched)))
   `(persp-selected-face ((,class (:weight bold :foreground "#799FD1"))))
   `(powerline-active1 ((,class (:foreground "#97C1D2" :background "#696963" :inherit mode-line))))
   `(powerline-active2 ((,class (:foreground "#97C1D2" :background "#465162" :inherit mode-line))))
   `(powerline-inactive1 ((,class (:foreground "#6B6B57" :background "#696963" :inherit mode-line-inactive))))
   `(powerline-inactive2 ((,class (:foreground "#6B6B57" :background "#5A5A55" :inherit mode-line-inactive))))
   `(rainbow-delimiters-depth-1-face ((,class (:foreground "#ABAB98"))))
   `(rainbow-delimiters-depth-2-face ((,class (:foreground "#A4ADCE"))))
   `(rainbow-delimiters-depth-3-face ((,class (:foreground "#A2A28D"))))
   `(rainbow-delimiters-depth-4-face ((,class (:foreground "#B2D1B2"))))
   `(rainbow-delimiters-depth-5-face ((,class (:foreground "#D1B3B3"))))
   `(rainbow-delimiters-depth-6-face ((,class (:foreground "#AFB6CF"))))
   `(rainbow-delimiters-depth-7-face ((,class (:foreground "#A6A692"))))
   `(rainbow-delimiters-depth-8-face ((,class (:foreground "#ADCEAD"))))
   `(rainbow-delimiters-depth-9-face ((,class (:foreground "#AAAA97"))))
   `(rainbow-delimiters-mismatched-face ((,class ,paren-unmatched)))
   `(rainbow-delimiters-unmatched-face ((,class ,paren-unmatched)))
   `(recover-this-file ((,class (:weight bold :background "#723737"))))
   `(rng-error ((,class (:weight bold :foreground "#E4A1A1" :background "#5C3637"))))
   `(sh-heredoc ((,class (:foreground "#A1A1E4" :background "#324660"))))
   `(sh-quoted-exec ((,class (:foreground "#E39DC3"))))
   `(shadow ((,class ,shadow)))         ; Used for grep context lines.
   `(shell-option-face ((,class (:foreground "#BCDDBC"))))
   `(shell-output-2-face ((,class (:foreground "#A1A1E4"))))
   `(shell-output-3-face ((,class (:foreground "#C7A2DE"))))
   `(shell-output-face ((,class (:foreground "#E3E3DD"))))
   ;; `(shell-prompt-face ((,class (:weight bold :foreground "#E4E4A1"))))
   `(shm-current-face ((,class (:background "#524D3D"))))
   `(shm-quarantine-face ((,class (:background "#676131"))))
   `(show-paren-match ((,class ,paren-matched)))
   `(show-paren-mismatch ((,class ,paren-unmatched)))
   `(sml-modeline-end-face ((,class (:background "#38506A")))) ; #335EA8
   `(sml-modeline-vis-face ((,class (:background "#405A70"))))
   `(term ((,class (:foreground "#DCDCCC" :background "#3F3F3F"))))

   ;; `(sp-pair-overlay-face ((,class ())))
   ;; `(sp-show-pair-enclosing ((,class ())))
   ;; `(sp-show-pair-match-face ((,class ()))) ; ~ Pair highlighting (matching tags).
   ;; `(sp-show-pair-mismatch-face ((,class ())))
   ;; `(sp-wrap-overlay-closing-pair ((,class ())))
   ;; `(sp-wrap-overlay-face ((,class ())))
   ;; `(sp-wrap-overlay-opening-pair ((,class ())))
   ;; `(sp-wrap-tag-overlay-face ((,class ())))

   `(speedbar-button-face ((,class (:foreground "#B8EAB8"))))
   `(speedbar-directory-face ((,class (:foreground "#B8B8EA"))))
   `(speedbar-file-face ((,class (:foreground "#B8EAEA"))))
   `(speedbar-highlight-face ((,class ,volatile-highlight)))
   `(speedbar-selected-face ((,class (:underline t :foreground "#E4A1A1"))))
   `(speedbar-tag-face ((,class (:foreground "#DAB7B7"))))
   `(svn-status-directory-face ((,class ,directory)))
   `(svn-status-filename-face ((,class (:weight bold :foreground "#B0C2D3"))))
   `(svn-status-locked-face ((,class (:weight bold :foreground "#E4A1A1"))))
   `(svn-status-marked-face ((,class ,marked-line)))
   `(svn-status-marked-popup-face ((,class (:weight bold :foreground "#ABE7AB"))))
   `(svn-status-switched-face ((,class (:slant italic :foreground "#A1A18C"))))
   `(svn-status-symlink-face ((,class ,symlink)))
   `(svn-status-update-available-face ((,class (:foreground "#E4CCA1"))))
   `(tex-verbatim ((,class (:foreground "#A1A1E4"))))
   `(tool-bar ((,class (:box (:line-width 1 :style released-button) :foreground "#E3E3DD" :background "#555550"))))
   `(tooltip ((,class (:foreground "#DCDCCC" :background "#2B2B2B"))))
   `(traverse-match-face ((,class (:weight bold :foreground "#C2A7DB"))))
   `(vc-annotate-face-3F3FFF ((,class (:foreground "#9595E0" :background "#696963"))))
   `(vc-annotate-face-3F6CFF ((,class (:foreground "#9595E0" :background "#696963"))))
   `(vc-annotate-face-3F99FF ((,class (:foreground "#95B8E0" :background "#696963"))))
   `(vc-annotate-face-3FC6FF ((,class (:foreground "#95B8E0" :background "#696963"))))
   `(vc-annotate-face-3FF3FF ((,class (:foreground "#95DBE0" :background "#696963"))))
   `(vc-annotate-face-3FFF56 ((,class (:foreground "#93E093" :background "#696963"))))
   `(vc-annotate-face-3FFF83 ((,class (:foreground "#95E0C1" :background "#696963"))))
   `(vc-annotate-face-3FFFB0 ((,class (:foreground "#95E0C1" :background "#696963"))))
   `(vc-annotate-face-3FFFDD ((,class (:foreground "#95DBE0" :background "#696963"))))
   `(vc-annotate-face-56FF3F ((,class (:foreground "#93E093" :background "#696963"))))
   `(vc-annotate-face-83FF3F ((,class (:foreground "#C1E095" :background "#696963"))))
   `(vc-annotate-face-B0FF3F ((,class (:foreground "#C1E095" :background "#696963"))))
   `(vc-annotate-face-DDFF3F ((,class (:foreground "#E0DB95" :background "#696963"))))
   `(vc-annotate-face-F6FFCC ((,class (:foreground "#E3E3DD" :background "#686832"))))
   `(vc-annotate-face-FF3F3F ((,class (:foreground "#E09595" :background "#696963"))))
   `(vc-annotate-face-FF6C3F ((,class (:foreground "#E09595" :background "#696963"))))
   `(vc-annotate-face-FF993F ((,class (:foreground "#E0B895" :background "#696963"))))
   `(vc-annotate-face-FFC63F ((,class (:foreground "#E0B895" :background "#696963"))))
   `(vc-annotate-face-FFF33F ((,class (:foreground "#E0DB95" :background "#696963"))))

   ;; ;; vc
   ;; (vc-up-to-date-state    ((,c :foreground ,(gc 'green-1))))
   ;; (vc-edited-state        ((,c :foreground ,(gc 'yellow+1))))
   ;; (vc-missing-state       ((,c :foreground ,(gc 'red))))
   ;; (vc-conflict-state      ((,c :foreground ,(gc 'red+2) :weight bold)))
   ;; (vc-locked-state        ((,c :foreground ,(gc 'cyan-1))))
   ;; (vc-locally-added-state ((,c :foreground ,(gc 'blue))))
   ;; (vc-needs-update-state  ((,c :foreground ,(gc 'magenta))))
   ;; (vc-removed-state       ((,c :foreground ,(gc 'red-1))))

   `(vhl/default-face ((,class ,volatile-highlight))) ; `volatile-highlights.el' (for undo, yank).
   `(w3m-anchor ((,class ,link)))
   `(w3m-arrived-anchor ((,class (:foreground "#BE98E1"))))
   `(w3m-bitmap-image-face ((,class (:foreground "#E3E3DD" :background "#397739"))))
   `(w3m-bold ((,class (:weight bold :foreground "#E3E3DD"))))
   `(w3m-current-anchor ((,class (:weight bold :underline t :foreground "#A1A1E4"))))
   `(w3m-form ((,class (:underline t :foreground "#DFB892"))))
   `(w3m-form-button-face ((,class (:weight bold :underline t :foreground "#E3E3DD" :background "#50504B"))))
   `(w3m-form-button-mouse-face ((,class (:underline t :foreground "#777761" :background "#4A6849"))))
   `(w3m-form-button-pressed-face ((,class (:weight bold :underline t :foreground "#E3E3DD" :background "#50504B"))))
   `(w3m-header-line-location-content-face ((,class (:foreground "#A8A895":background "#464642"))))
   `(w3m-header-line-location-title-face ((,class (:foreground "#B4C0D9" :background "#464642"))))
   `(w3m-history-current-url-face ((,class (:foreground "#D8CF79"))))
   `(w3m-image-face ((,class (:weight bold :foreground "#92CA92"))))
   `(w3m-link-numbering ((,class (:foreground "#95A7C8")))) ; mouseless browsing
   `(w3m-strike-through-face ((,class (:strike-through t))))
   `(w3m-underline-face ((,class (:underline t))))

   ;; `(web-mode-block-attr-name-face ((,class ())))
   ;; `(web-mode-block-attr-value-face ((,class ())))
   ;; `(web-mode-block-comment-face ((,class ())))
   ;; `(web-mode-block-control-face ((,class ())))
   ;; `(web-mode-block-delimiter-face ((,class ())))
   ;; `(web-mode-block-face ((,class ())))
   ;; `(web-mode-block-string-face ((,class ())))
   ;; `(web-mode-bold-face ((,class ())))
   ;; `(web-mode-builtin-face ((,class ())))
   ;; `(web-mode-comment-face ((,class ())))
   ;; `(web-mode-comment-keyword-face ((,class ())))
   ;; `(web-mode-constant-face ((,class ())))
   ;; `(web-mode-css-at-rule-face ((,class ())))
   ;; `(web-mode-css-color-face ((,class ())))
   ;; `(web-mode-css-comment-face ((,class ())))
   ;; `(web-mode-css-function-face ((,class ())))
   ;; `(web-mode-css-priority-face ((,class ())))
   ;; `(web-mode-css-property-name-face ((,class ())))
   ;; `(web-mode-css-pseudo-class-face ((,class ())))
   ;; `(web-mode-css-selector-face ((,class ())))
   ;; `(web-mode-css-string-face ((,class ())))
   ;; `(web-mode-css-variable-face ((,class ())))
   ;; `(web-mode-current-column-highlight-face ((,class ())))
   `(web-mode-current-element-highlight-face ((,class (:background "#334F6B")))) ; #FFEE80
   ;; `(web-mode-doctype-face ((,class ())))
   ;; `(web-mode-error-face ((,class ())))
   ;; `(web-mode-filter-face ((,class ())))
   `(web-mode-folded-face ((,class (:box (:line-width 1 :color "#ACAC9A") :foreground "#D1D1B3" :background "#6D6D3A"))))
   ;; `(web-mode-function-call-face ((,class ())))
   ;; `(web-mode-function-name-face ((,class ())))
   ;; `(web-mode-html-attr-custom-face ((,class ())))
   ;; `(web-mode-html-attr-engine-face ((,class ())))
   ;; `(web-mode-html-attr-equal-face ((,class ())))
   `(web-mode-html-attr-name-face ((,class ,xml-attribute)))
   ;; `(web-mode-html-attr-value-face ((,class ())))
   ;; `(web-mode-html-entity-face ((,class ())))
   `(web-mode-html-tag-bracket-face ((,class ,xml-tag)))
   ;; `(web-mode-html-tag-custom-face ((,class ())))
   `(web-mode-html-tag-face ((,class ,xml-tag)))
   ;; `(web-mode-html-tag-namespaced-face ((,class ())))
   ;; `(web-mode-inlay-face ((,class ())))
   ;; `(web-mode-italic-face ((,class ())))
   ;; `(web-mode-javascript-comment-face ((,class ())))
   ;; `(web-mode-javascript-string-face ((,class ())))
   ;; `(web-mode-json-comment-face ((,class ())))
   ;; `(web-mode-json-context-face ((,class ())))
   ;; `(web-mode-json-key-face ((,class ())))
   ;; `(web-mode-json-string-face ((,class ())))
   ;; `(web-mode-jsx-depth-1-face ((,class ())))
   ;; `(web-mode-jsx-depth-2-face ((,class ())))
   ;; `(web-mode-jsx-depth-3-face ((,class ())))
   ;; `(web-mode-jsx-depth-4-face ((,class ())))
   ;; `(web-mode-keyword-face ((,class ())))
   ;; `(web-mode-param-name-face ((,class ())))
   ;; `(web-mode-part-comment-face ((,class ())))
   `(web-mode-part-face ((,class (:background "#656531"))))
   ;; `(web-mode-part-string-face ((,class ())))
   ;; `(web-mode-preprocessor-face ((,class ())))
   `(web-mode-script-face ((,class (:background "#484844"))))
   ;; `(web-mode-sql-keyword-face ((,class ())))
   ;; `(web-mode-string-face ((,class ())))
   ;; `(web-mode-style-face ((,class ())))
   ;; `(web-mode-symbol-face ((,class ())))
   ;; `(web-mode-type-face ((,class ())))
   ;; `(web-mode-underline-face ((,class ())))
   ;; `(web-mode-variable-name-face ((,class ())))
   ;; `(web-mode-warning-face ((,class ())))
   ;; `(web-mode-whitespace-face ((,class ())))

   `(which-func ((,class (:weight bold :slant italic :foreground "#6B6B57"))))
   ;; `(which-key-command-description-face)
   ;; `(which-key-group-description-face)
   ;; `(which-key-highlighted-command-face)
   ;; `(which-key-key-face)
   `(which-key-local-map-description-face ((,class (:weight bold :background "#374555" :inherit which-key-command-description-face))))
   ;; `(which-key-note-face)
   ;; `(which-key-separator-face)
   ;; `(which-key-special-key-face)
   `(widget-button ((,class ,link)))
   `(widget-button-pressed ((,class (:foreground "#E4A1A1"))))
   `(widget-documentation ((,class (:foreground "#B8EAB8"))))
   `(widget-field ((,class (:background "#4E4E4A"))))
   `(widget-inactive ((,class (:foreground "#B4B4A3"))))
   `(widget-single-line-field ((,class (:background "#4E4E4A"))))
   `(woman-bold ((,class (:weight bold :foreground "#DC9D9D"))))
   `(woman-italic ((,class (:weight bold :slant italic :foreground "#BCDEB0"))))
   `(woman-symbol ((,class (:weight bold :foreground "#C7A2DE"))))
   `(yas-field-debug-face ((,class (:foreground "#6B6B57" :background "#6D4454"))))
   `(yas-field-highlight-face ((,class (:box (:line-width 1 :color "#A6A692") :foreground "#E3E3DD" :background "#3E4C45"))))

   ;; `(ztreep-arrow-face ((,class ())))
   ;; `(ztreep-diff-header-face ((,class ())))
   ;; `(ztreep-diff-header-small-face ((,class ())))
   `(ztreep-diff-model-add-face ((,class (:weight bold :foreground "#B8EAB8"))))
   `(ztreep-diff-model-diff-face ((,class (:weight bold :foreground "#A8BBE6"))))
   `(ztreep-diff-model-ignored-face ((,class (:strike-through t :foreground "#979780"))))
   `(ztreep-diff-model-normal-face ((,class (:foreground "#E3E3DD"))))
   ;; `(ztreep-expand-sign-face ((,class ())))
   ;; `(ztreep-header-face ((,class ())))
   ;; `(ztreep-leaf-face ((,class ())))
   ;; `(ztreep-node-face ((,class ())))

   ))

(custom-theme-set-variables 'leuven-zen

  ;; highlight-sexp-mode.
  '(hl-sexp-background-color "#4A413D")

 )

;;;###autoload
(when (and (boundp 'custom-theme-load-path)
           load-file-name)
  ;; Add theme folder to `custom-theme-load-path' when installing over MELPA.
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'leuven-zen)

;; This is for the sake of Emacs.
;; Local Variables:
;; time-stamp-end: "$"
;; time-stamp-format: "%Y-%02m-%02d %02H:%02M"
;; time-stamp-start: "Last-Updated: "
;; End:

;;; leuven-zen-theme.el ends here
