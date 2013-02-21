;;; Title:   JunhuiCao .emacs file

;;改变mac control meta 键盘布局
(setq mac-command-modifier 'control)
(setq mac-control-modifier 'alt)
(setq mac-option-modifier 'meta)
;;选中 M+Space设置标记（set-mark)。
(global-set-key [?\M- ] 'set-mark-command)

;; 注释 M-;

;;(Add-to-list 'load-path "~/.emacs.d" t)

;; Allow easy customization of emacs without restarting it.
(defun edit-dot-emacs ()
  "Load the .emacs file into a buffer for editing."
  (interactive)
  (find-file "~/.emacs"))

(defun reload-dot-emacs ()
  "Save .emacs, if it is in a buffer, and reload it."
  (interactive)
  (if (bufferp (get-file-buffer "~/.emacs"))
    (save-buffer (get-buffer "~/.emacs")))
  (load-file "~/.emacs"))

;;设置package源
 (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                          ("marmalade" . "http://marmalade-repo.org/packages/")
                          ("melpa" . "http://melpa.milkbox.net/packages/")))

(require 'package)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))



;;字体和显示中文
(set-frame-font "Menlo-14")
(set-fontset-font
    (frame-parameter nil 'font)
    'han
    (font-spec :family "Hiragino Sans GB" ))

;;自动补齐
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete-1.3.1/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete-1.3.1/ac-dict/")
(ac-config-default)


(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)

(setq c-set-style "K&R")
(setq c-default-style "K&R"
      c-basic-offset 4)
(setq standard-indent 4)
(setq-default show-trailing-whitespace t)
(add-hook 'write-file-functions 'delete-trailing-whitespace)

;;color
;; (add-to-list 'load-path "~/.emacs.d/elpa/color-theme-sanityinc-solarized-2.21/")
;; (load-file "~/.emacs.d/elpa/color-theme-sanityinc-solarized-2.21/color-theme-sanityinc-solarized.el")
(require 'color-theme-sanityinc-solarized)
(color-theme-sanityinc-solarized-dark)

;;光标显示为一竖线
(setq-default cursor-type 'bar)

;;关闭工具栏
;;(tool-bar-mode nil)

;;滚动条置右
(customize-set-variable 'scroll-bar-mode 'right)


;;显示行号
(require 'linum)
(global-linum-mode t)

;;在窗口的标题栏上显示文件名称
(setq frame-title-format "%n%F/%b")

(setq kill-ring-max 200)

(setq default-fill-column 60)

(setq default-major-mode 'text-mode)
(mouse-avoidance-mode 'animate)

(fset 'yes-or-no-p 'y-or-n-p);以 y/n代表 yes/no

;解决emacs shell 乱码
(setq ansi-color-for-comint-mode t)
(customize-group 'ansi-colors)
(kill-this-buffer);关闭customize窗口

;; parentheses highlighting
(show-paren-mode 1)
(setq blink-matching-paren t)
;; highlight during query
(setq query-replace-highlight t)
;; highlight incremental search
(setq search-highlight t)

(setq inhibit-splash-screen t)


;自定义按键
(global-set-key [f1] 'shell);F1进入Shell
(global-set-key [f8] 'other-window);F8窗口间跳转
(global-set-key [f10] 'split-window-vertically);F10分割窗口
;;格式化整个文件函数
(defun indent-whole ()
  (interactive)
  (indent-region (point-min) (point-max))
  (message "format successfully"))
;;绑定到F7键
(global-set-key [f7] 'indent-whole)

;;括号自动补齐
;; (require 'paredit) if you didn't install via package.el
(defun turn-on-paredit () (paredit-mode 1))
(add-hook 'clojure-mode-hook 'turn-on-paredit)


(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)



;;; org-mode
;;(add-to-list 'load-path "~/.emacs.d/elpa/org-20130114/")
(require 'org-publish)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock)
(add-hook 'org-mode-hook
(lambda () (setq truncate-lines nil)))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-todo-keywords
      '((sequence "TODO" "|" "DONE")
        (type "CAO" "NA" "TAN" "|" "EXPERIMENT")
        (sequence "REPORT" "BUG" "INPROGRESS" "|" "FIXED")
        (sequence "|" "CANCELED")))
(setq org-log-done 'time)
(setq org-log-done 'note)
(defun org-summary-todo (n-done n-not-done)
  "Swith entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging.
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
(setq org-agenda-files (list "~/org/work.org"
                             "~/org/life.org"
                             "~/org/home.org"
                             "~/Twork/user-oauth2/org/work-todo.org"))
;;打开所有org文件都默认 对齐
(setq org-startup-indented t)


;;;Org-babel-clojure 配置高亮 clojure 代码
(require 'ob)
(require 'ob-tangle)
(add-to-list 'org-babel-tangle-lang-exts '("clojure" . "clj"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
 (clojure . t)))
(require 'ob-clojure)

(defun org-babel-execute:clojure (body params)
"Evaluate a block of Clojure code with Babel."
(concat "=> "
(if (fboundp 'slime-eval)
    (slime-eval `(swank:interactive-eval-region ,body))
  (if (fboundp 'lisp-eval-string)
    (lisp-eval-string body)
  (error "You have to start a clojure repl first!")))))

(setq org-src-fontify-natively t)
(setq org-confirm-babel-evaluate nil)
(setq org-export-babel-evaluate nil)


;;;php-mode
;;将lisp扩展目录加入load-path
(add-to-list 'load-path "~/.emacs.d/plugins/php-mode/")
;;打开php模式
(require 'php-mode)
(add-hook 'php-mode-user-hook 'turn-on-font-lock)

;;scala-mode
;; (add-hook 'scala-mode-hook
;;           '(lambda ()
;;              (yas/minor-mode-on)))
;; (setq yas/scala-directory "~/.emacs.d/plugins/scala-mode/contrib/yasnippet/snippets")
;; (yas/load-directory yas/scala-directory)

;;;; scala mode
    (setq scala-root-dir (expand-file-name "~/.emacs.d/plugins/scala-mode/"))
    (setq load-path (cons scala-root-dir load-path))
    (require 'scala-mode-auto)
