;;; helm-treemacs-icons.el --- Helm integration with treemacs icons  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Ivan Yonchovski

;; Author: Ivan Yonchovski <yyoncho@gmail.com>
;; Keywords: convenience

;; Version: 0.1
;; URL: https://github.com/yyoncho/helm-treemacs-icons
;; Package-Requires: ((emacs "25.1") (dash "2.14.1") (f "0.20.0") (treemacs "2.7"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received candidate copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; helm -> treemacs-icons integration

;;; Code:

(require 'dash)
(require 'icons-in-terminal)
(require 's)

(defgroup icons-in-terminal-helm nil
  "Helm treemacs icons."
  :group 'helm)

(defun icons-in-terminal-helm-for-dir (dir)
  (cond
   ((file-symlink-p dir) (icons-in-terminal-octicon "file-symlink-directory"))
   ((file-exists-p (format "%s/.git" dir)) (icons-in-terminal-fileicon "git"))
   ((icons-in-terminal-octicon "file-directory"))))

(defun icons-in-terminal-helm-buffers-add-icon (candidates _source)
  "Add icon to buffers source.
CANDIDATES is the list of candidates."
  (-map (-lambda ((display . buffer))
          (cons (concat
                 (with-current-buffer buffer
                   (let ((icon (if (and (buffer-file-name) (icons-in-terminal-auto-mode-match?))
                                   (cond
                                    ((f-dir? (buffer-file-name)) (icons-in-terminal-helm-for-dir (buffer-file-name)))
                                    ((condition-case err
                                      (icons-in-terminal-icon-for-file (file-name-nondirectory (buffer-file-name))
                                                                       :height 1.0
                                                                       :v-adjust 0.0)
                                      (error (message (cadr err))
                                             (icons-in-terminal-faicon "file-o"
                                                                       :face 'icons-in-terminal-dsilver
                                                                       :height 0.9
                                                                       :v-adjust 0.0)))))
                                 (icons-in-terminal-icon-for-mode major-mode
                                                                  :height 1.0
                                                                  :v-adjust 0.0))))
                     (if (or (null icon) (symbolp icon))
                         (setq icon (icons-in-terminal-faicon "file-o"
                                                              :face 'icons-in-terminal-dsilver
                                                              :height 0.9
                                                              :v-adjust 0.0))
                       icon)))
                 "  "
                 display)
                buffer))
        candidates))

(defun icons-in-terminal-helm-files-add-icons (candidates _source)
  "Add icon to files source.
CANDIDATES is the list of candidates."
  (-map (-lambda (candidate)
          (-let [(display . file-name) (if (listp candidate)
                                           candidate
                                         (cons candidate candidate))]
            (cons (concat (cond
                           ((f-dir? file-name) (icons-in-terminal-helm-for-dir file-name))
                           ((condition-case err
                                (icons-in-terminal-icon-for-file (file-name-nondirectory file-name)
                                                                 :height 1.0
                                                                 :v-adjust 0.0)
                              (error (message (cadr err))
                                     (icons-in-terminal-faicon "file-o"
                                                               :face 'icons-in-terminal-dsilver
                                                               :height 0.9
                                                               :v-adjust 0.0)))))
                          "  "
                          display)
                  file-name)))
        candidates))

(defun icons-in-terminal-helm-add-transformer (fn source)
  "Add FN to `filtered-candidate-transformer' slot of SOURCE."
  (setf (alist-get 'filtered-candidate-transformer source)
        (-uniq (append
                (-let [value (alist-get 'filtered-candidate-transformer source)]
                  (if (seqp value) value (list value)))
                (list fn)))))

(defun icons-in-terminal-helm--make (orig name class &rest args)
  "The advice over `helm-make-source'.
ORIG is the original function.
NAME, CLASS and ARGS are the original params."
  (let ((result (apply orig name class args)))
    (message "class: %s name: %s" class name)
    (cl-case class
      ((helm-recentf-source helm-source-ffiles helm-locate-source helm-fasd-source)
       (icons-in-terminal-helm-add-transformer
        #'icons-in-terminal-helm-files-add-icons
        result))
      ((helm-source-buffers helm-source-projectile-buffer)
       (icons-in-terminal-helm-add-transformer
        #'icons-in-terminal-helm-buffers-add-icon
        result)))
    (cond
     ((or (-any? (lambda (source-name) (s-match source-name name))
                 '("Projectile files"
                   "Projectile projects"
                   "Projectile directories"
                   "Projectile recent files"
                   "Projectile files in current Dired buffer"
                   "dired-do-rename.*"
                   "Elisp libraries (Scan)")))
      (icons-in-terminal-helm-add-transformer
       #'icons-in-terminal-helm-files-add-icons
       result)))
    result
))

;;;###autoload
(defun icons-in-terminal-helm-enable ()
  "Enable `icons-in-terminal-helm'."
  (interactive)
  (advice-add 'helm-make-source :around #'icons-in-terminal-helm--make))

(provide 'icons-in-terminal-helm)
;;; icons-in-terminal-helm.el ends here
