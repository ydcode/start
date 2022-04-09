#!/bin/sh

chmod +x docker_container_clean*
#*/3 * * * * /home/docker_container_clean.sh >> /var/log/docker_container_clean.log 2>&1

CONTAINER_KEYWORD=${1:-'super_proxy__'}
MAX_CONTAINER_NUMBER=${2:-8}
DELETE_CONTAINER_NUMBER=${3:-3}

if [ $(docker ps | grep "${CONTAINER_KEYWORD}" | awk 'END{print FNR}') -gt "${MAX_CONTAINER_NUMBER}" ]; then
  DOCKER_CONTAINER_LIST=$(docker ps | grep "${CONTAINER_KEYWORD}" | awk  '{print $10, $14}' | tail -"${DELETE_CONTAINER_NUMBER}" | awk '{printf $2 " " }')
  echo "${DOCKER_CONTAINER_LIST}"

  #不要双引号
  sudo docker rm -f ${DOCKER_CONTAINER_LIST}
  echo "Container Count > ${MAX_CONTAINER_NUMBER}, will delete oldest ${DELETE_CONTAINER_NUMBER}"
fi


#docker rm -f $(docker ps | grep ${CONTAINER_KEYWORD} | grep -E '[0-9]{2,4} hours' | awk '{print $14}')
#[ $(docker ps | grep super | grep -E '[0-9]{2,4} hours' | awk 'END{print FNR}') -gt 10 ] && echo 111 || echo 222
