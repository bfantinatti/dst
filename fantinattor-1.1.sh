#!/bin/bash
#Bruno Fantinatti - bfantinatti@gmail.com

if [ "$1" = "help" ]; then
	echo "==========fantinattor=========="
	echo
	echo "Information: This script will perform a full/selective backup on your system, saving all your data, configurations and installed packages."
	echo
	echo "Usage example: fantinattor.sh [full/system_only/home_only] /media/user/disk/"
	echo
	echo "You should provide:"
	echo "1. Selective option: full, home_only or system_only."
	echo "2. Destination directory: The full path to your external hard drive."
	echo
	echo "For restoring, you will need the UUID of your backup system (this is only necessary if you have formatted the hard drive, or if you are moving the system to another computer). This information is present in the /etc/fstab file on your backup data. Replace the new partition UUID with such UUID, and restore the data using live USB and rsync. It is not necessary to use the -avuorpESHAX options for restoring."
echo
echo "==========fantinattor=========="
fi

if [ "$1" = "full" ]; then
	rsync -avuorpESHAX /* $2 --delete --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found/*}
fi
if [ "$1" = "system_only" ]; then
	rsync -avuorpESHAX /* $2 --delete --exclude={/home/*,/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found/*}
fi
if [ "$1" = "home_only" ]; then
	rsync -avuorpESHAX /* $2 --delete --exclude={/bin/*,/boot/*,/cdrom/*,/dev/*,/etc/*,/initrd.img,/initrd.img.old,/lib/*,/lib32/*,/lib64/*,/lost+found/*,/media/*,/mnt/*,/opt/*,/proc/*,/root/*,/run/*,/sbin/*,/srv/*,/sys/*,/tmp/*,/usr/*,/var/*,/vmlinuz,/vmlinuz.old}
fi
