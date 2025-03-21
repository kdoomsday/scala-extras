(defgroup Scala-Extras nil
  "Scala Programming Language"
  :group 'convenience
  :prefix "scala-")

(defcustom scala-extras-output-buffer-name "*Scala Output Buffer*"
  "Name of the buffer for scala output"
  :type 'string
  :group 'Scala-Extras)

(defcustom scala-extras-command "scala-cli"
  "Command used to execute scala code. Default 'scala-cli'.
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

