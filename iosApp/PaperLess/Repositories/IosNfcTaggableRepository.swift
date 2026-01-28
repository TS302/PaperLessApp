//
//  IosNfcTaggableRepositoryImpl.swift
//  PaperLess
//
//  Created by Tom Salih on 12.12.25.
//

import FirebaseFirestore
import Shared

final class IosNfcTaggableRepository: NfcTaggableRepository {
    private let collection = Firestore.firestore().collection("nfcItems")
    private let firestore = Firestore.firestore()
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
        print("[IosNfcTaggableRepository] \(message)")
    }

    // MARK: - Observing

    func observeAll(onChange__ onChange: @escaping ([NfcTaggable]) -> Void) {
        stopAndClearListener()

        listener = collection.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                self?.log("observeAll error: \(error)")
                return
            }

            guard let self = self else { return }
            guard let snapshot = snapshot else {
                self.log("observeAll received nil snapshot")
                onChange([])
                return
            }

            let items: [NfcTaggable] = snapshot.documents.compactMap { doc in
                guard let dto = NfcTaggableDto.fromFirestore(doc.data()) else { return nil }
                return NfcTaggablePolymorphicMapperKt.nfcTaggableDtoToDomain(dto: dto)
            }

            onChange(items)
        }
    }

    func stopObserving() {
        stopAndClearListener()
    }

    // MARK: - CRUD

    func add(itemToAdd: NfcTaggable) async throws -> NfcTaggable {
        // Objekt wird zuerst in ein Format umgewandelt, das Firestore speichern kann
        let dto = NfcTaggablePolymorphicMapperKt
            .nfcTaggableToDto(item: itemToAdd)

        // Das Objekt wird mit seiner ID als Dokument gespeichert
        try await collection
            .document(dto.id)
            .setData(dto.toFirestore())

        return itemToAdd
    }

    func getAll() async throws -> [NfcTaggable] {
        let snapshot = try await collection.getDocuments()

        // Jedes Dokument wird wieder in ein Domain-Objekt umgewandelt
        return snapshot.documents.compactMap {
            guard let dto = NfcTaggableDto.fromFirestore($0.data()) else {
                // Falls etwas nicht passt, wird der Eintrag übersprungen
                return nil
            }
            return NfcTaggablePolymorphicMapperKt
                .nfcTaggableDtoToDomain(dto: dto)
        }
    }

    func getById(id: KotlinUuid) async throws -> NfcTaggable? {
        let doc = try await collection
            .document(uuidString(id))
            .getDocument()

        // Prüfen, ob Daten vorhanden sind und gelesen werden können
        guard let data = doc.data(),
              let dto = NfcTaggableDto.fromFirestore(data)
        else {
            return nil
        }

        return NfcTaggablePolymorphicMapperKt
            .nfcTaggableDtoToDomain(dto: dto)
    }

    func update(itemToUpdate: NfcTaggable) async throws -> NfcTaggable? {
        // Objekt erneut umwandeln, damit es gespeichert werden kann
        let dto = NfcTaggablePolymorphicMapperKt
            .nfcTaggableToDto(item: itemToUpdate)

        // Mit setData wird das alte Dokument überschrieben
        try await collection
            .document(dto.id)
            .setData(dto.toFirestore())

        return itemToUpdate
    }

    func delete(id: KotlinUuid) async throws -> KotlinBoolean {
        try await collection
            .document(uuidString(id))
            .delete()

        return true
    }
}
