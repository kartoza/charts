{ pkgs ? import <nixpkgs> {}
 , projectPath ? toString ./. }:
let
	# helm-docs generator
	helm-docs = pkgs.buildGoModule {
		pname = "helm-docs";
		version = "v1.5.0-notationtype";
		src = pkgs.fetchFromGitHub {
			owner = "lucernae";
			repo = "helm-docs";
			# github.com/lucernae/helm-docs@notation-type
			rev = "0c63790cb525f306ff81631d36c39889d75c7020";
			sha256 = "sha256:154rznqqw68d83j8p98l7n4n3fb3bp0q3nafbc0n09jv5rggr93i";
		};
		runVend = true;
		vendorSha256 = "sha256:0wqs35r570icja95g4qf4kzh1wlm4smfiq5flmg4cn4xqv4r1161";
		nativeBuildInputs = [ pkgs.makeWrapper ];
		postFixup = ''
			wrapProgram $out/bin/helm-docs \
				--add-flags -t=_templates.gotmpl \
				--add-flags -t=README.gotmpl
		'';
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
			echo ${projectPath}
			makeWrapper $out/bin/.ct.sh $out/bin/ct --set ROOT_DIR ${projectPath}
		'';
	};
in
pkgs.mkShell {
	nativeBuildInputs = [
		pkgs.makeWrapper
		helm-docs
		ct-in-container
	];
}
