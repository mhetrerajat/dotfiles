# dotfiles.fish - Function to manage dotfiles using Git
#
# Usage:
#   dotfiles <git-command> [options]
#
# Description:
#   Manages dotfiles using a bare Git repository with a fixed remote URL.
#   Automatically sets up the repository if it does not exist.
#
# Repository:
#   Remote URL: git@github.com:mhetrerajat/dotfiles.git
#
# Examples:
#   dotfiles status               # Check the status of tracked dotfiles
#   dotfiles add .vimrc           # Stage a dotfile for commit
#   dotfiles commit -m "Update"   # Commit changes
#   dotfiles push origin main     # Push changes to the remote repository
#   dotfiles checkout -b new-branch  # Create and switch to a new branch

# function dotfiles
#     set gitdir $HOME/.dotfiles
#     set worktree $HOME
#     set remote_url git@github.com:mhetrerajat/dotfiles.git
#     set branch v3

#     # Clone the repo if it doesn't exist
#     if not test -d $gitdir
#         echo "Cloning dotfiles repository..."
#         /usr/bin/git clone --bare $remote_url $gitdir -b $branch
#         #/usr/bin/git --git-dir=$gitdir fetch --all
# 
#         # Ensure untracked files are hidden
#         /usr/bin/git --git-dir=$gitdir --work-tree=$worktree config status.showUntrackedFiles no
# 
#         #/usr/bin/git --git-dir=$gitdir --work-tree=$worktree checkout $branch
#     end

#     # Execute the Git command with the given arguments
#     /usr/bin/git --git-dir=$gitdir --work-tree=$worktree $argv
# end


function dotfiles
    set gitdir $HOME/.dotfiles
    set worktree $HOME
    set remote_url git@github.com:mhetrerajat/dotfiles.git
    set branch v3

    if not test -d $gitdir
        /usr/bin/git clone --bare $remote_url $gitdir

        /usr/bin/git --git-dir=$gitdir --work-tree=$worktree config status.showUntrackedFiles no
    end 

    /usr/bin/git --git-dir=$gitdir --work-tree=$worktree $argv
end 

