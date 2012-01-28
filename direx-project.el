;;; direx-project.el --- Project Module for Direx

;; Copyright (C) 2012  Tomohiro Matsuyama

;; Author: Tomohiro Matsuyama <tomo@cx4a.org>
;; Keywords: convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(require 'cl)
(require 'direx)

(defgroup direx-project nil
  "Project Module for Direx."
  :group 'direx
  :prefix "direx-project:")

(defcustom direx-project:project-root-predicate-functions
  '(direx-project:git-root-p)
  "List of functions which predicate whether the directory is a
project root or not."
  :type '(repeat function)
  :group 'direx-project)

(defun direx-project:git-root-p (dirname)
  (file-exists-p (expand-file-name ".git" dirname)))

(defun direx-project:project-root-p (dirname)
  (some (lambda (fun) (funcall fun dirname))
        direx-project:project-root-predicate-functions))

(defun direx-project:jump-to-project-root-noselect ()
  (interactive)
  (loop for parent-dirname in (direx:directory-parents (or buffer-file-name default-directory))
        if (direx-project:project-root-p parent-dirname)
        return (let ((buffer (direx:find-directory-noselect parent-dirname)))
                 (direx:maybe-goto-current-node-in-directory buffer)
                 buffer)))

(defun direx-project:jump-to-project-root ()
  (interactive)
  (let ((buffer (direx-project:jump-to-project-root-noselect)))
    (if buffer
        (switch-to-buffer buffer)
      (error "Project root not found"))))

(defun direx-project:jump-to-project-root-other-window ()
  (interactive)
  (let ((buffer (direx-project:jump-to-project-root-noselect)))
    (if buffer
        (switch-to-buffer-other-window buffer)
      (error "Project root not found"))))

(provide 'direx-project)
;;; direx-project.el ends here
