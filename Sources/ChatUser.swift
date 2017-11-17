//
//  ChatUser.swift
//  Perfect-Chat-Demo
//
//  Created by Ryan Collins on 1/27/17.
//
//

import Foundation
import PerfectWebSockets

enum UserError: Error {
    case failedToCreate
}

class ChatUser: Hashable {
    
    var id: String
    var email: String
    var name: String
    var socket: WebSocket?
    var groupList = [Group]()
    
    
    init(json: [String: Any], _ socket: WebSocket) throws {
        
        guard let email = json["email"] as? String, let name = json["name"] as? String else { throw UserError.failedToCreate }
        
        self.id = UUID().uuidString
        self.email = email
        self.name = name
        self.socket = socket
    }
    
    //Plain == make a bot!
    init() {
        self.id = UUID().uuidString
        self.email = "nil"
        self.name = "Bot"
    }
    
    func addGroup(_ group: Group) {
        groupList.append(group)
    }
    
    var hashValue: Int {
        return email.hashValue
    }
    
    static func == (lhs: ChatUser, rhs: ChatUser) -> Bool {
        return lhs.email == rhs.email
    }
    
}
