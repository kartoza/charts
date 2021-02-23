let
	bootstrap = import <nixpkgs> {};
	pinned-pkgs = import (bootstrap.fetchFromGitHub {
		owner = "NixOS";
		repo = "nixpkgs";
		# branch@date: master@2021-02-23
		rev = "11cd34cd592f917bab5f42e2b378ab329dee3bcf";
		sha256 = "sha256:1mgga54np22csagzaxfjq5hrgyv8y4igrl3f6z24fb39rvvx236w";
	}) {};
in
{
  pkgs ? pinned-pkgs }:
let
	# helm-docs generator
	helm-docs = import ./nix/helm-docs.nix {
		inherit pkgs;
	};
	# chart-testing tools in a container
	ct-in-container = pkgs.stdenv.mkDerivation rec {
		name = "ct";
		version = "latest";
		nativeBuildInputs = [ pkgs.makeWrapper ];
		src = ./scripts;
		installPhase = ''
			mkdir -p $out/bin
			cp -f $src/ct.sh $out/bin/.ct.sh
			chmod +x $out/bin/.ct.sh
			makeWrapper $out/bin/.ct.sh $out/bin/ct
		'';
	};
	# chart-testing tools as binary
	ct-bin = import ./nix/chart-testing.nix {
		inherit pkgs;
	};
	# python-packages
	python = import ./nix/python.nix {
		inherit pkgs;
	};
in
pkgs.stdenv.mkDerivation rec {
	pname = "charts-devenv";
	version = "1.0";
	src = ./nix;
	propagatedBuildInputs = [
		pkgs.direnv
		pkgs.nix-direnv
		pkgs.makeWrapper
		pkgs.kubectl
		pkgs.kubernetes-helm
		helm-docs
		ct-bin
		python
	];
	dontInstall = true;
	meta = {
		description = "Development environment for Rancher/Helm chart in this repo";
		maintainers = [ "Rizky Maulana Nugraha <lana.pcfre@gmail.com>" ];
	};
}
