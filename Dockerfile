FROM archlinux:20200705
MAINTAINER feipyang <feipyang@gmail.com>
WORKDIR /
EXPOSE 443
EXPOSE 80

# Transfer pkgs
COPY pkgs /mnt/pkgs
COPY mirrorlist /etc/pacman.d/mirrorlist
RUN mkdir -p /opt/vc/bin/
COPY vcgencmd /opt/vc/bin/vcgencmd

# Install packages
RUN pacman -Sy && cd /mnt/pkgs && pacman -U kvmd-1.82-1-any.pkg.tar.xz kvmd-platform-v0-hdmiusb-x86-1.82-1-any.pkg.tar.xz kvmd-webterm-0.24-1-any.pkg.tar.zst  ttyd-1.6.1-2-x86_64.pkg.tar.xz  ustreamer-1.19-1-x86_64.pkg.tar.xz --noconfirm && pacman -S net-tools supervisor --noconfirm && chmod 777 /opt/vc/bin/vcgencmd
# Bug-fix, install inetutils for hostname command in web-terminal
RUN pacman -S inetutils --noconfirm

COPY nginx.conf /etc/kvmd/nginx/nginx.conf
COPY supervisord.conf /supervisord.conf
CMD ["/usr/bin/supervisord", "-c",  "/supervisord.conf"]
