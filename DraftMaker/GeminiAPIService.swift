//
//  GeminiAPIService.swift
//  DraftMaker
//

import Foundation

class GeminiAPIService {
    static let shared = GeminiAPIService()

    // API Key - Configuration.swiftで設定
    private var apiKey: String {
        let key = Configuration.geminiAPIKey
        return key != "YOUR_GEMINI_API_KEY_HERE" ? key : ""
    }

    private init() {}

    func generateMessage(purpose: String, relation: String) async throws -> String {
        guard !apiKey.isEmpty else {
            throw APIError.missingAPIKey
        }

        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let prompt = """
        あなたは日本語のメッセージ作成アシスタントです。
        以下の条件に合わせて、適切なメッセージの下書きを作成してください。

        【送り先】\(relation)
        【伝えたい内容】\(purpose)

        注意点：
        - 送り先に応じた適切な敬語レベルを使用してください
        - 「バイトの店長」「取引先」には丁寧な敬語を使用
        - 「ゼミの先輩」には適度な敬語を使用
        - 「仲の良い友達」にはカジュアルな言葉遣いで、絵文字も適度に使用
        - 自然で実用的なメッセージにしてください
        - 「〇〇」などのプレースホルダーは適宜残してください（名前、日時など）

        メッセージ本文のみを出力してください（説明は不要です）。
        """

        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let error = errorJson["error"] as? [String: Any],
               let message = error["message"] as? String {
                throw APIError.apiError(message)
            }
            throw APIError.httpError(httpResponse.statusCode)
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let firstCandidate = candidates.first,
              let content = firstCandidate["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let firstPart = parts.first,
              let text = firstPart["text"] as? String else {
            throw APIError.parseError
        }

        return text
    }

    enum APIError: LocalizedError {
        case missingAPIKey
        case invalidURL
        case invalidResponse
        case httpError(Int)
        case apiError(String)
        case parseError

        var errorDescription: String? {
            switch self {
            case .missingAPIKey:
                return "API Keyが設定されていません"
            case .invalidURL:
                return "無効なURLです"
            case .invalidResponse:
                return "無効なレスポンスです"
            case .httpError(let code):
                return "HTTPエラー: \(code)"
            case .apiError(let message):
                return "APIエラー: \(message)"
            case .parseError:
                return "レスポンスの解析に失敗しました"
            }
        }
    }
}
