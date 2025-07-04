(spacemacs/declare-prefix "o" "other")
(spacemacs/declare-prefix "os" "scala-extras")
(spacemacs/set-leader-keys
  "ose" 'scala-extras-execute-and-switch
  "oss" 'scala-extras-execute-and-switch
  "osE" 'scala-extras-execute
  "osS" 'scala-extras-execute
  "osd" 'scala-extras-execute-directory-and-switch
  "osD" 'scala-extras-execute-directory
  "osc" 'scala-extras-execute-to-clipboard
  "os." 'hydra-scala/body)
(spacemacs/set-leader-keys-for-major-mode 'scala-mode "ox" 'lsp-metals-run-scalafix)
