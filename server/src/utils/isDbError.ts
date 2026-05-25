export enum DbError {
  UniqueViolation = '23505',
}

export function isDbError(error: unknown, code: DbError): boolean {
  try {
    const err = error as { cause: { code: string } };
    return err.cause.code === code.toString();
  } catch {
    return false;
  }
}
