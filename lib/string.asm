struc strDef [data] {
    . db data, 0
    .len = $ - .
}
