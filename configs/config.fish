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

function jj-push
    jj bookmark set main -r @-; and jj git push
end

mise activate fish | source
