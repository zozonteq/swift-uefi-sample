[![Swift](https://img.shields.io/badge/Swift-Embedded-orange?logo=swift)](https://docs.swift.org/embedded/)
[![Platform](https://img.shields.io/badge/Platform-UEFI-blue)](https://uefi.org/)
[![Arch](https://img.shields.io/badge/Arch-x86__64%20%7C%20AArch64-lightgrey)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)


# swift-uefi-sample

Build UEFI Application with Swift-Embedded.  
`x86_64` and `Aarch64` are supported now.
# Preview
| x64 | aarch64 |
| --- | --- | 
| <img width="800"  alt="image" src="https://github.com/user-attachments/assets/f295e375-d1de-4dfe-9675-9eee57fc6c92" /> | <img width="800" alt="image" src="https://github.com/user-attachments/assets/3f206209-d192-4cf5-b0b9-1f05b2f2d5eb" /> |


# Build and Run
1. Embedded Swift is required. Following this docs to setup environment first.
- https://docs.swift.org/embedded/documentation/embedded/installembeddedswift
2. To run UEFI Application on QEMU. Also you need a pre-build UEFI such as `OVMF.fd`(x86_64) or `OVMF_AA.fd`(Aarch64)

```shell
make run # run uefi application(x86_64) in qemu
make run ARCH=arm64 # run uefi application(Aarch64) in qemu

make run NOGRAPHICS=true # run uefi application(x86_64) in qemu without graphics.
make run NOGRAPHICS=true ARCH=arm64 # run uefi application(arm64) in qemu without graphics.
```

- Build article is stored at `build/x64/BOOTX64.EFI`(x86_64), `build/arm64/BOOTAA64.EFI`(aarch64).
- Works on physical device. (Tested on Surface Pro 2017)
