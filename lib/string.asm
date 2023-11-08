struc strDef [data] {
    common
        . db data, 0
        .len = $ - .
}
