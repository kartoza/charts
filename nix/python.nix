{ pkgs ? import <nixpkgs> {} }:
let
	python-packages = ps: with ps; [
		yamale
		yamllint
	];
in
	pkgs.python38.withPackages(python-packages)
