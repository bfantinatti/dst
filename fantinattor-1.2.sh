#!/bin/bash
# Written by Bruno Fantinatti - bfantinatti@gmail.com
# Intended to use on incremental backups and restoring procedures.
# Tested on Linux Mint and Manjaro.

#info module
if [ "$1" = "help" ]
then
	echo "==========Fantinattor=========="
	echo
	echo "This script will perform a full/selective incremental backup of your system, including your personal data, operating system, configurations and installed softwares."
	echo
	echo "Usage example: ./fantinattor-X.X.sh [full/system_only/home_only] /destination/disk/"
	echo
	echo "You should provide:"
	echo "1. Selective option: full, home_only or system_only."
	echo "2. Destination directory: The full path to your external hard drive."
	echo
	echo "For restoring, you must execute this script from the root of your backup data using the "restore" option."
	echo "You need to indicate the destination device."
	echo
	echo "Restoring example: ./fantinattor.sh restore /dev/sda1"
	echo "Your destination for restoring might be different. This is just an example!"
	echo
	echo "Let me know if you have any questions."
echo
echo "==========Fantinattor=========="
fi

#backup module
if [ "$1" = "full" ]
then
	rsync -avuorpESHAX /* $2 --delete --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found/*}
	#information module
	mkdir $2/fantinattor
	date >> $2/fantinattor/last-backup
	blkid > $2/fantinattor/blkid.info
	df > $2/fantinattor/df.info
fi

if [ "$1" = "system_only" ]
then
	rsync -avuorpESHAX /* $2 --delete --exclude={/home/*,/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found/*}
	#information module
	mkdir $2/fantinattor
	date >> $2/fantinattor/last-backup
	blkid > $2/fantinattor/blkid.info
	df > $2/fantinattor/df.info
fi

if [ "$1" = "home_only" ]
then
	rsync -avuorpESHAX /* $2 --delete --exclude={/bin/*,/boot/*,/cdrom/*,/dev/*,/etc/*,/initrd.img,/initrd.img.old,/lib/*,/lib32/*,/lib64/*,/lost+found/*,/media/*,/mnt/*,/opt/*,/proc/*,/root/*,/run/*,/sbin/*,/srv/*,/sys/*,/tmp/*,/usr/*,/var/*,/vmlinuz,/vmlinuz.old}
	#information module
	mkdir $2/fantinattor
	date >> $2/fantinattor/last-backup
	blkid > $2/fantinattor/blkid.info
	df > $2/fantinattor/df.info
fi

#restore module
if [ "$1" = "restore" ]
then
	if
		`df | grep -q $2`
	then
		echo "Your destination device is mounted. Please umount and try again.";
	else
	#obtaining UUIDs
	destination=$2
	rootUUID=`cat ./fantinattor/blkid.info | grep $destination | awk '{print $3}' | sed 's/UUID="//g' | sed 's/"//g'`
	swap=`cat ./fantinattor/blkid.info | grep -w "swap" | awk '{print $1}' | sed 's/://g'`
	swapUUID=`cat ./fantinattor/blkid.info | grep -w "swap" | awk '{print $2}' | sed 's/UUID="//g' | sed 's/"//g'`

	#preparing destination
	tune2fs $destination -U $rootUUID
	swapoff -a
	mkswap $swap -U $swapUUID
	mkdir /mnt/fantinattor
	mount $destination /mnt/fantinattor

	#restoring data
	rsync -avuorpESHAX ./* /mnt/fantinattor
	wait
	fi
fi
