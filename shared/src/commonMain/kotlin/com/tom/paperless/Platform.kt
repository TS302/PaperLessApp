package com.tom.paperless

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform