set -e

SCRIPT_PATH="$(realpath "${0}")"
SOURCE_ROOT="$(dirname "${SCRIPT_PATH}")"
BUILD_DIR="${SOURCE_ROOT}/build"
IMAGE_NAME="python_test"

TARGET="${1}"
shift


DISTRO="alpine"
XZ_VERSION="5.2.6"
ZLIB_VERSION="1.2.13"
BZIP_VERSION="1.0.8"
UTIL_LINUX_VERSION="2.38"
NCURSES_VERSION="6.3"
LIBFFI_VERSION="3.4.2"
OPENSSL_1_VERSION="1.1.1s"
OPENSSL_3_VERSION="3.0.7"
LIBEDIT_VERSION_COMMIT="0cdd83b3ebd069c1dee21d81d6bf716cae7bf5da"  # tag - "upstream/3.1-20221030"
TCL_VERSION_COMMIT="338c6692672696a76b6cb4073820426406c6f3f9" # tag - "core-8-6-13"}"
SQLITE_VERSION_COMMIT="e671c4fbc057f8b1505655126eaf90640149ced6"  # tag - "version-3.41.2"


case "${TARGET}" in
  x86_64-*-*-*)
    IMAGE_PLATFORM="linux/amd64"
    ;;
  *aarch64-*-*-*)
    IMAGE_PLATFORM="linux/arm64/v8"
  ;;
  *armv7-*-*-*)
    IMAGE_PLATFORM="linux/arm/v7"
  ;;
  *)
    echo -e "Can not determine CPU architecture by HOST: '${TARGET}'"
    exit 1
  ;;
esac

case "${TARGET}" in
  *-*-*-gnu*)
    DISTRO="ubuntu"
    HOST="x86_64-unknown-linux-gnu"

    ;;
  *-*-*-musl*)
    DISTRO="alpine"
    HOST="x86_64-unknown-linux-musl"
  ;;
  *)
    echo -e "Can not determine distro by HOST: '${HOST}'"
    exit 1
  ;;
esac

BASE_IMAGE="ghcr.io/arthurkamalov/toolchains/dev/${HOST}_${TARGET}:cce01b7f6eede97383d76d67fb6f8bab187643af"

docker buildx build -t "${IMAGE_NAME}" \
  --build-arg "BASE_IMAGE=${BASE_IMAGE}" \
  --build-arg "TARGET=${TARGET}" \
  --build-arg "HOST=${HOST}" \
  --build-arg "DISTRO=${DISTRO}" \
  --build-arg "XZ_VERSION=${XZ_VERSION}" \
  --build-arg "ZLIB_VERSION=${ZLIB_VERSION}" \
  --build-arg "BZIP_VERSION=${BZIP_VERSION}" \
  --build-arg "UTIL_LINUX_VERSION=${UTIL_LINUX_VERSION}" \
  --build-arg "NCURSES_VERSION=${NCURSES_VERSION}" \
  --build-arg "LIBFFI_VERSION=${LIBFFI_VERSION}" \
  --build-arg "OPENSSL_1_VERSION=${OPENSSL_1_VERSION}" \
  --build-arg "OPENSSL_3_VERSION=${OPENSSL_3_VERSION}" \
  --build-arg "LIBEDIT_VERSION_COMMIT=${LIBEDIT_VERSION_COMMIT}" \
  --build-arg "TCL_VERSION_COMMIT=${TCL_VERSION_COMMIT}" \
  --build-arg "SQLITE_VERSION_COMMIT=${SQLITE_VERSION_COMMIT}" \
  --build-arg "IMAGE_PLATFORM=${IMAGE_PLATFORM}" \
   --load \
   --progress=plain \
   "$@" \
  "${BUILD_DIR}"
