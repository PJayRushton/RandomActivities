//
//  WordFetcher.swift
//  SwiftUIScratchPad
//
//  Created by Parker Rushton on 6/15/21.
//

import Foundation

class ActivityFetcher {
    
    enum APIError: Error {
        case corruptedResponse
    }
    
    
    let url = URL(string: "https://www.boredapi.com/api/activity")!
    
    func fetchNewActivity() async throws -> Activity {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw APIError.corruptedResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw APIError.corruptedResponse}
        let activity = try JSONDecoder().decode(Activity.self, from: data)
        return activity
    }
    
}
