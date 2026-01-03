#!/usr/bin/env python3
import sys
import pathlib
import subprocess
import shlex

# ============================================================
# UI bridge (gum)
# ============================================================
UI_SCRIPT = "/root/vv-os/install/helpers/presentation.sh"

def _ui(func, msg):
    safe = shlex.quote(msg)
    subprocess.run(
        ["bash", "-c", f"source {UI_SCRIPT} && {func} {safe}"],
        check=True
    )

def show_header(msg):  _ui("show_header", msg)
def show_info(msg):    _ui("show_info", msg)
def show_success(msg): _ui("show_success", msg)
def show_error(msg):   _ui("show_error", msg)

# ============================================================
# Disk selection + manual partitioning (FULLY MANUAL)
# ============================================================
def select_and_partition_disk():
    show_header("VV OS Disk Setup")
    show_info("Swap partition is NOT required")
    show_info("VV OS will configure zram and swapfile automatically during post-install")

    try:
        lsblk = subprocess.check_output(
            ["lsblk", "-d", "-o", "NAME,SIZE,MODEL"],
            text=True
        ).splitlines()
    except subprocess.CalledProcessError:
        show_error("Failed to detect disks")
        sys.exit(1)

    print(lsblk[0])
    for line in lsblk[1:]:
        parts = line.split(None, 2)
        name = parts[0]
        rest = " ".join(parts[1:]) if len(parts) > 1 else ""
        print(f"/dev/{name} {rest}")

    disk = input("\nEnter target disk (example: /dev/sda): ").strip()
    if not disk.startswith("/dev/"):
        show_error("Invalid disk path")
        sys.exit(1)

    use_gpt = input("Use GPT partition table? [y/n]: ").strip().lower()
    if use_gpt != "n":
        show_info("GPT will be used")
        subprocess.run(["parted", disk, "mklabel", "gpt"], check=True)
    else:
        show_info("DOS/MBR will be used")
        subprocess.run(["parted", disk, "mklabel", "msdos"], check=True)

    show_info("Launching partition editor (cfdisk)")
    subprocess.run(["cfdisk", disk], check=True)
    show_success("Disk partitioning finished")
    return disk

# ============================================================
# Partition configuration
# ============================================================
def configure_partitions(disk):
    show_header("Partition Configuration")

    try:
        lsblk = subprocess.check_output(
            ["lsblk", "-ln", "-o", "NAME,TYPE", disk],
            text=True
        ).splitlines()
    except subprocess.CalledProcessError:
        show_error("Failed to list partitions")
        sys.exit(1)

    partitions = [f"/dev/{line.split()[0]}" for line in lsblk if line.split()[1] == "part"]
    if not partitions:
        show_error("No partitions found on disk")
        sys.exit(1)

    config = {}
    for part in partitions:
        while True:
            show_info(f"Configuring {part}")
            fs = input("Filesystem (ext4/xfs/btrfs/fat32) [ext4]: ").strip() or "ext4"
            mount = input("Mount point (e.g. /, /boot/efi, /home): ").strip()
            if not mount:
                show_error("Mount point cannot be empty")
                continue

            # === ПОДТВЕРЖДЕНИЕ ===
            confirm = input(f'Confirm: format as "{fs}" and mount at "{mount}"? [y/n]: ').strip().lower()
            if confirm in ('y'):
                break
            else:
                show_info("Please re-enter the configuration for this partition.")

        subvolumes = []
        if fs == "btrfs":
            create = input("Create BTRFS subvolumes? [y/n]: ").strip().lower()
            if create == "y":
                while True:
                    name = input("Subvolume name (empty to finish): ").strip()
                    if not name:
                        break
                    mp = input(f"Mount point for {name} [/{name}]: ").strip() or f"/{name}"
                    subvolumes.append((name, mp))

        config[part] = {"fs": fs, "mount": mount, "subvolumes": subvolumes}

    show_success("Partition configuration completed")
    return config

