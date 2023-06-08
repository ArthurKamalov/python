set -e


../configure \
  CFLAGS="-I${TARGET_SYSROOT}/usr/local/include -I${TARGET_SYSROOT}/usr/local/include/ncurses --sysroot=${TARGET_SYSROOT}" \
  LDFLAGS="${LDFLAGS} -L${TARGET_SYSROOT}/usr/local/lib --sysroot=${TARGET_SYSROOT}" \
  --build="${HOST}" \
  --host="${TARGET}" \
  --target="${TARGET}" \
  --with-build-python=/usr/local/bin/python3 \
	--enable-shared=no \
  --with-openssl="${TARGET_SYSROOT}/${OPENSSL_INSTALL_PREFIX}" \
	--with-readline=edit \
	--prefix="${PYTHON_INSTALL_PREFIX}" \
	--with-ensurepip=no \
	--enable-ipv6 \
	ac_cv_file__dev_ptmx=no \
	ac_cv_file__dev_ptc=no