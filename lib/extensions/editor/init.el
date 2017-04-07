; Customizations --------------------------------------------
(defcustom fg42-todo-file "~/.TODO.org"
  "Path to your TODO file. You can use a tramp address here as well."
  :type 'string
  :group 'fg42)

;; Hooks -----------------------------------------------------
(defvar fg42-before-open-todo-hook nil)
(defvar fg42-after-open-todo-hook nil)

;; Functions -------------------------------------------------
(defun fg42-reload ()
  "Reload the entire FG42."
  (interactive)
  (load-file (concat (getenv "FG42_HOME") "/fg42-config.el")))

;;;###autoload
(defun fg42-open-todo ()
  (interactive)
  (run-hooks 'fg42-before-open-todo-hook)
  (find-file fg42-todo-file)
  (run-hooks 'fg42-after-open-todo-hook))

;;;###autoload
(defun extensions/editor-initialize ()
  "Base plugin initialization."
  (message "Initializing 'editor' extension.")

  (require 'all-the-icons)
  (require 'cheatsheet)
  (require 'extensions/editor/utils)

  (cheatsheet-add :group '--HELP--
                  :key   "C-?"
                  :description "Show this cheatsheet")
  (cheatsheet-add :group '--Navigation--
                  :key   "M-f"
                  :description "Move a word to right")
  (cheatsheet-add :group '--Navigation--
                  :key   "M-b"
                  :description "Move a word to left")
  (cheatsheet-add :group '--Navigation--
                  :key   "M-{"
                  :description "Move back a paragraph")
  (cheatsheet-add :group '--Navigation--
                  :key   "M-}"
                  :description "Move forward by a paragraph")

  (global-set-key (kbd "C-?") 'cheatsheet-show)


  ;; Remove splash screen
  (setq inhibit-splash-screen t)

  ;; scratch should be scratch
  (setq initial-scratch-message nil)



  (ability spaceline ()
           "A really cool mode line alternative which borrowed from awesome spacemacs"
           (require 'spaceline-config)
           (require 'extensions/editor/spaceline-alt)
           (setq-default mode-line-format '("%e" (:eval (spaceline-ml-ati)))))
           ;;(spaceline-emacs-theme))

  ;; Tramp configuration -------------------------------------
  (ability tramp ()
           (setq tramp-default-method "ssh")
           (cheatsheet-add :group '--EDITOR--
                           :key   "f9"
                           :description "Open up your todo file. checkout `fg42-todo-file` var and `fg42-open-todo` function.")
           (global-set-key [f9] 'fg42-open-todo))

  ;; replace strings
  (global-set-key (kbd "C-c M-s") 'replace-string)

  ;; Basic Key bindings
  (global-set-key (kbd "\C-c m") 'menu-bar-mode)

  ;; Don't allow tab as indent
  (setq-default indent-tabs-mode nil)

  (ability indent-guides ()
           "Show guides for indentations in code."

           (indent-guide-global-mode)

           (ability recursive-indent-guides ()
                    "Show recursive indents guides."
                    (setq indent-guide-recursive t))

           (ability delayed-indent-guides ()
                    "Show indent guides with a delay."
                    (setq indent-guide-delay 0.3)))


  (ability nlinum ()
           "Faster alternative to linum-mode"
           (require 'nlinum)
           (nlinum-mode t))

  ;; Default indent width
  (setq tab-width 2)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)

  ;; Enhancements ---------------------------------------------

  ;; Global configurations
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (setq x-select-enable-clipboard t)
  (column-number-mode t)

  ;; linum mode
  (ability linum ()
           "Line numbering ability"
           (global-linum-mode)
           (setq linum-format " %3d "))

  (menu-bar-mode -1)
  (show-paren-mode t)
  (cua-selection-mode t)



  ;; expand-region -------------------------------------------
  (global-set-key (kbd "C-=") 'er/expand-region)

  ;; Multiple cursor -----------------------------------------
  ;; multiple cursor configurations
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-SPC ") 'mc/mark-all-like-this)

  ;; Reload FG42
  (define-key global-map (kbd "<f5>") 'fg42-reload)

  ;; Key Chord ------------------------------------------------
  ;; (require 'key-chord)
  ;; (key-chord-mode 1)

  ;; (key-chord-define-global "hj"     'undo)
  ;; (key-chord-define-global "kl"     'right-word)
  ;; (key-chord-define-global "sd"     'left-word)
  ;; (key-chord-define-global "m,"     'forward-paragraph)
  ;; (key-chord-define-global "p["     'backward-paragraph)

  ;; HideShow -------------------------------------------------------
  (global-set-key (kbd "C-\-") 'hs-toggle-hiding)
  (hs-minor-mode)

  ;; Guru Configuration
  (with-ability guru
                (require 'guru-mode)
                (guru-global-mode +1))

  ;; IDO configurations ---------------------------------------------
  (with-ability ido
                (require 'flx-ido)
                (require 'ido-vertical-mode)

                (ido-everywhere t)
                (ido-ubiquitous-mode 1)
                (ido-mode t)

                (smex-initialize)
                (global-set-key (kbd "M-x") 'smex)

                (flx-ido-mode 1)
                (setq ido-use-faces nil)
		(setq ido-use-filename-at-point nil)

                (setq ido-enable-flex-matching t)
                (ido-vertical-mode 1))


  ;; Helm -----------------------------------------------------
  (with-ability helm

                (global-set-key (kbd "C-c h") 'helm-command-prefix)
                (global-unset-key (kbd "C-x c"))

                (define-key helm-map (kbd "<tab>")
                  'helm-execute-persistent-action)
                (define-key helm-map (kbd "C-i")
                  'helm-execute-persistent-action)
                (define-key helm-map (kbd "C-z")
                  'helm-select-action)

                (when (executable-find "curl")
                  (setq helm-google-suggest-use-curl-p t))

                (setq helm-split-window-in-side-p t
                      helm-move-to-line-cycle-in-source t
                      helm-ff-search-library-in-sexp t
                      helm-scroll-amount 8
                      helm-ff-file-name-history-use-recentf t)

                (helm-mode 1))

  (ability ivy ()
           "Completion using ivy."
           (require 'ivy)
           (ivy-mode 1)

           (setq ivy-use-virtual-buffers t)
           (global-set-key (kbd "C-c C-r") 'ivy-resume))

  ;; Swiper ---------------------------------------------------
  (ability swiper (ivy)
           "Replace default isearch with swiper"
           (global-set-key "\C-s" 'swiper)
           (global-set-key "\C-r" 'swiper))
           ;; (with-ability ido
           ;;               (global-set-key (kbd "C-x b") 'ido-switch-buffer)))

  ;; Session Management ---------------------------------------
  (ability desktop-mode ()
	   "Save your current working buffers and restore later"
	   (desktop-save-mode 1))

  ;; Backup files ---------------------------------------------
  ;; Put them in one nice place if possible
  (if (file-directory-p "~/.backup")
      (setq backup-directory-alist '(("." . "~/.backup")))
    (make-directory "~/.backup"))

  (setq backup-by-copying t    ; Don't delink hardlinks
	delete-old-versions t  ; Clean up the backups
	version-control t      ; Use version numbers on backups,
	kept-new-versions 3    ; keep some new versions
	kept-old-versions 2)   ; and some old ones, too

  ;; get rid of yes-or-no questions - y or n is enough
  (defalias 'yes-or-no-p 'y-or-n-p)

  (setup-utils)

  (setq my-path (file-name-directory load-file-name))
  ;; Load about submenu
  (require 'extensions/editor/version)
  (require 'extensions/editor/about)
  (require 'extensions/editor/custom)
  (require 'extensions/editor/session-management))

(provide 'extensions/editor/init)