# ============================================================
# Format & mount
# ============================================================
def format_and_mount(config):
    show_header("Formatting and Mounting")

    # Identify all partition types
    root_part = None
    efi_part = None
    other_parts = []

    for part, c in config.items():
        if c["mount"] == "/":
            root_part = (part, c)
        elif c["mount"] == "/boot/efi":
            efi_part = (part, c)
        else:
            other_parts.append((part, c))

    if not root_part:
        show_error("Root partition (/) is required!")
        sys.exit(1)

    # Format all partitions
    for part, c in config.items():
        fs = c["fs"]
        show_info(f"Formatting {part} as {fs}")

        if fs == "ext4":
            subprocess.run(["mkfs.ext4", "-F", part], check=True)
        elif fs == "xfs":
            subprocess.run(["mkfs.xfs", "-f", part], check=True)
        elif fs == "fat32":
            subprocess.run(["mkfs.fat", "-F32", part], check=True)
        elif fs == "btrfs":
            subprocess.run(["mkfs.btrfs", "-f", part], check=True)
            # Create subvolumes (only relevant for root, but check all)
            if c["subvolumes"]:
                subprocess.run(["mount", part, "/mnt"], check=True)
                for name, _ in c["subvolumes"]:
                    subprocess.run(["btrfs", "subvolume", "create", f"/mnt/{name}"], check=True)
                subprocess.run(["umount", "/mnt"], check=True)
        else:
            show_error(f"Unsupported filesystem: {fs}")
            sys.exit(1)


    # Mount ROOT (/)
    part, c = root_part
    if c["fs"] == "btrfs" and c["subvolumes"]:
        root_subvol = c["subvolumes"][0][0]
        subprocess.run(["mount", "-o", f"subvol={root_subvol}", part, "/mnt"], check=True)
        # Mount remaining subvolumes from root
        for name, mp in c["subvolumes"][1:]:
            target = f"/mnt{mp}"
            subprocess.run(["mkdir", "-p", target], check=True)
            subprocess.run(["mount", "-o", f"subvol={name}", part, target], check=True)
    else:
        subprocess.run(["mount", part, "/mnt"], check=True)

    # Mount EFI (/boot/efi)
    if efi_part:
        part, c = efi_part
        efi_target = "/mnt/boot/efi"
        subprocess.run(["mkdir", "-p", efi_target], check=True)
        subprocess.run(["mount", part, efi_target], check=True)

    # Mount EVERYTHING ELSE
    for part, c in other_parts:
        mount = c["mount"]
        target = f"/mnt{mount}"
        subprocess.run(["mkdir", "-p", target], check=True)

        if c["fs"] == "btrfs" and c["subvolumes"]:
            # If this is a BTRFS volume with subvolumes (unlikely for non-root, but let's be safe)
            root_subvol = c["subvolumes"][0][0]
            subprocess.run(["mount", "-o", f"subvol={root_subvol}", part, target], check=True)
            for name, mp in c["subvolumes"][1:]:
                sub_target = f"/mnt{mp}"
                subprocess.run(["mkdir", "-p", sub_target], check=True)
                subprocess.run(["mount", "-o", f"subvol={name}", part, sub_target], check=True)
        else:
            subprocess.run(["mount", part, target], check=True)

    show_success("All partitions mounted correctly under /mnt")

