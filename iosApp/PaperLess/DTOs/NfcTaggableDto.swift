//
//  NfcTaggableDto.swift
//  PaperLess
//
//  Created by Tom Salih on 14.12.25.
//

import Shared

extension NfcTaggableDto {

    func toFirestore() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "tagType": tagType,
            "tagStatus": tagStatus,
            "currentAssigneeId": currentAssigneeId as Any,
            "lastAssigneeIds": lastAssigneeIds,
            "brand": brand as Any,
            "serialNumber": serialNumber as Any,
            "plate": plate as Any,
            "note": note as Any
        ]
    }

    static func fromFirestore(_ data: [String: Any]) -> NfcTaggableDto? {
        guard
            let id = data["id"] as? String,
            let name = data["name"] as? String,
            let tagType = data["tagType"] as? String,
            let tagStatus = data["tagStatus"] as? String
        else {
            return nil
        }

        return NfcTaggableDto(
            id: id,
            name: name,
            tagType: tagType,
            tagStatus: tagStatus,
            currentAssigneeId: data["currentAssigneeId"] as? String,
            lastAssigneeIds: data["lastAssigneeIds"] as? [String] ?? [],
            brand: data["brand"] as? String,
            serialNumber: data["serialNumber"] as? String,
            plate: data["plate"] as? String,
            note: data["note"] as? String
        )
    }
}
