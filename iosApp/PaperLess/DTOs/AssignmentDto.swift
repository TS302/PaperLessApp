//
//  AssignmentDto.swift
//  PaperLess
//
//  Created by Tom Salih on 14.12.25.
//


import Foundation
import FirebaseFirestore
import Shared

struct AssignmentDto {
    let id: String
    let assetUserId: String
    let tagId: String
    let from: Date
    let until: Date?
    let fromNote: String?
    let untilNote: String?

    static func fromFirestore(docId: String, _ data: [String: Any]) -> AssignmentDto? {
        guard
            let assetUserId = data["assetUserId"] as? String,
            let tagId = data["tagId"] as? String,
            let fromTs = data["from"] as? Timestamp
        else { return nil }

        let id = (data["id"] as? String) ?? docId
        let untilTs = data["until"] as? Timestamp

        return AssignmentDto(
            id: id,
            assetUserId: assetUserId,
            tagId: tagId,
            from: fromTs.dateValue(),
            until: untilTs?.dateValue(),
            fromNote: data["fromNote"] as? String,
            untilNote: data["untilNote"] as? String
        )
    }

    func toFirestore() -> [String: Any] {
        var map: [String: Any] = [
            "id": id,
            "assetUserId": assetUserId,
            "tagId": tagId,
            "from": Timestamp(date: from)
        ]
        if let until { map["until"] = Timestamp(date: until) }
        if let fromNote { map["fromNote"] = fromNote }
        if let untilNote { map["untilNote"] = untilNote }
        return map
    }
}

extension AssignmentDto {

    static func fromDomain(_ a: Assignment) -> AssignmentDto {
        let fromDate = Date(timeIntervalSince1970: TimeInterval(a.from.toEpochMilliseconds()) / 1000)
        let untilDate: Date? = a.until == nil
            ? nil
            : Date(timeIntervalSince1970: TimeInterval(a.until!.toEpochMilliseconds()) / 1000)

        return AssignmentDto(
            id: a.id.description,
            assetUserId: a.assetUserId.description,
            tagId: a.tagId.description,
            from: fromDate,
            until: untilDate,
            fromNote: a.fromNote,
            untilNote: a.untilNote
        )
    }

    func toDomain() -> Assignment {
        let idUuid = UuidBridgeKt.uuidFromString(value: id)
        let assetUserUuid = UuidBridgeKt.uuidFromString(value: assetUserId)
        let tagUuid = UuidBridgeKt.uuidFromString(value: tagId)

        return Assignment(
            id: idUuid,
            assetUserId: assetUserUuid,
            tagId: tagUuid,
            from: Kotlinx_datetimeInstant.Companion()
                .fromEpochMilliseconds(epochMilliseconds: Int64(from.timeIntervalSince1970 * 1000)),
            until: until == nil
                ? nil
                : Kotlinx_datetimeInstant.Companion()
                    .fromEpochMilliseconds(epochMilliseconds: Int64(until!.timeIntervalSince1970 * 1000)),
            fromNote: fromNote,
            untilNote: untilNote
        )
    }
}


