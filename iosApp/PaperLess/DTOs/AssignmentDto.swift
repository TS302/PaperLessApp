//
//  AssignmentDto.swift
//  PaperLess
//
//  Created by Tom Salih on 14.12.25.
//

//import Shared
//
//extension AssignmentDto {
//
//    func toFirestore() -> [String: Any] {
//        [
//            "id": id,
//            "assetUserId": assetUserId,
//            "tagId": tagId,
//            "from": from,
//            "until": until as Any,
//            "note": note as Any
//        ]
//    }
//
//    static func fromFirestore(_ data: [String: Any]) -> AssignmentDto? {
//        guard
//            let id = data["id"] as? String,
//            let assetUserId = data["assetUserId"] as? String,
//            let tagId = data["tagId"] as? String,
//            let from = data["from"] as? String
//        else {
//            return nil
//        }
//
//        return AssignmentDto(
//            id: id,
//            assetUserId: assetUserId,
//            tagId: tagId,
//            from: from,
//            until: data["until"] as? String,
//            note: data["note"] as? String
//        )
//    }
//}

//import Foundation
//import FirebaseFirestore
//import Shared
//
//struct AssignmentFirestoreDto {
//
//    let id: String
//    let assetUserId: String
//    let tagId: String
//    let from: Date
//    let until: Date?
//    let note: String?
//
//    // Firestore -> DTO
//    static func fromFirestore(_ data: [String: Any]) -> AssignmentFirestoreDto? {
//        guard
//            let id = data["id"] as? String,
//            let assetUserId = data["assetUserId"] as? String,
//            let tagId = data["tagId"] as? String,
//            let fromTimestamp = data["from"] as? Timestamp
//        else {
//            return nil
//        }
//
//        let untilTimestamp = data["until"] as? Timestamp
//
//        return AssignmentFirestoreDto(
//            id: id,
//            assetUserId: assetUserId,
//            tagId: tagId,
//            from: fromTimestamp.dateValue(),
//            until: untilTimestamp?.dateValue(),
//            note: data["note"] as? String
//        )
//    }
//
//    // DTO -> Firestore
//    func toFirestore() -> [String: Any] {
//        var map: [String: Any] = [
//            "id": id,
//            "assetUserId": assetUserId,
//            "tagId": tagId,
//            "from": Timestamp(date: from)
//        ]
//
//        if let until {
//            map["until"] = Timestamp(date: until)
//        }
//
//        if let note {
//            map["note"] = note
//        }
//
//        return map
//    }
//}
//
//extension AssignmentFirestoreDto {
//
//    func toDomain() -> Assignment {
//        let idUuid = UuidBridgeKt.uuidFromString(value: id)
//        let assetUserUuid = UuidBridgeKt.uuidFromString(value: assetUserId)
//        let tagUuid = UuidBridgeKt.uuidFromString(value: tagId)
//
//        return Assignment(
//            id: idUuid,
//            assetUserId: assetUserUuid,
//            tagId: tagUuid,
//            from: Kotlinx_datetimeInstant.Companion()
//                .fromEpochMilliseconds(
//                    epochMilliseconds: Int64(from.timeIntervalSince1970 * 1000)
//                ),
//            until: until != nil
//                ? Kotlinx_datetimeInstant.Companion()
//                    .fromEpochMilliseconds(
//                        epochMilliseconds: Int64(until!.timeIntervalSince1970 * 1000)
//                    )
//                : nil,
//            note: note
//        )
//    }
//}

