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

(defun scala-extras-execute-directory ()
  "Send the entire directory as a scala-cli project"
  (interactive)
  (let ((directory (file-name-directory (buffer-file-name))))
    (if (null directory)
        (message "Buffer is not visiting a file")
      (let ((buffer (scala-extras-create-buffer)))
        (call-process-region nil nil scala-extras-command nil buffer t "." "-q")))))

(defun scala-extras-execute-directory-and-switch ()
  "Send directory as scala-cli project and switch to results buffer"
  (interactive)
  (scala-extras-execute-directory)
  (switch-to-buffer scala-extras-output-buffer-name))

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
    (call-process-region begin end scala-extras-command nil buffer t mode "-q")
    (if switch (switch-to-buffer buffer))))
