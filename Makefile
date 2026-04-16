SWIFTC     = swiftc
CLANG      = clang
LLDLINK    = lld-link

# Architecture selection: x86 (default) or arm64
ARCH       ?= x86

ifeq ($(ARCH),arm64)
  SWIFT_TARGET   = aarch64-none-none-elf
  CLANG_TARGET   = aarch64-unknown-windows
  EFI_NAME       = BOOTAA64.EFI
  ESP_DIR        = mnt/EFI/BOOT
  QEMU           = qemu-system-aarch64
  QEMU_MACHINE   = -machine virt,highmem=off -cpu cortex-a57
  QEMU_DRIVE     = -drive if=none,id=esp,format=raw,file=fat:rw:mnt \
                   -device virtio-blk-device,drive=esp
  QEMU_DISPLAY   = -device ramfb \
                   -device qemu-xhci \
                   -display cocoa
  QEMU_DEBUG_EXIT =
  OVMF           = OVMF_AA64.fd
else
  SWIFT_TARGET   = x86_64-unknown-none-elf
  CLANG_TARGET   = x86_64-unknown-windows
  EFI_NAME       = BOOTX64.EFI
  ESP_DIR        = mnt/EFI/BOOT
  QEMU           = qemu-system-x86_64
  QEMU_MACHINE   = -cpu Haswell,+xsave,+avx,+avx2
  QEMU_DRIVE     = -drive if=ide,format=raw,file=fat:rw:mnt
  OVMF           = OVMF.fd
endif

SRC_DIR    = src
BUILD_DIR  = build/$(ARCH)
SOURCES    = $(wildcard $(SRC_DIR)/*.swift)
STUBS_SRC  = $(SRC_DIR)/stubs.c

SWIFT_OBJ  = $(BUILD_DIR)/main.obj
STUBS_OBJ  = $(BUILD_DIR)/stubs.obj
SWIFT_IR   = $(BUILD_DIR)/main.ll
OUTPUT     = $(BUILD_DIR)/$(EFI_NAME)

# SWIFTFLAGS = \
#   -enable-experimental-feature Embedded \
#   -target $(SWIFT_TARGET) \
#   -parse-as-library \
#   -wmo \
#   -Osize
SWIFTFLAGS = \
  -enable-experimental-feature Embedded \
  -target $(SWIFT_TARGET) \
  -parse-as-library \
  -wmo \
  -Osize \
  -Xfrontend -disable-reflection-metadata \
  -Xfrontend -disable-reflection-names

CLANGFLAGS = \
  -target $(CLANG_TARGET) \
  -ffreestanding \
  -c \
  -Oz

#LDFLAGS = \
#  -subsystem:efi_application \
#  -entry:efi_main \
#  -nodefaultlib
  
LDFLAGS = \
  -subsystem:efi_application \
  -entry:efi_main \
  -nodefaultlib \
  -opt:ref,icf \
  -ignore:4217


.PHONY: all clean run

all: $(ESP_DIR)/$(EFI_NAME)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(SWIFT_IR): $(SOURCES) | $(BUILD_DIR)
	$(SWIFTC) $(SWIFTFLAGS) -emit-ir $(SOURCES) -o $@

$(SWIFT_OBJ): $(SWIFT_IR)
	$(CLANG) $(CLANGFLAGS) $< -o $@

$(STUBS_OBJ): $(STUBS_SRC) | $(BUILD_DIR)
	$(CLANG) $(CLANGFLAGS) $< -o $@

$(OUTPUT): $(SWIFT_OBJ) $(STUBS_OBJ)
	$(LLDLINK) $^ -out:$@ $(LDFLAGS)

$(ESP_DIR)/$(EFI_NAME): $(OUTPUT)
	mkdir -p $(ESP_DIR)
	cp $(OUTPUT) $(ESP_DIR)/

run: $(ESP_DIR)/$(EFI_NAME)
	$(QEMU) \
		-m 2G \
		-bios $(OVMF) \
		$(QEMU_MACHINE) \
		$(QEMU_DRIVE) \
		$(QEMU_DISPLAY)

clean:
	rm -rf build mnt
