;; emacs configuration
(add-to-list 'load-path "~/.emacs.d/vendor")
(push "/usr/local/bin" exec-path)

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq js-indent-level 2)
(setq inhibit-startup-message t)

(fset 'yes-or-no-p 'y-or-n-p)
(setq mac-command-modifier 'meta)
(setq mac-function-modifier 'super)

(delete-selection-mode t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode t)
(show-paren-mode t)
(line-number-mode t)
(column-number-mode t)
(set-fringe-style -1)
(tooltip-mode -1)
(global-hl-line-mode t)

(set-frame-font "Anonymous Pro-15")

; window-number-mode
;(autoload 'window-number-mode "window-number"
;  "A global minor mode that enables selection of windows according to
;numbers with the C-x C-j prefix.  Another mode,
;`window-number-meta-mode' enables the use of the M- prefix."
;  t)
;
;(autoload 'window-number-meta-mode "window-number"
;  "A global minor mode that enables use of the M- prefix to select
;windows, use `window-number-mode' to display the window numbers in
;the mode-line."
;  t)

;;;;;

(require 'package)
(setq package-archives (cons '("tromey" . "http://tromey.com/elpa/") package-archives))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)

(defun set-newline-and-indent ()
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun ruby-mode-hook ()
  (autoload 'ruby-mode "ruby-mode" nil t)
  (add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.ru\\'" . ruby-mode))
  (add-hook 'ruby-mode-hook '(lambda ()
                               (setq ruby-deep-arglist t)
                               (setq ruby-deep-indent-paren nil)
                               (setq c-tab-always-indent nil)
                               (set-newline-and-indent)
;                               (add-hook 'before-save-hook 'delete-trailing-whitespace)
                               (require 'inf-ruby)
                               (require 'ruby-compilation))))
(defun rhtml-mode-hook ()
  (autoload 'rhtml-mode "rhtml-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . rhtml-mode))
  (add-to-list 'auto-mode-alist '("\\.rhtml\\'" . rhtml-mode))
  (add-to-list 'auto-mode-alist '("\\.rjs\\'" . rhtml-mode))
  (add-hook 'rhtml-mode '(lambda ()
                           (define-key rhtml-mode-map (kbd "M-s") 'save-buffer))))

(defun cucumber-mode-hook ()
  (autoload 'feature-mode "feature-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.feature$" . feature-mode)))

(defun yaml-mode-hook ()
  (autoload 'yaml-mode "yaml-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode)))

(defun css-mode-hook ()
  (autoload 'css-mode "css-mode" nil t)
  (add-hook 'css-mode-hook '(lambda ()
                              (setq css-indent-level 2)
                              (setq css-indent-offset 2))))

(defun yasnippet-bundle-hook ()
  (setq yas/root-directory "~/.emacs.d/snippets")
  (yas/load-directory yas/root-directory))

(add-hook 'emacs-lisp-mode-hook '(lambda ()
                              (set-newline-and-indent)))


(setq el-get-sources
      '((:name ruby-mode
               :type elpa
               :load "ruby-mode.el"
               :after (lambda () (ruby-mode-hook)))
        (:name inf-ruby  :type elpa)
        (:name ruby-compilation :type elpa)
        (:name yasnippet-bundle
               :type elpa
               :after (lambda () (yasnippet-bundle-hook)))
        (:name css-mode
               :type elpa
               :load "css-mode.el"
               :after (lambda () (css-mode-hook)))
        (:name textmate
               :type git
               :url "git://github.com/defunkt/textmate.el"
               :load "textmate.el")
        (:name feature-mode
               :type git
               :url "git://github.com/michaelklishin/cucumber.el.git"
               :features feature-mode
               :after (lambda() (cucumber-mode-hook)))
        (:name rvm
               :type git
               :url "http://github.com/djwhitt/rvm.el.git"
               :load "rvm.el"
               :compile ("rvm.el")
               :after (lambda() (rvm-use-default)))
        (:name rhtml
               :type git
               :url "https://github.com/eschulte/rhtml.git"
               :features rhtml-mode
               :after (lambda () (rhtml-mode-hook)))
        (:name yaml-mode
               :type git
               :url "http://github.com/yoshiki/yaml-mode.git"
               :features yaml-mode
               :after (lambda () (yaml-mode-hook)))
        (:name magit
               :type git
               :url "https://github.com/philjackson/magit.git"
               :features magit)
        (:name cheat
               :type git
               :url "https://github.com/defunkt/cheat.el.git"
               :load "cheat.el")
        (:name gist
               :type git
               :url "https://github.com/defunkt/gist.el.git"
               :load "gist.el")))
(el-get 'sync)

(defun is-rails-project ()
  (when (textmate-project-root)
    (file-exists-p (expand-file-name "config/environment.rb" (textmate-project-root)))))

;; peepopen command+t
(require 'peepopen)
(setq ns-pop-up-frames nil)
(textmate-mode)

; ack!
(autoload 'ack-same "full-ack" nil t)
(autoload 'ack "full-ack" nil t)
(autoload 'ack-find-same-file "full-ack" nil t)
(autoload 'ack-find-file "full-ack" nil t)


(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)


; My keybindings
(global-set-key (kbd "M-l") 'goto-line)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x j") 'join-line)
(global-set-key (kbd "M-T") 'transpose-words)

(server-start)

;; packages still to install:
;    yasnippet
;    markdown-mode
;    autotest ?
;    ack
;    ecb
;    window-numbering-mode

;; TODO - ideas for functions that I want to write but don't know how yet
; kill-whole-word : should look up previous character for word boundary (\b)
;    and move back a word if it's not a boundary, then forward kill
;    http://www.appdesign.com/blog/2007/04/21/killing-the-whole-word-in-emacs/
; set the path properly (currently hacking markdown & ack)


(defun hoist-region ()
  (save-excursion
    (open-new-buffer-with-region (point) (mark))
    (add-save-hook-to-current-buffer '(replace-original-region-with-buffer-contents))))

(defun open-new-buffer-with-region (start end)
  (copy-to-buffer "chicken" start end)
  (pop-to-buffer "chicken"))

(defun add-save-hook-to-current-buffer (functions)
  (setq write-contents-functions functions))
