/** @type {import("prettier").Config} */
export default {
	plugins: [await import("prettier-plugin-astro")],
	overrides: [
		{
			files: "*.astro",
			options: {
				parser: "astro"
			}
		}
	],
	useTabs: true,
	trailingComma: "none",
	arrowParens: "avoid",
	printWidth: 120
};
