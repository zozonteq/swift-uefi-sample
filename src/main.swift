//
//  main.swift
//  swift-os
//
@_silgen_name("init_allocator")
func init_allocator(_ bs: UnsafeMutableRawPointer?)

var IMAGE_HANDLE: UInt64?
var SYSTEM_TABLE: UnsafeMutablePointer<EFISystemTable>?

public func uefiPrint(_ message: String) {
    guard let conOut = SYSTEM_TABLE?.pointee.conOut else { return }
    typealias OutputFn = @convention(c) (UInt64, UnsafePointer<UInt16>) -> UInt64
    let outputString = unsafeBitCast(conOut.pointee.outputString, to: OutputFn.self)
    let handle = UInt64(UInt(bitPattern: conOut))
    for byte in message.utf8 {
        var buf: (UInt16, UInt16) = (UInt16(byte), 0x0000)
        withUnsafeMutableBytes(of: &buf) { raw in
            _ = outputString(handle, raw.baseAddress!.assumingMemoryBound(to: UInt16.self))
        }
    }
}
func getBuildArchitecture() -> String {
    #if arch(x86_64)
    return "x86_64"
    #elseif arch(arm64)
    return "AArch64"
    #elseif arch(riscv64)
    return "RISC-V 64"
    #else
    return "Unknown"
    #endif
}


@_silgen_name("efi_main")
public func efiMain(
    imageHandle: UInt64,
    systemTable: UnsafeMutablePointer<EFISystemTable>
) -> UInt64 {
    IMAGE_HANDLE = imageHandle
    SYSTEM_TABLE = systemTable

    let bs = systemTable.pointee.bootServices
    init_allocator(UnsafeMutableRawPointer(bs))

    // : https://uefi.org/specs/UEFI/2.9_A/12_Protocols_Console_Support.html#efi-graphics-output-protocol
    var gopGUID = EFI_GUID(
        data1: 0x9042a9de,
        data2: 0x23dc,
        data3: 0x4a38,
        data4: (0x96, 0xfb, 0x7a, 0xde, 0xd0, 0x80, 0x51, 0x6a)
    )

    typealias LocateProtocolFn = @convention(c) (UInt64, UInt64, UInt64) -> UInt64
    let locateFn = unsafeBitCast(bs.pointee.locateProtocol, to: LocateProtocolFn.self)

    var gopRaw: UnsafeMutableRawPointer? = nil
    let status = withUnsafeMutablePointer(to: &gopGUID) { guidPtr in
        withUnsafeMutablePointer(to: &gopRaw) { outPtr in
            locateFn(
                UInt64(UInt(bitPattern: guidPtr)),
                0,
                UInt64(UInt(bitPattern: outPtr))
            )
        }
    }
    

    if status == 0, let raw = gopRaw {
        if let gop = GOP(from: raw) {
            gop.clear(with: 0xFF000000)
            
            // gradient
            for y in 0..<gop.height {
                let intensity = UInt32(y * 255 / gop.height)
                let color = (0xFF << 24) | (intensity << 16) | (intensity << 8) | intensity
                for x in 0..<gop.width {
                    gop.drawPixel(x: x, y: y, color: color)
                }
            }

            uefiPrint("GOP Initialized: \(gop.width)x\(gop.height)\r\n")
        }
    }
    
    uefiPrint("Hello, UEFI Application using swift embedded!\r\n")
    uefiPrint("CPU Architecture: \(getBuildArchitecture())")
    
    while true {}

    return 0
}
