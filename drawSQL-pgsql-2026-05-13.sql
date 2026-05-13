CREATE TABLE "users"(
    "id" UUID NOT NULL DEFAULT UUID(), "email" VARCHAR(255) NOT NULL, "password_hash" VARCHAR(255) NOT NULL, "phone" VARCHAR(20) NULL, "first_name" VARCHAR(100) NULL, "last_name" VARCHAR(100) NULL, "avatar_url" VARCHAR(500) NULL, "is_blocked" BOOLEAN NOT NULL, "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP);
ALTER TABLE
    "users" ADD PRIMARY KEY("id");
ALTER TABLE
    "users" ADD CONSTRAINT "users_email_unique" UNIQUE("email");
CREATE TABLE "refresh_tokens"(
    "id" UUID NOT NULL DEFAULT UUID(), "user_id" UUID NOT NULL, "token_hash" VARCHAR(255) NOT NULL, "expires_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP, "revoked_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL);
ALTER TABLE
    "refresh_tokens" ADD PRIMARY KEY("id");
ALTER TABLE
    "refresh_tokens" ADD CONSTRAINT "refresh_tokens_token_hash_unique" UNIQUE("token_hash");
CREATE TABLE "cars"(
    "id" UUID NOT NULL DEFAULT UUID(), "owner_id" UUID NOT NULL, "brand" VARCHAR(100) NOT NULL, "model" VARCHAR(100) NOT NULL, "year" INTEGER NOT NULL, "fuel_type" INTEGER NOT NULL, "transmission" INTEGER NOT NULL, "description" TEXT NULL, "price_per_day" DECIMAL(10, 2) NOT NULL, "deposit" DECIMAL(10, 2) NOT NULL, "car_status" INTEGER NOT NULL DEFAULT 'active', "lat" DECIMAL(10, 7) NULL, "lng" DECIMAL(10, 7) NULL, "address" VARCHAR(255) NULL, "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP);
ALTER TABLE
    "cars" ADD PRIMARY KEY("id");
CREATE TABLE "car_photos"(
    "id" UUID NOT NULL DEFAULT UUID(), "car_id" UUID NOT NULL, "url" VARCHAR(500) NOT NULL, "sort_order" INTEGER NOT NULL);
ALTER TABLE
    "car_photos" ADD PRIMARY KEY("id");
CREATE TABLE "car_availability"(
    "id" UUID NOT NULL DEFAULT UUID(), "car_id" UUID NOT NULL, "date_from" DATE NOT NULL, "date_to" DATE NOT NULL, "period_type" INTEGER NOT NULL DEFAULT 'available');
ALTER TABLE
    "car_availability" ADD PRIMARY KEY("id");
CREATE TABLE "bookings"(
    "id" UUID NOT NULL DEFAULT UUID(), "car_id" UUID NOT NULL, "renter_id" UUID NOT NULL, "start_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, "end_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, "total_price" DECIMAL(10, 2) NOT NULL, "deposit_amount" DECIMAL(10, 2) NOT NULL, "booking_status" INTEGER NOT NULL DEFAULT 'PENDING', "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP);
ALTER TABLE
    "bookings" ADD PRIMARY KEY("id");
CREATE TABLE "reviews"(
    "id" UUID NOT NULL DEFAULT UUID(), "author_id" UUID NOT NULL, "car_id" UUID NULL, "rating" INTEGER NOT NULL, "comment" TEXT NULL, "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP);
ALTER TABLE
    "reviews" ADD PRIMARY KEY("id");
ALTER TABLE
    "bookings" ADD CONSTRAINT "bookings_renter_id_foreign" FOREIGN KEY("renter_id") REFERENCES "users"("id");
ALTER TABLE
    "car_photos" ADD CONSTRAINT "car_photos_car_id_foreign" FOREIGN KEY("car_id") REFERENCES "cars"("id");
ALTER TABLE
    "bookings" ADD CONSTRAINT "bookings_car_id_foreign" FOREIGN KEY("car_id") REFERENCES "cars"("id");
ALTER TABLE
    "cars" ADD CONSTRAINT "cars_owner_id_foreign" FOREIGN KEY("owner_id") REFERENCES "users"("id");
ALTER TABLE
    "car_availability" ADD CONSTRAINT "car_availability_car_id_foreign" FOREIGN KEY("car_id") REFERENCES "cars"("id");