#!/usr/bin/env bash

# Dependencies: curl tar gzip grep coreutils
# Root rights are required

########################################################################
# prepare batocera patched files
thisdir="$(dirname "$(readlink -f "${0}")")"
cd $thisdir
wget -q --tries=10 -O $thisdir/utils_dwarfs.tar.gz https://github.com/profork/profork/raw/master/steam/build/utils_dwarfs.tar.gz
tar xf $thisdir/utils_dwarfs.tar.gz
########################################################################

# Package groups
audio_pkgs="alsa-lib lib32-alsa-lib alsa-plugins lib32-alsa-plugins libpulse lib32-libpulse \
jack2 lib32-jack2 alsa-tools alsa-utils pavucontrol pipewire lib32-pipewire"

video_pkgs="mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon \
vulkan-intel lib32-vulkan-intel nvidia-utils lib32-nvidia-utils wayland \
vulkan-icd-loader lib32-vulkan-icd-loader vulkan-mesa-layers weston \
lib32-vulkan-mesa-layers libva-mesa-driver lib32-libva-mesa-driver \
libva-intel-driver lib32-libva-intel-driver intel-media-driver \
mesa-utils vulkan-tools nvidia-prime libva-utils lib32-mesa-utils"

wine_pkgs="wine-ge-custom winetricks wine-nine wineasio \
giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap \
gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal \
v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins \
lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo \
lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama \
lib32-libxinerama libxslt lib32-libxslt libva lib32-libva gtk3 \
lib32-gtk3 vulkan-icd-loader lib32-vulkan-icd-loader sdl2 lib32-sdl2 \
vkd3d lib32-vkd3d libgphoto2 ffmpeg gstreamer gst-plugins-good gst-plugins-bad \
gst-plugins-ugly gst-plugins-base lib32-gst-plugins-good \
lib32-gst-plugins-base gst-libav wget wine-mono wine-gecko"

devel_pkgs="base-devel git meson mingw-w64-gcc cmake"

# Packages to install
# You can add packages that you want and remove packages that you don't need
# Apart from packages from the official Arch repos, you can also specify
# packages from the Chaotic-AUR repo
export packagelist="${audio_pkgs} ${video_pkgs} ${wine_pkgs} ${devel_pkgs} \
nano ttf-dejavu ttf-liberation steam mpv pcmanfm strace nnn bat \
htop aria2 neofetch xorg-xwayland kdenlive gedit btop ranger python-pyqt6-webengine\
steam-native-runtime gamemode  lib32-gamemode jre-openjdk lxterminal \
mangohud thunderbird gimp audacity lib32-mangohud kodi ksysguard ark kate okular breeze breeze-gtk  \
qt5-wayland xorg-server-xephyr openbox binutils emby-theater \
xdotool xbindkeys gparted vlc smplayer mpv fish zsh xmlstarlet nvtop duf exa systemsettings dolphin  \
legendary gamescope  minizip flatpak libreoffice rsync  \
ripgrep i7z sd bandwhich tre zoxide p7zip atop iftop sysstat totem feh krename  \
bottles bauh flatseal rebuild-detector ccache axel breeze xorg-xdpyinfo dua-cli  \
handbrake tigervnc remmina  kitty terminator xorg-xkill media-downloader file  noto-fonts ttf-ubuntu-font-family ttf-droid \
docker docker-compose portainer-bin unzip gthumb nmon thunar nemo umu-launcher gtk-engines gtk-engine-murrine  \
gdk-pixbuf-xlib gdk-pixbuf2 xarchiver mc vifm fd deckctl steam-tweaks deck-pref-gui   \
steam-boilr-gui btrfs-assistant protontricks-git lib32-sdl12-compat sdl12-compat appimagepool-appimage  kmod pciutils xrdp x11vnc tigervnc onboard remmina vinagre freerdp sunshine btrfs-progs tre \
podman distrobox cheese filezilla dos2unix wmctrl xorg-xprop fzf scc yarn sdl2 sdl2_image squashfs-tools \
btrfs-heatmap meld lynx yq xorg xorg-server-xvfb nodejs npm cairo-dock imagemagick strace sdl2_mixer python-pysdl2 \
tint2 plank lxde mate mate-extra dialog xterm compsize antimicrox lutris-git chiaki procs sdl2_ttf \
protontricks-git sublime-text-4 fuse2 heroic-games-launcher-bin moonlight-qt ventoy-bin 7-zip crun runc \
microsoft-edge-stable-bin qdirstat peazip jq steam-rom-manager-git google-chrome steamtinkerlaunch xfwm4 xfwm4-themes \
screenfetch glances discord jre8-openjdk gcc13 python-pip xfce4 xfce4-goodies obs-studio-git lua53"
# If you want to install AUR packages, specify them in this variable
export aur_packagelist="geforcenow-electron shadps4-bin mcpelauncher-appimage parsec-bin protonup-qt  sgdboop-bin winegui-bin"

