(defun scala-extras-execute-region ()
  "Run scala-cli on selected region"
  (let ((region (region-beginning))
        (end (region-end))
        (buffer (scala-extras-create-buffer)))
    (call-process-region region end scala-extras-command nil buffer t "_.sc" "-q")))

(defun scala-extras-execute-buffer ()
  "Run scala-cli on the contents of the entire buffer"
  (let ((buffer (scala-extras-create-buffer))
        (mode (scala-extras-select-mode)))
    (call-process-region nil nil scala-extras-command nil buffer t mode "-q")))

(defun scala-extras-execute ()
  "Run a shell command on the current region and open the output in a new buffer."
  (interactive)
  (if (use-region-p) (scala-extras-execute-region) (scala-extras-execute-buffer)))

(defun scala-extras-execute-and-switch ()
  "Run a shell command on buffer or region, send the output to a buffer and
  switch to that buffer"
  (interactive)
  (if (use-region-p) (scala-extras-execute-region) (scala-extras-execute-buffer))
  (switch-to-buffer scala-extras-output-buffer-name))

(defun scala-extras-execute-directory ()
  "Send the entire directory as a scala-cli project"
  (interactive)
  (let ((directory (file-name-directory (buffer-file-name))))
    (if (null directory)
        (message "Buffer is not visiting a file")
      (let ((buffer (scala-extras-create-buffer)))
        (call-process-region nil nil scala-extras-command nil buffer t "." "-q"))
      )
    ))

(defun scala-extras-execute-directory-and-switch ()
  "Send directory as scala-cli project and switch to results buffer"
  (interactive)
  (scala-extras-execute-directory)
  (switch-to-buffer scala-extras-output-buffer-name)
  )

(defun scala-extras-select-mode ()
  "Select the mode to use for running code, as per the buffer name"
  (if (equal (file-name-extension (buffer-name)) "scala") "_" "_.sc")
  )

(defun scala-extras-create-buffer ()
  "Get or create the output buffer"
  (get-buffer-create scala-extras-output-buffer-name '((q . delete-window))))
