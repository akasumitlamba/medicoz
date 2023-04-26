//
//  RecentMessage.swift
//  medicoz
//
//  Created by Sachin Sharma on 23/04/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let message, email: String
    let fromId, toId: String
    let name, profileImage: String
    let timestamp: Date
    
    var username: String {
        email.components(separatedBy: "@").first ?? email
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
