;; -*- lexical-binding: t; -*-
(defgroup Scala-Extras nil
  "Scala Programming Language"
  :group 'convenience
  :prefix "scala-")

(defcustom scala-extras-output-buffer-name "*Scala Output Buffer*"
  "Name of the buffer for scala output"
  :type 'string
  :group 'Scala-Extras)

(defcustom scala-extras-command "scala"
  "Command used to execute scala code. Default 'scala'.
  You can provide the command with explicit path to use a specific version"
  :type 'string
  :group 'Scala-Extras)


(defcustom scala-extras-keep-buffer-contents nil
  "Whether to keep the output buffer contents between runs
  If non nil, the buffer will not be cleared between subsequent runs. Output will
  be inserted at point, wherever that happens to be."
  :type 'boolean
  :group 'Scala-Extras)

(defcustom scala-extras-execution-arguments "-q"
  "Extra arguments to be passed to scala-cli when calling"
  :type 'string
  :group 'Scala-Extras)


(defcustom scala-extras-split-direction 'right
  "Direction to split the window (right, below, or no split)"
  :type '(choice string (const right) (const below) (const none))
  :group 'Scala-Extras)

;; Configure errors for Mill builds
(with-eval-after-load 'compile
  (progn
    (push 'mill compilation-error-regexp-alist)
    (push '(mill ".*\\[\\(error\\|warn\\)\\] -- .*: \\([/0-9a-zA-Z-_\\.]+\\):\\([0-9]+\\):\\([0-9]+\\)" 2 3 4)
          compilation-error-regexp-alist-alist)
    ))

;; Use scala-ts-mode for .mill files
(add-to-list 'auto-mode-alist '("\\.mill" . scala-ts-mode))

;; Configurations
(with-eval-after-load 'scala-ts-mode
  (progn
    (setopt treesit-font-lock-level 4)       ;; Show actual color highlights
    (add-hook 'scala-ts-mode-hook 'lsp)      ;; Enable lsp-mode and dap-mode
    (add-hook 'scala-ts-mode-hook 'dap-mode)
    ;; Key bindings to restore expected functionality from the scala layer
    (spacemacs/declare-prefix-for-mode 'scala-ts-mode "mb" "sbt")
    (spacemacs/declare-prefix-for-mode 'scala-ts-mode "mg" "goto")
    (evil-define-key 'normal scala-ts-mode-map "J" 'spacemacs/scala-join-line)
    (spacemacs/set-leader-keys-for-major-mode 'scala-ts-mode
      "b." 'sbt-hydra
      "bb" 'sbt-command
      "bc" #'spacemacs/scala-sbt-compile
      "bt" #'spacemacs/scala-sbt-test
      "bI" #'spacemacs/scala-sbt-compile-it
      "bT" #'spacemacs/scala-sbt-compile-test
      "b=" #'spacemacs/scala-sbt-scalafmt-all)
    ))
