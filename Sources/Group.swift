
import Foundation

enum GroupError: Error {
    case failedToCreate
}

class Group {
    
    var id: String
    var name: String
    var userList = [ChatUser]()
    
    init(json: [String: Any]) throws {
        guard let name = json["name"] as? String else { throw GroupError.failedToCreate }
        
        self.id = UUID().uuidString
        self.name = name
    }
    
    func addUser(_ user: ChatUser){
        userList.append(user)
    }
}
