# CUSTOM COMMANDS -----------------------------------------------------------------------------------------------------

_pm() {
  if [[ -f package.json ]]; then
    local pm
    pm=$(command jq -r '.packageManager // empty' package.json 2>/dev/null)
    if [[ -n "$pm" ]]; then
      echo "${pm%%@*}"
      return
    fi
  fi

  [[ -f pnpm-lock.yaml ]] && { echo pnpm; return; }
  [[ -f bun.lock || -f bun.lockb ]] && { echo bun; return; }
  [[ -f yarn.lock ]] && { echo yarn; return; }
  [[ -f package-lock.json ]] && { echo npm; return; }

  echo npm
}

_pm_exec() {
  local pm=$(_pm)
  if [[ "$pm" == bun ]]; then
    bun "$@"
  elif command -v corepack >/dev/null; then
    corepack "$pm" "$@"
  else
    "$pm" "$@"
  fi
}

_pm_remove() {
  local pm=$(_pm)

  case "$pm" in
    pnpm)
      _pm_exec remove "$@"
      ;;
    bun)
      bun remove "$@"
      ;;
    npm)
      npm uninstall "$@"
      ;;
    yarn)
      yarn remove "$@"
      ;;
    *)
      echo "Unknown package manager: $pm" >&2
      return 1
      ;;
  esac
}

_pm_add() {
  local pm=$(_pm)

  # No args: install dependencies
  if (( $# == 0 )); then
    _pm_exec install
    return
  fi

  case "$pm" in
    pnpm)
      _pm_exec add "$@"
      ;;
    bun)
      bun add "$@"
      ;;
    npm)
      npm install "$@"
      ;;
    yarn)
      yarn add "$@"
      ;;
    *)
      echo "Unknown package manager: $pm" >&2
      return 1
      ;;
  esac
}

pi-up() {
  local mode="${1:-self}"

  case "$mode" in
    all)        pi update --all || return 1 ;;
    extensions) pi update --extensions || return 1 ;;
    self)       pi update || return 1 ;;
    -h|--help)
      echo "usage: pi-up [all|extensions|self]"
      echo "  all         update pi + all packages, then sync SDK pin"
      echo "  extensions  update packages only, then sync SDK pin"
      echo "  self        update pi only (default)"
      return 0
      ;;
    *)
      echo "pi-up: unknown mode '$mode' (expected all|extensions|self)" >&2
      return 1
      ;;
  esac

  [[ "$mode" == self ]] && return 0

  local pkg="$HOME/.pi/agent/npm/package.json"
  local dep='@earendil-works/pi-coding-agent'
  local pi_ver
  pi_ver=$(pi --version)

  if ! grep -q "\"$dep\"" "$pkg"; then
    echo "pi-up: no SDK pin in package.json — nothing to sync"
    return 0
  fi

  if grep -q "\"$dep\": *\"$pi_ver\"" "$pkg"; then
    echo "pi-up: SDK pin already $pi_ver"
  else
    sed -i '' "s|\"$dep\": *\"[^\"]*\"|\"$dep\": \"$pi_ver\"|" "$pkg"
    echo "pi-up: SDK pin synced to $pi_ver"
  fi

  (cd "$HOME/.pi/agent/npm" && npm install --legacy-peer-deps --no-fund --no-audit)
}

## ALIASES ------------------------------------------------------------------------------------------------------------

alias docker-compose="docker compose --compatibility $@"
alias dc="docker compose"
alias d="_pm_exec run dev"
alias b="_pm_exec run build"
alias s="_pm_exec run serve"
alias p="_pm_exec run preview"
alias st="_pm_exec run start"
alias un='f() { _pm_remove "$@" };f'
alias i='f() { _pm_add "$@" };f'
alias prettyjson='python -m json.tool'

alias ls='lsd --group-directories-first'
alias ll='lsd -la'
alias la='lsd -a'
alias l='lsd -l'
alias lt='lsd -l --sort time --blocks size,date,name'


