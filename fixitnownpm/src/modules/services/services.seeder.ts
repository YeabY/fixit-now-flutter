import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Service } from './entities/service.entity';
import { ServiceType } from '../auth/enums/service-type.enum';
import { User } from '../users/entities/user.entity';
import { Role } from '../auth/enums/roles.enum';

@Injectable()
export class ServicesSeeder {
  constructor(
    @InjectRepository(Service)
    private serviceRepository: Repository<Service>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async seed() {
    // Create a default admin user if it doesn't exist
    const adminUser = await this.userRepository.findOne({
      where: { role: Role.ADMIN }
    });

    if (!adminUser) {
      console.log('No admin user found. Please create an admin user first.');
      return;
    }

    // Define the services to create
    const services = [
      {
        serviceType: ServiceType.CLEANING,
        provider_id: adminUser.id,
        rating: 5,
        images: JSON.stringify([])
      },
      {
        serviceType: ServiceType.PLUMBING,
        provider_id: adminUser.id,
        rating: 5,
        images: JSON.stringify([])
      },
      {
        serviceType: ServiceType.ELECTRICAL,
        provider_id: adminUser.id,
        rating: 5,
        images: JSON.stringify([])
      }
    ];

    // Create each service if it doesn't exist
    for (const serviceData of services) {
      const existingService = await this.serviceRepository.findOne({
        where: {
          serviceType: serviceData.serviceType,
          provider_id: serviceData.provider_id
        }
      });

      if (!existingService) {
        const service = this.serviceRepository.create(serviceData);
        await this.serviceRepository.save(service);
        console.log(`Created service: ${serviceData.serviceType}`);
      }
    }
  }
} 