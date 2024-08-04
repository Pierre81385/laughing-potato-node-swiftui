//
//  Task.swift
//  laughing-potato
//
//  Created by m1_air on 8/3/24.
//

import Foundation

struct AnyDecodable: Decodable {
    let value: Any

    init<T>(_ value: T?) {
        self.value = value ?? ()
    }

    init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(), !container.decodeNil() {
            if let boolValue = try? container.decode(Bool.self) {
                value = boolValue
            } else if let intValue = try? container.decode(Int.self) {
                value = intValue
            } else if let doubleValue = try? container.decode(Double.self) {
                value = doubleValue
            } else if let stringValue = try? container.decode(String.self) {
                value = stringValue
            } else if let arrayValue = try? container.decode([AnyDecodable].self) {
                value = arrayValue.map { $0.value }
            } else if let dictionaryValue = try? container.decode([String: AnyDecodable].self) {
                value = dictionaryValue.mapValues { $0.value }
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type")
            }
        } else {
            value = ()
        }
    }
}

extension AnyDecodable: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if let value = value as? [AnyDecodable] {
            try container.encode(value)
        } else if let value = value as? [String: AnyDecodable] {
            try container.encode(value)
        } else {
            try container.encodeNil()
        }
    }
}

struct TeamResponse: Decodable {
    let teams: [Team]
}

struct Team: Identifiable, Decodable {
    let id: String
    let name: String
    let color: String
    let avatar: String?
    let members: [Member]

    private enum CodingKeys: String, CodingKey {
        case id, name, color, avatar, members
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        color = try container.decode(String.self, forKey: .color)
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        members = try container.decode([Member].self, forKey: .members)
    }
}

struct SpacesResponse: Decodable {
    let spaces: [Space]
}

struct Space: Identifiable, Decodable {
    let id: String
    let name: String?
    let isPrivate: Bool?
    let color: String?
    let avatar: String?
    let adminCanManage: Bool?
    let isArchived: Bool?
    let members: [Member]?
    let statuses: [Status]?
    let multipleAssignees: Bool?
    let features: Features?

    private enum CodingKeys: String, CodingKey {
        case id, name, isPrivate = "private", color, avatar, adminCanManage, isArchived = "archived", members, statuses, multipleAssignees, features
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        isPrivate = try container.decodeIfPresent(Bool.self, forKey: .isPrivate)
        color = try container.decodeIfPresent(String.self, forKey: .color)
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        adminCanManage = try container.decodeIfPresent(Bool.self, forKey: .adminCanManage)
        isArchived = try container.decodeIfPresent(Bool.self, forKey: .isArchived)
        members = try container.decodeIfPresent([Member].self, forKey: .members)
        statuses = try container.decodeIfPresent([Status].self, forKey: .statuses)
        multipleAssignees = try container.decodeIfPresent(Bool.self, forKey: .multipleAssignees)
        features = try container.decodeIfPresent(Features.self, forKey: .features)
    }
}

struct FolderResponse: Decodable {
    let folders: [Folder]
}


struct Folder: Identifiable, Decodable {
    var id: String
    var name: String
    var orderIndex: Int?
    var overrideStatuses: Bool?
    var hidden: Bool?
    var space: Space?
    var taskCount: String?
    var archived: Bool?
    var statuses: [Status]?
    var lists: [ClickUpList]?
    var permissionLevel: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case orderIndex = "orderindex"
        case overrideStatuses = "override_statuses"
        case hidden
        case space
        case taskCount = "task_count"
        case archived
        case statuses
        case lists
        case permissionLevel = "permission_level"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        orderIndex = try container.decodeIfPresent(Int.self, forKey: .orderIndex)
        overrideStatuses = try container.decodeIfPresent(Bool.self, forKey: .overrideStatuses)
        hidden = try container.decodeIfPresent(Bool.self, forKey: .hidden)
        space = try container.decodeIfPresent(Space.self, forKey: .space)
        taskCount = try container.decodeIfPresent(String.self, forKey: .taskCount)
        lists = try container.decodeIfPresent([ClickUpList].self, forKey: .lists)
        archived = try container.decodeIfPresent(Bool.self, forKey: .archived)
        statuses = try container.decodeIfPresent([Status].self, forKey: .statuses)
        permissionLevel = try container.decodeIfPresent(String.self, forKey: .permissionLevel)
    }
}

struct ListResponse: Decodable {
    let lists: [ClickUpList]
}

struct ClickUpList: Identifiable, Decodable {
    var id: String
       var name: String
       var orderIndex: Int?
       var status: String?
       var priority: String?
       var assignee: String?
       var taskCount: Int?
       var dueDate: String?
       var startDate: String?
       var folder: Folder?
       var space: Space?
       var archived: Bool?
       var overrideStatuses: Bool?
       var permissionLevel: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case orderIndex = "orderindex"
        case status
        case priority
        case assignee
        case taskCount = "task_count"
        case dueDate = "due_date"
        case startDate = "start_date"
        case folder
        case space
        case archived
        case overrideStatuses = "override_statuses"
        case permissionLevel = "permission_level"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
                name = try container.decode(String.self, forKey: .name)
                orderIndex = try container.decodeIfPresent(Int.self, forKey: .orderIndex)
                status = try container.decodeIfPresent(String.self, forKey: .status)
                priority = try container.decodeIfPresent(String.self, forKey: .priority)
                taskCount = try container.decodeIfPresent(Int.self, forKey: .taskCount)
                dueDate = try container.decodeIfPresent(String.self, forKey: .dueDate)
                startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
                folder = try container.decodeIfPresent(Folder.self, forKey: .folder)
                space = try container.decodeIfPresent(Space.self, forKey: .space)
                archived = try container.decodeIfPresent(Bool.self, forKey: .archived)
                overrideStatuses = try container.decodeIfPresent(Bool.self, forKey: .overrideStatuses)
                permissionLevel = try container.decodeIfPresent(String.self, forKey: .permissionLevel)
            }
    }

