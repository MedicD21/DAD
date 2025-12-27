import Foundation

class APIService {
    static let shared = APIService()

    // Configuration - change this to your server URL
    // For simulator: http://localhost:3000/api/v1
    // For device: http://YOUR_COMPUTER_IP:3000/api/v1
    private let baseURL: String = {
        #if DEBUG
        return "http://localhost:3000/api/v1"
        #else
        return "https://dad-f3bf.onrender.com/api/v1"
        #endif
    }()

    private let session: URLSession
    private let timeout: TimeInterval = 60.0

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: configuration)
    }

    func analyzeApp(url: String) async throws -> AnalysisResult {
        guard let endpoint = URL(string: "\(baseURL)/analyze") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Dead App Detector iOS/1.0", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = timeout

        let body = ["url": url]
        request.httpBody = try JSONEncoder().encode(body)

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            // Handle different status codes
            switch httpResponse.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                return try decoder.decode(AnalysisResult.self, from: data)
            case 400:
                throw APIError.badRequest(parseErrorMessage(from: data))
            case 429:
                throw APIError.rateLimitExceeded
            case 500...599:
                throw APIError.serverError(httpResponse.statusCode)
            default:
                throw APIError.serverError(httpResponse.statusCode)
            }
        } catch let error as APIError {
            throw error
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw APIError.decodingFailed
        } catch let error as URLError {
            throw APIError.networkError(error.localizedDescription)
        } catch {
            throw APIError.unknown(error.localizedDescription)
        }
    }

    func checkHealth() async throws -> Bool {
        guard let endpoint = URL(string: baseURL.replacingOccurrences(of: "/api/v1", with: "/health")) else {
            throw APIError.invalidURL
        }

        let request = URLRequest(url: endpoint)
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return false
        }

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let status = json["status"] as? String {
            return status == "healthy"
        }

        return false
    }

    private func parseErrorMessage(from data: Data) -> String {
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let message = json["message"] as? String {
            return message
        }
        return "Bad request"
    }

    enum APIError: LocalizedError {
        case invalidURL
        case invalidResponse
        case badRequest(String)
        case rateLimitExceeded
        case serverError(Int)
        case networkError(String)
        case decodingFailed
        case unknown(String)

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL provided"
            case .invalidResponse:
                return "Invalid response from server"
            case .badRequest(let message):
                return "Bad request: \(message)"
            case .rateLimitExceeded:
                return "Rate limit exceeded. Please try again later."
            case .serverError(let code):
                return "Server error (\(code)). Please try again later."
            case .networkError(let message):
                return "Network error: \(message)"
            case .decodingFailed:
                return "Failed to decode server response"
            case .unknown(let message):
                return "An error occurred: \(message)"
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .invalidURL:
                return "Please check the URL and try again"
            case .networkError:
                return "Check your internet connection and try again"
            case .rateLimitExceeded:
                return "Wait a few minutes before trying again"
            case .serverError:
                return "The server is experiencing issues. Try again later."
            default:
                return nil
            }
        }
    }
}
