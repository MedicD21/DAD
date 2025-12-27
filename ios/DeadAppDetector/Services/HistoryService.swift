import Foundation

class HistoryService {
    static let shared = HistoryService()
    
    private let defaults = UserDefaults.standard
    private let historyKey = "analysisHistory"
    private let maxHistoryItems = 50
    
    private init() {}
    
    func saveResult(_ result: AnalysisResult) {
        var history = getHistory()
        history.insert(result, at: 0)
        
        // Keep only last 50 items
        if history.count > maxHistoryItems {
            history = Array(history.prefix(maxHistoryItems))
        }
        
        if let encoded = try? JSONEncoder().encode(history) {
            defaults.set(encoded, forKey: historyKey)
        }
    }
    
    func getHistory() -> [AnalysisResult] {
        guard let data = defaults.data(forKey: historyKey),
              let history = try? JSONDecoder().decode([AnalysisResult].self, from: data) else {
            return []
        }
        return history
    }
    
    func clearHistory() {
        defaults.removeObject(forKey: historyKey)
    }
    
    func deleteResult(id: String) {
        var history = getHistory()
        history.removeAll { $0.id == id }
        
        if let encoded = try? JSONEncoder().encode(history) {
            defaults.set(encoded, forKey: historyKey)
        }
    }
}
