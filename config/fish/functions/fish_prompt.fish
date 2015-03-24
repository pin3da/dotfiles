# name : m

function _git_branch_name
    echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
    echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function fish_prompt -d "Sets a simple prompt"
	set -l last_status $status

	set -l pwd (prompt_pwd)
	set -l pwd1 (dirname $pwd)
	set -l pwd2 (basename $pwd)

    set -l blue (set_color blue)
    set -l green (set_color green)
    set -l normal (set_color normal)
    set -l arrow "λ"
    set -l user (id -u $USER)


	# Show a compressed path, highlighting only the last component
	if test $pwd1 != '.' -a $pwd2 != '/'
		echo -n -s (set_color $fish_color_cwd)$pwd1
		if test $pwd1 != '/'
			echo -n '/'
		end
	end
	echo -n -s (set_color -o $fish_color_cwd)$pwd2


    # Show info about git projects
    if [ (_git_branch_name) ]
        set git_info $blue(_git_branch_name)
        set git_info " $git_info"
        if [ (_is_git_dirty) ]
            set -l dirty "*"
            set git_info "$git_info$dirty"
        end
    end

    echo -n -s $git_info $normal

	# A very cool lambda sign; red in case the last command failed
	if test $last_status -eq 0
        # root user id
        if test $user -eq 0
            set_color -o green
        else
    		set_color -o white
        end
	else
		set_color -o red
	end

	echo -n -s ' ' $arrow ' '  $normal
end

