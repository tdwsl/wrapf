
create tokens 30 3 cells * allot
variable ntokens
variable wrapx
40 value wrapw
create wstart 2 cells allot
0 wstart !
3 value wjump

: str+ ( addr u -- addr u )
  dup if 1- swap 1+ swap then ;

: strchr ( addr u c -- addr u )
  -rot
  begin
    over c@ 3 pick = over 0= or if
      rot drop exit
    then
    str+
  again ;

: split ( addr u c -- addr2 u addr1 u )
  >r 2dup r> strchr 2swap 2 pick - ;

: token ( u -- addr )
  3 cells * tokens + ;

: wcumlen ( -- u )
  wstart @ ntokens @ 0 do
    i token dup cell+ @ swap 2 cells + @ + +
  loop ;

: wline-space ( -- )
  0 ntokens @ 1- token 2 cells + !
  0 begin wcumlen wrapw < while
    1 over token 2 cells + +!
    wjump + ntokens @ 1- mod
  repeat drop ;

: token. ( addr -- )
  dup @ over cell+ @ type 2 cells + @ spaces ;

: wline. ( -- )
  wstart dup cell+ @ swap @ type
  ntokens @ 0 ?do
    i token token.
  loop
  cr ;

: +token ( addr u -- )
  ntokens @ token swap over cell+ ! dup -rot !
  1 swap 2 cells + ! 1 ntokens +! ;

: wprint ( addr u -- )
  wstart @ wrapx ! 0 ntokens !
  begin
    32 split dup 1+ wrapx +!
    wrapx @ wrapw >= if
      wjump if wline-space then
      wline.
      dup 1+ wstart @ + wrapx !
      0 ntokens !
    then
    +token str+
  dup 0= until
  2drop wline. ;

