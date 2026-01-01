{ lib
, stdenv
, makeWrapper
, bash
, fzf
}:

stdenv.mkDerivation {
  pname = "nerdfont-search";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    bash
    fzf
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/nerdfont-search

    # Install the main search script
    cp nerdfont-search $out/bin/nerdfont-search
    chmod +x $out/bin/nerdfont-search

    # Create aliases
    ln -s $out/bin/nerdfont-search $out/bin/nfs
    ln -s $out/bin/nerdfont-search $out/bin/nf-search

    # Install the data file
    cp nerd-fonts-data.txt $out/share/nerdfont-search/nerd-fonts-data.txt

    # Wrap the script to use the correct paths
    wrapProgram $out/bin/nerdfont-search \
      --prefix PATH : ${lib.makeBinPath [ fzf ]} \
      --set NERDFONT_DATA_FILE $out/share/nerdfont-search/nerd-fonts-data.txt

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple Nerd Font icon searcher using fzf";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
