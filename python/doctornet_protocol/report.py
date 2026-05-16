from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, Field, confloat, conint

from .common import (
    AlertPayload,
    HealthSummaryPayload,
    ISPPayload,
    LocationPayload,
)
from .version import PROTOCOL_VERSION


class HostMetricsPayload(BaseModel):
    latency_avg_ms: float | None = None
    latency_min_ms: float | None = None
    latency_max_ms: float | None = None
    latency_p95_ms: float | None = None
    packet_loss_pct: float = 0.0
    jitter_ms: float = 0.0
    pings_sent: int = 0
    pings_ok: int = 0
    status_changes: list[dict] | None = None


class HostPayload(BaseModel):
    name: str
    address: str | None = None
    category: str
    status_at_end: str
    metrics: HostMetricsPayload
    # A single 1h × 1s ping run produces 3600 samples; 5000 leaves slack.
    latency_series: list[float] | None = Field(default=None, max_length=5000)


class WifiSample(BaseModel):
    t: int
    rssi: int
    noise: int
    tx_rate: float


class WifiSummaryPayload(BaseModel):
    rssi_avg: int
    rssi_min: int
    rssi_max: int
    noise_avg: int
    snr_avg: int
    tx_rate_avg: float


class WifiSeriesPayload(BaseModel):
    ssid: str | None = None
    channel: int | None = None
    band: str | None = None
    samples: list[WifiSample] = Field(default_factory=list, max_length=5000)
    summary: WifiSummaryPayload | None = None


class SpeedTestPayload(BaseModel):
    timestamp: datetime
    download_mbps: float
    upload_mbps: float
    latency_ms: float


class TraceHopPayload(BaseModel):
    number: int
    ip: str | None = None
    latency_ms: float | None = None
    is_timeout: bool = False


class TracerouteSamplePayload(BaseModel):
    target_host: str
    # Real-world traceroutes top out well below 64; agent caps at 20.
    hops: list[TraceHopPayload] = Field(default_factory=list, max_length=64)
    hop_count: int = 0
    final_ip: str | None = None
    captured_at: datetime | None = None


class IperfSamplePayload(BaseModel):
    server_host: str
    mode: str = "tcp_up"
    # 1 Tbps is a comfortable upper bound for any real iperf run.
    bits_per_second_sent: confloat(ge=0, le=1e12) | None = None
    bits_per_second_received: confloat(ge=0, le=1e12) | None = None
    jitter_ms: confloat(ge=0, le=1e6) | None = None
    loss_percent: confloat(ge=0, le=100) | None = None
    retransmits: conint(ge=0, le=10**9) | None = None
    duration_sec: confloat(ge=0, le=86400) = 0.0
    captured_at: datetime | None = None


class ReportPayload(BaseModel):
    version: str = PROTOCOL_VERSION
    device_id: UUID
    device_name: str
    report_interval_seconds: int = 300
    period_start: datetime
    period_end: datetime
    location: LocationPayload | None = None
    isp: ISPPayload | None = None
    health_summary: HealthSummaryPayload
    hosts: list[HostPayload] = Field(default_factory=list, max_length=200)
    wifi_series: WifiSeriesPayload | None = None
    speed_tests: list[SpeedTestPayload] = Field(default_factory=list, max_length=200)
    alerts_during_period: list[AlertPayload] = Field(default_factory=list, max_length=2000)
    traceroute_samples: list[TracerouteSamplePayload] = Field(default_factory=list, max_length=500)
    iperf_samples: list[IperfSamplePayload] = Field(default_factory=list, max_length=500)
