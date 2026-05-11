-- CarSharing P2P — MVP Database Schema
-- Compatible with DrawSQL import

CREATE TYPE fuel_type_enum AS ENUM ('petrol', 'diesel', 'electric', 'hybrid');
CREATE TYPE transmission_enum AS ENUM ('manual', 'automatic');
CREATE TYPE car_status_enum AS ENUM ('active', 'inactive', 'rented');
CREATE TYPE availability_type_enum AS ENUM ('available', 'blocked');
CREATE TYPE booking_status_enum AS ENUM ('PENDING', 'CONFIRMED', 'ACTIVE', 'COMPLETED', 'CANCELLED');
CREATE TYPE review_type_enum AS ENUM ('car', 'user');

CREATE TABLE users (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone         VARCHAR(20),
    first_name    VARCHAR(100),
    last_name     VARCHAR(100),
    avatar_url    VARCHAR(500),
    is_verified   BOOLEAN NOT NULL DEFAULT FALSE,
    created_at    TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE refresh_tokens (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash  VARCHAR(255) NOT NULL UNIQUE,
    expires_at  TIMESTAMP NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    revoked_at  TIMESTAMP
);

CREATE TABLE cars (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    brand         VARCHAR(100) NOT NULL,
    model         VARCHAR(100) NOT NULL,
    year          INT NOT NULL,
    fuel_type     fuel_type_enum NOT NULL,
    transmission  transmission_enum NOT NULL,
    description   TEXT,
    price_per_day DECIMAL(10, 2) NOT NULL,
    deposit       DECIMAL(10, 2) NOT NULL DEFAULT 0,
    status        car_status_enum NOT NULL DEFAULT 'active',
    lat           DECIMAL(10, 7),
    lng           DECIMAL(10, 7),
    address       VARCHAR(255),
    created_at    TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE car_photos (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    car_id     UUID NOT NULL REFERENCES cars(id) ON DELETE CASCADE,
    url        VARCHAR(500) NOT NULL,
    sort_order INT NOT NULL DEFAULT 0
);

CREATE TABLE car_availability (
    id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    car_id    UUID NOT NULL REFERENCES cars(id) ON DELETE CASCADE,
    date_from DATE NOT NULL,
    date_to   DATE NOT NULL,
    type      availability_type_enum NOT NULL DEFAULT 'available'
);

CREATE TABLE bookings (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    car_id         UUID NOT NULL REFERENCES cars(id) ON DELETE RESTRICT,
    renter_id      UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    start_at       TIMESTAMP NOT NULL,
    end_at         TIMESTAMP NOT NULL,
    total_price    DECIMAL(10, 2) NOT NULL,
    deposit_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    status         booking_status_enum NOT NULL DEFAULT 'PENDING',
    created_at     TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE reviews (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    author_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    car_id     UUID REFERENCES cars(id) ON DELETE SET NULL,
    rating     INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment    TEXT,
    type       review_type_enum NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
