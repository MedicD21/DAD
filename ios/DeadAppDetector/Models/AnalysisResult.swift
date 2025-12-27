import Foundation

struct AnalysisResult: Codable, Identifiable {
    let id: String
    let scanId: String
    let timestamp: String
    let url: String
    let overallScore: Int
    let status: Status
    let categories: Categories
    let summary: String
    let cached: Bool
    
    enum Status: String, Codable {
        case healthy
        case caution
        case risk
        
        var color: String {
            switch self {
            case .healthy: return "green"
            case .caution: return "yellow"
            case .risk: return "red"
            }
        }
        
        var displayName: String {
            switch self {
            case .healthy: return "Actively Maintained"
            case .caution: return "Caution"
            case .risk: return "High Risk"
            }
        }
    }
    
    struct Categories: Codable {
        let website: Category
        let engineering: Category
        let business: Category
    }
    
    struct Category: Codable {
        let score: Int
        let signals: [Signal]
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.scanId = try container.decode(String.self, forKey: .scanId)
        self.timestamp = try container.decode(String.self, forKey: .timestamp)
        self.url = try container.decode(String.self, forKey: .url)
        self.overallScore = try container.decode(Int.self, forKey: .overallScore)
        self.status = try container.decode(Status.self, forKey: .status)
        self.categories = try container.decode(Categories.self, forKey: .categories)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.cached = try container.decode(Bool.self, forKey: .cached)
        self.id = scanId
    }
    
    enum CodingKeys: String, CodingKey {
        case scanId, timestamp, url, overallScore, status, categories, summary, cached
    }
}
