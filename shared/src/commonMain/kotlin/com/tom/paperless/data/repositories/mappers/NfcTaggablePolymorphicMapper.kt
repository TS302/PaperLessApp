package com.tom.paperless.data.repositories.mappers

import com.tom.paperless.data.repositories.dto.NfcTaggableDto
import com.tom.paperless.domain.models.NfcTaggable
import com.tom.paperless.domain.models.enums.TagType

fun NfcTaggableDto.toDomainPolymorphic(): NfcTaggable {
    return when (TagType.valueOf(tagType)) {
        TagType.Tool      -> toToolDomain()
        TagType.Vehicle   -> toVehicleDomain()
        TagType.Key       -> toKeyRingDomain()
        TagType.AssetUser -> toAssetUserDomain()
    }
}