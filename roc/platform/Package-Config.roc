platform examples/quicksort
    requires {}{ quicksort : List F64 -> List F64 }
    exposes []
    packages {}
    imports []
    provides [ mainForHost ]
    effects fx.Effect {}

mainForHost : List F64 -> List F64
mainForHost = \list -> quicksort list
