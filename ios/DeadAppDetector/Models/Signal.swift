import Foundation

struct Signal: Codable, Identifiable {
    let id = UUID()
    let name: String
    let status: Status
    let value: String
    let impact: Impact
    let explanation: String
    
    enum Status: String, Codable {
        case healthy
        case warning
        case risk
        case unknown
        
        var color: String {
            switch self {
            case .healthy: return "green"
            case .warning: return "yellow"
            case .risk: return "red"
            case .unknown: return "gray"
            }
        }
    }
    
    enum Impact: String, Codable {
        case positive
        case negative
        case neutral
    }
    
    enum CodingKeys: String, CodingKey {
        case name, status, value, impact, explanation
    }
}
