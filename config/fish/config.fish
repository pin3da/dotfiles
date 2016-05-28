set -x TERM xterm-256color

function mkcd
  mkdir $argv
  cd $argv[1]
end
