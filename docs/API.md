# API Documentation

## Base URL

```
http://localhost:8000/api/v1
```

## Authentication

All endpoints (except login/register) require JWT token in header:

```
Authorization: Bearer <access_token>
```

## Endpoints

### Authentication

#### Register User

```http
POST /auth/register
Content-Type: application/json

{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "password123",
  "fullname": "John Doe",
  "role": "user"
}
```

**Response (201)**
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "fullname": "John Doe",
  "role": "user",
  "is_active": true,
  "created_at": "2024-01-01T12:00:00",
  "updated_at": "2024-01-01T12:00:00"
}
```

#### Login

```http
POST /auth/login
Content-Type: application/json

{
  "username": "john_doe",
  "password": "password123"
}
```

**Response (200)**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
  "token_type": "bearer"
}
```

### Assets

#### Create Asset

```http
POST /assets
Content-Type: application/json
Authorization: Bearer <access_token>

{
  "organization": "PT Company",
  "location": "Jakarta Office",
  "building": "Building A",
  "systems": "IT Infrastructure",
  "sub_systems": "Server Room",
  "kode_aset": "AST-001-2024",
  "asset_category": "Hardware",
  "merk": "Dell",
  "serial_number": "SN123456",
  "model": "PowerEdge R750",
  "kondisi": "Baik",
  "latitude": -6.2088,
  "longitude": 106.8456
}
```

**Response (201)**
```json
{
  "id": 1,
  "organization": "PT Company",
  "kode_aset": "AST-001-2024",
  "asset_category": "Hardware",
  "merk": "Dell",
  "serial_number": "SN123456",
  "model": "PowerEdge R750",
  "kondisi": "Baik",
  "latitude": -6.2088,
  "longitude": 106.8456,
  "created_at": "2024-01-01T12:00:00",
  "updated_at": "2024-01-01T12:00:00"
}
```

#### List Assets

```http
GET /assets?skip=0&limit=10&search=Dell&category=Hardware
Authorization: Bearer <access_token>
```

#### Get Asset

```http
GET /assets/{asset_id}
Authorization: Bearer <access_token>
```

#### Update Asset

```http
PATCH /assets/{asset_id}
Content-Type: application/json
Authorization: Bearer <access_token>

{
  "kondisi": "Rusak Ringan",
  "detail_kondisi": "Layar retak"
}
```

#### Delete Asset

```http
DELETE /assets/{asset_id}
Authorization: Bearer <access_token>
```

#### Search by Barcode

```http
GET /assets/search/barcode/SN123456
Authorization: Bearer <access_token>
```

### Users

#### Get Current User

```http
GET /users/me
Authorization: Bearer <access_token>
```

#### List Users (Admin Only)

```http
GET /users
Authorization: Bearer <access_token>
```

## Error Responses

### 400 Bad Request

```json
{
  "detail": "Validation error",
  "errors": [
    {
      "field": "kode_aset",
      "message": "Field required"
    }
  ]
}
```

### 401 Unauthorized

```json
{
  "detail": "Invalid credentials"
}
```

### 403 Forbidden

```json
{
  "detail": "Insufficient permissions"
}
```

### 404 Not Found

```json
{
  "detail": "Resource not found"
}
```

### 500 Internal Server Error

```json
{
  "detail": "Internal server error"
}
```

## Rate Limiting

- General API: 10 requests/second
- Login endpoint: 5 requests/minute

Rate limit headers:
```
X-RateLimit-Limit: 10
X-RateLimit-Remaining: 9
X-RateLimit-Reset: 1234567890
```
