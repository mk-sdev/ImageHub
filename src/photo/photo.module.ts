import { Module } from '@nestjs/common';
import { RepositoryModule } from 'src/repository/repository.module';
import { PhotoService } from './photo.service';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { PhotoController } from './photo.controller';
import { PhotoGateway } from './photo.gateway';
import { R2Service } from './R2.service';
import { AuthModule } from 'src/auth/auth.module';
import { ConfigService } from '@nestjs/config';

@Module({
  imports: [
    AuthModule,
    RepositoryModule,
    ClientsModule.registerAsync([
      {
        name: 'TEST_SERVICE',
        inject: [ConfigService],
        useFactory: (config: ConfigService) => ({
          transport: Transport.RMQ,
          options: {
            urls: [config.get<string>('AMQP_URL')!],
            queue: 'test_queue',
            queueOptions: { durable: false },
          },
        }),
      },
    ]),
  ],
  providers: [PhotoService, PhotoGateway, R2Service],
  exports: [PhotoService, PhotoGateway, R2Service],
  controllers: [PhotoController],
})
export class PhotoModule {}
