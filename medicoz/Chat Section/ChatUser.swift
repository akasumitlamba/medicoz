//
//  ChatUser.swift
//  medicoz
//
//  Created by Sachin Sharma on 23/04/23.
//

import FirebaseFirestoreSwift

struct ChatUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, name, profileImage: String
}


