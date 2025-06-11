import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { Role } from '../auth/enums/roles.enum';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersSeeder {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async seed() {
    // Check if admin user already exists
    const existingAdmin = await this.userRepository.findOne({
      where: { name: 'adam' }
    });

    if (existingAdmin) {
      console.log('Admin user already exists');
      return existingAdmin;
    }

    // Create admin user
    const hashedPassword = await bcrypt.hash('adam123', 10);
    
    const adminUser = this.userRepository.create({
      name: 'adam',
      email: 'adam@admin.com',
      phone: '1234567890',
      password: hashedPassword,
      role: Role.ADMIN,
      gender: 'MALE'
    });

    const savedAdmin = await this.userRepository.save(adminUser);
    console.log('Admin user created successfully');
    return savedAdmin;
  }
} 