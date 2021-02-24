{ pkgs ? import <nixpkgs> {} }:
pkgs.buildGoModule rec {
	pname = "chart-testing";
	name = "ct";
	version = "3.3.1";
	platform = if pkgs.stdenv.isLinux then "linux" else (if pkgs.stdenv.isDarwin then "darwin" else "");
	arch = if pkgs.stdenv.is64bit then "amd64" else "";
	nativeBuildInputs = [ pkgs.makeWrapper pkgs.installShellFiles ];
	src = pkgs.fetchFromGitHub {
		owner = "lucernae";
		repo = "chart-testing";
		rev = "8c0d4d040350522d99a0a487cdfba6d0b7a19a2b";
		sha256 = "sha256:0siig6svlj78qx63w6fibnxv3091k2jj7gjbf67dkc9z7y2wg9p0";
	};
	runVend = true;
	vendorSha256 = "sha256:1m3sqpmqgglr9blpgvgzg4bysvxdzsqp9znlgn12x48cc7a7n492";
	postFixup = ''
		wrapProgram $out/bin/ct --add-flags '--config $CT_CONFIG'
	'';
	/*
	# This part is when you need to install chart-testing binary from official
	# helm source
	src = pkgs.fetchurl {
		url = "https://github.com/helm/${pname}/releases/download/v${version}/${pname}_${version}_${platform}_${arch}.tar.gz";
		sha256 = "sha256:1v2f59yjydy5d6ri2fy7xqxh07vr3f2ffc8qfa51i62wyvvpq2ah";
	};
	installPhase = ''
		mkdir -p $out/bin
		cp -f $TMPDIR/ct $out/bin/ct
		chmod +x $out/bin/ct
	'';
	dontPatchELF = true;
	postFixup = ''
		wrapProgram $out/bin/ct --add-flags '--config $PROJECT_ROOT/ct.yaml'
	'';
	*/
}
