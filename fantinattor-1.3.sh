#!/bin/bash
# Written by Bruno Fantinatti - bfantinatti@gmail.com
# Intended to use on incremental backups
# Tested on Linux Mint
# Name: DST - Data Safety Tool

#info module
if [ "$1" = "help" ]
then
	echo "==========Fantinattor=========="
	echo
	echo "This script will perform a full/selective incremental backup of your system, including your data, operating system, configurations and installed packages."
	echo
	echo "Usage example: fantinattor.sh [full/system_only/home_only] /destination/disk/"
	echo
	echo "You should provide:"
	echo "1. Selective option: full, home_only or system_only."
	echo "2. Destination directory: The full path to your external hard drive."
	echo
	echo "For restoring, you must execute this script from the root folder of your backup data using the "restore" option. You need to indicate the destination device."
	echo
	echo "Restoring example: ./fantinattor.sh /dev/sda1"
	echo "Your destination for restoring might be different. This is just an example!"
echo
echo "==========Fantinattor=========="
fi


#checking destination format. Should be a Linux format.
#if
#	blkid | grep $2 | grep -q ext2 || blkid | grep $2 | grep -q ext3 || blkid | grep $2 | grep -q ext4
#then
	#backup module
	if [ "$1" = "full" ]
	then
		rsync -avuorpESHAX /* $2 --delete --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found/*}
		#information module
		mkdir $2/fantinattor
		date >> $2/fantinattor/last-backup
		blkid > $2/fantinattor/blkid.info
		df > $2/fantinattor/df.info
	#	echo $1 > $2/fantinattor/backup.type
	fi
	
	if [ "$1" = "system_only" ]
	then
		rsync -avuorpESHAX /* $2 --delete --exclude={/home/*,/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found/*}
		#information module
		mkdir $2/fantinattor
		date >> $2/fantinattor/last-backup
		blkid > $2/fantinattor/blkid.info
		df > $2/fantinattor/df.info
	#	echo $1 > $2/fantinattor/backup.type
	fi

	if [ "$1" = "home_only" ]
	then
		rsync -avuorpESHAX /* $2 --delete --exclude={/bin/*,/boot/*,/cdrom/*,/dev/*,/etc/*,/initrd.img,/initrd.img.old,/lib/*,/lib32/*,/lib64/*,/lost+found/*,/media/*,/mnt/*,/opt/*,/proc/*,/root/*,/run/*,/sbin/*,/srv/*,/sys/*,/tmp/*,/usr/*,/var/*,/vmlinuz,/vmlinuz.old}
		#information module
		mkdir $2/fantinattor
		date >> $2/fantinattor/last-backup
		blkid > $2/fantinattor/blkid.info
		df > $2/fantinattor/df.info
	#	echo $1 > $2/fantinattor/backup.type
	fi
#else
#	echo "Your destination device is not in the Ext4 format. It is strongly recomended using Ext4 for this. If your destination backup is in a Linux format and you see this message, please contact me.";
#fi

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
#	destination=`cat ./df.info | grep -w "/" | awk '{print $1}'`
	rootUUID=`cat ./fantinattor/blkid.info | grep $destination | awk '{print $3}' | sed 's/UUID="//g' | sed 's/"//g'`
	swap=`cat ./fantinattor/blkid.info | grep -w "swap" | awk '{print $1}' | sed 's/://g'`
	swapUUID=`cat ./fantinattor/blkid.info | grep -w "swap" | awk '{print $2}' | sed 's/UUID="//g' | sed 's/"//g'`
#	type=`cat ./fantinattor/backup.type`

	#preparing destination
	tune2fs $destination -U $rootUUID
	swapoff -a
	mkswap $swap -U $swapUUID
	mkdir /mnt/fantinattor
	mount $destination /mnt/fantinattor

	#restoring data
#	if [ "`cat ./fantinattor/backup.type`" = "full" ]; then
	rsync -avuorpESHAX ./* /mnt/fantinattor
	wait
	fi
fi

#fixing grub
if [ "$3" = "fix-grub" ]
then
	grub-install --root-directory=/mnt/fantinattor $2
fi

##umounting destination
#umount /mnt/fantinattor
#wait
#rm -r /mnt/fantinattor

#error module
#else
#	echo "Error: You should specify a valid option!"
#	echo "The available options are:"
#	echo ""full" for a full system backup;"
#	echo ""home-only" for a home-only backup;"
#	echo ""system-only" for a system-only backup;"
#	echo "or "restore" for restoring your data."
#fi
