import Foundation

public struct HostMetricsPayload: Codable, Equatable, Sendable {
    public var latencyAvgMs: Double?
    public var latencyMinMs: Double?
    public var latencyMaxMs: Double?
    public var latencyP95Ms: Double?
    public var packetLossPct: Double
    public var jitterMs: Double
    public var pingsSent: Int
    public var pingsOk: Int
    /// Up/down transitions during the period. Each entry is {timestamp, from, to}.
    /// Matches the Python side's `status_changes: list[dict]`.
    public var statusChanges: [[String: String]]?

    enum CodingKeys: String, CodingKey {
        case latencyAvgMs = "latency_avg_ms"
        case latencyMinMs = "latency_min_ms"
        case latencyMaxMs = "latency_max_ms"
        case latencyP95Ms = "latency_p95_ms"
        case packetLossPct = "packet_loss_pct"
        case jitterMs = "jitter_ms"
        case pingsSent = "pings_sent"
        case pingsOk = "pings_ok"
        case statusChanges = "status_changes"
    }

    public init(latencyAvgMs: Double? = nil, latencyMinMs: Double? = nil, latencyMaxMs: Double? = nil, latencyP95Ms: Double? = nil, packetLossPct: Double = 0, jitterMs: Double = 0, pingsSent: Int = 0, pingsOk: Int = 0, statusChanges: [[String: String]]? = nil) {
        self.latencyAvgMs = latencyAvgMs
        self.latencyMinMs = latencyMinMs
        self.latencyMaxMs = latencyMaxMs
        self.latencyP95Ms = latencyP95Ms
        self.packetLossPct = packetLossPct
        self.jitterMs = jitterMs
        self.pingsSent = pingsSent
        self.pingsOk = pingsOk
        self.statusChanges = statusChanges
    }
}

public struct HostPayload: Codable, Equatable, Sendable {
    public var name: String
    public var address: String?
    public var category: String
    public var statusAtEnd: String
    public var metrics: HostMetricsPayload
    public var latencySeries: [Double]?

    enum CodingKeys: String, CodingKey {
        case name, address, category, metrics
        case statusAtEnd = "status_at_end"
        case latencySeries = "latency_series"
    }

    public init(name: String, address: String? = nil, category: String, statusAtEnd: String, metrics: HostMetricsPayload, latencySeries: [Double]? = nil) {
        self.name = name
        self.address = address
        self.category = category
        self.statusAtEnd = statusAtEnd
        self.metrics = metrics
        self.latencySeries = latencySeries
    }
}

public struct WifiSample: Codable, Equatable, Sendable {
    public var t: Int
    public var rssi: Int
    public var noise: Int
    public var txRate: Double

    enum CodingKeys: String, CodingKey {
        case t, rssi, noise
        case txRate = "tx_rate"
    }

    public init(t: Int, rssi: Int, noise: Int, txRate: Double) {
        self.t = t
        self.rssi = rssi
        self.noise = noise
        self.txRate = txRate
    }
}

public struct WifiSummaryPayload: Codable, Equatable, Sendable {
    public var rssiAvg: Int
    public var rssiMin: Int
    public var rssiMax: Int
    public var noiseAvg: Int
    public var snrAvg: Int
    public var txRateAvg: Double

    enum CodingKeys: String, CodingKey {
        case rssiAvg = "rssi_avg"
        case rssiMin = "rssi_min"
        case rssiMax = "rssi_max"
        case noiseAvg = "noise_avg"
        case snrAvg = "snr_avg"
        case txRateAvg = "tx_rate_avg"
    }

    public init(rssiAvg: Int, rssiMin: Int, rssiMax: Int, noiseAvg: Int, snrAvg: Int, txRateAvg: Double) {
        self.rssiAvg = rssiAvg
        self.rssiMin = rssiMin
        self.rssiMax = rssiMax
        self.noiseAvg = noiseAvg
        self.snrAvg = snrAvg
        self.txRateAvg = txRateAvg
    }
}

public struct WifiSeriesPayload: Codable, Equatable, Sendable {
    public var ssid: String?
    public var channel: Int?
    public var band: String?
    public var samples: [WifiSample]
    public var summary: WifiSummaryPayload?

    public init(ssid: String? = nil, channel: Int? = nil, band: String? = nil, samples: [WifiSample] = [], summary: WifiSummaryPayload? = nil) {
        self.ssid = ssid
        self.channel = channel
        self.band = band
        self.samples = samples
        self.summary = summary
    }
}

public struct SpeedTestPayload: Codable, Equatable, Sendable {
    public var timestamp: Date
    public var downloadMbps: Double
    public var uploadMbps: Double
    public var latencyMs: Double

    enum CodingKeys: String, CodingKey {
        case timestamp
        case downloadMbps = "download_mbps"
        case uploadMbps = "upload_mbps"
        case latencyMs = "latency_ms"
    }

    public init(timestamp: Date, downloadMbps: Double, uploadMbps: Double, latencyMs: Double) {
        self.timestamp = timestamp
        self.downloadMbps = downloadMbps
        self.uploadMbps = uploadMbps
        self.latencyMs = latencyMs
    }
}

