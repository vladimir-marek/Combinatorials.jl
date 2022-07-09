import Base: ==, hash, copy, isempty, length, keys, values, iterate, getindex, setindex!, firstindex, lastindex, empty!, Set, KeyError

struct SimpleSortedBag{T}
    content::Vector{T}
    function SimpleSortedBag(content::Vector{T}) where {T}
        newContent = sort(content)
        new{T}(newContent)
    end
    function SimpleSortedBag{T}() where {T}
        SimpleSortedBag([])
    end
end

# begin: imported functions

function ==(bag1::SimpleSortedBag, bag2::SimpleSortedBag)
    return isequal(bag1.content, bag2.content)
end

function hash(bag::SimpleSortedBag)
    return hash(bag.content)
end

function copy(bag::SimpleSortedBag)
    return SimpleSortedBag(bag.content)
end

function isempty(bag::SimpleSortedBag)
    return isempty(bag.content)
end

function length(bag::SimpleSortedBag)
    return length(bag.content)
end

function keys(bag::SimpleSortedBag)
    return values(unique(bag.content))
end

function values(bag::SimpleSortedBag)
    return values(bag.content)
end

function getindex(bag::SimpleSortedBag, index::Int)
    return bag.content[index]
end

function setindex!(bag::SimpleSortedBag, value, index::Int)
    deleteat!(bag.content, index)
    for i=1:length(bag.content)
        if bag[i] >= value
            insert!(bag.content, i, value)
            return bag
        end
    end
    push!(bag.content, value)
    return bag
    # slow implementation:
    #   bag.content[i] = v
    #   sort!(bag.content)
end

function iterate(bag::SimpleSortedBag)
    return iterate(bag.content)
end

function iterate(bag::SimpleSortedBag, state)
    return iterate(bag.content, state)
end

function firstindex(bag::SimpleSortedBag)
    return firstindex(bag.content)
end

function lastindex(bag::SimpleSortedBag)
    return lastindex(bag.content)
end

function empty!(bag::SimpleSortedBag)
    empty!(bag.content)
end

function Set(bag::SimpleSortedBag)
    return Set(bag.content)
end

# end: imported functions

function insertatindex(bag::SimpleSortedBag, index::Int, value, multiplicity=1)
    for i=1:multiplicity
        insert!(bag.content, index, value)
    end
end

function add!(bag::SimpleSortedBag, value, multiplicity=1)
    for i=1:length(bag.content)
        if bag[i] >= value
            insertatindex(bag, i, value, multiplicity)
            return bag
        end
    end
    insertatindex(bag, length(bag.content) + 1, value, multiplicity)
    return bag
end

function remove!(bag::SimpleSortedBag, value, multiplicity=1)
    indexFirst = findfirst(isequal(value), bag.content)
    if isnothing(indexFirst)
        throw(KeyError(value))
    end
    indexLast = indexFirst + multiplicity - 1
    if indexLast>length(bag.content) || bag.content[indexLast]!=value
        throw(KeyError(value))
    end
    deleteat!(bag.content, indexFirst:indexLast)
end

function remove(bag::SimpleSortedBag, value, multiplicity=1)
    newBag = copy(bag)
    remove!(newBag, value, multiplicity)
    return newBag
end

function removeall!(bag::SimpleSortedBag, value)
    indexFirst = findfirst(isequal(value), bag.content)
    if isnothing(indexFirst)
        throw(KeyError(value))
    end
    indexLast = findlast(isequal(value), bag.content)
    deleteat!(bag.content, indexFirst:indexLast)
end

function removeall(bag::SimpleSortedBag, value)
    newBag = copy(bag)
    removeall!(newBag, value)
    return newBag
end

function multiplicities(bag::SimpleSortedBag)
    result = Int[]
    counter = 1
    for i = 1:length(bag) - 1
        if bag[i] == bag[i+1]
            counter = counter + 1
        else
            push!(result, counter)
            counter = 1
        end
    end
    if isempty(bag)
        counter = 0
    end
    push!(result, counter)
    return result
end

export SimpleSortedBag
export add!
export remove!
export remove
export removeall!
export removeall
export multiplicities
