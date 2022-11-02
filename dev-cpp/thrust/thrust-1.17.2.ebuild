# Copyright 2022-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2 or later

EAPI=8

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/NVIDIA/${PN}.git"
fi

inherit cmake ${SCM}

DESCRIPTION="C++ Parallel Algorithms Library for CUDA, OpenMP and TBB"
HOMEPAGE="https://github.com/NVIDIA/thrust"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/NVIDIA/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="Apache-2.0-with-LLVM-exceptions Apache-2.0 Boost-1.0"
SLOT="0"
IUSE="cuda tbb"
REQUIRED_USE=""

RDEPEND="
cuda? ( dev-util/nvidia-cuda-toolkit )
tbb? ( dev-cpp/tbb )
"
DEPEND="${RDEPEND}"


src_configure() {
	local mycmakeargs=(
		-DTHRUST_ENABLE_TESTING=OFF
		-DTHRUST_ENABLE_MULTICONFIG=ON
		-DTHRUST_MULTICONFIG_ENABLE_SYSTEM_CPP=ON
		-DTHRUST_MULTICONFIG_ENABLE_SYSTEM_OMP=ON
		-DTHRUST_MULTICONFIG_ENABLE_SYSTEM_TBB=$(usex tbb ON OFF)
		-DTHRUST_MULTICONFIG_ENABLE_SYSTEM_CUDA=$(usex cuda ON OFF)
		-DTHRUST_INCLUDE_CUB_CMAKE=OFF
		-DTHRUST_INSTALL_CUB_HEADERS=OFF
	)

	cmake_src_configure
}