public struct TraceHopPayload: Codable, Equatable, Sendable {
    public var number: Int
    public var ip: String?
    public var latencyMs: Double?
    public var isTimeout: Bool

    enum CodingKeys: String, CodingKey {
        case number, ip
        case latencyMs = "latency_ms"
        case isTimeout = "is_timeout"
    }

    public init(number: Int, ip: String? = nil, latencyMs: Double? = nil, isTimeout: Bool = false) {
        self.number = number
        self.ip = ip
        self.latencyMs = latencyMs
        self.isTimeout = isTimeout
    }
}

public struct TracerouteSamplePayload: Codable, Equatable, Sendable {
    public var targetHost: String
    public var hops: [TraceHopPayload]
    public var hopCount: Int
    public var finalIP: String?
    public var capturedAt: Date?

    enum CodingKeys: String, CodingKey {
        case targetHost = "target_host"
        case hops
        case hopCount = "hop_count"
        case finalIP = "final_ip"
        case capturedAt = "captured_at"
    }

    public init(targetHost: String, hops: [TraceHopPayload] = [], hopCount: Int = 0, finalIP: String? = nil, capturedAt: Date? = nil) {
        self.targetHost = targetHost
        self.hops = hops
        self.hopCount = hopCount
        self.finalIP = finalIP
        self.capturedAt = capturedAt
    }
}

public struct IperfSamplePayload: Codable, Equatable, Sendable {
    public var serverHost: String
    public var mode: String
    public var bitsPerSecondSent: Double?
    public var bitsPerSecondReceived: Double?
    public var jitterMs: Double?
    public var lossPercent: Double?
    public var retransmits: Int?
    public var durationSec: Double
    public var capturedAt: Date?

    enum CodingKeys: String, CodingKey {
        case serverHost = "server_host"
        case mode
        case bitsPerSecondSent = "bits_per_second_sent"
        case bitsPerSecondReceived = "bits_per_second_received"
        case jitterMs = "jitter_ms"
        case lossPercent = "loss_percent"
        case retransmits
        case durationSec = "duration_sec"
        case capturedAt = "captured_at"
    }

    public init(serverHost: String, mode: String = "tcp_up", bitsPerSecondSent: Double? = nil, bitsPerSecondReceived: Double? = nil, jitterMs: Double? = nil, lossPercent: Double? = nil, retransmits: Int? = nil, durationSec: Double = 0, capturedAt: Date? = nil) {
        self.serverHost = serverHost
        self.mode = mode
        self.bitsPerSecondSent = bitsPerSecondSent
        self.bitsPerSecondReceived = bitsPerSecondReceived
        self.jitterMs = jitterMs
        self.lossPercent = lossPercent
        self.retransmits = retransmits
        self.durationSec = durationSec
        self.capturedAt = capturedAt
    }
}

public struct ReportPayload: Codable, Equatable, Sendable {
    public var version: String
    public var deviceID: UUID
    public var deviceName: String
    public var reportIntervalSeconds: Int
    public var periodStart: Date
    public var periodEnd: Date
    public var location: LocationPayload?
    public var isp: ISPPayload?
    public var healthSummary: HealthSummaryPayload
    public var hosts: [HostPayload]
    public var wifiSeries: WifiSeriesPayload?
    public var speedTests: [SpeedTestPayload]
    public var alertsDuringPeriod: [AlertPayload]
    public var tracerouteSamples: [TracerouteSamplePayload]
    public var iperfSamples: [IperfSamplePayload]

    enum CodingKeys: String, CodingKey {
        case version
        case deviceID = "device_id"
        case deviceName = "device_name"
        case reportIntervalSeconds = "report_interval_seconds"
        case periodStart = "period_start"
        case periodEnd = "period_end"
        case location, isp
        case healthSummary = "health_summary"
        case hosts
        case wifiSeries = "wifi_series"
        case speedTests = "speed_tests"
        case alertsDuringPeriod = "alerts_during_period"
        case tracerouteSamples = "traceroute_samples"
        case iperfSamples = "iperf_samples"
    }

    public init(
        version: String = ProtocolVersion.current,
        deviceID: UUID,
        deviceName: String,
        reportIntervalSeconds: Int = 300,
        periodStart: Date,
        periodEnd: Date,
        location: LocationPayload? = nil,
        isp: ISPPayload? = nil,
        healthSummary: HealthSummaryPayload,
        hosts: [HostPayload] = [],
        wifiSeries: WifiSeriesPayload? = nil,
        speedTests: [SpeedTestPayload] = [],
        alertsDuringPeriod: [AlertPayload] = [],
        tracerouteSamples: [TracerouteSamplePayload] = [],
        iperfSamples: [IperfSamplePayload] = []
    ) {
        self.version = version
        self.deviceID = deviceID
        self.deviceName = deviceName
        self.reportIntervalSeconds = reportIntervalSeconds
        self.periodStart = periodStart
        self.periodEnd = periodEnd
        self.location = location
        self.isp = isp
        self.healthSummary = healthSummary
        self.hosts = hosts
        self.wifiSeries = wifiSeries
        self.speedTests = speedTests
        self.alertsDuringPeriod = alertsDuringPeriod
        self.tracerouteSamples = tracerouteSamples
        self.iperfSamples = iperfSamples
    }
}
