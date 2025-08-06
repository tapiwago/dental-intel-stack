#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

console.log('🔧 Setting up Dental Intel Stack environment...');

// Check if frontend and backend directories exist
const frontendDir = path.join(__dirname, '..', 'frontend');
const backendDir = path.join(__dirname, '..', 'backend');

if (!fs.existsSync(frontendDir)) {
    console.log('⚠️  Frontend directory not found. Please run:');
    console.log('   git submodule add https://github.com/tapiwago/dental.git frontend');
    console.log('   git submodule update --init --recursive');
    process.exit(1);
}

if (!fs.existsSync(backendDir)) {
    console.log('⚠️  Backend directory not found. Please run:');
    console.log('   git submodule add https://github.com/tapiwago/dental-api.git backend');
    console.log('   git submodule update --init --recursive');
    process.exit(1);
}

// Install backend dependencies (usually no conflicts)
console.log('📦 Installing backend dependencies...');
try {
    execSync('npm install', { cwd: backendDir, stdio: 'inherit' });
    console.log('✅ Backend dependencies installed');
} catch (error) {
    console.log('❌ Backend installation failed:', error.message);
}

// Install frontend dependencies with legacy peer deps
console.log('📦 Installing frontend dependencies...');
try {
    execSync('npm install --legacy-peer-deps', { cwd: frontendDir, stdio: 'inherit' });
    console.log('✅ Frontend dependencies installed');
} catch (error) {
    console.log('❌ Frontend installation failed:', error.message);
    console.log('💡 Trying with --force flag...');
    try {
        execSync('npm install --force', { cwd: frontendDir, stdio: 'inherit' });
        console.log('✅ Frontend dependencies installed with --force');
    } catch (forceError) {
        console.log('❌ Frontend installation failed even with --force');
        console.log('Please run manually: cd frontend && npm install --legacy-peer-deps');
    }
}

// Create environment files if they don't exist
const envFiles = [
    { src: '.env.example', dest: '.env' },
    { src: path.join(frontendDir, '.env.production'), dest: path.join(frontendDir, '.env.local') },
];

envFiles.forEach(({ src, dest }) => {
    if (fs.existsSync(src) && !fs.existsSync(dest)) {
        console.log(`📄 Creating ${dest} from ${src}`);
        fs.copyFileSync(src, dest);
    }
});

console.log('✅ Environment setup complete!');
console.log('');
console.log('Next steps:');
console.log('1. Update .env files with your configuration');
console.log('2. Run: npm run dev:start (for development)');
console.log('3. Or: npm run deploy:prod (for production)');
