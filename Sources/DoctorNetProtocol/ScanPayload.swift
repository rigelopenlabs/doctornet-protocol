import Foundation

public struct ScannedDevicePayload: Codable, Equatable, Sendable {
    public var ip: String
    public var mac: String
    public var vendor: String
    public var deviceType: String?
    public var osGuess: String?
    public var hostname: String?
    public var openPorts: [Int]?
    public var mdnsServices: [String]?

    enum CodingKeys: String, CodingKey {
        case ip, mac, vendor, hostname
        case deviceType = "device_type"
        case osGuess = "os_guess"
        case openPorts = "open_ports"
        case mdnsServices = "mdns_services"
    }

    public init(ip: String, mac: String, vendor: String = "Unknown", deviceType: String? = nil, osGuess: String? = nil, hostname: String? = nil, openPorts: [Int]? = nil, mdnsServices: [String]? = nil) {
        self.ip = ip
        self.mac = mac
        self.vendor = vendor
        self.deviceType = deviceType
        self.osGuess = osGuess
        self.hostname = hostname
        self.openPorts = openPorts
        self.mdnsServices = mdnsServices
    }
}

public struct ScanChangesPayload: Codable, Equatable, Sendable {
    public var new: [ScannedDevicePayload]
    public var gone: [ScannedDevicePayload]
    public var returned: [ScannedDevicePayload]

    public init(new: [ScannedDevicePayload] = [], gone: [ScannedDevicePayload] = [], returned: [ScannedDevicePayload] = []) {
        self.new = new
        self.gone = gone
        self.returned = returned
    }
}

public struct ScanPayload: Codable, Equatable, Sendable {
    public var version: String
    public var deviceID: UUID
    public var deviceName: String
    public var siteName: String
    public var scannedAt: Date
    public var subnet: String
    public var devicesFound: Int
    public var devices: [ScannedDevicePayload]
    public var changes: ScanChangesPayload
    public var vendorSummary: [String: Int]
    public var typeSummary: [String: Int]
    public var diagramSVG: String?

    enum CodingKeys: String, CodingKey {
        case version
        case deviceID = "device_id"
        case deviceName = "device_name"
        case siteName = "site_name"
        case scannedAt = "scanned_at"
        case subnet
        case devicesFound = "devices_found"
        case devices, changes
        case vendorSummary = "vendor_summary"
        case typeSummary = "type_summary"
        case diagramSVG = "diagram_svg"
    }

    public init(
        version: String = ProtocolVersion.current,
        deviceID: UUID,
        deviceName: String,
        siteName: String = "Unknown",
        scannedAt: Date,
        subnet: String,
        devicesFound: Int,
        devices: [ScannedDevicePayload] = [],
        changes: ScanChangesPayload = ScanChangesPayload(),
        vendorSummary: [String: Int] = [:],
        typeSummary: [String: Int] = [:],
        diagramSVG: String? = nil
    ) {
        self.version = version
        self.deviceID = deviceID
        self.deviceName = deviceName
        self.siteName = siteName
        self.scannedAt = scannedAt
        self.subnet = subnet
        self.devicesFound = devicesFound
        self.devices = devices
        self.changes = changes
        self.vendorSummary = vendorSummary
        self.typeSummary = typeSummary
        self.diagramSVG = diagramSVG
    }
}
