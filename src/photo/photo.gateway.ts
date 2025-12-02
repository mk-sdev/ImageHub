import { WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Server } from 'socket.io';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class PhotoGateway {
  @WebSocketServer()
  server: Server;

  sendUploadLog(count: number) {
    this.server.emit('photosUpdated', {
      message: `Uploaded ${count} images`,
      count,
    });
  }

  sendUpdateLog(count: number) {
    this.server.emit('photosUpdated', {
      message: `Updated ${count} images`,
      count,
    });
  }

  sendDeleteLog(count: number) {
    this.server.emit('photosDeleted', {
      message: `Deleted ${count} images`,
      count,
    });
  }
}
