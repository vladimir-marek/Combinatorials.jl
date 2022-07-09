import Base: ==, hash, copy, isempty, length, keys, values, iterate, getindex, setindex!, first, last, pop!, popfirst!, push!, pushfirst!, append!, prepend!

@enum Rank begin
    FIRST
    LAST
    RANDOM
end

struct Permutation{T}
    content::Vector{T}
    function Permutation()
        new{Any}([])
    end
    function Permutation(content::Vector{T}) where {T}
        new{T}(copy(content))
    end
    function Permutation(bag::SimpleSortedBag{T}, lexicographicIndex::Int) where {T}
        permutation(bag, lexicographicIndex)
    end
    function Permutation(bag::SimpleSortedBag{T}, rank::Rank) where {T}
        if rank == FIRST
            return firstpermutation(bag)
        elseif rank == LAST
            return lastpermutation(bag)
        elseif rank == RANDOM
            return randompermutation(bag)
        end
    end
end

# begin: imported functions

function ==(perm1::Permutation, perm2::Permutation)
    return isequal(perm1.content, perm2.content)
end

function hash(perm::Permutation)
    return hash(perm.content)
end

function copy(perm::Permutation)
    return Permutation(perm.content)
end

function isempty(perm::Permutation)
    return isempty(perm.content)
end

function length(perm::Permutation)
    return length(perm.content)
end

function keys(perm::Permutation)
    return keys(perm.content)
end

function values(perm::Permutation)
    return values(perm.content)
end

function iterate(perm::Permutation)
    return iterate(perm.content)
end

function iterate(perm::Permutation, state)
    return iterate(perm.content, state)
end

function getindex(perm::Permutation, index::Int)
    return perm.content[index]
end

function setindex!(perm::Permutation, value, index::Int)
    perm.content[index] = value
end

function first(perm::Permutation)
    return first(perm.content)
end

function last(perm::Permutation)
    return last(perm.content)
end

function pop!(perm::Permutation)
    return pop!(perm.content)
end

function popfirst!(perm::Permutation)
    return popfirst!(perm.content)
end

function push!(perm::Permutation, v)
    return push!(perm.content, v)
end

function pushfirst!(perm::Permutation, v)
    return pushfirst!(perm.content, v)
end

function append!(perm::Permutation, perm2::Permutation)
    return append!(perm.content, perm2.content)
end

function prepend!(perm::Permutation, perm2::Permutation)
    return prepend!(perm.content, perm2)
end

# end: imported functions

function isfirst(perm::Permutation)
    for i = 1:length(perm.content)-1
        if perm.content[i] > perm.content[i+1]
            return false
        end
    end
    return true
end

function islast(perm::Permutation)
    for i = 1:length(perm.content)-1
        if perm.content[i] < perm.content[i+1]
            return false
        end
    end
    return true
end

function firstpermutation(bag::SimpleSortedBag)
    return Permutation(bag.content)
end

function lastpermutation(bag::SimpleSortedBag)
    return Permutation(sort(bag.content, rev=true))
end

function randompermutation(bag::SimpleSortedBag)
    newBag = copy(bag)
    result = Permutation([])
    while !isempty(newBag)
        index = rand(1:length(newBag))
        value = splice!(newBag.content, index)
        push!(result, value)
    end
    return result
end

function npermutations(bag::SimpleSortedBag)
    mults = multiplicities(bag)
    numerator = factorial(sum(mults))
    denominator = 1
    for mult in mults
        denominator = denominator * factorial(mult)
    end
    result = numerator ÷ denominator
    return result
end

function npermutations(perm::Permutation)
    bag::SimpleSortedBag = SimpleSortedBag(perm)
    return npermutations(bag)
end

function swapindexes!(perm::Permutation, index1::Int, index2::Int)
    if index1==index2
        return perm
    end
    tmp = perm.content[index2]
    perm.content[index2] = perm.content[index1]
    perm.content[index1] = tmp
    return perm
end

function swapindexes(perm::Permutation, index1::Int, index2::Int)
    newperm = copy(perm)
    swapindexes!(newperm, elem1, elem2)
    return newperm
end

function swapvalues!(perm::Permutation, value1, value2)
    index1 = findfirst(x -> x==value1, perm.content)
    index2 = findfirst(x -> x==value2, perm.content)
    swapindexes!(perm, index1, index2)
    return perm
end

function swapvalues(perm::Permutation, value1, value2)
    newperm = copy(perm)
    swapvalues!(newperm, value1, value2)
    return newperm
end

