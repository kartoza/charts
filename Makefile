
build-deps:
	nix-build

shell:
	nix-shell

lint:
	ct lint

install:
	ct install

reload:
	direnv reload

direnv-allow:
	direnv allow
