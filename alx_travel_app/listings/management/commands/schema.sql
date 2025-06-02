DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS booking;
DROP TABLE IF EXISTS listing;

-- Drop enum types
DROP TYPE IF EXISTS booking_status;

-- Define ENUM types
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'cancelled');
 
CREATE TABLE listing (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(100) NOT NULL,
    pricepernight DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE booking (
    id SERIAL PRIMARY KEY,
    listing_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status booking_status NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (listing_id) REFERENCES listing(id),
);

CREATE TABLE review (
    id SERIAL PRIMARY KEY,
    listing_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (listing_id) REFERENCES listing(id),
);

-- To find bookings per poperty 
CREATE INDEX idx_listing_booking_id on booking(listing_id);
