//
//  uefi_output.swift
//  swift-os
//
//  Created by user on 2026/04/17.
//

// https://dox.ipxe.org/struct__EFI__SIMPLE__TEXT__OUTPUT__PROTOCOL.html
public struct SimpleTextOutput {
    var reset: UInt64
    var outputString: UInt64
    var testString: UInt64
    var queryMode: UInt64
    var setMode: UInt64
    var setAttribute: UInt64
    var clearScreen: UInt64
    var setCursorPosition: UInt64
    var enableCursor: UInt64
    var mode: UInt64  // pointer of *SIMPLE_TEXT_OUTPUT_MODE
}

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

public func uefiPrintln(_ message: String){
    uefiPrint(message + "\r\n")
}
