import { Module, OnModuleInit } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { User } from './entities/user.entity';
import { Request } from '../requests/entities/request.entity';
import { Service } from '../services/entities/service.entity';
import { UsersSeeder } from './users.seeder';

@Module({
  imports: [TypeOrmModule.forFeature([User, Request, Service])],
  controllers: [UsersController],
  providers: [UsersService, UsersSeeder],
  exports: [UsersService],
})
export class UsersModule implements OnModuleInit {
  constructor(private readonly usersSeeder: UsersSeeder) {}

  async onModuleInit() {
    await this.usersSeeder.seed();
  }
} 