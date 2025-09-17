//
//  NFCTagProtocol.swift
//  PaperLess
//
//  Created by Tom Salih on 03.06.25.
//

import SwiftUI

protocol NFCTagProtocol: Identifiable {
    var nfcTag: NFCTag { get }
}
