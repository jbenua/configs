#!/usr/bin/env bash

CURL=$(which curl)

function usage {
	echo -e  "Usage: ${0} <text> [count] [days]
	or echo <text> | ${0} [count] [days]
	<text> - text to send to enigma.bk.ru
	[count] - get [count] different links for this text, default 1.
    [days] - due [days] days from now, default 3, min 1.

	Example: ${0} P@ssword - Get one link, that will expire in 1 day
	         echo -e \"Login\\\nP@ssw0rd\" | ${0} 3 1 - Get 3 links, that will expire in 1 day
	"
	exit 1
}
function runcurl {
	${CURL} -w '\n' 'https://enigma.bk.ru/post/' --data-urlencode "msg=${MSG}" --data "due=${DAYS}" --data 'send=send' --data 'type=text'
}

declare -i COUNT
declare -i DAYS

if [ -t 0 ]; then
	MSG=${1}
	COUNT=${2:-1}
	DAYS=${3:-3}
else
	MSG=$(</dev/stdin)
	COUNT=${1:-1}
	DAYS=${2:-3}
fi

if [ -z "${MSG}" ] || [ "${COUNT}" -eq 0 ] || [ ${DAYS} -eq 0 ]; then 
	usage;
fi

for (( i=1; i<=${COUNT} ; i++ )); do
	runcurl
done
