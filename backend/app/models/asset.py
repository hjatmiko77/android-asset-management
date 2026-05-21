from sqlalchemy import Column, Integer, String, DateTime, Float, Text, Boolean, ForeignKey
from sqlalchemy.sql import func
from datetime import datetime
from app.models import Base

class Asset(Base):
    __tablename__ = "assets"

    id = Column(Integer, primary_key=True, index=True)
    
    # Location Data
    organization = Column(String(100), nullable=False)
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)
    location = Column(String(100), nullable=True)
    building = Column(String(100), nullable=True)
    systems = Column(String(100), nullable=True)
    sub_systems = Column(String(100), nullable=True)
    
    # Asset Level Data
    asset_code_lv5 = Column(String(50), nullable=True)
    desc_lv5 = Column(String(255), nullable=True)
    asset_code_lv6 = Column(String(50), nullable=True)
    desc_lv6 = Column(String(255), nullable=True)
    asset_code_lv7 = Column(String(50), nullable=True)
    desc_lv7 = Column(String(255), nullable=True)
    kode_aset = Column(String(50), unique=True, index=True, nullable=False)
    
    # Asset Detail
    asset_category = Column(String(50), nullable=True)
    merk = Column(String(100), nullable=True)
    serial_number = Column(String(100), nullable=True, index=True)
    model = Column(String(100), nullable=True)
    installed_date = Column(DateTime, nullable=True)
    warranty_date = Column(DateTime, nullable=True)
    capex_opex = Column(String(20), nullable=True)  # Capex, Opex
    kepemilikan = Column(String(100), nullable=True)
    kondisi = Column(String(50), nullable=True)  # Baik, Rusak, etc
    detail_kondisi = Column(Text, nullable=True)
    fungsi_utama = Column(Text, nullable=True)
    
    # Photos
    photo_asset = Column(String(255), nullable=True)
    photo_label = Column(String(255), nullable=True)
    
    # Metadata
    created_by = Column(Integer, ForeignKey('users.id'), nullable=False)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
    is_deleted = Column(Boolean, default=False)

    class Config:
        from_attributes = True
