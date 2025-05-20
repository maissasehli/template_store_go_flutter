# StoreGo - E-Commerce Application Platform

StoreGo is a comprehensive e-commerce platform that enables store owners to create and manage their own mobile applications without extensive technical knowledge. The platform operates on a multi-tenant architecture, allowing users to manage multiple stores, each with their own customer base.

## Project Overview

StoreGo is designed as a complete solution for creating and managing e-commerce mobile applications. Key features include:

- **Multi-tenant Architecture**: Support for multiple stores with isolated customer bases
- **No-Code App Generation**: Store owners can configure and generate full-featured mobile apps without coding
- **Real-time Updates**: Live progress tracking for app generation and bidirectional notifications
- **Comprehensive Store Management**: Complete dashboard for inventory, orders, customers, and analytics

## Getting Started

### Prerequisites

- Node.js (latest LTS version recommended)
- PostgreSQL database
- Supabase account for authentication
- Pusher account for real-time features

### Installation

1. Clone the repository

```bash
git clone https://github.com/wassimD28/store-go.git
cd store-go
```

2. Install dependencies

```bash
npm install
# or
pnpm install
# or
bun install
```

3. Set up your environment variables (see `.env.example` for required variables)

4. Generate and apply database migrations

```bash
npm run db:generate
npm run db:push
```

5. Start the development server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the application.

## Architecture

### Core Components

1. **Flutter-based mobile app** for end customers
2. **Next.js admin dashboard** for store owners
3. **Flutter code generator** that transforms store configurations into complete Flutter applications

### Technology Stack

- **Generator**: TypeScript, Handlebars, Node.js
- **Mobile App**: Flutter/Dart with GetX state management
- **Admin Dashboard**: Next.js/TypeScript with Hono for API routes
- **Database**: PostgreSQL with Drizzle ORM
- **Authentication**:
  - Butter-auth for the main platform authentication
  - Supabase for app user authentication
- **Realtime Communications**: Pusher for notifications and presence channels
- **CI/CD**: GitHub Actions for automated app generation

## Authentication System

### App User Authentication Workflow

1. User creates an account through the generated mobile app
2. The account is linked with the store ID that exists in the Flutter .env file (generated via GitHub Actions)
3. On each login attempt:
   - System checks if the user belongs to the correct store
   - The generated app uses Supabase Auth system for JWT-based authentication
   - NextJS platform (StoreGo) uses Hono to handle API routes and communicates with Supabase

### Key Authentication Features

- JWT-based authentication
- Store-specific user validation
- Secure password hashing with bcrypt
- Session management with refresh tokens

## Database Schema

The database schema includes numerous interconnected tables for the multi-tenant e-commerce system:

### Key Tables

- **stores**: Store information and configurations
- **app_user**: End customers of specific stores
- **app_product**: Products offered by stores
- **app_category/app_subcategory**: Product categorization
- **app_order/app_payment**: Order management
- **app_cart/app_wishlist**: User shopping interactions
- **app_promotion**: Store promotions and discounts
- **app_notification/store_notification**: Notification system for both apps and stores
- **custom_store_template/store_template**: Templates for generating store apps
- **generation_jobs**: Tracking app generation processes

## App Generation Process

1. Store owner configures their store in the admin dashboard
2. Configuration is saved as `config.json`
3. GitHub Action triggers the code generator
4. Generator validates the configuration
5. Generator creates Flutter application structure from templates
6. Progress updates are sent via Pusher to the store owner
7. Generated app is built for target platforms
8. Completed app is made available to the store owner

## Deployment

StoreGo is currently deployed on Vercel. To deploy your own instance:

```bash
npm run build
```

Then deploy using the [Vercel Platform](https://vercel.com/new) or your preferred hosting provider.

## License

[MIT](LICENSE)
