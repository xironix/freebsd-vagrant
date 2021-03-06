# bash completion for tcpdump

have tcpdump &&
  _tcpdump()
{
  local cur prev

  COMPREPLY=()
  _get_comp_words_by_ref cur prev

  case $prev in
    -r|-w|-F)
      _filedir
      return 0
      ;;
    -i)
      _available_interfaces -a
      return 0
      ;;
  esac


  if [[ "$cur" == -* ]]; then
    COMPREPLY=( $( compgen -W '-a -d -e -f -l -n -N -O -p \
      -q -R -S -t -u -v -x -C -F -i -m -r -s -T -w -E' -- "$cur" ) )
  fi

} &&
  complete -F _tcpdump tcpdump

# Local variables:
# mode: shell-script
# sh-basic-offset: 4
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# ex: ts=4 sw=4 et filetype=sh
