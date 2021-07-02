{ pkgs ? import <nixpkgs> {} }:
pkgs.buildGoModule {
	pname = "helm-docs";
	version = "v1.5.0-notationtype";
	src = pkgs.fetchFromGitHub {
		owner = "lucernae";
		repo = "helm-docs";
		# github.com/lucernae/helm-docs@notation-type
		rev = "76d8026d0d7e25fa0dd308c5b07db0e7d8d82188";
		sha256 = "sha256:0cjx3j42cr1c9rwc9d11p944fj836b8ccilalbvpvx8xds9vi298";
	};
	runVend = true;
	vendorSha256 = "sha256:0wqs35r570icja95g4qf4kzh1wlm4smfiq5flmg4cn4xqv4r1161";
	nativeBuildInputs = [ pkgs.makeWrapper ];
	postFixup = ''
		wrapProgram $out/bin/helm-docs --add-flags '$HELM_DOCS_ARGS'
	'';
}
