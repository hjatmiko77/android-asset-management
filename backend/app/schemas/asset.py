from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

class AssetBase(BaseModel):
    organization: str
    location: Optional[str] = None
    building: Optional[str] = None
    systems: Optional[str] = None
    sub_systems: Optional[str] = None
    kode_aset: str = Field(..., unique=True)
    asset_category: Optional[str] = None
    merk: Optional[str] = None
    serial_number: Optional[str] = None
    model: Optional[str] = None

class AssetCreate(AssetBase):
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    asset_code_lv5: Optional[str] = None
    desc_lv5: Optional[str] = None
    asset_code_lv6: Optional[str] = None
    desc_lv6: Optional[str] = None
    asset_code_lv7: Optional[str] = None
    desc_lv7: Optional[str] = None
    installed_date: Optional[datetime] = None
    warranty_date: Optional[datetime] = None
    capex_opex: Optional[str] = None
    kepemilikan: Optional[str] = None
    kondisi: Optional[str] = None
    detail_kondisi: Optional[str] = None
    fungsi_utama: Optional[str] = None

class AssetUpdate(BaseModel):
    kondisi: Optional[str] = None
    detail_kondisi: Optional[str] = None
    photo_asset: Optional[str] = None
    photo_label: Optional[str] = None

class AssetResponse(AssetBase):
    id: int
    latitude: Optional[float]
    longitude: Optional[float]
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
