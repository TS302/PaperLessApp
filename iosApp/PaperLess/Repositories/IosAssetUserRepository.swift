//
//  IosAssetUserRepository.swift
//  PaperLess
//
//  Created by Tom Salih on 13.12.25.
//

import FirebaseFirestore
import Shared

final class IosAssetUserRepository: AssetUserRepository {
    
    private let collection =
    Firestore.firestore().collection("assetUsers")
    private var listener: ListenerRegistration?
    
    func observeAll(onChange: @escaping ([AssetUser]) -> Void) {
        listener?.remove()
        listener = nil
        listener = collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("AssetUser snapshot error: \(error)")
                return
            }
            
            let documents = snapshot?.documents ?? []
            
            let users: [AssetUser] = documents.compactMap { doc in
                guard let dto = AssetUserDto.fromFirestore(doc.data()) else {
                    return nil
                }
                return dto.toDomain()
            }
            onChange(users)
        }
    }
    
    func stopObserving() {
        listener?.remove()
        listener = nil
    }
    
    func add(assetUser: AssetUser) async throws -> AssetUser {
        let dto = assetUser.toDto()
        try await collection
            .document(dto.id)
            .setData(dto.toFirestore())
        
        return assetUser
    }
    
    func delete(id: KotlinUuid) async throws -> KotlinBoolean {
        try await collection
            .document(String(describing: id))
            .delete()
        return true
    }
    
    func getAll() async throws -> [AssetUser] {
        let snapshot = try await collection.getDocuments()
        
        return snapshot.documents.compactMap {
            AssetUserDto.fromFirestore($0.data())?.toDomain()
        }
    }
    
    func getById(id: KotlinUuid) async throws -> AssetUser? {
        let doc = try await collection
            .document(String(describing: id))
            .getDocument()
        
        guard let data = doc.data(),
              let dto = AssetUserDto.fromFirestore(data)
        else { return nil }
        
        return dto.toDomain()
    }
    
    func update(assetUser: AssetUser) async throws -> AssetUser {
        let dto = assetUser.toDto()
        try await collection
            .document(dto.id)
            .setData(dto.toFirestore())
        
        return assetUser
    }
}
