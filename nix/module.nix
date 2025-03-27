self:
{ lib, config, ... }:
{
    options.services.moulberry-bush-website = {
        enable = lib.mkEnableOption "moulbery bush website";

        package = lib.mkOption {
            description = "The package to use for the website";
            default = null;
            defaultText = "null";
            type = lib.types.package;
        };

        environmentFile = lib.mkOption {
            description = "An extra file containing environment variables to load (for secrets)";
            default = null;
            defaultText = "null";
            type = lib.types.nullOr lib.types.path;
        };

        settings = {
            port = lib.mkOption {
                description = "The port to run the webserver on";
                default = 80;
                defaultText = "80";
                type = lib.types.port;
            };

            host = lib.mkOption {
                description = "The host to listen on";
                default = "0.0.0.0";
                defaultText = "0.0.0.0";
                type = lib.types.str;
            };

            redirectHost = lib.mkOption {
                description = "The hostname of the website to give discord as a redirect URL";
                default = "bush.notenoughupdates.org";
                defaultText = "bush.notenoughupdates.org";
                type = lib.types.str;
            };

            redirectScheme = lib.mkOption {
                description = "The scheme of the website to give discord as a redirect URL";
                default = "https";
                defaultText = "https";
                type = lib.types.enum [ "http" "https" ];
            };

            clientId = lib.mkOption {
                description = "The discord oauth client ID";
                default = 1262889947946287169;
                defaultText = "1262889947946287169";
                type = lib.types.int;
            };
        };
    };

    config = let
        cfg = config.services.moulberry-bush-website;
    in lib.mkIf cfg.enable {
        systemd.services.moulberry-bush-website = {
            description = "moulberry bush website";
            wants = [ "network-online.target" ];
            after = [ "network-online.target" ];
            wantedBy = [ "multi-user.target" ];

            serviceConfig = {
                User = "mbwebsite";
                Group = "mbwebsite";
                DynamicUser = "yes";

                ExecStart = "${cfg.package}";
                Restart = "on-failure";

                EnvironmentFile = [ cfg.environmentFile ];
            };

            environment = {
                PORT = builtins.toString cfg.settings.port;
                HOST = cfg.settings.host;
                REDIRECT_HOST = cfg.settings.redirectHost;
                REDIRECT_SCHEME = cfg.settings.redirectScheme;
                CLIENT_ID = builtins.toString cfg.settings.clientId;
            };
        };
    };
}