#include <stdio.h>
#include <ffi.h>

void customFunction() {
    printf("Custom function called!\n");
}

int main() {
    ffi_cif cif;
    ffi_type *args[1];
    void *values[1];

    args[0] = &ffi_type_void;
    values[0] = NULL;

    if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 0, &ffi_type_void, args) == FFI_OK) {
        ffi_call(&cif, (void (*)())customFunction, values, NULL);
        return 0;
    }

    return 1;
}
