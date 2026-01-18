//
//  AssetUserDto.swift
//  PaperLess
//
//  Created by Tom Salih on 14.12.25.
//

import Shared

extension AssetUserDto {

    func toFirestore() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "email": email,
            "phoneNumber": phoneNumber,
            "tagType": tagType,
            "tagStatus": tagStatus,
            "currentAssigneeId": currentAssigneeId as Any,
            "lastAssigneeIds": lastAssigneeIds,
            "note": note as Any
        ]
    }

    static func fromFirestore(_ data: [String: Any]) -> AssetUserDto? {
        guard
            let id = data["id"] as? String,
            let name = data["name"] as? String,
            let email = data["email"] as? String,
            let phoneNumber = data["phoneNumber"] as? String,
            let tagType = data["tagType"] as? String,
            let tagStatus = data["tagStatus"] as? String
        else {
            return nil
        }

        return AssetUserDto(
            id: id,
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            tagType: tagType,
            tagStatus: tagStatus,
            currentAssigneeId: data["currentAssigneeId"] as? String,
            lastAssigneeIds: data["lastAssigneeIds"] as? [String] ?? [],
            note: data["note"] as? String
        )
    }
}
