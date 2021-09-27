app "quicksort"
    packages { base: "platform" }
    imports []
    provides [ quicksort ] to base

quicksort = \originalList ->
    n = List.len originalList
    quicksortHelp originalList 0 (n - 1)

quicksortHelp : List (Num a), Nat, Nat -> List (Num a)
quicksortHelp = \list, low, high ->
    n = high - low + 1

    if n < 2 then
        list
    else 
        when partition high low (low + ((high - low) // 2 |> Result.withDefault 0)) list is
            Pair partitionIndex partitioned ->
                partitioned
                    |> quicksortHelp low (partitionIndex - 1)
                    |> quicksortHelp (partitionIndex + 1) high

partition : Nat, Nat, Nat, List (Num a) -> [ Pair Nat (List (Num a)) ]
partition = \high, low, pivotIndex, list ->
    swapped = (swap pivotIndex high list)
    when List.get swapped high is
        Ok pivotElement ->
            innerLoop high pivotElement low low swapped

        Err _ ->
            Pair 0 swapped

innerLoop : Nat, (Num a), Nat, Nat, List (Num a) -> [ Pair Nat (List (Num a)) ]
innerLoop = \high, pivotElement, i, si, list ->
    if i < high then
        when List.get list i is
            Ok x if x < pivotElement ->
                innerLoop high pivotElement (i + 1) (si + 1) (swap i si list)

            _ ->
                innerLoop high pivotElement (i + 1) si list

    else
        Pair si (swap si high list)



swap : Nat, Nat, List a -> List a
swap = \i, j, list -> List.swap list i j

# swap : Nat, Nat, List a -> List a
# swap = \i, j, list ->
#     when Pair (List.get list i) (List.get list j) is
#         Pair (Ok atI) (Ok atJ) ->
#             list
#                 |> List.set i atJ
#                 |> List.set j atI
# 
#         _ ->
#             list
