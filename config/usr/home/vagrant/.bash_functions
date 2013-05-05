# Handy extraction function
extract() {
  local c e i

  (($#)) || return

  for i; do
    c=''
    e=1

    if [[ ! -r $i ]]; then
      echo "$0: file is unreadable: \`$i'" >&2
      continue
    fi

    case $i in
      *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
             c='bsdtar xvf';;
      *.7z)  c='7z x';;
      *.Z)   c='uncompress';;
      *.bz2) c='bunzip2';;
      *.exe) c='cabextract';;
      *.gz)  c='gunzip';;
      *.rar) c='unrar x';;
      *.xz)  c='unxz';;
      *.zip) c='unzip';;
      *)     echo "$0: unrecognized file extension: \`$i'" >&2
             continue;;
    esac

    command $c "$i"
    e=$?
  done

  return $e
}

# Change directory and list contents
cl() {
  if [ -d "$1" ]; then
    cd "$1"
    ll
    else
    echo "bash: cl: '$1': Directory not found"
  fi
}

# Trap error codes
EC() {
  echo -e '\033[1;33m'code $?'\033[0m';
}
trap EC ERR
