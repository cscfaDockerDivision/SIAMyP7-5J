#!/bin/bash

SOURCE=
HOST=
IP=
IMAGE=
VERBOSE=0
NET=

function log () {
  if [[ $VERBOSE -eq 1 ]]; then
    echo "$@"
  fi
}
function usage() {
  echo "Usage: $0 --source-volume|-o <string> --host|-t <string> --ip|-p <string> --image|-i <string> [--net|-n <string>] [--verbose|-v] [--help|-h]" 1>&2
  echo ""
  echo "-o (source volume) The path to the local jenkins/mysql to be mounted into the container"
  echo "-t (host) The server name of the container"
  echo "-p (ip) The container ip"
  echo "-i (image) The docker image name to run"
  echo "-n (net) The docker network to use"
  echo "-v (verbose) Display more informations"
  echo "-h (help) Display this help"
  exit 1
}

max_loop=100
while true; do
  max_loop=$((max_loop-1))
  if [ $max_loop -lt 0 ]; then
    usage
    break
  fi

  case "$1" in
    -v | --verbose ) VERBOSE=1; shift ;;
    -o | --source-volume ) SOURCE="$2"; shift 2 ;;
    -t | --host ) HOST="$2"; shift 2 ;;
    -p | --ip ) IP="$2"; shift 2 ;;
    -i | --image ) IMAGE="$2"; shift 2 ;;
    -n | --net ) NET="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

log "source : ${SOURCE}"
log "host : ${HOST}"
log "ip : ${IP}"
log "image : ${IMAGE}"
log "net : ${NET}"

declare -A values
values[source]="${SOURCE}"
values[host]="${HOST}"
values[ip]="${IP}"
values[image]="${IMAGE}"

for i in "${!values[@]}"
do
  if [ -z "${values[$i]}" ]; then
    echo "$i must be defined"
    exit 2
  else
    if [ ${SOURCE:0:1} == "-" ]; then
      echo "$i require a value"
      exit 3
    fi
  fi
done

COM_VOLUME="-v ${SOURCE}:/mnt/hostShared"
COM_HOST="--add-host=${HOST}:${IP}"

COM_NET=""
if [ -n "${NET}" ]; then
  if [ `docker network ls | grep " ${NET} " | wc -l $f | cut -f1 -d' '` -lt 1 ]; then
    echo
    echo "Docker network ${NET} does not exist. Existing are : "
    docker network ls
    echo ""
    echo "For help see https://docs.docker.com/engine/reference/commandline/network_create/"
    echo ""
    exit 4
  fi
  COM_NET=" --net ${NET} --ip ${IP}"
fi


docker run${COM_NET} -td ${COM_VOLUME} ${COM_HOST} ${IMAGE}
