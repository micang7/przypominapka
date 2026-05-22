export function assertExists<T>(
  value: T | null | undefined,
  message = 'Expected value to exist',
): asserts value is T {
  if (value == null) {
    throw new Error(message);
  }
}
