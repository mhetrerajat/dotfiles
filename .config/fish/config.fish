if status is-interactive
    # Commands to run in interactive sessions can go here
end


# set SHELL
set -gx SHELL (which fish)

# Environment Vars
set -gx LANG en_US.UTF-8

# Editor
set -gx EDITOR nvim
set -gx GIT_EDITOR $EDITOR

