#!/usr/bin/env bash
if [ $# -eq 0 ]; then
  echo "Port number required"
  exit 1
fi

pId="$(lsof -nti:$1)"

if [ -z "$pId" ]; then
  echo "Could not find pId of port $1";
else
  echo "Killing pId: $pId of port $1";
  kill -9 $pId
  echo "port $1 killed successfully";
fi