# ALHP is a repository containing packages from the official Arch Linux
# repos recompiled with -O3, LTO and optimizations for modern CPUs for
# better performance
#
# When this repository is enabled, most of the packages from the official
# Arch Linux repos will be replaced with their optimized versions from ALHP
#
# Set this variable to true, if you want to enable this repository
enable_alhp_repo="false"

# Feature levels for ALHP. Available feature levels are 2 and 3
# For level 2 you need a CPU with SSE4.2 instructions
# For level 3 you need a CPU with AVX2 instructions
alhp_feature_level="2"

########################################################################

if [ $EUID != 0 ]; then
	echo "Root rights are required!"

	exit 1
fi

if ! command -v curl 1>/dev/null; then
	echo "curl is required!"
	exit 1
fi

if ! command -v gzip 1>/dev/null; then
	echo "gzip is required!"
	exit 1
fi

if ! command -v grep 1>/dev/null; then
	echo "grep is required!"
	exit 1
fi

if ! command -v sha256sum 1>/dev/null; then
	echo "sha256sum is required!"
	exit 1
fi

script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

mount_chroot () {
	# First unmount just in case
	umount -Rl "${bootstrap}"

	mount --bind "${bootstrap}" "${bootstrap}"
	mount -t proc /proc "${bootstrap}"/proc
	mount --bind /sys "${bootstrap}"/sys
	mount --make-rslave "${bootstrap}"/sys
	mount --bind /dev "${bootstrap}"/dev
	mount --bind /dev/pts "${bootstrap}"/dev/pts
	mount --bind /dev/shm "${bootstrap}"/dev/shm
	mount --make-rslave "${bootstrap}"/dev

	rm -f "${bootstrap}"/etc/resolv.conf
	cp /etc/resolv.conf "${bootstrap}"/etc/resolv.conf

	mkdir -p "${bootstrap}"/run/shm
}

unmount_chroot () {
	umount -l "${bootstrap}"
	umount "${bootstrap}"/proc
	umount "${bootstrap}"/sys
	umount "${bootstrap}"/dev/pts
	umount "${bootstrap}"/dev/shm
	umount "${bootstrap}"/dev
}

run_in_chroot () {
	if [ -n "${CHROOT_AUR}" ]; then
		chroot --userspec=aur:aur "${bootstrap}" /usr/bin/env LANG=en_US.UTF-8 TERM=xterm PATH="/bin:/sbin:/usr/bin:/usr/sbin" "$@"
	else
		chroot "${bootstrap}" /usr/bin/env LANG=en_US.UTF-8 TERM=xterm PATH="/bin:/sbin:/usr/bin:/usr/sbin" "$@"
	fi
}

install_packages () {
	echo "Checking if packages are present in the repos, please wait..."
	for p in ${packagelist}; do
		if pacman -Sp "${p}" &>/dev/null; then
			good_pkglist="${good_pkglist} ${p}"
		else
			bad_pkglist="${bad_pkglist} ${p}"
		fi
	done

	if [ -n "${bad_pkglist}" ]; then
		echo ${bad_pkglist} > /opt/bad_pkglist.txt
	fi

	for i in {1..10}; do
		if pacman --noconfirm --needed -S ${good_pkglist}; then
			good_install=1
			break
		fi
	done

	if [ -z "${good_install}" ]; then
		echo > /opt/pacman_failed.txt
	fi
}

