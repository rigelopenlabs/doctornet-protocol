from datetime import datetime, timezone
from uuid import uuid4

from doctornet_protocol import (
    HealthSummaryPayload,
    HealthSummaryValue,
    HostMetricsPayload,
    HostPayload,
    IperfSamplePayload,
    LocationPayload,
    PROTOCOL_VERSION,
    ReportPayload,
    ScannedDevicePayload,
    ScanPayload,
)


def test_report_roundtrip():
    report = ReportPayload(
        device_id=uuid4(),
        device_name="test-device",
        period_start=datetime.now(timezone.utc),
        period_end=datetime.now(timezone.utc),
        health_summary=HealthSummaryPayload.model_validate({
            "overall": {"avg": 95, "min": 80, "max": 100},
            "global": {"avg": 98, "min": 90, "max": 100},
            "isp": {"avg": 92, "min": 70, "max": 100},
            "local": {"avg": 100, "min": 100, "max": 100},
        }),
        hosts=[
            HostPayload(
                name="Cloudflare",
                address="1.1.1.1",
                category="Internet",
                status_at_end="online",
                metrics=HostMetricsPayload(latency_avg_ms=12.5, pings_sent=30, pings_ok=30),
            )
        ],
        iperf_samples=[
            IperfSamplePayload(server_host="iperf.example.com", mode="tcp_up", bits_per_second_sent=1.5e8, duration_sec=5)
        ],
    )
    blob = report.model_dump_json()
    decoded = ReportPayload.model_validate_json(blob)
    assert decoded.device_name == "test-device"
    assert decoded.hosts[0].address == "1.1.1.1"
    assert decoded.iperf_samples[0].server_host == "iperf.example.com"


def test_scan_roundtrip():
    scan = ScanPayload(
        device_id=uuid4(),
        device_name="netscout-01",
        site_name="Office",
        scanned_at=datetime.now(timezone.utc),
        subnet="192.168.1.0/24",
        devices_found=1,
        devices=[ScannedDevicePayload(ip="192.168.1.1", mac="AA:BB:CC:DD:EE:FF", vendor="MikroTik", hostname="router")],
    )
    blob = scan.model_dump_json()
    decoded = ScanPayload.model_validate_json(blob)
    assert decoded.subnet == "192.168.1.0/24"
    assert decoded.devices[0].vendor == "MikroTik"


def test_location_bssid_roundtrip():
    # Present: wifi_bssid survives the round-trip.
    loc = LocationPayload(site_name="OFI", wifi_ssid="INFINITUM", wifi_bssid="AA:BB:CC:DD:EE:FF")
    decoded = LocationPayload.model_validate_json(loc.model_dump_json())
    assert decoded.wifi_bssid == "AA:BB:CC:DD:EE:FF"
    # Absent (older client): field defaults to None, still parses.
    legacy = LocationPayload.model_validate_json('{"site_name":"OFI","wifi_ssid":"INFINITUM"}')
    assert legacy.wifi_bssid is None


def test_version():
    assert PROTOCOL_VERSION == "1.1"
