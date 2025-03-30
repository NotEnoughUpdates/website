{
    lib,
    stdenvNoCC,
    cacert,
    nodejs,
    yarn-berry,
    makeWrapper
}:

stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "website";
    version = "1";

    src = ../.;

    nativeBuildInputs = [
        nodejs
        yarn-berry
        makeWrapper
    ];

    yarnOfflineCache = stdenvNoCC.mkDerivation {
        name = "website-deps";
        nativeBuildInputs = [ yarn-berry ];
        inherit (finalAttrs) src;

        NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";

        supportedArchitectures = builtins.toJSON {
            os = [ "darwin" "linux" ];
            cpu = [ "arm" "arm64" "ia32" "x64" ];
            libc = [ "glibc" "musl" ];
        };

        configurePhase = ''
            runHook preConfigure

            export HOME="$NIX_BUILD_TOP"
            export YARN_ENABLE_TELEMETRY=0

            yarn config set enableGlobalCache false
            yarn config set cacheFolder $out
            yarn config set supportedArchitectures --json "$supportedArchitectures"

            runHook postConfigure
        '';

        buildPhase = ''
            runHook preBuild

            mkdir -p $out
            yarn install --immutable --mode skip-build

            runHook postBuild
        '';

        dontInstall = true;

        outputHashAlgo = "sha256";
        outputHash = "sha256-VeV3p8zNHWdzd9+9BYrJoR9apuBxjk83WyOhp2JjOK0=";
        outputHashMode = "recursive";
    };

    configurePhase = ''
        runHook preConfigure

        export HOME="$NIX_BUILD_TOP"
        export YARN_ENABLE_TELEMETRY=0
        export ASTRO_TELEMETRY_DISABLED=1

        yarn config set enableGlobalCache false
        yarn config set cacheFolder $yarnOfflineCache

        runHook postConfigure
    '';

    buildPhase = ''
        runHook preBuild

        yarn install --immutable --immutable-cache
        yarn build

        runHook postBuild
    '';

    installPhase = ''
        runHook preInstall

        mkdir -p $out/{lib,bin}

        cp -r ./dist/* $out/lib/

        echo -e "#!/usr/bin/env sh\n${lib.getExe nodejs} $out/lib/server/entry.mjs" > $out/bin/website
        chmod +x $out/bin/website

        runHook postInstall
    '';

    fixupPhase = ''
        runHook preFixup

        patchShebangs $out/lib

        runHook postFixup
    '';

    meta = {
        description = "Moulberry's Bush Website";
        homepage = "https://github.com/NotEnoughUpdates/website";
        license = lib.licenses.cc0;
        mainProgram = "website";
    };
})
