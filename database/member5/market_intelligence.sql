-- AgriSphere AI | Member 5 - Market Intelligence
-- Run against the same MySQL database configured by DB_NAME in the project .env.
-- All tables use the mi_ prefix to avoid collisions with other team modules.

CREATE TABLE IF NOT EXISTS mi_buyers_sellers (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, name VARCHAR(120) NOT NULL,
  role ENUM('buyer','seller','both') NOT NULL, phone VARCHAR(20), email VARCHAR(160),
  city VARCHAR(100), state VARCHAR(100), business_name VARCHAR(160),
  is_active TINYINT(1) NOT NULL DEFAULT 1, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_mi_user_location(city,state), INDEX idx_mi_user_role(role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS mi_markets (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, name VARCHAR(160) NOT NULL,
  city VARCHAR(100) NOT NULL, state VARCHAR(100) NOT NULL, address VARCHAR(255),
  market_type VARCHAR(80) DEFAULT 'Mandi', opening_time TIME, closing_time TIME,
  contact_phone VARCHAR(20), is_active TINYINT(1) NOT NULL DEFAULT 1,
  INDEX idx_mi_market_location(city,state)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS mi_crop_listings (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, seller_id BIGINT UNSIGNED NOT NULL,
  crop_name VARCHAR(100) NOT NULL, variety VARCHAR(100), quantity_kg DECIMAL(12,2) NOT NULL,
  price_per_kg DECIMAL(10,2) NOT NULL, quality_grade VARCHAR(40) DEFAULT 'Standard',
  description TEXT, status ENUM('available','reserved','sold','inactive') NOT NULL DEFAULT 'available',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_mi_listing_seller FOREIGN KEY(seller_id) REFERENCES mi_buyers_sellers(id),
  INDEX idx_mi_listing_crop_status(crop_name,status), INDEX idx_mi_listing_created(created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS mi_price_history (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, crop_name VARCHAR(100) NOT NULL,
  market_id BIGINT UNSIGNED NULL, market_date DATE NOT NULL,
  min_price_per_kg DECIMAL(10,2), max_price_per_kg DECIMAL(10,2),
  modal_price_per_kg DECIMAL(10,2) NOT NULL, source_name VARCHAR(160),
  CONSTRAINT fk_mi_price_market FOREIGN KEY(market_id) REFERENCES mi_markets(id) ON DELETE SET NULL,
  INDEX idx_mi_price_crop_date(crop_name,market_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS mi_cold_storage (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, name VARCHAR(160) NOT NULL,
  city VARCHAR(100) NOT NULL, state VARCHAR(100) NOT NULL, address VARCHAR(255),
  capacity_tonnes DECIMAL(12,2) NOT NULL DEFAULT 0, available_capacity_tonnes DECIMAL(12,2) NOT NULL DEFAULT 0,
  temperature_range VARCHAR(80), price_per_tonne_day DECIMAL(10,2), contact_phone VARCHAR(20),
  is_active TINYINT(1) NOT NULL DEFAULT 1, INDEX idx_mi_storage_location(city,state)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS mi_transport_providers (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, provider_name VARCHAR(160) NOT NULL,
  vehicle_type VARCHAR(100) NOT NULL, city VARCHAR(100) NOT NULL, state VARCHAR(100) NOT NULL,
  service_area VARCHAR(255), load_capacity_tonnes DECIMAL(10,2), price_per_km DECIMAL(10,2),
  contact_phone VARCHAR(20), is_active TINYINT(1) NOT NULL DEFAULT 1,
  INDEX idx_mi_transport_location(city,state)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Optional demo records: clearly fictional examples for local UI testing only.
-- Uncomment and replace with verified local data before a real deployment.
-- INSERT INTO mi_buyers_sellers(name,role,phone,city,state) VALUES ('Demo Seller','seller','0000000000','Bhopal','Madhya Pradesh');
