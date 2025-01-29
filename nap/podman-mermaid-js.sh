podman run --userns keep-id --user ${UID} --rm -v "${PWD}":/data:z ghcr.io/mermaid-js/mermaid-cli/mermaid-cli -i *.mmd
