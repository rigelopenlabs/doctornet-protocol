import XCTest
@testable import DoctorNetProtocol

final class RoundTripTests: XCTestCase {
    func testReportPayloadRoundTrip() throws {
        let report = ReportPayload(
            deviceID: UUID(),
            deviceName: "test-device",
            periodStart: Date(),
            periodEnd: Date(),
            healthSummary: HealthSummaryPayload(
                overall: HealthSummaryValue(avg: 95, min: 80, max: 100),
                global: HealthSummaryValue(avg: 98, min: 90, max: 100),
                isp: HealthSummaryValue(avg: 92, min: 70, max: 100),
                local: HealthSummaryValue(avg: 100, min: 100, max: 100)
            ),
            hosts: [
                HostPayload(
                    name: "Cloudflare",
                    address: "1.1.1.1",
                    category: "Internet",
                    statusAtEnd: "online",
                    metrics: HostMetricsPayload(latencyAvgMs: 12.5, packetLossPct: 0, jitterMs: 0.8, pingsSent: 30, pingsOk: 30, statusChanges: [["timestamp": "2026-05-31T00:00:00Z", "from": "online", "to": "offline"]])
                )
            ],
            iperfSamples: [
                IperfSamplePayload(serverHost: "iperf.example.com", mode: "tcp_up", bitsPerSecondSent: 1.5e8, durationSec: 5)
            ]
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(report)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(ReportPayload.self, from: data)

        XCTAssertEqual(decoded.deviceName, report.deviceName)
        XCTAssertEqual(decoded.hosts.count, 1)
        XCTAssertEqual(decoded.hosts.first?.metrics.statusChanges?.first?["to"], "offline")
        XCTAssertEqual(decoded.iperfSamples.first?.serverHost, "iperf.example.com")
    }

    func testScanPayloadRoundTrip() throws {
        let scan = ScanPayload(
            deviceID: UUID(),
            deviceName: "netscout-01",
            siteName: "Office",
            scannedAt: Date(),
            subnet: "192.168.1.0/24",
            devicesFound: 1,
            devices: [
                ScannedDevicePayload(ip: "192.168.1.1", mac: "AA:BB:CC:DD:EE:FF", vendor: "MikroTik", hostname: "router")
            ]
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(scan)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(ScanPayload.self, from: data)

        XCTAssertEqual(decoded.subnet, "192.168.1.0/24")
        XCTAssertEqual(decoded.devices.first?.vendor, "MikroTik")
    }

    func testVersionConstant() {
        XCTAssertEqual(ProtocolVersion.current, "1.0")
        XCTAssertEqual(ProtocolVersion.packageVersion, "0.1.1")
    }
}
