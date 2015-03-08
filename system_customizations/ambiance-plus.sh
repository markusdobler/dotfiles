ORIG=/usr/share/themes/Ambiance
PLUS=${ORIG}-plus

[ -d ${PLUS} ] && echo "'${PLUS}' already exits" && exit

sudo cp -a "${ORIG}" "${PLUS}"
( cd "${PLUS}"; sudo patch -p 0 ) < ambiance-plus.patch
( cd "${PLUS}"; sudo patch -p 0 ) < ambiance-plus-14.10.patch

dconf write /org/gnome/desktop/wm/preferences/theme "'Ambiance-plus'"
dconf write /org/gnome/desktop/interface/gtk-theme "'Ambiance-plus'"

