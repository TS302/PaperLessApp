package com.tom.paperless.di

import com.google.firebase.firestore.FirebaseFirestore
import com.tom.paperless.data.FirebaseAssetUserRepository
import com.tom.paperless.data.FirebaseAssignmentRepository
import com.tom.paperless.data.FirebaseNfcTaggableRepository
import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.NfcTaggableRepository
import org.koin.dsl.module

val androidDataModule = module {

    single { FirebaseFirestore.getInstance() }

    single<NfcTaggableRepository> {
        FirebaseNfcTaggableRepository(get())
    }

    single<AssetUserRepository> {
        FirebaseAssetUserRepository(get())
    }

    single<AssignmentRepository> {
        FirebaseAssignmentRepository(get())
    }
}
