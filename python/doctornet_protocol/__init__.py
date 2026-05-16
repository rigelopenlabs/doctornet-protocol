"""DoctorNet shared protocol — DTOs for NOC, agents and mobile clients.

Single source of truth for the report/scan payloads exchanged between
the NetProbe Agent, NetScout, DoctorNet macOS/iOS and the NOC.
"""

from .version import PROTOCOL_VERSION, PACKAGE_VERSION
from .common import (
    LocationPayload,
    ISPPayload,
    HealthSummaryValue,
    HealthSummaryPayload,
    AlertPayload,
)
from .report import (
    HostMetricsPayload,
    HostPayload,
    WifiSample,
    WifiSummaryPayload,
    WifiSeriesPayload,
    SpeedTestPayload,
    TraceHopPayload,
    TracerouteSamplePayload,
    IperfSamplePayload,
    ReportPayload,
)
from .scan import (
    ScannedDevicePayload,
    ScanChangesPayload,
    ScanPayload,
)

__all__ = [
    "PROTOCOL_VERSION",
    "PACKAGE_VERSION",
    # common
    "LocationPayload",
    "ISPPayload",
    "HealthSummaryValue",
    "HealthSummaryPayload",
    "AlertPayload",
    # report
    "HostMetricsPayload",
    "HostPayload",
    "WifiSample",
    "WifiSummaryPayload",
    "WifiSeriesPayload",
    "SpeedTestPayload",
    "TraceHopPayload",
    "TracerouteSamplePayload",
    "IperfSamplePayload",
    "ReportPayload",
    # scan
    "ScannedDevicePayload",
    "ScanChangesPayload",
    "ScanPayload",
]
