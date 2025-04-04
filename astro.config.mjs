import { defineConfig } from "astro/config";

import node from "@astrojs/node";

// https://astro.build/config
export default defineConfig({
	output: "hybrid",
	adapter: node({
		mode: "standalone"
	}),
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
