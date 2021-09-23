//
//  DataModel.swift
//  Talklo
//
//  Created by Apple on 01/01/2020.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import Foundation

struct UsersDBModel {
    let displayName = "displayName"
    let userName = "UserName"
    let profilePhoto = "UserLink"
    let status = "UserStatus"
    let phoneNumber = "UserPhoneNumber"
    let userId = "user_id"
    let deviceId = "UserDeviceId"
    let fcmId  = "fcmId"
    let source = "source"
    let onLine = "onLine"
    let onLineUpdatedAt = "onLineUpdatedAt"
    let lastSeen = "LastSeen"
    let seeAbout = "SeeAbout"
    let profilePhotoPrivacy = "ProfilePhoto"
}

struct ChatDBModel {
    let createdAt = "createdAt"
    let groupType = "groupType"
    let lastMessage = "lastMessage"
    let lastMessageId = "lastMessageId"
    let lastMessageStatus = "lastMessageStatus"
    let lastMessageTime = "lastMessageTime"
    let lastMessageType = "lastMessageType"
    let lastMessageUserId  = "lastMessageUserId"
    let messageStatus = "messageStatus"
    let otherUserId = "otherUserId"
    let seen = "seen"
    let typing = "typing"
    let userName = "userPhoneNumber"
    let unSeenCount = "unSeenCount"
    let source = "source"
}

struct MessagesDBModel {
    let from = "from"
    let imageThumb = "imageThumb"
    let message = "message"
    let messageImagePath = "messageImagePath"
    let messageStatus = "messageStatus"
    let messageType = "messageType"
    let userName  = "phoneNumber"
    let timeStamp = "timestamp"
    let messageVideoPath = "messageVideoPath"
    let source = "source"
}

struct GroupsDBModel {
    let groupCreatedAt = "groupCreatedAt"
    let groupCreatedBy = "groupCreatedBy"
    let groupDescription = "groupDescription"
    let groupImage = "groupImage"
    let groupName = "groupName"
    let groupType = "groupType"
    let groupUpdated  = "groupUpdated"
    let source = "source"
}

struct ParticipantsDBModel {
    let Role = "Role"
}

struct PrivateChatDBModel {
    let groupId = "groupId"
}
