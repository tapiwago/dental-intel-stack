# Dental Intel - Full Stack Application

A comprehensive dental practice management system built with React, Node.js, and MongoDB.

## 🏗️ Architecture

```
dental-intel-stack/
├── frontend/          # React TypeScript frontend
├── backend/           # Node.js Express API
├── docker/            # Docker configurations
├── docs/              # Documentation
├── scripts/           # Deployment and utility scripts
└── infrastructure/    # Infrastructure as code
```

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Git
- MongoDB Atlas account (for database)

### Development Setup
```bash
# Clone the repository
git clone https://github.com/tapiwago/dental-intel-stack.git
cd dental-intel-stack

# Initialize submodules (if using git submodules)
git submodule update --init --recursive

# Start the application with Docker
docker-compose up -d --build

# Or use the simplified version
docker-compose -f docker-compose.simple.yml up -d --build
```

### Manual Setup (Alternative)
```bash
# Backend dependencies and start
cd dental-api
npm install
npm start &

# Frontend dependencies and start  
cd ../dental
npm install --legacy-peer-deps
npm run build
npx serve -s dist -l 3000 &
```

### Production Deployment
```bash
# Upload files to your server
scp -r dental-intel-stack root@206.81.11.59:~/

# SSH into server and deploy
ssh root@206.81.11.59
cd dental-intel-stack
docker-compose up -d --build
```

## 📊 Services

| Service | Port | Description | URL |
|---------|------|-------------|-----|
| Frontend | 80 | React TypeScript application | http://206.81.11.59 |
| Backend API | 5000 | Node.js Express REST API | http://206.81.11.59:5000 |
| MongoDB | Atlas | Cloud database (external) | MongoDB Atlas |
| Nginx | 8080 | Reverse proxy & static files | http://206.81.11.59:8080 |

## 🔧 Configuration

### MongoDB Atlas Setup
1. **Create MongoDB Atlas Account**: [MongoDB Atlas](https://www.mongodb.com/atlas)
2. **Create Cluster**: Choose M0 (free tier)
3. **Create Database User**: Username and password
4. **Configure Network Access**: Add your server IP (206.81.11.59)
5. **Get Connection String**: Copy the connection string
6. **Update Backend Environment**: Update `dental-api/.env` with your MongoDB URI

### Environment Files
- **Backend**: `dental-api/.env` (contains MongoDB Atlas connection)
- **Frontend**: Uses production build settings
- **Docker**: Uses backend's .env file automatically

### API Endpoints
- **Health Check**: `GET http://206.81.11.59:5000/health`
- **API Docs**: `GET http://206.81.11.59:5000/api-docs` 
- **Templates**: `GET|POST|PUT|DELETE http://206.81.11.59:5000/api/templates`
- **Users**: `GET|POST|PUT|DELETE http://206.81.11.59:5000/api/users`

## 🛠️ Development

### Local Development Setup
```bash
# Backend setup
cd dental-api
npm install
cp .env.example .env  # Update with your MongoDB Atlas URI
npm run dev

# Frontend setup (new terminal)
cd dental
npm install --legacy-peer-deps
npm run dev
```

### With Docker (Easier)
```bash
# Start everything with Docker
docker-compose up -d --build

# Access applications:
# Frontend: http://localhost
# API: http://localhost:5000
# API Health: http://localhost:5000/health
```

### MongoDB Atlas Connection
Make sure your `dental-api/.env` file contains:
```env
NODE_ENV=production
PORT=5000
MONGODB_URI=mongodb+srv://username:password@cluster0.mongodb.net/dental_db?retryWrites=true&w=majority
DB_NAME=dental_db
```

## 🐳 Docker Deployment

### Quick Start (Recommended)
```bash
# Clone and enter directory
git clone https://github.com/tapiwago/dental-intel-stack.git
cd dental-intel-stack

# Start all services
docker-compose up -d --build

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

### Simple Deployment
```bash
# Use minimal configuration
docker-compose -f docker-compose.simple.yml up -d --build
```

### Development with Docker
```bash
# Start services individually
docker-compose up dental-api -d  # Start API only
docker-compose up dental-frontend -d  # Start frontend only

# Rebuild after code changes
docker-compose up --build -d
```

### Stop Services
```bash
# Stop all containers
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

## 📚 Documentation

- [API Documentation](./docs/api.md)
- [Frontend Guide](./docs/frontend.md)
- [Backend Guide](./docs/backend.md)
- [Deployment Guide](./docs/deployment.md)
- [Contributing Guide](./docs/contributing.md)

## 🔒 Security

- JWT Authentication
- CORS Configuration
- Rate Limiting
- Input Validation
- HTTPS/SSL Support

## 🧪 Testing

```bash
# Frontend tests
cd frontend && npm test

# Backend tests
cd backend && npm test

# E2E tests
npm run test:e2e
```

## 📦 Build & Deploy

### Docker Deployment (Production)
```bash
# Build and deploy to server
scp -r dental-intel-stack root@206.81.11.59:~/
ssh root@206.81.11.59
cd dental-intel-stack
docker-compose up -d --build
```

### Manual Build
```bash
# Build frontend
cd dental
npm run build  # Creates dist/ folder

# Start backend
cd ../dental-api
npm start  # Runs on port 5000

# Serve frontend
cd ../dental
npx serve -s dist -p 80  # Serves built files
```

### Health Checks
```bash
# Check API health
curl http://206.81.11.59:5000/health

# Check frontend
curl http://206.81.11.59

# Check all services
docker-compose ps
```

### Troubleshooting
```bash
# View logs
docker-compose logs dental-api
docker-compose logs dental-frontend

# Restart services
docker-compose restart

# Rebuild containers
docker-compose up --build -d
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Lead Developer**: Tapiwa
- **Frontend**: React + TypeScript + Material-UI
- **Backend**: Node.js + Express + MongoDB
- **DevOps**: Docker + Nginx + PM2

## 🔗 Related Repositories

- [Frontend Repository](https://github.com/tapiwago/dental)
- [Backend Repository](https://github.com/tapiwago/dental-api)

## 📈 Roadmap

- [ ] Multi-tenant support
- [ ] Real-time notifications
- [ ] Mobile app (React Native)
- [ ] Advanced analytics
- [ ] AI-powered insights
- [ ] Integration APIs
