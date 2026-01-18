//
//  IosAssignmentRepository.swift
//  PaperLess
//
//  Created by Tom Salih on 13.12.25.
//

import FirebaseFirestore
import Shared

final class IosAssignmentRepository: AssignmentRepository {
    
    
    private let collection = Firestore.firestore().collection("assignments")
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    func observeAll(onChange_ onChange: @escaping ([Assignment]) -> Void) {
        listener?.remove()
        listener = nil
        
        listener = collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Assignment observeAll error: \(error)")
                return
            }
            
            let assignments: [Assignment] =
            snapshot?.documents.compactMap { doc in
                AssignmentFirestoreDto.fromFirestore(doc.data())?.toDomain()
            } ?? []
            
            onChange(assignments)
        }
    }
    
    
    func observeByAsset(
        taggableId: KotlinUuid,
        onChange: @escaping ([Assignment]) -> Void
    ) {
        listener?.remove()
        listener = nil
        listener = collection
            .whereField("tagId", isEqualTo: taggableId.description)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("🔥 Assignment snapshot error: \(error)")
                    return
                }
                
                let assignments: [Assignment] =
                snapshot?.documents.compactMap { doc in
                    AssignmentFirestoreDto.fromFirestore(doc.data())?.toDomain()
                } ?? []
                
                onChange(assignments)
            }
        }
    
    
    func stopObserving() {
        listener?.remove()
        listener = nil
    }
    
    
    func add(assignment: Assignment) async throws -> Assignment {
        let dto = AssignmentFirestoreDto.fromDomain(assignment)
        try await collection.document(dto.id).setData(dto.toFirestore())
        return assignment
    }
    
    func delete(id: KotlinUuid) async throws -> KotlinBoolean {
        try await collection
            .document(String(describing: id))
            .delete()
        return true
    }
    
    func getAll() async throws -> [Assignment] {
        let snapshot = try await collection.getDocuments()
        
        return snapshot.documents.compactMap {
            AssignmentFirestoreDto.fromFirestore($0.data())?.toDomain()
        }
    }
    
    func getById(id: KotlinUuid) async throws -> Assignment? {
        let doc = try await collection
            .document(String(describing: id))
            .getDocument()
        
        guard let data = doc.data(),
              let dto = AssignmentFirestoreDto.fromFirestore(data)
        else { return nil }
        
        return dto.toDomain()
    }
    
    func getByAsset(taggableId: KotlinUuid) async throws -> [Assignment] {
        let snapshot = try await collection
            .whereField("tagId", isEqualTo: String(describing: taggableId))
            .getDocuments()
        
        return snapshot.documents.compactMap {
            AssignmentFirestoreDto.fromFirestore($0.data())?.toDomain()
        }
    }
    
    func getByEmployee(assetUserId: KotlinUuid) async throws -> [Assignment] {
        let snapshot = try await collection
            .whereField("assetUserId", isEqualTo: String(describing: assetUserId))
            .getDocuments()
        
        return snapshot.documents.compactMap {
            AssignmentFirestoreDto.fromFirestore($0.data())?.toDomain()
        }
    }
    
    func update(assignment: Assignment) async throws -> Assignment? {
        let dto = AssignmentFirestoreDto.fromDomain(assignment)
        try await collection.document(dto.id).setData(dto.toFirestore())
        return assignment
    }
}
