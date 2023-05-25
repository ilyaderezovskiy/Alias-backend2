//
//  File.swift
//  
//
//  Created by Ilya Derezovskiy on 28.03.2023.
//

import Fluent
import Vapor

final class User: Model {
    static let schema = "users"
    
    @ID(key: "id")
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "teamID")
    var teamID: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    final class Public: Content {
        var id: UUID?
        var username: String
        var teamID: String
        
        init(id: UUID? = nil, username: String, teamID: String) {
            self.id = id
            self.username = username
            self.teamID = teamID
        }
    }
}

extension User {
    func asPublic() -> User.Public {
        User.Public(id: id, username: username, teamID: teamID)
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
