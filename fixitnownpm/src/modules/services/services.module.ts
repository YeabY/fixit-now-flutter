import { Module, OnModuleInit } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ServicesService } from './services.service';
import { ServicesController } from './services.controller';
import { Service } from './entities/service.entity';
import { User } from '../users/entities/user.entity';
import { ServicesSeeder } from './services.seeder';

@Module({
  imports: [TypeOrmModule.forFeature([Service, User])],
  controllers: [ServicesController],
  providers: [ServicesService, ServicesSeeder],
  exports: [ServicesService],
})
export class ServicesModule implements OnModuleInit {
  constructor(private readonly servicesSeeder: ServicesSeeder) {}

  async onModuleInit() {
    await this.servicesSeeder.seed();
  }
} 