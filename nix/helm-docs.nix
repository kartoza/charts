{ pkgs ? import <nixpkgs> {} }:
pkgs.buildGoModule {
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
		wrapProgram $out/bin/helm-docs --add-flags '$HELM_DOCS_ARGS'
	'';
}
