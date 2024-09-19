;;; flycheck-buf-lint.el --- A flycheck handler for protobuf-mode files

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
;;   (require 'flycheck-buf-lint)
;;   (add-hook 'protobuf-mode-hook 'flycheck-buf-lint-setup)

;;; Code:
(require 'flycheck)

(defun flycheck-buf-lint--project-root (&optional _checker)
  "Flycheck buf lint get project root."
  (and buffer-file-name
       (expand-file-name (locate-dominating-file buffer-file-name "buf.yaml"))))

(flycheck-define-checker buf-lint
  "Buf lint checker."
  :command ("buf" "lint"
            (eval (concat (string-trim-left (buffer-file-name) (flycheck-buf-lint--project-root))
                          "#include_package_files=true")))
  :error-patterns
  ((error line-start (file-name) ":" line ":" column ":" (message) line-end))
  :working-directory flycheck-buf-lint--project-root
  :enabled flycheck-buf-lint--project-root
  :modes (protobuf-mode))

;;;###autoload
(defun flycheck-buf-lint-setup ()
  "Setup Flycheck buf-lint."
  (interactive)
  (add-to-list 'flycheck-checkers 'buf-lint))

(provide 'flycheck-buf-lint)
;;; flycheck-buf-lint.el ends heree