//
//  ExtensionUInt64.swift
//  PlaygroundLogger
//
//  Copyright (c) 2014-2016 Apple Inc. All rights reserved.
//

extension UInt64 : Serializable {
	static let largeNumMarker : UInt8 = 0xFF
	
	func toBytes() -> [UInt8] {
		if (self < UInt64(UInt64.largeNumMarker)) {
			return [ UInt8(self) ]
		}

		var ret = Array<UInt8>()
        ret.append(UInt64.largeNumMarker)
        var up_int = UnsafeMutablePointer<UInt64>(allocatingCapacity: 1)
        defer { up_int.deallocateCapacity(1) }
		up_int.pointee = self
        var up_byte: UnsafePointer<UInt8> = UnsafePointer(up_int)
        8.doFor {
			ret.append(up_byte.pointee)
			up_byte = up_byte.successor()
		}
		return ret
	}

    func toEightBytes() -> [UInt8] {
        var ret = Array<UInt8>()
        var up_int = UnsafeMutablePointer<UInt64>(allocatingCapacity: 1)
        defer { up_int.deallocateCapacity(1) }
        up_int.pointee = self
        var up_byte: UnsafePointer<UInt8> = UnsafePointer(up_int)
        8.doFor {
            ret.append(up_byte.pointee)
            up_byte = up_byte.successor()
        }
        return ret
    }
    
    init? (storage : BytesStorage) {
		let byte0 = storage.get()
		if (byte0 == UInt64.largeNumMarker) {
            if let x = UInt64(eightBytesStorage: storage) {
                self = x
            } else {
                return nil
            }
		} else {
			self = UInt64(byte0)
		}
	}

    init? (eightBytesStorage: BytesStorage) {
        if !eightBytesStorage.has(8) { return nil }
		var up_byte = UnsafeMutablePointer<UInt8>(allocatingCapacity: 8)
        defer { up_byte.deallocateCapacity(8) }
        8.doFor {
            up_byte[$0] = eightBytesStorage.get()
        }
        let up_int: UnsafePointer<UInt64> = UnsafePointer(up_byte)
		self = up_int.pointee
    }
}