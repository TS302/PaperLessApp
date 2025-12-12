//
//  IosNfcTaggableRepositoryImpl.swift
//  PaperLess
//
//  Created by Tom Salih on 12.12.25.
//

import Foundation
import FirebaseFirestore
import Shared  // wichtig: Zugriff auf DTOs aus Kotlin

class IosNfcTaggableRepositoryImpl: NfcTaggableRepository {
    
}






































//@objc class IosNfcTaggableRepositoryImpl: NSObject {
//
//    private let db = Firestore.firestore()
//    private let collection = Firestore.firestore().collection("nfcItems")
//
//    // Listener-Callback für Kotlin
//    private var listener: ListenerRegistration? = nil
//    private var onUpdate: (([NfcTaggableDto]) -> Void)? = nil
//
//    @objc func startListening(onUpdate: @escaping ([NfcTaggableDto]) -> Void) {
//        self.onUpdate = onUpdate
//
//        listener = collection.addSnapshotListener { snapshot, error in
//            guard let docs = snapshot?.documents else {
//                onUpdate([])
//                return
//            }
//
//            let dtos: [NfcTaggableDto] = docs.compactMap { doc in
//                let data = doc.data()
//
//                return NfcTaggableDto(
//                    id: doc.documentID,
//                    name: data["name"] as? String ?? "",
//                    tagType: data["tagType"] as? String ?? "",
//                    tagStatus: data["tagStatus"] as? String ?? "",
//                    currentAssigneeId: data["currentAssigneeId"] as? String,
//                    lastAssigneeIds: data["lastAssigneeIds"] as? [String] ?? [],
//                    brand: data["brand"] as? String,
//                    serialNumber: data["serialNumber"] as? String,
//                    plate: data["plate"] as? String,
//                    note: data["note"] as? String
//                )
//
//            }
//
//            onUpdate(dtos)
//        }
//    }
//
//    @objc func stopListening() {
//        listener?.remove()
//        listener = nil
//    }
//
//    @objc func add(dto: NfcTaggableDto) {
//        collection.document(dto.id).setData(dto.toDictionary())
//    }
//
//    @objc func update(dto: NfcTaggableDto) {
//        collection.document(dto.id).setData(dto.toDictionary())
//    }
//
//    @objc func delete(id: String) {
//        collection.document(id).delete()
//    }
//}
//
//extension NfcTaggableDto {
//    func toDictionary() -> [String: Any] {
//        return [
//            "id": id,
//            "name": name,
//            "tagType": tagType,
//            "tagStatus": tagStatus,
//            "currentAssigneeId": currentAssigneeId as Any,
//            "lastAssigneeIds": lastAssigneeIds,
//            "brand": brand as Any,
//            "serialNumber": serialNumber as Any,
//            "plate": plate as Any,
//            "note": note as Any
//        ]
//    }
//}
