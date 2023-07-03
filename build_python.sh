set -e

SCRIPT_PATH="$(realpath "${0}")"
SOURCE_ROOT="$(dirname "${SCRIPT_PATH}")"
BUILD_DIR="${SOURCE_ROOT}/build"
IMAGE_NAME="python_test"

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

TARGET="${1}"
shift

IFS=- read -r TARGET_CPU TARGET_VENDOR TARGET_OS TARGET_LIBC_ABI <<< "${TARGET}"

case "${TARGET_LIBC_ABI}" in
  gnu*)
    TARGET_LIBC="gnu"
    ;;
  musl*)
    TARGET_LIBC="musl"
  ;;
  *)
    echo -e "Can not determine TARGET LIBC and TARGET ABI from TARGET: '${TARGET}'"
    exit 1
  ;;
esac

TARGET_ABI="${TARGET_LIBC_ABI//$TARGET_LIBC/}"

RECONSTRUCTED_TARGET="${TARGET_CPU}-${TARGET_VENDOR}-${TARGET_OS}-${TARGET_LIBC}${TARGET_ABI}"
if [ "${TARGET}" != "${RECONSTRUCTED_TARGET}" ]; then
  echo -e "TARGET - '${TARGET}' is  parsed incorrectly, result: ${RECONSTRUCTED_TARGET}"
  exit 1
fi

case "${TARGET_CPU}" in
  x86_64)
    IMAGE_PLATFORM="linux/amd64"
    ;;
  aarch64)
    IMAGE_PLATFORM="linux/arm64/v8"
  ;;
  armv7)
    IMAGE_PLATFORM="linux/arm/v7"
  ;;
  *)
    echo -e "Can not determine CPU architecture by TARGET_CPU: '${TARGET_CPU}'"
    exit 1
  ;;
esac


#echo "${IMAGE_PLATFORM}"
#exit 1

docker buildx build -t "${IMAGE_NAME}" \
  --build-arg "TARGET_CPU=${TARGET_CPU}" \
  --build-arg "TARGET_VENDOR=${TARGET_VENDOR}" \
  --build-arg "TARGET_OS=${TARGET_OS}" \
  --build-arg "TARGET_LIBC=${TARGET_LIBC}" \
  --build-arg "TARGET_ABI=${TARGET_ABI}" \
  --build-arg "IMAGE_PLATFORM=${IMAGE_PLATFORM}" \
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
   --load \
   --progress=plain \
   --cache-to type=local,dest=/Users/arthur/PycharmProjects/python/cache \
   "$@" \
  "${BUILD_DIR}"
