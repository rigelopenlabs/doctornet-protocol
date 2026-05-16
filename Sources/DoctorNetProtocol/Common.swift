import Foundation

public struct LocationPayload: Codable, Equatable, Sendable {
    public var siteName: String?
    public var wifiSSID: String?
    public var gpsLat: Double?
    public var gpsLon: Double?
    public var connectionType: String?

    enum CodingKeys: String, CodingKey {
        case siteName = "site_name"
        case wifiSSID = "wifi_ssid"
        case gpsLat = "gps_lat"
        case gpsLon = "gps_lon"
        case connectionType = "connection_type"
    }

    public init(siteName: String? = nil, wifiSSID: String? = nil, gpsLat: Double? = nil, gpsLon: Double? = nil, connectionType: String? = "wifi") {
        self.siteName = siteName
        self.wifiSSID = wifiSSID
        self.gpsLat = gpsLat
        self.gpsLon = gpsLon
        self.connectionType = connectionType
    }
}

public struct ISPPayload: Codable, Equatable, Sendable {
    public var name: String?
    public var asn: String?
    public var publicIP: String?
    public var source: String
    public var userOverride: String?

    enum CodingKeys: String, CodingKey {
        case name, asn, source
        case publicIP = "public_ip"
        case userOverride = "user_override"
    }

    public init(name: String? = nil, asn: String? = nil, publicIP: String? = nil, source: String = "auto", userOverride: String? = nil) {
        self.name = name
        self.asn = asn
        self.publicIP = publicIP
        self.source = source
        self.userOverride = userOverride
    }
}

public struct HealthSummaryValue: Codable, Equatable, Sendable {
    public var avg: Int
    public var min: Int
    public var max: Int

    public init(avg: Int, min: Int, max: Int) {
        self.avg = avg
        self.min = min
        self.max = max
    }
}

public struct HealthSummaryPayload: Codable, Equatable, Sendable {
    public var overall: HealthSummaryValue
    public var global: HealthSummaryValue
    public var isp: HealthSummaryValue
    public var local: HealthSummaryValue

    public init(overall: HealthSummaryValue, global: HealthSummaryValue, isp: HealthSummaryValue, local: HealthSummaryValue) {
        self.overall = overall
        self.global = global
        self.isp = isp
        self.local = local
    }
}

public struct AlertPayload: Codable, Equatable, Sendable {
    public var timestamp: Date
    public var host: String
    public var type: String
    public var value: Double

    public init(timestamp: Date, host: String, type: String, value: Double) {
        self.timestamp = timestamp
        self.host = host
        self.type = type
        self.value = value
    }
}