install_aur_packages () {
	cd /home/aur

	echo "Patching aur makepkg to multithread..."
	sed -i 's,#MAKEFLAGS="-j2",MAKEFLAGS="-j$(nproc)",g' /etc/makepkg.conf 2>/dev/null
	
	echo "Checking if packages are present in the AUR, please wait..."
	for p in ${aur_pkgs}; do
		if ! yay -a -G "${p}" &>/dev/null; then
			bad_aur_pkglist="${bad_aur_pkglist} ${p}"
		fi
	done

	if [ -n "${bad_aur_pkglist}" ]; then
		echo ${bad_aur_pkglist} > /home/aur/bad_aur_pkglist.txt
	fi

	for i in {1..10}; do
		#if yay --needed --noconfirm --removemake --nocleanmenu --nodiffmenu --builddir /home/aur -a -S ${aur_pkgs}; then
		if yay --needed --noconfirm --removemake --builddir /home/aur -a -S ${aur_pkgs}; then
			break
		fi
	done
}

generate_localegen () {
	cat <<EOF > locale.gen
ar_EG.UTF-8 UTF-8
en_US.UTF-8 UTF-8
en_GB.UTF-8 UTF-8
en_CA.UTF-8 UTF-8
en_SG.UTF-8 UTF-8
es_MX.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
fr_FR.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
ru_UA.UTF-8 UTF-8
es_ES.UTF-8 UTF-8
de_DE.UTF-8 UTF-8
pt_BR.UTF-8 UTF-8
it_IT.UTF-8 UTF-8
id_ID.UTF-8 UTF-8
ja_JP.UTF-8 UTF-8
bg_BG.UTF-8 UTF-8
pl_PL.UTF-8 UTF-8
da_DK.UTF-8 UTF-8
ko_KR.UTF-8 UTF-8
tr_TR.UTF-8 UTF-8
hu_HU.UTF-8 UTF-8
cs_CZ.UTF-8 UTF-8
bn_IN.UTF-8 UTF-8
hi_IN.UTF-8 UTF-8
he_IL.UTF-8 UTF-8
zh_TW.UTF-8 UTF-8
th_TH.UTF-8 UTF-8
vi_VN.UTF-8 UTF-8
EOF
}

#Server = https://europe.mirror.pkgbuild.com/\$repo/os/\$arch
generate_mirrorlist_og () {
	cat <<EOF > mirrorlist
Server = https://mirror.osbeck.com/archlinux/\$repo/os/\$arch
Server = https://archlinux.thaller.ws/\$repo/os/\$arch
Server = https://mirror.moson.org/arch/\$repo/os/\$arch
Server = https://md.mirrors.hacktegic.com/archlinux/\$repo/os/\$arch
Server = https://mirror.tux.si/arch/\$repo/os/\$arch
Server = https://arch.jensgutermuth.de/\$repo/os/\$arch
Server = https://geo.mirror.pkgbuild.com/\$repo/os/\$arch
EOF
}

