
function dev
{
	if [[ ! -f ".devcontainer/devcontainer.json" ]]; then
		printf "No .devcontainer/devcontainer.json found!\n";
		return 0
	fi

	local JSON="$(cat .devcontainer/devcontainer.json)"
	function __get
	{
		printf "$JSON" | jq -r $1
	}
	function __ports
	{
		local PORT_STRING=""

		# Check if its empty
		if [[ "$(__get '.forwardPorts')" == "null" ]]; then printf ""; return; fi
		# Else, get all the ports
		local i=0
		local port="$(__get ".forwardPorts[$i]")"
		while [[ "${port}" != "null" ]]; do
			PORT_STRING=$PORT_STRING" -p $port:$port"
			i=$((i+1))
			port="$(__get ".forwardPorts[$i]")"
		done
		printf "$PORT_STRING"
	}
	
	local IMAGE_NAME="$(__get ".name" | tr '[:upper:]' '[:lower:]')"
	local DOCKERFILE="$(__get ".build.dockerfile")"
	local MOUNT_DIR="$PWD"
	local MOUNT_TO="$(__get ".workspaceFolder")"
	local PORTS="$(__ports)"


	if [[ "$1" == "build" ]]; then
		printf "Building!\n";

		podman build \
			--build-arg USER_ID=$(id -u) \
			--build-arg GROUP_ID=$(id -g) \
			--build-arg USER_NAME=$USER \
			-f ".devcontainer/$DOCKERFILE" \
			-t $IMAGE_NAME .

		return 0
	fi

	if [[ "$1" == "run" ]]; then

		podman run \
			--rm \
			--mount=type=bind,src="$MOUNT_DIR",dst="$MOUNT_TO" \
			--name $IMAGE_NAME \
			--interactive --tty \
			--userns="keep-id" \
			$PORTS \
			$IMAGE_NAME /bin/bash

	fi

	printf \
"\tbuild - Build the current directory's devcontainer\n"\
"\trun   - Run the current directory's devcontainer\n";

	unset __get
	unset __ports
}