struct TaskResponse: Decodable {
    let tasks: [ClickUpTask]
}

struct ClickUpTask: Identifiable, Decodable {
    let id: String
    let customId: String?
    let customItemId: Int?
    let name: String
    let textContent: String?
    let description: String?
    let status: Status?
    let orderIndex: String?
    let dateCreated: String?
    let dateUpdated: String?
    let dateClosed: String?
    let creator: User?
    let assignees: [User]?
    let checklists: [String]?
    let tags: MetadataType?
    let parent: String?
    let priority: String?
    let dueDate: String?
    let startDate: String?
    let timeEstimate: String?
    let timeSpent: Int?
    let customFields: [CustomField]?
    let list: ClickUpList?
    let folder: Folder?
    let space: Space?
    let url: String?
    let markdownDescription: String?

    enum CodingKeys: String, CodingKey {
        case id
        case customId = "custom_id"
        case customItemId = "custom_item_id"
        case name
        case textContent = "text_content"
        case description
        case status
        case orderIndex = "orderindex"
        case dateCreated = "date_created"
        case dateUpdated = "date_updated"
        case dateClosed = "date_closed"
        case creator
        case assignees
        case checklists
        case tags
        case parent
        case priority
        case dueDate = "due_date"
        case startDate = "start_date"
        case timeEstimate = "time_estimate"
        case timeSpent = "time_spent"
        case customFields = "custom_fields"
        case list
        case folder
        case space
        case url
        case markdownDescription = "markdown_description"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        customId = try container.decodeIfPresent(String.self, forKey: .customId)
        customItemId = try container.decodeIfPresent(Int.self, forKey: .customItemId)
        name = try container.decode(String.self, forKey: .name)
        textContent = try container.decodeIfPresent(String.self, forKey: .textContent)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        status = try container.decodeIfPresent(Status.self, forKey: .status)
        orderIndex = try container.decodeIfPresent(String.self, forKey: .orderIndex)
        dateCreated = try container.decodeIfPresent(String.self, forKey: .dateCreated)
        dateUpdated = try container.decodeIfPresent(String.self, forKey: .dateUpdated)
        dateClosed = try container.decodeIfPresent(String.self, forKey: .dateClosed)
        creator = try container.decodeIfPresent(User.self, forKey: .creator)
        assignees = try container.decodeIfPresent([User].self, forKey: .assignees)
        checklists = try container.decodeIfPresent([String].self, forKey: .checklists)
        tags = try container.decodeIfPresent(MetadataType.self, forKey: .tags)
        parent = try container.decodeIfPresent(String.self, forKey: .parent)
        priority = try container.decodeIfPresent(String.self, forKey: .priority)
        dueDate = try container.decodeIfPresent(String.self, forKey: .dueDate)
        startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        timeEstimate = try container.decodeIfPresent(String.self, forKey: .timeEstimate)
        timeSpent = try container.decodeIfPresent(Int.self, forKey: .timeSpent)
        customFields = try container.decodeIfPresent([CustomField].self, forKey: .customFields)
        list = try container.decodeIfPresent(ClickUpList.self, forKey: .list)
        folder = try container.decodeIfPresent(Folder.self, forKey: .folder)
        space = try container.decodeIfPresent(Space.self, forKey: .space)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        markdownDescription = try container.decodeIfPresent(String.self, forKey: .markdownDescription)
    }
}


struct Member: Decodable {
    let user: User?
}

struct User: Decodable {
    let id: Int?
    let username: String?
    let color: String?
    let profilePicture: String?

    private enum CodingKeys: String, CodingKey {
        case id, username, color, profilePicture
    }
}

struct Status: Decodable {
    // Define properties for Status if needed
}

struct Features: Decodable {
    // Define properties for Features if needed
}

struct Priority: Decodable {
    var priority: String
    var color: String
}



struct MetadataType: Codable {
    let value: String?

    private init(_ value: String?) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let decodedValue = try? container.decode(Int.self) {
            self.init(String(decodedValue))
        } else if let decodedValue = try? container.decode(Double.self) {
            self.init(String(decodedValue))
        } else if let decodedValue = try? container.decode(Bool.self) {
            self.init(String(decodedValue))
        } else if let decodedValue = try? container.decode(String.self) {
            self.init(decodedValue)
        } else {
            self.init(nil)
        }
    }
}


struct CustomField: Decodable {
    let id: String
    let name: String
    let type: String?
    let typeConfig: TaskTypeConfig?
    let dateCreated: String?
    let hideFromGuests: Bool?
    let value: Value?
    let required: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case typeConfig
        case dateCreated
        case hideFromGuests
        case value
        case required
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        typeConfig = try container.decodeIfPresent(TaskTypeConfig.self, forKey: .typeConfig)
        dateCreated = try container.decodeIfPresent(String.self, forKey: .dateCreated)
        hideFromGuests = try container.decodeIfPresent(Bool.self, forKey: .hideFromGuests)
        value = try container.decodeIfPresent(Value.self, forKey: .value)
        required = try container.decodeIfPresent(Bool.self, forKey: .required)
        
    }
}

struct TaskTypeConfig: Decodable {
    // Add properties if needed
}

struct TaskReference: Decodable {
    let id: String
}

struct Value: Decodable {
    
}
