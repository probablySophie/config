
function dev
{
	if [[ ! -f ".devcontainer/devcontainer.json" ]]; then
		printf "No .devcontainer/devcontainer.json found!\n";

		local INPUT=""
		read -p "Make one? (y/N) " INPUT
		
		if [[ "$(printf "%.1s" "$INPUT" | tr '[:upper:]' '[:lower:]')" == "y" ]]; then
			mkdir -p ".devcontainer";
			printf "{\n\"%s\": \"%s\"\n}" \
				"\$schema" \
				"https://raw.githubusercontent.com/devcontainers/spec/refs/heads/main/schemas/devContainer.base.schema.json" \
				>> ".devcontainer/devcontainer.json";
		fi
		
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
	
	local IMAGE_NAME="$(__get ".name" | tr '[:upper:]' '[:lower:]' | sed 's/ //g')"
	local DOCKERFILE="$(__get ".build.dockerfile")"
	local MOUNT_DIR="$PWD"
	local MOUNT_TO="$(__get ".workspaceFolder")"
	local PORTS="$(__ports)"
	local MOUNTS=$(__get ".mounts");
	local MOUNT_STRING="";
	local MOUNT_COMMAND="";

	if [[ "$DOCKERFILE" != "null" ]]; then
		local MOUNT_COMMAND="$(grep "CMD" .devcontainer/$DOCKERFILE)"
		if [[ "$MOUNT_COMMAND" != "" ]]; then
			MOUNT_COMMAND="$(printf "$MOUNT_COMMAND" | sed -e 's/CMD //g' -e 's/\(\[\|]\|"\)//g')"
		fi
	fi
	if [[ "$MOUNT_COMMAND" == "" ]]; then
		MOUNT_COMMAND="/bin/bash"
	fi

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

	# Add a slash to MOUNT_TO if it doesn't already have one
	if [[ "${MOUNT_TO: -1}" != "/" ]]; then local MOUNT_TO="${MOUNT_TO}/"; fi
	# Add the current directory to MOUNT_TO so that we get workspaces/project_dir/
	local MOUNT_TO="${MOUNT_TO}${PWD##*/}"

	# Looping over array items
	for item in $MOUNTS; do
		if [[ ${#item} > 3 ]] && [[ "$item" -ne "" ]]; then
			# Strip quotes
			if [[ "${item: -1}" == '"' ]]; then item="${item: 0 : -1}"; fi
			if [[ "${item:0:1}" == '"' ]]; then item="${item: 1 }"; fi

			local MOUNT_STRING="${MOUNT_STRING} --mount=${item}"
		fi
	done

	if [[ "$1" == "run" ]]; then

		podman run \
			--rm \
			--mount=type=bind,src="$MOUNT_DIR",dst="$MOUNT_TO" $MOUNT_STRING\
			--name $IMAGE_NAME \
			--interactive --tty \
			--userns="keep-id" \
			$PORTS $2\
			$IMAGE_NAME $MOUNT_COMMAND

		return 0
	fi

	if [[ "$1" == "admin" ]]; then

		podman container exec -itu 0 $IMAGE_NAME bash
		
		return 0
	fi

	if [[ "$1" == "test" ]]; then
		printf "%s = %s\n" "IMAGE_NAME" "$IMAGE_NAME";
		printf "%s = %s\n" "DOCKERFILE" "$DOCKERFILE";
		printf "%s = %s\n" "MOUNT_DIR" "$MOUNT_DIR";
		printf "%s = %s\n" "MOUNT_TO" "$MOUNT_TO";
		printf "%s = %s\n" "PORTS" "$PORTS";
		printf "%s = %s\n" "MOUNTS" "$MOUNTS";
		printf "%s = %s\n" "MOUNT_STRING" "$MOUNT_STRING";
		printf "%s = %s\n" "MOUNT_COMMAND" "$MOUNT_COMMAND";

		return 0
	fi

	printf \
"\t${yellow}build${normal} - Build the current directory's devcontainer\n"\
"\t${yellow}run${normal}   - Run the current directory's devcontainer\n"\
"\t${yellow}admin${normal}   - Attach to the current directory's devcontainer as admin\n";

	unset __get
	unset __ports
}
