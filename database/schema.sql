-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    fullname VARCHAR(100),
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user' NOT NULL CHECK (role IN ('admin', 'user')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);

-- Assets Table
CREATE TABLE IF NOT EXISTS assets (
    id SERIAL PRIMARY KEY,
    organization VARCHAR(100) NOT NULL,
    latitude FLOAT,
    longitude FLOAT,
    location VARCHAR(100),
    building VARCHAR(100),
    systems VARCHAR(100),
    sub_systems VARCHAR(100),
    asset_code_lv5 VARCHAR(50),
    desc_lv5 VARCHAR(255),
    asset_code_lv6 VARCHAR(50),
    desc_lv6 VARCHAR(255),
    asset_code_lv7 VARCHAR(50),
    desc_lv7 VARCHAR(255),
    kode_aset VARCHAR(50) UNIQUE NOT NULL,
    asset_category VARCHAR(50),
    merk VARCHAR(100),
    serial_number VARCHAR(100),
    model VARCHAR(100),
    installed_date TIMESTAMP,
    warranty_date TIMESTAMP,
    capex_opex VARCHAR(20),
    kepemilikan VARCHAR(100),
    kondisi VARCHAR(50),
    detail_kondisi TEXT,
    fungsi_utama TEXT,
    photo_asset VARCHAR(255),
    photo_label VARCHAR(255),
    created_by INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_assets_kode_aset ON assets(kode_aset);
CREATE INDEX idx_assets_serial_number ON assets(serial_number);
CREATE INDEX idx_assets_created_by ON assets(created_by);
CREATE INDEX idx_assets_is_deleted ON assets(is_deleted);

-- Audit Logs Table
CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    action VARCHAR(50) NOT NULL,
    resource VARCHAR(50),
    resource_id INTEGER,
    details TEXT,
    device_info VARCHAR(255),
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

-- Sync Queue Table (for offline sync)
CREATE TABLE IF NOT EXISTS sync_queue (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    action VARCHAR(20) NOT NULL,
    resource VARCHAR(50) NOT NULL,
    resource_id INTEGER,
    payload JSONB,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    synced_at TIMESTAMP
);

CREATE INDEX idx_sync_queue_user_id ON sync_queue(user_id);
CREATE INDEX idx_sync_queue_status ON sync_queue(status);
