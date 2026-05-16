from datetime import datetime

from pydantic import BaseModel, Field


class LocationPayload(BaseModel):
    site_name: str | None = None
    wifi_ssid: str | None = None
    gps_lat: float | None = None
    gps_lon: float | None = None
    connection_type: str | None = "wifi"


class ISPPayload(BaseModel):
    name: str | None = None
    asn: str | None = None
    public_ip: str | None = None
    source: str = "auto"
    user_override: str | None = None


class HealthSummaryValue(BaseModel):
    avg: int
    min: int
    max: int


class HealthSummaryPayload(BaseModel):
    overall: HealthSummaryValue
    global_health: HealthSummaryValue = Field(alias="global")
    isp: HealthSummaryValue
    local: HealthSummaryValue

    model_config = {"populate_by_name": True}


class AlertPayload(BaseModel):
    timestamp: datetime
    host: str
    type: str
    value: float
