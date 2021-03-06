//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

extension Float : Serializable {
    
    func toBytes() -> [UInt8] {
        var udPtr = UnsafeMutablePointer<Float>(allocatingCapacity: 1)
        defer { udPtr.deallocateCapacity(1) }
        udPtr.pointee = self
        let ubPtr = UnsafeMutablePointer<UInt8>(udPtr)
        var arr = Array<UInt8>(repeating: 0, count: 4)
        4.doFor {
            arr[$0] = ubPtr[$0]
        }
        return arr
    }
    
    
    init? (storage: BytesStorage) {
        var ubPtr = UnsafeMutablePointer<UInt8>(allocatingCapacity: 4)
        defer { ubPtr.deallocateCapacity(4) }
        4.doFor {
            ubPtr[$0] = storage.get()
        }
        let udPtr = UnsafeMutablePointer<Float>(ubPtr)
        self = udPtr.pointee
    }
    
}

