
set -o pipefail

WHITE='\033[1;37m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

command_exists() {
  command -v "$@" > /dev/null 2>&1
}

sudo_cmd=()

if command_exists sudo; then
  sudo_cmd=(sudo -E bash -c)
elif command_exists su; then
  sudo_cmd=(su -p -s bash -c)
fi

docker ps > /dev/null 2>&1

if [[ ${EUID} -ne 0 && ${#sudo_cmd} -ne 0 ]]; then
  cur_fd="$(printf %q "$BASH_SOURCE")$((($#)) && printf ' %q' "$@")"
  cur_script=$(cat "${cur_fd}")
  ${sudo_cmd[*]} "${cur_script}"

  exit 0
fi

confirmDialog() {
  echo -e "
${WHITE}${1} [y/n]${NC} "
  read -n 1 -r response
  echo

  if ! [[ $response =~ ^[Yy]$ ]]
  then
    exit 1
  fi
}

confirmUser() {
  confirmDialog "This check might be false positive. Proceed anyway?"

  echo -e "
${YELLOW}Help us improve the experience. Report that this check doesn't work for you.${NC}
"

  sleep 3
}

if ! command -v docker > /dev/null 2>&1; then
  echo -e "${RED}It looks like Docker is not installed. Run the command below to install it:${NC}"
  echo 'curl -sSL https://get.docker.com/ | sh'
  confirmUser
fi

if ! command -v nvidia-smi > /dev/null 2>&1; then
  echo -e "${RED}It looks like NVIDIA drivers are not installed. Visit the link below to install it:${NC}"
  echo "https://docs.nvidia.com/cuda/index.html#installation-guides"
  confirmUser
fi

if dpkg -s nvidia-docker > /dev/null 2>&1; then
  echo -e "${RED}It looks like nvidia-docker 1.x.x is installed.
This version is deprecated, please, visit the link below to upgrade to version 2.x.x at least:${NC}"
  echo "https://github.com/NVIDIA/nvidia-docker#quickstart"
  confirmUser
fi

if [ -z $(docker info -f '{{json .Runtimes}}' | grep 'nvidia') ] ; then
  echo -e "${RED}It looks like nvidia-docker >= 2.0 is not installed. Visit the link below to install it:${NC}"
  echo "https://github.com/NVIDIA/nvidia-docker#quickstart"
  confirmUser
fi


export SUPERVISELY_AGENT_IMAGE='supervisely/agent:6.7.12'
export AGENT_HOST_DIR="${HOME}/.supervisely-agent/ACCESS_TOKEN"
export ACCESS_TOKEN='ACCESS_TOKEN'
export SERVER_ADDRESS='https://app.supervise.ly'
export DOCKER_REGISTRY=''
export DOCKER_LOGIN=''
export DELETE_TASK_DIR_ON_FINISH='true'
export DELETE_TASK_DIR_ON_FAILURE='true'
export PULL_POLICY='ifnotpresent'
export DOCKER_PASSWORD=''
export SUPERVISELY_AGENT_FILES=$(echo -n "${HOME}/supervisely/agent-10172")



docker pull "${SUPERVISELY_AGENT_IMAGE}"

retVal=$?
if [ $retVal -ne 0 ]; then
    echo -e "${RED}Couldn't pull the image.
Servers might be overloaded right now or you didn't login to the docker registry via docker login command.
Consider waiting a few minutes and try again.

If this issue persists, please, contact support and attach the log above${NC}"

    confirmDialog "Proceed anyway?"
fi

echo 'Remove existing container if any...'
docker rm -fv "supervisely-agent-ACCESS_TOKEN" 2> /dev/null
docker run -it -d --name="supervisely-agent-ACCESS_TOKEN" --runtime=nvidia  \
      --restart=unless-stopped \
      -e AGENT_HOST_DIR \
      -e ACCESS_TOKEN \
      -e SERVER_ADDRESS \
      -e LOG_LEVEL=INFO \
      -e DOCKER_REGISTRY \
      -e DOCKER_LOGIN \
      -e DOCKER_PASSWORD \
      -e DELETE_TASK_DIR_ON_FINISH \
      -e DELETE_TASK_DIR_ON_FAILURE \
      -e PULL_POLICY \
      -e SUPERVISELY_AGENT_FILES \
       \
       \
       \
       \
       \
       \
       \
      -e "DOCKER_NET=supervisely-net-ACCESS_TOKEN" \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v "${AGENT_HOST_DIR}:/sly_agent" \
      -v "${HOME}/supervisely/agent-10172:/app/sly-files" \
       \
      "${SUPERVISELY_AGENT_IMAGE}"

retVal=$?
if [ $retVal -ne 0 ]; then
    echo -e "
${RED}Couldn't start container. Please, contact support and attach the log above${NC}"
    exit $retVal
fi

echo 'Supervisely Net is enabled, starting client...'
docker pull supervisely/sly-net-client:latest
docker network create supervisely-net-ACCESS_TOKEN 2> /dev/null
echo 'Remove existing Net Client container if any...'
docker rm -fv "supervisely-net-client-ACCESS_TOKEN" 2> /dev/null
docker run -it -d --name="supervisely-net-client-ACCESS_TOKEN" \
      -e "SLY_NET_CLIENT_PING_INTERVAL=60" \
      --network supervisely-net-ACCESS_TOKEN \
      --restart=unless-stopped \
      --cap-add NET_ADMIN \
      --device /dev/net/tun:/dev/net/tun \
       \
       \
       \
       \
       \
       \
      -v /var/run/docker.sock:/tmp/docker.sock:ro \
      -v "${AGENT_HOST_DIR}:/app/sly" \
       \
      -v "${HOME}/supervisely/agent-10172:/app/sly-files" \
      "supervisely/sly-net-client:latest" \
      "ACCESS_TOKEN" \
      "https://app.supervise.ly/net/" \
      "app.supervise.ly:51822"

retVal=$?
if [ $retVal -ne 0 ]; then
    echo -e "
${RED}Couldn't start Supervisely Net. Agent is running fine. Please, contact support and attach the log above${NC}"
fi

echo -e "${WHITE}============ You can close this terminal safely now ============${NC}"
docker logs -f "supervisely-agent-ACCESS_TOKEN"
    