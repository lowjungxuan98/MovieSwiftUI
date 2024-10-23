//
//  SecureStorage.swift
//  movie app
//
//  Created by Low Jung Xuan on 23/10/2024.
//

import CryptoKit
import Foundation

class SecureStorage {
    static func encryptData(_ data: Data, usingKey key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }

    static func decryptData(_ encryptedData: Data, usingKey key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        return try AES.GCM.open(sealedBox, using: key)
    }

    static func generateSymmetricKey() -> SymmetricKey {
        return SymmetricKey(size: .bits256)
    }
}
