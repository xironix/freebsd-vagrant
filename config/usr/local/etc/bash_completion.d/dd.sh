# bash completion for dd

have dd &&
  _dd()
{
  local cur

  COMPREPLY=()
  _get_comp_words_by_ref -n = cur

  case $cur in
    if=*|of=*)
      cur=${cur#*=}
      _filedir
      return 0
      ;;
    conv=*)
      cur=${cur#*=}
      COMPREPLY=( $( compgen -W 'ascii ebcdic ibm block unblock lcase
      notrunc ucase swab noerror sync' -- "$cur" ) )
      return 0
      ;;
  esac

  _expand || return 0

  COMPREPLY=( $( compgen -W '--help --version' -- "$cur" ) \
    $( compgen -W 'bs cbs conv count ibs if obs of seek skip' \
    -S '=' -- "$cur" ) )
} &&
  complete -F _dd -o nospace dd

# Local variables:
# mode: shell-script
# sh-basic-offset: 4
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# ex: ts=4 sw=4 et filetype=sh
