;;; thelpa.el --- Build and publish ThELPA with GitHub Pages -*- lexical-binding: t -*-
;;
;; Copyright (c) 2023 Jade Michael Thornton
;; Copyright (C) 2016 10sr
;;
;; URL: https://github.com/thornjad/thelpa
;; Version: 0.1.0
;; Package-Requires: ((package-build "1.0") (commander "0.7.0") (git "0.1.1"))
;;
;; This file is not part of GNU Emacs.
;;
;; Permission to use, copy, modify, and/or distribute this software for any
;; purpose with or without fee is hereby granted, provided that the above
;; copyright notice and this permission notice appear in all copies.
;;
;; The software is provided "as is" and the author disclaims all warranties with
;; regard to this software including all implied warranties of merchantability
;; and fitness. In no event shall the author be liable for any special, direct,
;; indirect, or consequential damages or any damages whatsoever resulting from
;; loss of use, data or profits, whether in an action of contract, negligence or
;; other tortious action, arising out of or in connection with the use or
;; performance of this software.
;;
;;; Commentary:
;;
;; ThELPA is an Emacs utility to maintain the ThELPA package repository. The repository is built
;; into the docs/thelpa directory, ready for GitHub to serve through GH Pages.
;;
;; This package is mainly intended to be used from Cask. See https://github.com/thornjad/thelpa for
;; usage guide.
;;
;; This package is based on 10sr's github-elpa project
;;

(require 'package-build)
(require 'git)

;;; Code:

(defvar thelpa-working-dir "./.thelpa-working"
  "Working directory for ThELPA during build time.")

(defvar thelpa-archive-dir "./docs/thelpa"
  "Directory to store built packages.")

(defvar thelpa-recipes-dir "./recipes"
  "Directory to store recipes.")

(defvar thelpa-tar-executable nil
  "Path to tar executable.")

(defun thelpa--git-check-repo ()
  "Check if current directory is git top level directory."
  (or (git-repo? default-directory)
      (error (concat "Working directory is not a git directory: "
                     default-directory
                     " Did you mean to run this from the top level of ThELPA?"))))

(defun thelpa--git-check-workdir-clean ()
  "Check if current working tree is clean."
  (let ((git-repo default-directory))
    (condition-case err
        (git-run "diff" "--quiet")
      (git-error (error "ThELPA Git working tree is not clean")))))

(defun thelpa--git-commit-archives ()
  "Commit elpa archives to git repository."
  (let ((git-repo default-directory))
    (git-add thelpa-archive-dir)
    (git-commit "[ThELPA] Update archive" thelpa-archive-dir)))

;;;###autoload
(defun thelpa-build ()
  "Main build function for ThELPA."
  (let ((package-build-working-dir (expand-file-name thelpa-working-dir))
        (package-build-archive-dir (expand-file-name thelpa-archive-dir))
        (package-build-recipes-dir (expand-file-name thelpa-recipes-dir)))
    (thelpa--git-check-repo)
    (thelpa--git-check-workdir-clean)
    (make-directory package-build-archive-dir t)
    ;; TODO Currently no way to detect build failure...
    (dolist (recipe (directory-files package-build-recipes-dir nil "^[^.]"))
      (message ":: ThELPA: packaging recipe %s" recipe)
      (let ((package-build-tar-executable (or thelpa-tar-executable
                                              package-build-tar-executable)))
        (package-build-archive recipe)))
    (package-build-cleanup)))

;;;###autoload
(defun thelpa-commit ()
  "Commit built packages to git repository."
  (let ((package-build-working-dir (expand-file-name thelpa-working-dir))
        (package-build-archive-dir (expand-file-name thelpa-archive-dir))
        (package-build-recipes-dir (expand-file-name thelpa-recipes-dir)))
    (message ":: ThELPA: Commit packages in %s" package-build-archive-dir)
    (thelpa--git-check-repo)
    (thelpa--git-commit-archives)))

(provide 'thelpa)

;;; thelpa.el ends here
