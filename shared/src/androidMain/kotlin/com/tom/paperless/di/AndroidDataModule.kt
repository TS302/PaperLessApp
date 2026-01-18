package com.tom.paperless.di

import com.google.firebase.firestore.FirebaseFirestore
import com.tom.paperless.data.repositories.AndroidAssetUserRepository
import com.tom.paperless.data.repositories.AndroidAssignmentRepository
import com.tom.paperless.data.repositories.AndroidNfcTaggableRepository
import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.NfcTaggableRepository
import org.koin.dsl.module


val androidDataModule = module {
    single<FirebaseFirestore> { FirebaseFirestore.getInstance() }
    single<NfcTaggableRepository> { AndroidNfcTaggableRepository(get()) }
    single<AssetUserRepository> { AndroidAssetUserRepository(get()) }
    single<AssignmentRepository> { AndroidAssignmentRepository(get()) }
}
