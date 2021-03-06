# ast:parse:command-call $command_ast $out
#
# parse an AST of the form: command expr1 expr2...
#

ast:parse:command-call() { #<<NOSHADOW>>
  local assigns="$1" out="$2"
  local cmd

  if [ -z "$assigns" ]; then
    ast:make assigns 'assign-sequence' ''
  fi

  ast:parse:expr cmd
  ast:parse:command-call-with-cmd "$assigns" "$cmd" "$out"
}
noshadow ast:parse:command-call 1

ast:parse:command-call-with-cmd() { #<<NOSHADOW>>
  local assigns=$1 command_ast=$2 out="$3"

  if ast:is $command_ast name math; then
    local state
    ast:parse:math "$out"
    ast:last-state state
    case "$state" in
      '(') token:require special ')' ;;
      '[') token:require special ']' ;;
      '{') token:require special '}' ;;
    esac

  else
    local expression child predicate
    ast:make expression call '' $assigns $command_ast

    if ast:state-is ==; then
      predicate='ast:parse:not-binary-conditional %'
    else
      predicate='true'
    fi
    ast:parse:sequence $expression "$predicate"
    setvar "$out" $expression
  fi
}
noshadow ast:parse:command-call-with-cmd 2


ast:parse:not-binary-conditional() {
  local expr="$1"
  local name

  if ast:is $expr name; then
    ast:from $expr value name
    case "$name" in
      and|or|'&&'|'||') return 1 ;;
      *)                return 0 ;;
    esac
  fi
  return 0
}
