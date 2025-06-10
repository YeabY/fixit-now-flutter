import { Controller, Post, Body, Res, UseGuards, Get, Request, Headers } from '@nestjs/common';
import { Response } from 'express';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { TokenBlacklistGuard } from './guards/token-blacklist.guard';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  async register(@Body() registerDto: RegisterDto) {
    return this.authService.register(registerDto);
  }

  @Post('login')
  async login(@Body() loginDto: LoginDto, @Res() res: Response) {
    const result = await this.authService.login(loginDto);
    return res.status(200).json(result); // <-- always 200
  }

  @UseGuards(JwtAuthGuard, TokenBlacklistGuard)
  @Post('logout')
  async logout(@Headers('authorization') authHeader: string) {
    return this.authService.logout(authHeader);
  }

  @UseGuards(JwtAuthGuard, TokenBlacklistGuard)
  @Get('profile')
  getProfile(@Request() req) {
    return req.user;
  }
}