import { z } from "zod";

export function validateForm(data: unknown) {
	try {
		const schema = z.union([
			z
				.object({
					punishmentType: z.enum(["ban", "mute"]),
					punishmentReason: z.string(),
					fairness: z.string(),
					reasoning: z.string()
				})
				.strict(),
			z
				.object({
					punishmentType: z.literal("channelBlock"),
					blockedChannel: z.string(),
					punishmentReason: z.string(),
					fairness: z.string(),
					reasoning: z.string()
				})
				.strict()
		]);
		return schema.parse(data);
	} catch {
		return null;
	}
}
