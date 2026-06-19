```markdown
# TWRP Device Tree for BBK A2 (P22H190) – Unisoc UMS512

This repository provides the device tree and build instructions for **TWRP (Team Win Recovery Project)** on the **BBK A2** smartphone (model **P22H190**) powered by the **Unisoc UMS512 (Tiger T618)** SoC.

> **✅ Status: Fully Functional**  
> ADB, MTP, `/data` decryption (FBE), backup/restore, and flashing are all confirmed working.  
> The only requirement is to patch the kernel to bypass the integrity check – guidance is provided below.

---

## Device Specifications

| Item | Details |
|------|---------|
| **Model** | EEBBK A2 (P22H190) |
| **SoC / CPU** | Unisoc UMS512 (Tiger T618) |
| **CPU Architecture** | ARM64‑v8A (Octa‑core Cortex‑A75/A55) |
| **Android Version** | 11 (based on kernel logs) |

---

## About This Tree

This tree contains:
- Board configuration for TWRP
- Partition layout (`fstab`)
- Recovery UI settings
- Build scripts for the UMS512 platform

**Current Status:**  
- TWRP builds successfully.  
- Kernel panic can be bypassed with the provided kernel patching methods.  
- All core recovery features are **fully functional** after applying the bypass.

**Working Features:**
- ADB (sideload, shell, logcat)
- MTP (file transfer between PC and device)
- `/data` partition mount and decryption (FBE supported)
- Backup / Restore (including system, data, boot, etc.)
- Flashing ZIP and IMG files
- Touchscreen input
- UI brightness control (workaround for screen‑lock issue, if any)

---

## Prerequisites

- **OS:** 64‑bit Linux (Ubuntu 18.04+)
- **Disk space:** ≥30 GB
- **RAM:** ≥4 GB (8+ GB recommended)
- **Packages** (install with `sudo apt install ...`):

```
git-core gnupg flex bison gperf zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip openjdk-8-jdk build-essential
```

Enable ccache (optional but recommended):

```bash
export USE_CCACHE=1
ccache -M 50G   # adjust size as needed
```

---

## Bypassing the Kernel Integrity Check

The stock kernel (for UMS512) contains a verification routine inside the **drm_open** function (disassembled signature: `sub_FFFFFF8008563184`). It checks whether the loaded `recovery.img` is official; if not, it triggers a panic with the message:

```
Kernel panic - not syncing: BBK:recovery.img is destroyed  Error!
```

This is evident from the `ramoops` logs and the provided IDA snippet (`kernelpatch.c`).

You must **modify the kernel** to skip this check. Two approaches are possible:

**Option 1 – Patch the kernel source code (if available)**  
Locate the `drm_open` function in the kernel source (likely in `drivers/gpu/drm/` or a Unisoc‑specific driver). Find the conditional branch that leads to the panic (the string `"BBK:recovery.img is destroyed"` is a good search target). **Comment out or remove** the entire check, or force the condition to always evaluate to `false`.

Example (pseudo‑code):

```c
// Original (simplified)
if (some_check) {
    panic("BBK:recovery.img is destroyed");
}
// Patch:
// if (some_check) { ... }   // comment out
```

**Option 2 – Modify the compiled kernel binary (Image / zImage)**  
If you only have the prebuilt kernel image, use a hex editor or IDA to **replace the conditional jump instruction with a NOP**:

1. Open the kernel image in IDA and locate `sub_FFFFFF8008563184`.
2. Find the instruction that branches to the panic code (often a `cbz` / `cbnz` / `b.ne` etc.).
3. Overwrite that instruction with `NOP` (ARM64 NOP is `0xD503201F`).
4. Save the modified kernel image.

**Important:** The exact offset depends on your kernel build. Use the `dmesg` log to confirm the panic string and cross‑reference with the disassembly.

---

## Build Instructions

To build this recovery from source, follow these steps:

1. Set up a TWRP build environment (It is recommended to use the AOSP11 branch, otherwise, the image memory disk may become too large, resulting in a failure to package successfully, with a 99% chance of failure). For example, use the minimal manifest:

   ```
   repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-11.0
   repo sync
   ```

2. Clone this device tree into `device/bbk/P22H190`:

   ```bash
   git clone <your-repo-url> device/bbk/P22H190
   ```

   (Replace `<your-repo-url>` with the actual URL of this repository.)

3. If you have kernel source and need to apply the patch, do so now and place the built `Image` (or `zImage`) in the device tree directory or specify its path in `BoardConfig`.

4. Run the following commands to build:

   ```bash
   . build/envsetup.sh
   lunch omni_P22H190-eng
   mka recoveryimage
   ```

   For A/B devices, use `mka bootimage` instead.

The output image will be located at `out/target/product/P22H190/recovery.img`.

After building, flash the recovery along with the patched kernel (if not included in the recovery image):

```bash
fastboot flash recovery recovery.img
fastboot flash boot patched_kernel.img   # if needed
```

---


## Credits

- TeamWin for TWRP
- @rtyutechstudio & @Zhiyu722
- The open‑source community
- Special thanks to those who reversed the kernel checks

---

## License

This device tree is licensed under the Apache License, Version 2.0.

---

**Use this software at your own risk. The authors are not responsible for bricked devices or data loss.**
```

---

