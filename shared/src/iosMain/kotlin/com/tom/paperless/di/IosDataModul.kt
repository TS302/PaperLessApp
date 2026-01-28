package com.tom.paperless.di

import com.tom.paperless.data.repositories.AssetUserRepository
import com.tom.paperless.data.repositories.AssignmentRepository
import com.tom.paperless.data.repositories.NfcTaggableRepository
import org.koin.dsl.module

fun iosDataModule(
    assetUserRepository: AssetUserRepository,
    assignmentRepository: AssignmentRepository,
    nfcTaggableRepository: NfcTaggableRepository
)  = module {
    single<AssetUserRepository> { assetUserRepository }
    single<AssignmentRepository> { assignmentRepository }
    single<NfcTaggableRepository> { nfcTaggableRepository }
}