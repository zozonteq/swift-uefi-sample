//
//  uefi_gop.swift
//  swift-os
//
//  Created by zozonteq on 2026/04/16.
//

// GOP Mode Information
public struct EFI_GRAPHICS_OUTPUT_MODE_INFORMATION {
    var version: UInt32
    var horizontalResolution: UInt32
    var verticalResolution: UInt32
    var pixelFormat: UInt32
    var pixelInformation: (UInt32, UInt32, UInt32, UInt32)
    var pixelsPerScanLine: UInt32
}

// GOP Mode
public struct EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE {
    var maxMode: UInt32
    var mode: UInt32
    var info: UnsafeMutablePointer<EFI_GRAPHICS_OUTPUT_MODE_INFORMATION>
    var sizeOfInfo: UInt64
    var frameBufferBase: UInt64
    var frameBufferSize: UInt64 
}

// GOP
public struct EFI_GRAPHICS_OUTPUT_PROTOCOL {
    var queryMode: UInt64
    var setMode: UInt64
    var blt: UInt64
    var mode: UnsafeMutablePointer<EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE>
}

public struct GOP {
    private let protocolPointer: UnsafeMutablePointer<EFI_GRAPHICS_OUTPUT_PROTOCOL>
    
    public let width: Int
    public let height: Int
    private let frameBuffer: UnsafeMutablePointer<UInt32>
    private let pixelsPerScanLine: Int

    public init?(from raw: UnsafeMutableRawPointer) {
        self.protocolPointer = raw.assumingMemoryBound(to: EFI_GRAPHICS_OUTPUT_PROTOCOL.self)
        
        let modePtr = protocolPointer.pointee.mode
        
        guard Int(bitPattern: modePtr) != 0 else { return nil }
        
        let mode = modePtr.pointee
        
        let info = mode.info.pointee
        
        self.width = Int(info.horizontalResolution)
        self.height = Int(info.verticalResolution)
        self.pixelsPerScanLine = Int(info.pixelsPerScanLine)
        
        guard let fbBase = UnsafeMutablePointer<UInt32>(bitPattern: UInt(mode.frameBufferBase)) else {
            return nil
        }
        self.frameBuffer = fbBase
    }


    @inline(__always)
    public func drawPixel(x: Int, y: Int, color: UInt32) {
        frameBuffer[y * pixelsPerScanLine + x] = color
    }

    public func clear(with color: UInt32) {
        for y in 0..<height {
            for x in 0..<width {
                drawPixel(x: x, y: y, color: color)
            }
        }
    }

    public func drawVerticalGradient() {
    }
}
