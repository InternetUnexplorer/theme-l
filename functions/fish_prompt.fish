# name: L
function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function fish_prompt
  set -l purple (set_color purple)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l normal (set_color normal)

  set -l arrow "λ"
  set -l cwd $blue(basename (prompt_pwd))

  if [ (_git_branch_name) ]
    set git_info $green(_git_branch_name)
    set git_info ":$git_info"

    if [ (_is_git_dirty) ]
      set -l dirty "*"
      set git_info "$git_info$dirty"
    end
  end

  if [ $SHLVL -gt 1 ]
    set nested $purple(math $SHLVL - 1)' '
  end

  if set -q SSH_CLIENT; or set -q SSH_TTY
    set remote $purple'('(hostname -s)') '
  end

  echo -n -s $remote $nested $cwd $git_info $normal ' ' $arrow ' '
end
