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
        print("[IosAssignmentRepository] \(message)")
    }

    // MARK: - Observing

    func observeAll(onChange_ onChange: @escaping ([Assignment]) -> Void) {
        stopAndClearListener()

        listener = collection.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                self?.log("observeAll error: \(error)")
                return
            }

            guard let snapshot = snapshot else {
                self?.log("observeAll received nil snapshot")
                onChange([])
                return
            }

            let assignments: [Assignment] = snapshot.documents.compactMap { doc in
                AssignmentDto.fromFirestore(docId: doc.documentID, doc.data())?.toDomain()
            }
            onChange(assignments)
        }
    }

    func observeByAsset(
        taggableId: KotlinUuid,
        onChange: @escaping ([Assignment]) -> Void
    ) {
        stopAndClearListener()

        listener = collection
            .whereField("tagId", isEqualTo: uuidString(taggableId))
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    self?.log("observeByAsset error: \(error)")
                    return
                }

                guard let snapshot = snapshot else {
                    self?.log("observeByAsset received nil snapshot")
                    onChange([])
                    return
                }

                let assignments: [Assignment] = snapshot.documents.compactMap { doc in
                    AssignmentDto.fromFirestore(docId: doc.documentID, doc.data())?.toDomain()
                }
                onChange(assignments)
            }
    }

    func stopObserving() {
        stopAndClearListener()
    }

    // MARK: - CRUD

    func add(assignment: Assignment) async throws -> Assignment {
        let dto = AssignmentDto.fromDomain(assignment)
        try await collection.document(dto.id).setData(dto.toFirestore())
        return assignment
    }

    func delete(id: KotlinUuid) async throws -> KotlinBoolean {
        try await collection
            .document(uuidString(id))
            .delete()
        return true
    }

    func getAll() async throws -> [Assignment] {
        let snapshot = try await collection.getDocuments()

        return snapshot.documents.compactMap {
            AssignmentDto.fromFirestore(docId: $0.documentID, $0.data())?.toDomain()
        }
    }

    func getById(id: KotlinUuid) async throws -> Assignment? {
        let doc = try await collection
            .document(uuidString(id))
            .getDocument()

        guard let data = doc.data(),
              let dto = AssignmentDto.fromFirestore(docId: doc.documentID, data)
        else { return nil }

        return dto.toDomain()
    }

    func getByAsset(taggableId: KotlinUuid) async throws -> [Assignment] {
        let snapshot = try await collection
            .whereField("tagId", isEqualTo: uuidString(taggableId))
            .getDocuments()

        return snapshot.documents.compactMap {
            AssignmentDto.fromFirestore(docId: $0.documentID, $0.data())?.toDomain()
        }
    }

    func getByEmployee(assetUserId: KotlinUuid) async throws -> [Assignment] {
        let snapshot = try await collection
            .whereField("assetUserId", isEqualTo: uuidString(assetUserId))
            .getDocuments()

        return snapshot.documents.compactMap {
            AssignmentDto.fromFirestore(docId: $0.documentID, $0.data())?.toDomain()
        }
    }

    func update(assignment: Assignment) async throws -> Assignment? {
        let dto = AssignmentDto.fromDomain(assignment)
        try await collection.document(dto.id).setData(dto.toFirestore(), merge: true)
        return assignment
    }
}
