# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ar be bg bn ca cs da de el en_GB es et eu fa fi fo fr gl he hr hu id
is it ja kk km ko lg lt lv ms nl pa pl pt pt_BR ro ru si sk sl sr sr@latin sv
te th tr tt_RU ug uk vi zh_CN zh_TW"
PLOCALE_BACKUP="en_GB"

inherit eutils xdg-utils l10n readme.gentoo-r1

MY_PV="${PV/_/}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Fast lightweight tabbed filemanager"
HOMEPAGE="https://wiki.lxde.org/en/PCManFM"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"
#SRC_URI="https://git.lxde.org/gitweb/?p=lxde/pcmanfm.git;a=snapshot;h=83b74b2fe78f449b37f5c511070a3fc1d5b6ee12;sf=tbz2"
SRC_URI="https://sourceforge.net/projects/pcmanfm/files/PCManFM%20%2B%20Libfm%20%28tarball%20release%29/PCManFM/pcmanfm-1.3.1.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~mips ppc x86"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.18:2
	>=x11-libs/gtk+-2.16:2
	>=lxde-base/menu-cache-0.3.2
	x11-misc/shared-mime-info
	>=x11-libs/libfm-${PV}:=[gtk(+)]
	virtual/eject
	virtual/freedesktop-icon-theme"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	sys-devel/gettext"

S="${WORKDIR}"/${MY_P}

#PATCHES=( "${FILESDIR}"/${PN}-1.2.5-CVE-2017-8934.patch )

src_prepare() {
	default

	export LINGUAS="${LINGUAS:-${PLOCALE_BACKUP}}"
	l10n_get_locales > po/LINGUAS || die
}

src_configure() {
	econf \
		--sysconfdir="${EPREFIX}"/etc \
		$(use_enable debug)
}

src_install() {
	default

	local DOC_CONTENTS="PCmanFM can optionally support the menu://applications/
	location. You should install lxde-base/lxmenu-data for that functionality."
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
