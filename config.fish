set -x TERM xterm-256color

function mkcd
  mkdir $argv
  cd $argv[1]
end

function compi
  g++ -static -Wall -O3 -DLOCAL $argv[1].cc -o $argv[1].out
end

function cprun
  eval time -p ./$argv[1].out < $argv[2].in > $argv[1].tmp
  if diff $argv[1].tmp $argv[2].ans
    set_color green
    echo 'passed'
    set_color normal
  else
    set_color red
    echo 'wrong answer'
    set_color normal
  end
end

function cptest
  compi $argv[1]
  cprun $argv[1] $argv[2]
end

function cpbatch
  compi $argv[1]
  for i in (seq $argv[3] $argv[4])
    cprun $argv[1] $argv[2]$i
  end
end


set -gx PATH  $PATH /home/pin3da/gopath/bin
set -gx GOPATH /home/pin3da/gopath/bin
