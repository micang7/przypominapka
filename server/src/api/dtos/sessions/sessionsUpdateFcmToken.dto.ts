import { z } from 'zod';

export const SessionsUpdateFcmTokenDto = z.object({
  deviceId: z.string().min(1),
  fcmToken: z.string().min(1),
});

export type SessionsUpdateFcmTokenDtoType = z.infer<
  typeof SessionsUpdateFcmTokenDto
>;
