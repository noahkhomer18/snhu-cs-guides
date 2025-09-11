# Travlr Getaways - Full Stack Project

## Project Overview
A travel booking application built with the MEAN stack (MongoDB, Express, Angular, Node.js).

## Architecture Components

### Backend (Express + Node.js)
- RESTful API endpoints
- MongoDB database integration
- User authentication and authorization
- Data validation and error handling

### Frontend (Angular)
- Single Page Application (SPA)
- Component-based architecture
- Reactive forms and validation
- HTTP client for API communication

### Database (MongoDB)
- User collection for authentication
- Travel packages collection
- Booking history collection
- Reviews and ratings collection

## Key Features
- User registration and login
- Browse travel packages
- Book travel packages
- View booking history
- Leave reviews and ratings
- Admin panel for package management

## API Endpoints
```
GET    /api/packages          - Get all travel packages
GET    /api/packages/:id      - Get specific package
POST   /api/bookings          - Create new booking
GET    /api/bookings/:userId  - Get user bookings
POST   /api/auth/login        - User login
POST   /api/auth/register     - User registration
```

## Deployment Considerations
- Environment variables for configuration
- Database connection security
- CORS configuration
- Error handling middleware
- Input validation and sanitization
