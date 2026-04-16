# swift-uefi-sample
Build UEFI Application with Swift-Embedded.  
`x86_64` and `Aarch64` are supported now.
# Preview
| x64 | aarch64 |
| --- | --- | 
| <img width="800"  alt="image" src="https://github.com/user-attachments/assets/f295e375-d1de-4dfe-9675-9eee57fc6c92" /> | <img width="800" alt="image" src="https://github.com/user-attachments/assets/3f206209-d192-4cf5-b0b9-1f05b2f2d5eb" /> |


# Build and Run
Embedded Swift is require. Following this docs to setup environment first.
https://docs.swift.org/embedded/documentation/embedded/installembeddedswift

```shell
make run # run uefi application(x86_64) in qemu
make run ARCH=arm64 # run uefi application(Aarch64) in qemu
```
- Build article is stored at `build/x64/BOOTX64.EFI`(x86_64), `build/arm64/BOOTAA64.EFI`(aarch64).
- Works on physical device. (Tested on Surface Pro 2017)
