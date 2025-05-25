import { err, Result } from "@sapphire/result";
import { z } from "zod";

export function validateForm(data: unknown) {
	return Result.from(() => {
		const base = {
			punishmentReason: z.string(),
			fairness: z.string(),
			reasoning: z.string()
		};
		const schema = z.union([
			z
				.object({
					punishmentType: z.union([
						z.literal("ban").transform(() => "Ban" as const),
						z.literal("mute").transform(() => "Mute" as const)
					])
				})
				.extend(base),
			z
				.object({
					punishmentType: z.literal("channelBlock").transform(() => "Channel Block" as const),
					blockedChannel: z
						.string()
						.regex(/^[\w-]{1,100}$/, {
							error: _ => "Invalid channel name"
						})
				})
				.extend(base),
			z
				.object({
					punishmentType: z.literal("role").transform(() => "Punishment Role" as const),
					role: z
						.enum([
							"Limited Server Access",
							"No Files",
							"No Reactions",
							"No Links",
							"No Giveaways",
							"No Bots",
							"No Threads"
						])
						.transform(v => `@${v}` as const)
				})
				.extend(base)
		]);
		const parsed = schema.safeParse(data);
		if (parsed.success === true) return parsed.data;
		else return err(parsed.error); // Necessary for allowing TS to infer the error type without having to manually type the success case
	});
}
