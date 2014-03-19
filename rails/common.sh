#!/bin/sh

getCurrentBranch ()
{
  echo "$(git branch | grep "*" | awk '{print $2}')"
}

getTicket ()
{
  if [ `expr $1 : "^DEV\-[0-9]\+.*"` -gt 0 ]; then
    echo "$(echo $1 | sed -e "s/^\(DEV\-[0-9]\+\).*/\1/g")"
  else
    echo ""
  fi
}

appendTicketNumberToCommitMessage ()
{
  branch="$(getCurrentBranch)"
  ticket="$(getTicket "$branch")"
  if [ "$ticket" != "" ]; then
    ticket_line="$(egrep "^[^#]*DEV\-[0-9]+.*" $1)"
    if [ "$ticket_line" = "" ]; then
      mv $1 $1.tmp
      echo -n "$ticket " > $1
      cat $1.tmp >> $1
      rm $1.tmp
    fi
  fi
}
