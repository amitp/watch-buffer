;; Copyright (C) 2012  Michael Steger

;; Author: Michael Steger <mjsteger1@gmail.com>
;; Keywords: automation, convenience
;; Version: 1.0.0

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
;; This extension provides a way to connect updating a buffer with running a shell command
;; So you can have a shell script which makes and runs a c program, and then you would
;; M-x watch-buffer, enter the shell script to run, and every time you save the file it
;; will run the shell script asynchronously in a seperate buffer

(defgroup watch-buffer nil
  "Watching buffers, and running commands"
  :group 'watch)

(defvar watch-buffer-command nil
  "Command to run when this buffer is saved. Do not set this directly; call watch-buffer.")
(make-variable-buffer-local 'watch-buffer-command)

(defun watch-buffer-run-command ()
  (when watch-buffer-command
    (async-shell-command watch-buffer-command "*Watch-Process*")))

(defun watch-buffer (command)
  "Run a command when the current buffer is saved"
  (interactive "sWhat command do you want: ")
  (setq watch-buffer-command command)
  (add-hook 'after-save-hook 'watch-buffer-run-command))

(defun unwatch-buffer ()
  "Don't run a command when the current buffer is saved"
  (interactive)
  (setq watch-buffer-command nil)
  (remove-hook 'after-save-hook 'watch-buffer-run-command))

(provide 'watch-buffer)