#Server = https://europe.mirror.pkgbuild.com/\$repo/os/\$arch
generate_mirrorlist () {
	cat <<EOF > mirrorlist
Server = https://mirror.osbeck.com/archlinux/\$repo/os/\$arch
Server = https://mirror.f4st.host/archlinux/\$repo/os/\$arch
Server = https://archlinux.thaller.ws/\$repo/os/\$arch
Server = https://mirror.moson.org/arch/\$repo/os/\$arch
Server = https://md.mirrors.hacktegic.com/archlinux/\$repo/os/\$arch
Server = https://mirror.tux.si/arch/\$repo/os/\$arch
Server = https://arch.jensgutermuth.de/\$repo/os/\$arch
Server = https://geo.mirror.pkgbuild.com/\$repo/os/\$arch
Server = https://mirror.rackspace.com/archlinux/\$repo/os/\$arch
Server = https://arch.mirror.constant.com/\$repo/os/\$arch
Server = https://mirror.23media.com/archlinux/\$repo/os/\$arch
Server = https://mirrors.mit.edu/archlinux/\$repo/os/\$arch
Server = https://mirror.pkgbuild.com/\$repo/os/\$arch
Server = https://archlinux.mailtunnel.eu/\$repo/os/\$arch
Server = https://mirror.onet.pl/pub/mirrors/archlinux/\$repo/os/\$arch
Server = https://mirror.rackspace.com/archlinux/\$repo/os/\$arch
Server = https://archlinux.uk.mirror.allworldit.com/archlinux/\$repo/os/\$arch
Server = https://mirror.bytemark.co.uk/archlinux/\$repo/os/\$arch
Server = https://london.mirror.pkgbuild.com/\$repo/os/\$arch
Server = http://mirrors.acm.wpi.edu/archlinux/\$repo/os/\$arch
Server = https://mirror.adectra.com/archlinux/\$repo/os/\$arch
Server = https://mirror.kirbee.tech/archlinux/\$repo/os/\$arch
Server = https://mirrors.nguyenhoang.cloud/archlinux/\$repo/os/\$arch
Server = http://mirror.bizflycloud.vn/archlinux/\$repo/os/\$arch
Server = http://mirror.kirbee.tech/archlinux/\$repo/os/\$arch
Server = https://asia.mirror.pkgbuild.com/\$repo/os/\$arch
Server = http://mirror-hk.koddos.net/archlinux/\$repo/os/\$arch
Server = https://mirror-hk.koddos.net/archlinux/\$repo/os/\$arch
Server = http://hkg.mirror.rackspace.com/archlinux/\$repo/os/\$arch
Server = https://hkg.mirror.rackspace.com/archlinux/\$repo/os/\$arch
Server = https://arch-mirror.wtako.net/\$repo/os/\$arch
Server = http://mirror.xtom.com.hk/archlinux/\$repo/os/\$arch
Server = https://mirror.xtom.com.hk/archlinux/\$repo/os/\$arch
EOF
}

cd "${script_dir}" || exit 1

bootstrap="${script_dir}"/root.x86_64

curl -#LO 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
curl -#LO 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

if [ ! -s chaotic-keyring.pkg.tar.zst ] || [ ! -s chaotic-mirrorlist.pkg.tar.zst ]; then
	echo "Seems like Chaotic-AUR keyring or mirrorlist is currently unavailable"
	echo "Please try again later"
	exit 1
fi

bootstrap_urls=("arch.hu.fo" \
			"mirror.cyberbits.eu" \
			"mirror.osbeck.com" \
			"mirror.lcarilla.de" \
			"mirror.moson.org")

echo "Downloading Arch Linux bootstrap"

for link in "${bootstrap_urls[@]}"; do
        curl -#LO "https://${link}/archlinux/iso/latest/archlinux-bootstrap-x86_64.tar.zst"
	curl -#LO "https://${link}/archlinux/iso/latest/sha256sums.txt"

	if [ -s sha256sums.txt ]; then
		grep bootstrap-x86_64 sha256sums.txt > sha256.txt

		echo "Verifying the integrity of the bootstrap"
		if sha256sum -c sha256.txt &>/dev/null; then
			bootstrap_is_good=1
			break
		fi
	fi

	echo "Download failed, trying again with different mirror"
done

if [ -z "${bootstrap_is_good}" ]; then
	echo "Bootstrap download failed or its checksum is incorrect"
	exit 1
fi

rm -rf "${bootstrap}"
tar --zstd -xf archlinux-bootstrap-x86_64.tar.zst
rm archlinux-bootstrap-x86_64.tar.zst sha256sums.txt sha256.txt

mount_chroot

generate_localegen

if command -v reflector 1>/dev/null; then
	echo "Generating mirrorlist..."
	reflector --connection-timeout 10 --download-timeout 10 --protocol https --score 7 --sort rate --save mirrorlist
	reflector_used=1
else
	generate_mirrorlist
fi

rm "${bootstrap}"/etc/locale.gen
mv locale.gen "${bootstrap}"/etc/locale.gen

rm "${bootstrap}"/etc/pacman.d/mirrorlist
mv mirrorlist "${bootstrap}"/etc/pacman.d/mirrorlist

