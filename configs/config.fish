function mkcd
    mkdir $argv
    cd $argv[1]
end

function screenshot
    set output_arg
    if test (count $argv) -gt 0
        set output_arg -o $argv
    end
    grim -g "$(slurp)" - | swappy -f - $output_arg
end

mise activate fish | source
