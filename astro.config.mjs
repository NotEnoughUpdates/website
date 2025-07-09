import { defineConfig, envField } from "astro/config";

import node from "@astrojs/node";

// https://astro.build/config
export default defineConfig({
	output: "static",
	adapter: node({
		mode: "standalone"
	}),
	env: {
		schema: {
			REDIRECT_SCHEME: envField.string({ context: "server", access: "secret" }),
			REDIRECT_HOST: envField.string({ context: "server", access: "secret" }),
			CLIENT_ID: envField.string({ context: "server", access: "secret" }),
			CLIENT_SECRET: envField.string({ context: "server", access: "secret" }),
			BANNED_IDS: envField.string({ context: "server", access: "secret", default: "" }),
			WEBHOOK_URL: envField.string({ context: "server", access: "secret" })
		}
	},
	...(
		process.env.NODE_ENV === "production"
			? {
				vite: {
					ssr: {
						noExternal: true
					}
				}
			}
			: null
	)
});
