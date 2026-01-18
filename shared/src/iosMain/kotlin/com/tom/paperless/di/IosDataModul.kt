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















//val iosDataModule = module {
////    single<AssetUserRepository> { AssetUserRepositoryImpl() }
////    single<AssignmentRepository> { AssignmentRepositoryImpl() }
////    single<NfcTaggableRepository> { NfcTaggableRepositoryImpl() }
//}

//fun declareIosRepositories(
//    assetRepo: AssetUserRepository,
//    assignmentRepo: AssignmentRepository,
//    nfcRepo: NfcTaggableRepository
//) {
//    val koin = getKoinIos()
//
//    koin.declare(assetRepo, allowOverride = true)
//    koin.declare(assignmentRepo, allowOverride = true)
//    koin.declare(nfcRepo, allowOverride = true)
//}


//fun iosDataModule(
//    assetUserRepository: AssetUserRepository,
//    assignmentRepository: AssignmentRepository,
//    nfcTaggableRepository: NfcTaggableRepository
//) = module {
//    single<AssetUserRepository> { assetUserRepository }
//    single<AssignmentRepository> { assignmentRepository }
//    single<NfcTaggableRepository> { nfcTaggableRepository }
//}