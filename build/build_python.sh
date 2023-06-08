set -e

LD_LIBRARY_PATH="$(realpath .)" \
    QEMU_SET_ENV="LD_LIBRARY_PATH=$(realpath .)" \
    QEMU_LD_PREFIX="${TARGET_SYSROOT}" \
    make -j 8