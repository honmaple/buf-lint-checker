;;; flymake-buf-lint.el --- A flymake handler for protobuf-mode files

;; Copyright (C) 2024 honmaple

;; Author: honmaple <mail@honmaple.com>
;; Version: 0.1.0
;; URL: https://github.com/honmaple/buf-lint-checker

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Usage:
;;   (require 'flymake-buf-lint)
;;   (add-hook 'protobuf-mode-hook 'flymake-buf-lint-setup)

;;; Code:
(require 'flymake-proc)

(defun flymake-buf-lint--project-root (&optional _basedir)
  "Flymake buf lint get project root."
  (and buffer-file-name
       (expand-file-name (locate-dominating-file buffer-file-name "buf.yaml"))))

(defun flymake-buf-lint--init ()
  "Flymake buf lint init."
  (let ((root (flymake-buf-lint--project-root)))
    (list "buf"
          (list "lint" (string-trim-left (buffer-file-name) root))
          root)))

(defun flymake-buf-lint--name (name)
  "Flymake buf lint get real NAME."
  (expand-file-name name (flymake-buf-lint--project-root)))

(defun flymake-buf-lint--clean ()
  "Flymake buf lint clean do nothing."
  (ignore))

;;;###autoload
(defun flymake-buf-lint-setup ()
  "Setup Flymake buf-lint."
  (interactive)
  (set (make-local-variable 'flymake-proc-allowed-file-name-masks)
       '(("\\.proto\\'" flymake-buf-lint--init flymake-buf-lint--clean flymake-buf-lint--name)))
  (set (make-local-variable 'flymake-proc-err-line-patterns)
       '(("^\\(.*\\.proto\\):\\([0-9]+\\):\\([0-9]+\\):\\(.*\\)$" 1 2 3 4))))

(provide 'flymake-buf-lint)
;;; flymake-buf-lint.el ends heree