{
	echo
	echo "[multilib]"
	echo "Include = /etc/pacman.d/mirrorlist"
} >> "${bootstrap}"/etc/pacman.conf

run_in_chroot pacman-key --init
echo "keyserver hkps://keyserver.ubuntu.com" >> "${bootstrap}"/etc/pacman.d/gnupg/gpg.conf
run_in_chroot pacman-key --populate archlinux

# Add Chaotic-AUR repo
run_in_chroot pacman-key --recv-key 3056513887B78AEB
run_in_chroot pacman-key --lsign-key 3056513887B78AEB

mv chaotic-keyring.pkg.tar.zst chaotic-mirrorlist.pkg.tar.zst "${bootstrap}"/opt
run_in_chroot pacman --noconfirm -U /opt/chaotic-keyring.pkg.tar.zst /opt/chaotic-mirrorlist.pkg.tar.zst
rm "${bootstrap}"/opt/chaotic-keyring.pkg.tar.zst "${bootstrap}"/opt/chaotic-mirrorlist.pkg.tar.zst

{
	echo
	echo "[chaotic-aur]"
	echo "Include = /etc/pacman.d/chaotic-mirrorlist"
} >> "${bootstrap}"/etc/pacman.conf

# The ParallelDownloads feature of pacman
# Speeds up packages installation, especially when there are many small packages to install
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 3/g' "${bootstrap}"/etc/pacman.conf

# Do not install unneeded files (man pages and Nvidia firmwares)
sed -i 's/#NoExtract   =/NoExtract   = usr\/lib\/firmware\/nvidia\/\* usr\/share\/man\/\*/' "${bootstrap}"/etc/pacman.conf

run_in_chroot pacman -Sy archlinux-keyring --noconfirm
run_in_chroot pacman -Su --noconfirm

if [ "${enable_alhp_repo}" = "true" ]; then
	if [ "${alhp_feature_level}" -gt 2 ]; then
		alhp_feature_level=3
	else
		alhp_feature_level=2
	fi

	run_in_chroot pacman --noconfirm --needed -S alhp-keyring alhp-mirrorlist
	sed -i "s/#\[multilib\]/#/" "${bootstrap}"/etc/pacman.conf
	sed -i "s/\[core\]/\[core-x86-64-v${alhp_feature_level}\]\nInclude = \/etc\/pacman.d\/alhp-mirrorlist\n\n\[extra-x86-64-v${alhp_feature_level}\]\nInclude = \/etc\/pacman.d\/alhp-mirrorlist\n\n\[core\]/" "${bootstrap}"/etc/pacman.conf
	sed -i "s/\[multilib\]/\[multilib-x86-64-v${alhp_feature_level}\]\nInclude = \/etc\/pacman.d\/alhp-mirrorlist\n\n\[multilib\]/" "${bootstrap}"/etc/pacman.conf
	run_in_chroot pacman -Syu --noconfirm
fi

date -u +"%d-%m-%Y %H:%M (DMY UTC)" > "${bootstrap}"/version

# These packages are required for the self-update feature to work properly
run_in_chroot pacman --noconfirm --needed -S base reflector squashfs-tools fakeroot

# Regenerate the mirrorlist with reflector if reflector was not used before
if [ -z "${reflector_used}" ]; then
	echo "Generating mirrorlist..."
	run_in_chroot reflector --connection-timeout 10 --download-timeout 10 --protocol https --score 7 --sort rate --save /etc/pacman.d/mirrorlist
fi

export -f install_packages
run_in_chroot bash -c install_packages

if [ -f "${bootstrap}"/opt/pacman_failed.txt ]; then
	unmount_chroot
	echo "Pacman failed to install some packages"
	exit 1
fi

if [ -n "${aur_packagelist}" ]; then
	run_in_chroot pacman --noconfirm --needed -S base-devel yay
	run_in_chroot useradd -m -G wheel aur
	echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> "${bootstrap}"/etc/sudoers

	for p in ${aur_packagelist}; do
		aur_pkgs="${aur_pkgs} aur/${p}"
	done
	export aur_pkgs

	export -f install_aur_packages
	CHROOT_AUR=1 HOME=/home/aur run_in_chroot bash -c install_aur_packages
	mv "${bootstrap}"/home/aur/bad_aur_pkglist.txt "${bootstrap}"/opt
	rm -rf "${bootstrap}"/home/aur
