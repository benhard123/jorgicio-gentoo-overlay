# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# USE="-* gtk2 gtk3 xfce" ebuild ${P}.ebuild clean compile
# cd ~portage/x11-themes/${P}/work
# make -j -C ${P}/common/gtk-3.0/3.18
# find ${P}/common/{gtk-2.0,gtk-3.0/3.*,xfwm4} -name "*.png" ! -path "*/menubar-toolbar/*" | xargs tar Jcvf /usr/portage/distfiles/${P}-pngs.tar.xz

inherit autotools

DESCRIPTION="A flat theme with transparent elements for GTK+3, GTK+2 and GNOME Shell"
HOMEPAGE="https://github.com/NicoHood/arc-theme"
SRC_URI="https://github.com/NicoHood/${PN}/releases/download/${PV}/${P}.tar.xz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="cinnamon gnome-shell +gtk2 +gtk3 mate xfce"

SASSC_DEPEND="
	dev-lang/sassc
"

SVG_DEPEND="
	media-gfx/inkscape
	media-gfx/optipng
"

# Supports various GTK+3 versions and uses pkg-config to determine which
# set of files to install. Updates will break it but only this fix will
# help. https://github.com/horst3180/arc-theme/pull/436
DEPEND="
	cinnamon? (
		${SASSC_DEPEND}
	)
	gnome-shell? (
		${SASSC_DEPEND}
	)
	gtk2? (
		${SVG_DEPEND}
	)
	gtk3? (
		${SASSC_DEPEND}
		${SVG_DEPEND}
		virtual/pkgconfig
		>=x11-libs/gtk+-3.18:3
	)
	xfce? (
		${SVG_DEPEND}
	)
"

# gnome-themes-standard is only needed by GTK+2 for the Adwaita
# engine. This engine is built into GTK+3.
RDEPEND="
	gtk2? (
		x11-themes/gnome-themes-standard
		x11-themes/gtk-engines-murrine
	)
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-openbox \
		--disable-plank \
		--disable-unity \
		$(use_enable cinnamon) \
		$(use_enable gtk2) \
		$(use_enable gtk3) \
		$(use_enable gnome-shell) \
		$(use_enable mate metacity) \
		$(use_enable xfce xfwm)
}
