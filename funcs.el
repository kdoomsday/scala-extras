(defun scala-extras-execute-region (&optional switch)
  "Run scala-cli on selected region"
  (scala-extras-call (region-beginning) (region-end) "_.sc" switch))

(defun scala-extras-execute-buffer (&optional switch)
  "Run scala-cli on the contents of the entire buffer"
  (scala-extras-call nil nil (scala-extras-select-mode) switch))

(defun scala-extras-execute (&optional switch)
  "Run a shell command on the current region and open the output in a new buffer."
  (interactive)
  (if (use-region-p) (scala-extras-execute-region switch) (scala-extras-execute-buffer switch)))

(defun scala-extras-execute-and-switch ()
  "Run a shell command on buffer or region, send the output to a buffer and
  switch to that buffer"
  (interactive)
  (scala-extras-execute t))

(defun scala-extras-execute-directory (&optional switch)
  "Send the entire directory as a scala-cli project"
  (interactive)
  (let ((directory (file-name-directory (if buffer-file-name buffer-file-name ""))))
    (if (null directory)
        (message "Buffer is not visiting a file")
      (progn
        (when (and (buffer-modified-p (current-buffer))
                   (yes-or-no-p (format "Buffer '%s' has not been saved. Save now?" (buffer-name))))
          (save-buffer (current-buffer)))
        (let ((buffer (scala-extras-create-buffer)))
          (call-process-region nil nil scala-extras-command nil buffer t "." scala-extras-execution-arguments)
          (if switch (switch-to-buffer buffer)))))))

(defun scala-extras-execute-directory-and-switch ()
  "Send directory as scala-cli project and switch to results buffer"
  (interactive)
  (scala-extras-execute-directory t))

(defun scala-extras-select-mode ()
  "Select the mode to use for running code, as per the buffer name"
  (if (equal (file-name-extension (buffer-name)) "scala") "_" "_.sc"))

(defun scala-extras-create-buffer ()
  "Get or create the output buffer.
   If scala-extras-keep-buffer-contents is non-nil, will move the point to the
   end of the buffer. If nil, it will delete the buffer contents entirely"
  (let ((buffer (get-buffer-create scala-extras-output-buffer-name)))
    (if scala-extras-keep-buffer-contents
        (with-current-buffer buffer (goto-char (point-max)))
        (with-current-buffer buffer (erase-buffer)))
    buffer))

(defun scala-extras-call (begin end mode &optional switch)
  "Actually call the scala-cli command on selected region
   If begin is nil will send the whole buffer to the command.
   Mode chooses whether to execute as a scala buffer or scala script.
   Returns the buffer used."
  (let ((buffer (scala-extras-create-buffer)))
    (call-process-region begin end scala-extras-command nil buffer t mode scala-extras-execution-arguments)
    (if switch (switch-to-buffer buffer))))

(defun scala-extras-copy-output-dir ()
    "Copy all the contents of the output directory"
  (with-current-buffer scala-extras-output-buffer-name
    (clipboard-kill-region (point-min) (point-max))))

(defun scala-extras-execute-to-clipboard ()
  "Call Scala-Cli on region or buffer and copy output to clipboard"
  (interactive)
  (scala-extras-execute)
  (scala-extras-copy-output-dir))

(defun scala-extras-execute-directory-to-clipboard ()
  "Call the entire directory as a scala-cli project and copy the output to clipboard"
  (interactive)
  (scala-extras-execute-directory)
  (scala-extras-copy-output-dir))
