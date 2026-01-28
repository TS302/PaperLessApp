//
//  IosAssetUserRepository.swift
//  PaperLess
//
//  Created by Tom Salih on 13.12.25.
//

import FirebaseFirestore
import Shared

final class IosAssetUserRepository: AssetUserRepository {
    private let collection = Firestore.firestore().collection("assetUsers")
    private var listener: ListenerRegistration?

    deinit {
        stopObserving()
    }

    // MARK: - Helpers

    private func stopAndClearListener() {
        listener?.remove()
        listener = nil
    }

    private func uuidString(_ id: KotlinUuid) -> String {
        String(describing: id)
    }

    private func log(_ message: String) {
        print("[IosAssetUserRepository] \(message)")
    }

    private func patchedData(doc: QueryDocumentSnapshot) -> [String: Any] {
        var data = doc.data()
        if data["id"] == nil {
            data["id"] = doc.documentID
        }
        return data
    }

    // MARK: - Observing

    func observeAll(onChange: @escaping ([AssetUser]) -> Void) {
        stopAndClearListener()

        listener = collection.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                self?.log("observeAll error: \(error)")
                onChange([])
                return
            }

            guard let self = self else { return }
            guard let snapshot = snapshot else {
                self.log("observeAll received nil snapshot")
                onChange([])
                return
            }

            let users: [AssetUser] = snapshot.documents.compactMap { doc in
                let data = self.patchedData(doc: doc)
                guard let dto = AssetUserDto.fromFirestore(data) else {
                    self.log("❌ AssetUserDto.fromFirestore failed docId=\(doc.documentID), data=\(data)")
                    return nil
                }
                return dto.toDomain()
            }

            onChange(users)
        }
    }

    func stopObserving() {
        stopAndClearListener()
    }

    // MARK: - CRUD

    func add(assetUser: AssetUser) async throws -> AssetUser {
        let dto = assetUser.toDto()

        var data = dto.toFirestore()
        data["id"] = dto.id

        try await collection.document(dto.id).setData(data)
        return assetUser
    }

    func delete(id: String) async throws -> KotlinBoolean {
        try await collection
            .document(id)
            .delete()
        return true
    }

    func delete(id: KotlinUuid) async throws -> KotlinBoolean {
        try await collection
            .document(uuidString(id))
            .delete()
        return true
    }

    func getAll() async throws -> [AssetUser] {
        let snapshot = try await collection.getDocuments()

        return snapshot.documents.compactMap {
            AssetUserDto.fromFirestore($0.data())?.toDomain()
        }
    }

    func getById(id: String) async throws -> AssetUser? {
        let doc = try await collection
            .document(id)
            .getDocument()

        guard let data = doc.data(),
              let dto = AssetUserDto.fromFirestore(data)
        else { return nil }

        return dto.toDomain()
    }

    func getById(id: KotlinUuid) async throws -> AssetUser? {
        let doc = try await collection
            .document(uuidString(id))
            .getDocument()

        guard let data = doc.data(),
              let dto = AssetUserDto.fromFirestore(data)
        else { return nil }

        return dto.toDomain()
    }

    func update(assetUser: AssetUser) async throws -> AssetUser {
        let dto = assetUser.toDto()

        var data = dto.toFirestore()
        data["id"] = dto.id

        try await collection.document(dto.id).setData(data)
        return assetUser
    }
}
