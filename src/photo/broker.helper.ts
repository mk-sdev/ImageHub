import { ClientProxy } from '@nestjs/microservices';
import { timeout, catchError } from 'rxjs/operators';
import { throwError, lastValueFrom } from 'rxjs';

export async function sendWithTimeout<T>(
  client: ClientProxy,
  pattern: Record<string, any>,
  data: any,
  expectedType: 'number' | 'string' | 'boolean' | 'object' = 'object',
  timeoutMs = 10000,
): Promise<T> {
  const result = await lastValueFrom(
    client.send<T>(pattern, data).pipe(
      timeout(timeoutMs),
      catchError((err: Error) => {
        console.error('Broker error in sendWithTimeout:', err);
        if (err.name === 'TimeoutError') {
          return throwError(() => new Error('Timeout: no broker response'));
        }
        return throwError(() => err);
      }),
    ),
  );

  if (typeof result !== expectedType && expectedType !== 'object') {
    throw new Error(
      `Incorrect broker response - expected type: ${expectedType}`,
    );
  }
  return result;
}
