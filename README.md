# Combinatorials.jl

`Combinatorials.jl` is a library written in Julia language and performs permutations on an array.

It contains two important structures
 - `SimpleSortedBag` implements a multiset (bag) containing lexicographically sorted elements
 - `Permutation` holds a permutation of elements

# Example
```julia
permutation = Permutation([1, 4, 3])      # creates a new permutation
println(permutation)                      # prints [1, 4, 3]
println(lexicographicindex(permutation))  # prints 2
next!(permutation)                        # changes the permutation to the nex one in the lexikographic order
println(permutation)                      # prints [3, 1, 4]
println(lexicographicindex(permutation))  # prints 3
```

# How to run tests
In Julia REPL press `]`.
Type `test` and press `Enter`.
