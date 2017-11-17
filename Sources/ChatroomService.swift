//
//  ChatroomService.swift
//  Perfect-Chat-Demo
//
//  Created by Ryan Collins on 1/27/17.
//
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectWebSockets

class Chatroom {
    
    //This line makes this a singleton, where you only use one shared instance of this class across the whole project. Singletons are VERY useful as a dataservice where data moves in and out, but needs to be shown in many places. 
    static let instance = Chatroom()
    
    private var chatGroupsList = [Group]()
    private var chatUsersList = [ChatUser]()
    let bot = ChatUser()
    
    func addUser(user: ChatUser) {
        chatUsersList.append(user)
//        sendMessage("\(user.name) Joined", fromUser: bot)
    }
    
//    func leave(user: ChatUser) {
//        _chats.removeValue(forKey: user)
//        sendMessage("\(user.name) Left", fromUser: bot)
//    }
    
    func addGroup(group: Group) {
        chatGroupsList.append(group)
    }
    
    func joinGroup(userId: String, groupId: String) {
//        var userCheck = false, groupCheck = false
        var user: ChatUser? , group: Group?
        if user == nil {
            print("success")
        }
        for userIterator in chatUsersList {
            if userIterator.id == userId {
                user = userIterator
                break
            }
        }
        for groupIterator in chatGroupsList {
            if groupIterator.id == groupId {
                group = groupIterator
                break
            }
        }
        guard user != nil, group != nil else {
            print("Error in joining group")
            return
        }
        print("user " + (user?.id)! + " group " + (group?.id)!)
        group?.addUser(user!)
        user?.addGroup(group!)
    }
    
    func sendMessage(message: String, fromUser userId: String, toGroup groupId: String) {

        let jsonString = ["type": "chat", "message": "\(message)"]
        var group: Group?
        
        do {
            let json = try jsonString.jsonEncodedString()
            for groupIterator in chatGroupsList {
                if groupIterator.id == groupId {
                    group = groupIterator
                    break
                }
            }
            guard group != nil else {
                print("Error in joining group")
                return
            }
            for user in (group?.userList)! {
                print("userID: \(userId) ,user in the loop: \(user.id)")
                if user.id != userId {
                    user.socket?.sendStringMessage(string: json, final: true) {
                        print("message: \(json) was sent to user: \(user.name)")
                    }
                }
            }
        } catch {
            print("Failed to send message")
        }

    }
}
