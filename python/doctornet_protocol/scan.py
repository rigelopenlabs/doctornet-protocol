from datetime import datetime
from uuid import UUID

from pydantic import BaseModel

from .version import PROTOCOL_VERSION


class ScannedDevicePayload(BaseModel):
    ip: str
    mac: str
    vendor: str = "Unknown"
    device_type: str | None = None
    os_guess: str | None = None
    hostname: str | None = None
    open_ports: list[int] | None = None
    mdns_services: list[str] | None = None


class ScanChangesPayload(BaseModel):
    new: list[ScannedDevicePayload] = []
    gone: list[ScannedDevicePayload] = []
    returned: list[ScannedDevicePayload] = []


class ScanPayload(BaseModel):
    version: str = PROTOCOL_VERSION
    device_id: UUID
    device_name: str
    site_name: str = "Unknown"
    scanned_at: datetime
    subnet: str
    devices_found: int
    devices: list[ScannedDevicePayload] = []
    changes: ScanChangesPayload = ScanChangesPayload()
    vendor_summary: dict[str, int] = {}
    type_summary: dict[str, int] = {}
    topology: dict | None = None
    alerts: list[dict] = []
    diagram_svg: str | None = None