fi

run_in_chroot locale-gen

# Generate a list of installed packages
run_in_chroot pacman -Q > "${bootstrap}"/pkglist.x86_64.txt

unmount_chroot

# Clear pacman package cache
rm -f "${bootstrap}"/var/cache/pacman/pkg/*

# Create some empty files and directories
# This is needed for bubblewrap to be able to bind real files/dirs to them
# later in the conty-start.sh script
mkdir "${bootstrap}"/media
mkdir -p "${bootstrap}"/usr/share/steam/compatibilitytools.d
touch "${bootstrap}"/etc/asound.conf
touch "${bootstrap}"/etc/localtime
chmod 755 "${bootstrap}"/root

# Enable full font hinting
rm -f "${bootstrap}"/etc/fonts/conf.d/10-hinting-slight.conf
ln -s /usr/share/fontconfig/conf.avail/10-hinting-full.conf "${bootstrap}"/etc/fonts/conf.d

#clear

# Fix apps (steam/lutris/vlc) to run as root
find "${bootstrap}"/var/lib/flatpak/app -type f -name 'bin_steam.sh' -exec sed -i 's,id -u)" == "0",id -u)" == "888",g' {} + 2>/dev/null
sed -i 's/os.popen("id -u").read() == "0\\n"/os.popen("id -u").read() == "888\\n"/g; s/os.popen("id -u").read() == "0"/os.popen("id -u").read() == "888"/g' "${bootstrap}"/usr/share/playonlinux4/python/mainwindow.py 2>/dev/null
sed -i 's,os.geteuid() == 0,os.geteuid() == 888,g' "${bootstrap}"/usr/lib/python3.11/site-packages/lutris/gui/application.py 2>/dev/null
sed -i 's,id -u)" == "0",id -u)" == "888",g' "${bootstrap}"/usr/lib/steam/bin_steam.sh 2>/dev/null
sed -i 's,id -u)" = "0",id -u)" = "888",g' "${bootstrap}"/usr/share/playonlinux4/lib/sources 2>/dev/null
sed -i 's,EUID" = 0,EUID" = 888,g'   "${bootstrap}"/bin/steamtinkerlaunch 2>/dev/null
sed -i 's/geteuid/getppid/' "${bootstrap}"/usr/sbin/vlc 2>/dev/null

# Fix steam ctrl+click openbox bug
# --
# Include steamfixer.sh as /usr/bin/steamfixer
steamfixer="${bootstrap}"/usr/bin/steamfixer
	rm "$steamfixer" 2>/dev/null
	wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$steamfixer" "https://raw.githubusercontent.com/trashbus99/Conty/master/steamfixer.sh"
		dos2unix "$steamfixer" 2>/dev/null
		chmod 777 "$steamfixer" 2>/dev/null
		chown -R batocera:batocera "$steamfixer" 2>/dev/null
# --
# Include steamfix.sh as /usr/bin/steamfix
steamfix="${bootstrap}"/usr/bin/steamfix
	rm "$steamfix" 2>/dev/null
	wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$steamfix" "https://raw.githubusercontent.com/trashbus99/Conty/master/steamfix.sh"
		dos2unix "$steamfix" 2>/dev/null
		chmod 777 "$steamfix" 2>/dev/null
		chown -R batocera:batocera "$steamfix" 2>/dev/null
# --
# Include steamlauncher as /usr/bin/steamlauncher
f="${bootstrap}"/usr/bin/steamlauncher
	rm "$f" 2>/dev/null
	echo '#!/bin/bash' >> $f
	echo 'killall -9 steam steamfix steamfixer 2>/dev/null' >> $f
	echo 'nohup /usr/bin/steamfixer 1>/dev/null 2>/dev/null &' >> $f
	echo 'DISPLAY=:0.0 dbus-run-session /usr/bin/steam "${@}"' >> $f
		chown -R batocera:batocera "$f" 2>/dev/null
		dos2unix "$f" 2>/dev/null
		chmod 777 "$f" 2>/dev/null
# --
# Include xbindkeys profile
home="${HOME}"
xbind="${HOME}/.xbindkeysrc"
	rm "$xbind" 2>/dev/null
	mkdir -p "$home" 2>/dev/null
		echo '# .xbindkeysrc' >> "$xbind"
		echo '"xdotool keydown ctrl click 1 keyup ctrl"' >> "$xbind"
		echo '  b:1 + Release' >> "$xbind"
		chown -R batocera:batocera "$xbind" 2>/dev/null
# --
home="${bootstrap}/home/batocera"
xbind="${bootstrap}/home/batocera/.xbindkeysrc"
	rm "$xbind" 2>/dev/null
	mkdir -p "$home" 2>/dev/null
		echo '# .xbindkeysrc' >> "$xbind"
		echo '"xdotool keydown ctrl click 1 keyup ctrl"' >> "$xbind"
		echo '  b:1 + Release' >> "$xbind"
		chown -R batocera:batocera "$xbind" 2>/dev/null
		chown -R batocera:batocera "${bootstrap}/home/batocera" 2>/dev/null
# --
# Include dbus fix (dbus session)
dbus="${bootstrap}/usr/bin/dbus"
	rm "$dbus" 2>/dev/null
		echo '#!/bin/bash' >> "$dbus"
		echo 'eval "$(dbus-launch --sh-syntax)' >> "$dbus"
		dos2unix "$dbus" 2>/dev/null && chmod 777 "$dbus" 2>/dev/null
		chown -R batocera:batocera "$dbus" 2>/dev/null

echo "Done"

if [ -f "${bootstrap}"/opt/bad_pkglist.txt ]; then
	echo
	echo "These packages are not in the repos and have not been installed:"
	cat "${bootstrap}"/opt/bad_pkglist.txt
	rm "${bootstrap}"/opt/bad_pkglist.txt
fi

if [ -f "${bootstrap}"/opt/bad_aur_pkglist.txt ]; then
	echo
	echo "These packages are either not in the AUR or yay failed to download their"
	echo "PKGBUILDs:"
	cat "${bootstrap}"/opt/bad_aur_pkglist.txt
	rm "${bootstrap}"/opt/bad_aur_pkglist.txt
fi

######################
######################
##                  ##
##   ENTER CHROOT   ##
##                  ##
######################
######################

# Root rights are required

if [ $EUID != 0 ]; then
    echo "Root rights are required!"

    exit 1
fi

script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

bootstrap="${script_dir}"/root.x86_64

if [ ! -d "${bootstrap}" ]; then
    echo "Bootstrap is missing"
    exit 1
fi

# First unmount just in case
umount -Rl "${bootstrap}"

mount --bind "${bootstrap}" "${bootstrap}"
mount -t proc /proc "${bootstrap}"/proc
mount --bind /sys "${bootstrap}"/sys
mount --make-rslave "${bootstrap}"/sys
mount --bind /dev "${bootstrap}"/dev
mount --bind /dev/pts "${bootstrap}"/dev/pts
mount --bind /dev/shm "${bootstrap}"/dev/shm
mount --make-rslave "${bootstrap}"/dev

rm -f "${bootstrap}"/etc/resolv.conf
cp /etc/resolv.conf "${bootstrap}"/etc/resolv.conf

mkdir -p "${bootstrap}"/run/shm

echo "Entering chroot"

# ------------------------------------------------------------------------------------------
# REBUILD LIBC WITH DT_HASH PATCH + ADDITIONAL FIXES
chroot "${bootstrap}" \
/usr/bin/env LANG=en_US.UTF-8 TERM=xterm PATH="/bin:/sbin:/usr/bin:/usr/sbin" /bin/bash -c \
"curl -Ls https://github.com/profork/profork/raw/master/steam/build/patch.sh | bash && exit"
# ------------------------------------------------------------------------------------------

echo "Exiting chroot"

umount -l "${bootstrap}"
umount "${bootstrap}"/proc
umount "${bootstrap}"/sys
umount "${bootstrap}"/dev/pts
umount "${bootstrap}"/dev/shm
umount "${bootstrap}"/dev
