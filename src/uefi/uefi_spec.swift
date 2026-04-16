//
//  uefi_spec.swift
//  swift-os
//
//  Created by zozonteq on 2026/04/16.
//

// EFI Table Header
public struct EFITableHeader {
    var signature: UInt64
    var revision: UInt32
    var headerSize: UInt32
    var crc32: UInt32
    var reserved: UInt32
}

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

// EFI GUID
public struct EFI_GUID {
    var data1: UInt32
    var data2: UInt16
    var data3: UInt16
    var data4: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
}

// BootService (https://dox.ipxe.org/structEFI__BOOT)
// - https://dox.ipxe.org/UefiSpec_8h_source.html
public struct EFI_BOOT_SERVICES {
    var hdr: EFITableHeader
    // Task Priority Services
    var raiseTPL: UInt64
    var restoreTPL: UInt64
    // Memory Services
    var allocatePages: UInt64
    var freePages: UInt64
    var getMemoryMap: UInt64
    var allocatePool: UInt64
    var freePool: UInt64
    // Events and timer Services
    var createEvent: UInt64
    var setTimer: UInt64
    var waitForEvent: UInt64
    var signalEvent: UInt64
    var closeEvent: UInt64
    var checkEvent: UInt64
    // Protocol Handler Services
    var installProtocolInterface: UInt64
    var reinstallProtocolInterface: UInt64
    var uninstallProtocolInterface: UInt64
    var handleProtocol: UInt64
    var reserved: UInt64
    var registerProtocolNotify: UInt64
    var locateHandle: UInt64
    var locateDevicePath: UInt64
    var installConfigurationTable: UInt64
    // Image Services
    var loadImage: UInt64
    var startImage: UInt64
    var exit: UInt64
    var unloadImage: UInt64
    var exitBootServices: UInt64
    // Miscellaneous Services
    var getNextMonotonicCount: UInt64
    var stall: UInt64
    var setWatchdogTimer: UInt64
    // DriverSupport Services
    var connectController: UInt64
    var disconnectController: UInt64
    // Open and Close Protocol Services
    var openProtocol: UInt64
    var closeProtocol: UInt64
    var openProtocolInformation: UInt64
    // Library Services
    var protocolsPerHandle: UInt64
    var locateHandleBuffer: UInt64
    var locateProtocol: UInt64
    var installMultipleProtocolInterfaces: UInt64
    var uninstallMultipleProtocolInterfaces: UInt64
    // 32bit CRC Services
    var calculateCrc32: UInt64
    // Misc Services
    var copyMem: UInt64
    var setMem: UInt64
    var createEventEx: UInt64
}

public struct EFISystemTable {
    var hdr: EFITableHeader
    var firmwareVendor: UInt64
    var firmwareRevision: UInt32
    var _pad: UInt32
    var consoleInHandle: UInt64
    var conIn: UInt64
    var consoleOutHandle: UInt64
    var conOut: UnsafeMutablePointer<SimpleTextOutput>
    var consoleErrHandle: UInt64
    var stdErr: UInt64
    var runtimeServices: UInt64
    var bootServices: UnsafeMutablePointer<EFI_BOOT_SERVICES>
}
