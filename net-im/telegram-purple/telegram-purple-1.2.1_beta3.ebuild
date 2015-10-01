# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="git://github.com/majn/${PN}.git https://github.com/majn/${PN}.git"
fi

inherit autotools ${SCM}

DESCRIPTION="Libpurple (Pidgin) plugin for using a Telegram account"
HOMEPAGE="https://github.com/majn/telegram-purple"

MY_P=${P/_/-}
MY_PV=${PV/_/-}

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="
		https://github.com/majn/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
		https://github.com/majn/tgl/archive/master.tar.gz -> tgl_master_${PV}.tar.gz
		https://github.com/vysheng/tl-parser/archive/master.tar.gz -> tl-parser_master_${PV}.tar.gz
	"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
fi


LICENSE="GPL-2"
SLOT="0"
IUSE="webp"

DEPEND="
net-im/pidgin
dev-libs/openssl
dev-libs/glib:2
webp? ( media-libs/libwebp )
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack

		EGIT_REPO_URI="https://github.com/majn/tgl.git"
		cd ${S}
		unset ${PN}_LIVE_REPO
		EGIT_CHECKOUT_DIR=tgl
		git-r3_src_fetch
		git-r3_checkout

		EGIT_REPO_URI="https://github.com/vysheng/tl-parser"
		cd tgl
		unset ${PN}_LIVE_REPO
		EGIT_CHECKOUT_DIR=tl-parser
		git-r3_src_fetch
		git-r3_checkout
	else
		unpack ${P}.tar.gz
		cd ${S}
		rmdir tgl
		unpack "tgl_master_${PV}.tar.gz"
		mv tgl-master tgl

		cd tgl
		rmdir tl-parser
		unpack "tl-parser_master_${PV}.tar.gz"
		mv tl-parser-master tl-parser
	fi
}

src_configure() {
	pushd tgl
	econf
	popd
	econf \
		$(use_enable webp libwebp)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install
}
