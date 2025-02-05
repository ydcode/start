#!/bin/bash


process_raid() {
    echo "#############################################"
    echo "Processing RAID devices and RAID member devices"
    echo "#############################################"
    echo ""

    echo "[Step 1] Detecting and stopping all RAID devices:"
    # Extract active md devices from /proc/mdstat (e.g., md0, md1, ...)
    active_md=$(grep -oP 'md\d+' /proc/mdstat | sort -u)

    if [ -z "$active_md" ]; then
        echo "No active RAID devices detected."
    else
        for md in $active_md; do
            echo "Stopping /dev/$md"
            mdadm --stop "/dev/$md" 2>/dev/null || echo "Failed to stop /dev/$md"
        done
    fi
    echo ""

    echo "[Step 2] Detecting devices with RAID superblocks:"
    # Find devices with a RAID superblock using blkid
    raid_members=$(blkid -t TYPE=linux_raid_member -o device)

    if [ -z "$raid_members" ]; then
        echo "No devices with RAID superblocks detected."
    else
        echo "$raid_members" | while read -r dev; do
            echo "Device: $dev"
        done
        echo ""
        read -r -p "Confirm to clear RAID superblocks on the above devices? Enter [y] to continue, any other key to exit: " confirm
        if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
            echo "Cancelled clearing RAID superblocks."
        else
            for dev in $raid_members; do
                echo "Clearing RAID superblock on $dev..."
                mdadm --zero-superblock "$dev" 2>/dev/null || echo "Failed to clear RAID superblock on $dev"
            done
        fi
    fi

    echo ""
    echo "RAID operations completed."
    echo "#############################################"
    echo ""
}



disk_raid__debian() {
  remove_raid
  sysctl -p
}

disk_raid() {
  echo
  echo "⌛️ Starting Config RAID..."

  disk_raid__debian

  if [ -z "$(swapon --noheadings)" ]; then
    echo "✅ Config RAID successfully: no active swap devices found."
  else
    echo "❌ Config RAID failed: active swap devices still detected."
    exit 1
  fi
}
