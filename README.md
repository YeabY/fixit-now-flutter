# Fix It Now

A full-stack application for managing and tracking repair/maintenance services, built with NestJS backend and Flutter mobile app.

## 🚀 Features

- User authentication and authorization
- Service request management
- Real-time updates
- Cross-platform mobile app
- Secure API endpoints
- Database integration

## 🛠 Tech Stack

### Backend
- NestJS (Node.js framework)
- TypeORM for database operations
- PostgreSQL/MySQL database
- JWT authentication
- Passport.js for security
- TypeScript

### Mobile App
- Flutter
- Dart
- Cross-platform support (iOS, Android, Web)

## 📋 Prerequisites

- Node.js (v14 or higher)
- Flutter SDK
- MySQL
- npm
- Git

## 🚀 Getting Started

### Backend Setup

1. Navigate to the backend directory:
```bash
cd fixitnownpm
```

2. Install dependencies:
```bash
npm install
```

3. Configure environment variables:
Create a `.env` file in the root directory with the following variables:
```
DATABASE_URL=your_database_url
JWT_SECRET=your_jwt_secret
```

4. Start the development server:
```bash
npm run start:dev
```

### Mobile App Setup

1. Navigate to the Flutter project directory:
```bash
cd fixit-now-flutter-feature-auth-flow-validation-db
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🧪 Testing

### Backend Tests
```bash
# Unit tests
npm run test

# e2e tests
npm run test:e2e

# Test coverage
npm run test:cov
```

### Flutter Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/your_test_file.dart
```

## 📦 Scripts

### Backend
- `npm run build` - Build the application
- `npm run start:dev` - Start development server
- `npm run start:prod` - Start production server
- `npm run lint` - Run linting
- `npm run format` - Format code

### Flutter
- `flutter pub get` - Get dependencies
- `flutter run` - Run the app
- `flutter build` - Build the app
- `flutter test` - Run tests

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- NestJS team for the amazing framework
- Flutter team for the cross-platform framework
- All contributors who have helped shape this project 