# ============================================================
# Base system installation
# ============================================================
def install_base_system():
    show_header("Installing Base System and bootloader")
    base_file = pathlib.Path("/root/vv-os/packages/vv-base-system.txt")
    if not base_file.exists():
        show_error("Base package list not found")
        sys.exit(1)
    base_pkgs = [l.strip() for l in base_file.read_text().splitlines() if l.strip() and not l.startswith("#")]
    if not base_pkgs:
        show_error("Base package list is empty")
        sys.exit(1)

    bootloader_file = pathlib.Path("/root/vv-os/packages/vv-bootloader.txt")
    if not bootloader_file.exists():
        show_error("Bootloader package list not found")
        sys.exit(1)
    bootloader_pkgs = [l.strip() for l in bootloader_file.read_text().splitlines() if l.strip() and not l.startswith("#")]
    if not bootloader_pkgs:
        show_error("Bootloader package list is empty")
        sys.exit(1)

    show_info("Initializing pacman keyring")
    subprocess.run(["pacman-key", "--init"], check=True)
    subprocess.run(["pacman-key", "--populate", "archlinux"], check=True)

    show_info("Installing base system packages")
    subprocess.run(["pacstrap", "/mnt"] + base_pkgs, check=True)

    show_info("Installing bootloader packages")
    subprocess.run(["pacstrap", "/mnt"] + bootloader_pkgs, check=True)

    vconsole_path = pathlib.Path("/mnt/etc/vconsole.conf")
    vconsole_path.parent.mkdir(parents=True, exist_ok=True)
    vconsole_path.write_text("KEYMAP=us\n")
    show_info("Created /etc/vconsole.conf with US keymap")

    show_info("Generating filesystem table (fstab)")
    with open("/mnt/etc/fstab", "w") as f:
        subprocess.run(["genfstab", "-U", "/mnt"], stdout=f, check=True)

    show_success("Base system packages and bootloader packages installed successfully")

def install_bootloader(disk, config):
    show_header("Installing Bootloader")

    has_efi = any(c["mount"] == "/boot/efi" for c in config.values())

    if has_efi:
        # --- UEFI MODE ---
        show_info("Detected UEFI mode. Installing GRUB for UEFI...")
        subprocess.run([
            'arch-chroot', '/mnt',
            'grub-install',
            '--target=x86_64-efi',
            '--efi-directory=/boot/efi',
            '--bootloader-id=GRUB'
        ], check=True)
    else:
        # --- BIOS MODE ---
        show_info("Detected BIOS mode. Installing GRUB for BIOS...")
        subprocess.run([
            'arch-chroot', '/mnt',
            'grub-install',
            '--target=i386-pc',
            disk
        ], check=True)

    show_info("Generating GRUB configuration...")
    subprocess.run(['arch-chroot', '/mnt', 'grub-mkconfig', '-o', '/boot/grub/grub.cfg'], check=True)

    show_success("GRUB bootloader installed successfully")

# ============================================================
# User configuration
# ============================================================
def configure_users():
    show_header("User Setup")
    hostname = input("Hostname [vv-os]: ").strip() or "vv-os"
    root_pass = input("Root password: ").strip()

    users = []
    while True:
        username = input("Create user (empty to finish): ").strip()
        if not username:
            break
        user_pass = input(f"Password for {username}: ").strip()
        users.append((username, user_pass))

    if not users:
        show_error("At least one user is required")
        sys.exit(1)

    return hostname, root_pass, users

# ============================================================
# Main
# ============================================================
def main():
    disk = select_and_partition_disk()
    config = configure_partitions(disk)
    format_and_mount(config)
    install_base_system()
    install_bootloader(disk, config)

    hostname, root_pass, users = configure_users()

    # === Configure system via arch-chroot ===
    show_info("Configuring hostname...")
    with open("/mnt/etc/hostname", "w") as f:
        f.write(hostname + "\n")

    show_info("Setting root password...")
    subprocess.run(['arch-chroot', '/mnt', 'passwd', '--stdin', 'root'], input=root_pass.encode())


    # Create all users
    for username, user_pass in users:
        show_info(f"Creating user: {username}...")
        subprocess.run(['arch-chroot', '/mnt', 'useradd', '-m', '-G', 'wheel', '-s', '/bin/bash', username])
        subprocess.run(['arch-chroot', '/mnt', 'passwd', '--stdin', username], input=user_pass.encode())

        # Enable sudo for each user
        sudoers_line = f"{username} ALL=(ALL) ALL\n"
        with open("/mnt/etc/sudoers.d/10-installer", "a") as f:
            f.write(sudoers_line)

    # Services
    for service in ["systemd-networkd", "systemd-resolved"]:
        subprocess.run(['arch-chroot', '/mnt', 'systemctl', 'enable', service])

    show_success("Base system and user setup completed")
    show_info("You can now continue with VV OS post-installation")

if __name__ == "__main__":
    main()