function lexicographicindexzero(perm::Permutation)
    if isempty(perm)
        return 0
    end
    firstElement = first(perm)
    sortedKeys = keys(SimpleSortedBag(perm))
    totalSkippedItems = 0
    for key in sortedKeys
        if key < firstElement
            subPermutation = swapvalues(perm, firstElement, key)
            popfirst!(subPermutation)
            skippedItems = npermutations(subPermutation)
            totalSkippedItems += skippedItems
        elseif key == firstElement
            subPermutation = copy(perm)
            popfirst!(subPermutation)
            skippedItems = lexicographicindexzero(subPermutation)
            totalSkippedItems += skippedItems
            return totalSkippedItems
        else
            throw(OverflowError("this cannot happen #1"))
        end
    end
    throw(OverflowError("this cannot happen #2"))
end

function lexicographicindex(perm::Permutation)
    return lexicographicindexzero(perm) + 1
end

function removekey!(groupSizes, key)
    if groupSizes[key] > 1
        groupSizes[key] = groupSizes[key] - 1
    else
        delete!(groupSizes, key)
    end
end

function removekey(groupSizes, key)
    newGroupSizes = copy(groupSizes)
    removekey!(newGroupSizes, key)
    return newGroupSizes
end

function permutationzero(bag::SimpleSortedBag, lexicographicIndexZero::Int)
    if lexicographicIndexZero < 0
        throw(ArgumentError("lexicographicIndexZero must be greater or equal to 0"))
    end
    firstPermutation = firstpermutation(bag)
    if lexicographicIndexZero == 0
        return firstPermutation
    end    
    totalSkippedItems = 0
    result = Permutation([])
    firstElement = first(firstPermutation)
    for key in keys(bag)
        subPermutation = swapvalues(firstPermutation, firstElement, key)
        popfirst!(subPermutation)
        skippedItems = npermutations(subPermutation)

        if totalSkippedItems + skippedItems > lexicographicIndexZero
            push!(result, key)
            subBag = remove(bag, key)
            remaining = permutationzero(subBag, lexicographicIndexZero - totalSkippedItems)
            append!(result, remaining)
            return result
        else
            totalSkippedItems += skippedItems
        end
    end
    throw(ArgumentError("Lexicographis index is too big, there is no such permutation."))
end

function permutation(bag::SimpleSortedBag, lexicographicIndex::Int)
    lexicographicIndex = lexicographicIndex - 1
    return permutationzero(bag, lexicographicIndex)
end

function nonincreasingsuffix(perm::Permutation)
    for i=length(perm.content)-1:-1:1
        if perm.content[i] < perm.content[i+1]
            return i+1
        end
    end
    return 1
end

function rightmostsuccessor(perm::Permutation, pivotValue, nisIndex::Int)
    for i = length(perm.content):-1:nisIndex
        currentValue = perm[i]
        if currentValue > pivotValue
            return i
        end
    end
    throw(OverflowError("righmostsuccessor not found"))
end

function reversesuffix!(perm::Permutation, nisIndex::Int)
    len = length(perm.content)
    if nisIndex==len
        return perm
    end
    i1 = nisIndex
    i2 = len
    while i1 < i2
        swapindexes!(perm, i1, i2)
        i1 = i1 + 1
        i2 = i2 - 1
    end
    return perm
end


function next!(perm::Permutation)
    # https://www.nayuki.io/page/next-lexicographical-permutation-algorithm
    # https://www.baeldung.com/cs/array-generate-all-permutations
    # https://seriouscomputerist.atariverse.com/media/pdf/book/Discipline%20of%20Programming.pdf
    # 146295873 -> 146297358
    nisIndex = nonincreasingsuffix(perm)
    if (nisIndex == 1)
        return throw(OverflowError("There is no next permutation."))
    end
    pivotIndex = nisIndex - 1
    pivotValue = perm[pivotIndex]
    rmsIndex = rightmostsuccessor(perm, pivotValue, nisIndex)
    #@info perm
    #@info "pivotIndex=", pivotIndex, ", pivotValue=", pivotValue, "nisIndex=", nisIndex, ", rmsIndex=", rmsIndex
    swapindexes!(perm, pivotIndex, rmsIndex)
    #@info "po swap=", perm
    reversesuffix!(perm, nisIndex)
    #@info "po reverse=", perm
    return perm
end

function prev(perm)
    # tbd
end

function SimpleSortedBag(perm::Permutation)
    return SimpleSortedBag(perm.content)
end

export Rank, FIRST, LAST, RANDOM
export Permutation
export isfirst
export islast
export next
export prev
export npermutations
export firstpermutation
export lastpermutation
export randompermutation
export swapvalues
export lexicographicindex
export permutation
export nonincreasingsuffix
export rightmostsuccessor
export next!
export SimpleSortedBag
