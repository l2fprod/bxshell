_bxshell_complete()
{
  local cur_word prev_word type_list

  cur_word="${COMP_WORDS[COMP_CWORD]}"
  prev_word="${COMP_WORDS[COMP_CWORD-1]}"

  environment_list=`ls $HOME/.bxshell/environments 2>/dev/null`
  COMPREPLY=( $(compgen -W "${environment_list}" -- ${cur_word}) )
  return 0
}
complete -F _bxshell_complete bxshell
