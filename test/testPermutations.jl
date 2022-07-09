@testset verbose = true "summary for Permutation    " begin

    @testset "constructors" begin
        p1 = Permutation([1, 2, 3])
        @test p1.content[1] == 1 && p1.content[2] == 2 && p1.content[3] == 3
        p2 = Permutation(SimpleSortedBag([1, 2, 3]), 1)
        @test p2.content[1] == 1 && p2.content[2] == 2 && p2.content[3] == 3
        p3 = Permutation(SimpleSortedBag([1, 2, 3]), 6)
        @test p3.content[1] == 3 && p3.content[2] == 2 && p3.content[3] == 1
        p4 = Permutation(SimpleSortedBag([1, 2, 3]), FIRST)
        @test p4.content[1] == 1 && p4.content[2] == 2 && p4.content[3] == 3
        p5 = Permutation(SimpleSortedBag([1, 2, 3]), LAST)
        @test p5.content[1] == 3 && p5.content[2] == 2 && p5.content[3] == 1
        p6 = Permutation(SimpleSortedBag([1, 2]), RANDOM)
        @test (p6.content[1] == 1 && p6.content[2] == 2) || (p6.content[1] == 2 && p6.content[2] == 1)
    end

    empty1 = Permutation()
    empty2 = Permutation([])
    empty3 = Permutation(SimpleSortedBag([]), FIRST)
    filled1 = Permutation([1, 2, 3])
    filled2 = Permutation([1, 2, 3])
    reordered = Permutation([3, 1, 2])
    different1 = Permutation([1, 4, 3])
    different2 = Permutation([1, 2, 3, 1, 1, 2, 3])

    @testset "equivalence" begin
        @test empty1 == empty1
        @test empty1 == empty2
        @test empty1 == empty3
        @test filled1 == filled1
        @test filled1 == filled2
        @test filled1 != reordered
        @test filled1 != empty1
        @test filled1 != different1
        @test filled1 != different2
        @test different1 != different2

        @test isequal(empty1, empty1)
        @test isequal(empty1, empty2)
        @test isequal(empty1, empty3)
        @test isequal(filled1, filled1)
        @test isequal(filled1, filled2)
        @test !isequal(filled1, reordered)
        @test !isequal(filled1, empty1)
        @test !isequal(filled1, different1)
        @test !isequal(filled1, different2)
        @test !isequal(different1, different2)

        @test hash(empty1) == hash(empty1)
        @test hash(empty1) == hash(empty2)
        @test hash(empty1) == hash(empty3)
        @test hash(filled1) == hash(filled1)
        @test hash(filled1) == hash(filled2)
        @test hash(filled1) != hash(reordered)
        @test hash(filled1) != hash(empty1)
        @test hash(filled1) != hash(different1)
        @test hash(filled1) != hash(different2)
        @test hash(different1) != hash(different2)
    end

    @testset "copy" begin
        @test copy(filled1) == filled1
        @test copy(filled1) !== filled1
        @test copy(filled1).content == filled1.content
        @test copy(filled1).content !== filled1.content
        x = copy(filled1)
        x.content[2] = 5
        @test x != filled1
        @test x.content != filled1.content
        @test x.content !== filled1.content
    end

    @testset "isempty" begin
        @test isempty(empty1)
        @test isempty(empty2)
        @test isempty(empty3)
        @test !isempty(filled1)
        @test !isempty(filled2)
        @test !isempty(reordered)
        @test !isempty(different1)
        @test !isempty(different2)
    end

    @testset "length" begin
        @test length(empty1) == 0
        @test length(empty2) == 0 
        @test length(empty3) == 0 
        @test length(filled1) == 3
        @test length(filled2) == 3
        @test length(reordered) == 3
        @test length(different1) == 3
        @test length(different2) == 7
    end

    @testset "keys" begin
        @test keys(empty1) == []
        @test keys(empty2) == []
        @test keys(empty3) == []
        @test keys(filled1) == [1, 2, 3]
        @test keys(filled2) == [1, 2, 3]
        @test keys(reordered) == [1, 2, 3]
        @test keys(different1) == [1, 2, 3]
        @test keys(different2) == [1, 2, 3, 4, 5, 6, 7]
    end

    @testset "values" begin
        @test values(empty1) == []
        @test values(empty2) == []
        @test values(empty3) == []
        @test values(filled1) == [1, 2, 3]
        @test values(filled2) == [1, 2, 3]
        @test values(reordered) == [3, 1, 2]
        @test values(different1) == [1, 4, 3]
        @test values(different2) == [1, 2, 3, 1, 1, 2, 3]
    end

    @testset "getindex" begin
        @test different2[1] == 1
        @test different2[2] == 2
        @test different2[3] == 3
        @test different2[4] == 1
        @test different2[5] == 1
        @test different2[6] == 2
        @test different2[7] == 3
    end

    @testset "setindex!" begin
        x = Permutation([1, 2, 4, 8])
        x[1] = 3
        @test x == Permutation([3, 2, 4, 8])
        x[2] = 5
        @test x == Permutation([3, 5, 4, 8])
        x[3] = 2
        @test x == Permutation([3, 5, 2, 8])
        x[4] = 1
        @test x == Permutation([3, 5, 2, 1])
        @test_throws BoundsError x[5] == 1
    end

    @testset "first" begin
        @test first(reordered) == 3
        @test_throws BoundsError first(empty1) == 1
    end

    @testset "last" begin
        @test last(reordered) == 2
        @test_throws BoundsError last(empty1) == 1
    end

    @testset "pop!" begin
        p = Permutation([4, 3, 2])
        v = pop!(p)
        @test v == 2
        @test p == Permutation([4, 3])
        v = pop!(p)
        @test v == 3
        @test p == Permutation([4])
        v = pop!(p)
        @test v == 4
        @test p == Permutation([])
        @test_throws ArgumentError pop!(p) == 1
    end

    @testset "popfirst!" begin
        p = Permutation([4, 3, 2])
        v = popfirst!(p)
        @test v == 4
        @test p == Permutation([3, 2])
        v = popfirst!(p)
        @test v == 3
        @test p == Permutation([2])
        v = popfirst!(p)
        @test v == 2
        @test p == Permutation([])
        @test_throws ArgumentError popfirst!(p) == 1
    end

    @testset "push!" begin
        p = Permutation([4, 3, 2])
        push!(p, 6)
        @test p == Permutation([4, 3, 2, 6])
    end

    @testset "pushfirst!" begin
        p = Permutation([4, 3, 2])
        pushfirst!(p, 6)
        @test p == Permutation([6, 4, 3, 2])
    end

    @testset "append!" begin
        p1 = Permutation([4, 3, 2])
        p2 = Permutation([6, 7])
        append!(p1, p2)
        @test p1 == Permutation([4, 3, 2, 6, 7])
    end

    @testset "prepend!" begin
        p1 = Permutation([4, 3, 2])
        p2 = Permutation([6, 7])
        prepend!(p1, p2)
        @test p1 == Permutation([6, 7, 4, 3, 2])
    end

    @testset "isfirst" begin
        @test isfirst(Permutation([])) == true
        @test isfirst(Permutation([1])) == true
        @test isfirst(Permutation([1, 2])) == true
        @test isfirst(Permutation([2, 1])) == false
        @test isfirst(Permutation([1, 2, 3])) == true
        @test isfirst(Permutation([1, 3, 2])) == false
        @test isfirst(Permutation([2, 1, 3])) == false
        @test isfirst(Permutation([2, 3, 1])) == false
        @test isfirst(Permutation([3, 1, 2])) == false
        @test isfirst(Permutation([3, 2, 1])) == false

        @test isfirst(Permutation([1, 1, 2, 3])) == true
        @test isfirst(Permutation([1, 2, 3, 1])) == false
        @test isfirst(Permutation([3, 1, 1, 2])) == false
        @test isfirst(Permutation([3, 2, 1, 1])) == false

        @test isfirst(Permutation([1, 2, 2, 3])) == true
        @test isfirst(Permutation([1, 2, 3, 2])) == false
        @test isfirst(Permutation([2, 3, 2, 1])) == false
        @test isfirst(Permutation([3, 2, 2, 1])) == false

        @test isfirst(Permutation([1, 2, 3, 3])) == true
        @test isfirst(Permutation([2, 1, 3, 3])) == false
        @test isfirst(Permutation([3, 2, 3, 1])) == false
        @test isfirst(Permutation([3, 3, 2, 1])) == false
    end

    @testset "islast" begin
        @test islast(Permutation([])) == true
        @test islast(Permutation([1])) == true
        @test islast(Permutation([1, 2])) == false
        @test islast(Permutation([2, 1])) == true
        @test islast(Permutation([1, 2, 3])) == false
        @test islast(Permutation([1, 3, 2])) == false
        @test islast(Permutation([2, 1, 3])) == false
        @test islast(Permutation([2, 3, 1])) == false
        @test islast(Permutation([3, 1, 2])) == false
        @test islast(Permutation([3, 2, 1])) == true

        @test islast(Permutation([1, 1, 2, 3])) == false
        @test islast(Permutation([1, 2, 3, 1])) == false
        @test islast(Permutation([3, 1, 1, 2])) == false
        @test islast(Permutation([3, 2, 1, 1])) == true

        @test islast(Permutation([1, 2, 2, 3])) == false
        @test islast(Permutation([1, 2, 3, 2])) == false
        @test islast(Permutation([2, 3, 2, 1])) == false
        @test islast(Permutation([3, 2, 2, 1])) == true

        @test islast(Permutation([1, 2, 3, 3])) == false
        @test islast(Permutation([2, 1, 3, 3])) == false
        @test islast(Permutation([3, 2, 3, 1])) == false
        @test islast(Permutation([3, 3, 2, 1])) == true
    end

    @testset "firstpermutation" begin
        @test firstpermutation(SimpleSortedBag([])) == Permutation([])
        @test firstpermutation(SimpleSortedBag([1])) == Permutation([1])
        @test firstpermutation(SimpleSortedBag([1, 2])) == Permutation([1, 2])
        @test firstpermutation(SimpleSortedBag([1, 1])) == Permutation([1, 1])
        @test firstpermutation(SimpleSortedBag([3, 2, 1])) == Permutation([1, 2, 3])
    end

    @testset "lastpermutation" begin
        @test lastpermutation(SimpleSortedBag([])) == Permutation([])
        @test lastpermutation(SimpleSortedBag([1])) == Permutation([1])
        @test lastpermutation(SimpleSortedBag([1, 2])) == Permutation([2, 1])
        @test lastpermutation(SimpleSortedBag([1, 1])) == Permutation([1, 1])
        @test lastpermutation(SimpleSortedBag([1, 2, 3])) == Permutation([3, 2, 1])
    end

    @testset "randompermutation" begin
        @test randompermutation(SimpleSortedBag([])) == Permutation([])
        @test randompermutation(SimpleSortedBag([1])) == Permutation([1])
        s = SimpleSortedBag([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20])
        requiredlength = length(s)
        requiredsum = sum(s.content)
        p1 = randompermutation(s)
        p2 = randompermutation(s)
        p3 = randompermutation(s)
        p4 = randompermutation(s)
        allEqual = isequal(p1, p2) && isequal(p2, p3) && isequal(p3, p4)
        @test allEqual == false
        allLengthsEqual = length(p1) == requiredlength && length(p2) == requiredlength && length(p3) == requiredlength && length(p4) == requiredlength
        @test !isequal(p1, firstpermutation(s))
        @test !isequal(p1, lastpermutation(s))
        @test allLengthsEqual == true
        allSumsEqual = sum(p1.content) == requiredsum && sum(p2.content) == requiredsum && sum(p3.content) == requiredsum && sum(p4.content) == requiredsum
        @test allSumsEqual == true
    end

    @testset "npermutations" begin
        @test npermutations(SimpleSortedBag([])) == 1
        @test npermutations(SimpleSortedBag([1])) == 1
        @test npermutations(SimpleSortedBag([1, 2])) == 2
        @test npermutations(SimpleSortedBag([1, 2, 3])) == 6
        @test npermutations(SimpleSortedBag([1, 1, 2])) == 3
        @test npermutations(SimpleSortedBag([1, 2, 2])) == 3
        @test npermutations(SimpleSortedBag([1, 1, 1])) == 1
        @test npermutations(SimpleSortedBag([1, 2, 3, 4])) == 24
        @test npermutations(SimpleSortedBag([1, 1, 2, 3])) == 12
        @test npermutations(SimpleSortedBag([1, 2, 2, 3])) == 12
        @test npermutations(SimpleSortedBag([1, 2, 3, 3])) == 12
        @test npermutations(SimpleSortedBag([1, 1, 1, 2])) == 4
        @test npermutations(SimpleSortedBag([1, 2, 2, 2])) == 4
        @test npermutations(SimpleSortedBag([1, 1, 2, 2])) == 6
        @test npermutations(SimpleSortedBag([1, 1, 1, 1])) == 1
        @test npermutations(SimpleSortedBag([1, 1, 2, 3])) == 12
        @test npermutations(SimpleSortedBag([1, 1, 2, 2, 3, 3])) == 90
        @test npermutations(SimpleSortedBag([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])) == 3628800
        # https://medium.com/i-math/can-you-solve-the-mississippi-problem-6c0f3b02531
        @test npermutations(SimpleSortedBag(['M', 'I', 'S', 'S', 'I', 'S', 'S', 'I', 'P', 'P', 'I'])) == 34650 

        @test npermutations(Permutation([])) == 1
        @test npermutations(Permutation([1])) == 1
        @test npermutations(Permutation([1, 2])) == 2
        @test npermutations(Permutation([1, 2, 3])) == 6
        @test npermutations(Permutation([1, 1, 2])) == 3
        @test npermutations(Permutation([1, 2, 2])) == 3
        @test npermutations(Permutation([1, 1, 1])) == 1
        @test npermutations(Permutation([1, 2, 3, 4])) == 24
        @test npermutations(Permutation([1, 1, 2, 3])) == 12
        @test npermutations(Permutation([1, 2, 2, 3])) == 12
        @test npermutations(Permutation([1, 2, 3, 3])) == 12
        @test npermutations(Permutation([1, 1, 1, 2])) == 4
        @test npermutations(Permutation([1, 2, 2, 2])) == 4
        @test npermutations(Permutation([1, 1, 2, 2])) == 6
        @test npermutations(Permutation([1, 1, 1, 1])) == 1
        @test npermutations(Permutation([1, 1, 2, 3])) == 12
        @test npermutations(Permutation([1, 1, 2, 2, 3, 3])) == 90
        @test npermutations(Permutation([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])) == 3628800
        # https://medium.com/i-math/can-you-solve-the-mississippi-problem-6c0f3b02531
        @test npermutations(Permutation(['M', 'I', 'S', 'S', 'I', 'S', 'S', 'I', 'P', 'P', 'I'])) == 34650 
    end

    @testset "swapvalues" begin
        @test swapvalues(Permutation([1]), 1, 1) == Permutation([1])
        @test swapvalues(Permutation([1, 2]), 1, 2) == Permutation([2, 1])
        @test swapvalues(Permutation([1, 2]), 2, 1) == Permutation([2, 1])
        @test swapvalues(Permutation([4, 5, 6]), 4, 5) == Permutation([5, 4, 6])
        @test swapvalues(Permutation([4, 5, 6]), 4, 6) == Permutation([6, 5, 4])
        @test swapvalues(Permutation([4, 5, 6]), 5, 6) == Permutation([4, 6, 5])
        @test swapvalues(Permutation(['L', 'O', 'O', 'P']), 'L', 'P') == Permutation(['P', 'O', 'O', 'L'])
    end

    @testset "lexicographicindex" begin
        @test lexicographicindex(Permutation([])) == 1
        @test lexicographicindex(Permutation([1])) == 1
        @test lexicographicindex(Permutation([1, 1])) == 1
        @test lexicographicindex(Permutation([1, 2])) == 1
        @test lexicographicindex(Permutation([2, 1])) == 2
        @test lexicographicindex(Permutation([2, 2])) == 1
        @test lexicographicindex(Permutation([1, 2, 3])) == 1
        @test lexicographicindex(Permutation([1, 3, 2])) == 2
        @test lexicographicindex(Permutation([2, 1, 3])) == 3
        @test lexicographicindex(Permutation([2, 3, 1])) == 4
        @test lexicographicindex(Permutation([3, 1, 2])) == 5
        @test lexicographicindex(Permutation([3, 2, 1])) == 6 
        @test lexicographicindex(Permutation([1, 1, 2, 3])) == 1
        @test lexicographicindex(Permutation([1, 1, 3, 2])) == 2
        @test lexicographicindex(Permutation([1, 2, 1, 3])) == 3
        @test lexicographicindex(Permutation([1, 2, 3, 1])) == 4
        @test lexicographicindex(Permutation([1, 3, 1, 2])) == 5
        @test lexicographicindex(Permutation([1, 3, 2, 1])) == 6
        @test lexicographicindex(Permutation([2, 1, 1, 3])) == 7
        @test lexicographicindex(Permutation([2, 1, 3, 1])) == 8
        @test lexicographicindex(Permutation([2, 3, 1, 1])) == 9
        @test lexicographicindex(Permutation([3, 1, 1, 2])) == 10
        @test lexicographicindex(Permutation([3, 1, 2, 1])) == 11
        @test lexicographicindex(Permutation([3, 2, 1, 1])) == 12
        @test lexicographicindex(Permutation([4, 4, 5, 5, 6, 7, 7])) == 1
        @test lexicographicindex(Permutation([4, 4, 5, 5, 7, 6, 7])) == 2
        @test lexicographicindex(Permutation([4, 4, 5, 5, 7, 7, 6])) == 3
        @test lexicographicindex(Permutation([4, 4, 5, 6, 5, 7, 7])) == 4
        @test lexicographicindex(Permutation([4, 4, 5, 6, 7, 5, 7])) == 5
        @test lexicographicindex(Permutation([4, 4, 5, 6, 7, 7, 5])) == 6
        @test lexicographicindex(Permutation([4, 4, 5, 7, 5, 6, 7])) == 7
        @test lexicographicindex(Permutation([4, 4, 5, 7, 5, 7, 6])) == 8
        @test lexicographicindex(Permutation([4, 4, 5, 7, 6, 5, 7])) == 9
        @test lexicographicindex(Permutation([4, 4, 5, 7, 6, 7, 5])) == 10
        @test lexicographicindex(Permutation([4, 4, 5, 7, 7, 5, 6])) == 11
        @test lexicographicindex(Permutation([4, 4, 5, 7, 7, 6, 5])) == 12
        @test lexicographicindex(Permutation([5, 5, 4, 7, 6, 7, 4])) == 250
        @test lexicographicindex(Permutation([7, 4, 7, 4, 5, 6, 5])) == 500
        @test lexicographicindex(Permutation([7, 7, 6, 4, 4, 5, 5])) == 625
        @test lexicographicindex(Permutation([7, 7, 6, 5, 5, 4, 4])) == 630
        @test lexicographicindex(Permutation([2, 7, 8, 3, 9, 1, 5, 4, 6, 0])) == 1000000
        # https://www.quora.com/What-is-the-rank-of-the-word-MISSISSIPPI
        @test lexicographicindex(Permutation(['M', 'I', 'S', 'S', 'I', 'S', 'S', 'I', 'P', 'P', 'I'])) == 13737
    end


#=
    @testset "groupsizes" begin
        @test groupsizes([]) == Dict()
        @test groupsizes([1]) == Dict(1=>1)
        @test groupsizes([1, 2]) == Dict(1=>1, 2=>1)
        @test groupsizes([1, 1]) == Dict(1=>2)
        @test groupsizes([1, 2, 3]) == Dict(1=>1, 2=>1, 3=>1)
        @test groupsizes([1, 1, 2]) == Dict(1=>2, 2=>1)
        @test groupsizes([1, 2, 2]) == Dict(1=>1, 2=>2)
        @test groupsizes([1, 1, 1]) == Dict(1=>3)
        @test groupsizes([1, 2, 3, 4]) == Dict(1=>1, 2=>1, 3=>1, 4=>1)
        @test groupsizes([1, 1, 2, 3]) == Dict([1, 1, 2, 3])
        @test groupsizes([1, 2, 2, 3]) == Dict(1=>1, 2=>2, 3=>1)
        @test groupsizes([1, 2, 3, 3]) == Dict(1=>1, 2=>1, 3=>2)
        @test groupsizes([1, 1, 1, 2]) == Dict(1=>3, 2=>1)
        @test groupsizes([1, 2, 2, 2]) == Dict(1=>1, 2=>3)
        @test groupsizes([1, 1, 2, 2]) == Dict(1=>2, 2=>2)
        @test groupsizes([1, 1, 1, 1]) == Dict(1=>4)
    end
    =#




    @testset "permutation" begin

        @test permutation(SimpleSortedBag([]), 1) == Permutation([])
        @test permutation(SimpleSortedBag([1]), 1) == Permutation([1])
        @test permutation(SimpleSortedBag([1, 1]), 1) == Permutation([1, 1])
        @test permutation(SimpleSortedBag([1, 2]), 1) == Permutation([1, 2])
        @test permutation(SimpleSortedBag([1, 2]), 2) == Permutation([2, 1])
        @test permutation(SimpleSortedBag([2, 2]), 1) == Permutation([2, 2]) 
        @test permutation(SimpleSortedBag([1, 2, 3]), 1) == Permutation([1, 2, 3])
        @test permutation(SimpleSortedBag([1, 2, 3]), 2) == Permutation([1, 3, 2])
        @test permutation(SimpleSortedBag([1, 2, 3]), 3) == Permutation([2, 1, 3])
        @test permutation(SimpleSortedBag([1, 2, 3]), 4) == Permutation([2, 3, 1])
        @test permutation(SimpleSortedBag([1, 2, 3]), 5) == Permutation([3, 1, 2])
        @test permutation(SimpleSortedBag([1, 2, 3]), 6) == Permutation([3, 2, 1]) 
        @test permutation(SimpleSortedBag([1, 1, 2, 3]), 1) == Permutation([1, 1, 2, 3])
        @test permutation(SimpleSortedBag([1, 1, 2, 3]), 2) == Permutation([1, 1, 3, 2])
        @test permutation(SimpleSortedBag([1, 1, 2, 3]), 3) == Permutation([1, 2, 1, 3])
        @test permutation(SimpleSortedBag([1, 1, 2, 3]), 4) == Permutation([1, 2, 3, 1])
        @test permutation(SimpleSortedBag([1, 1, 2, 3]), 5) == Permutation([1, 3, 1, 2])
        @test permutation(SimpleSortedBag([1, 1, 2, 3]), 6) == Permutation([1, 3, 2, 1])
        @test permutation(SimpleSortedBag([1, 1, 2, 3]), 7) == Permutation([2, 1, 1, 3])
        @test permutation(SimpleSortedBag([1, 1, 2, 3]), 8) == Permutation([2, 1, 3, 1])
        @test permutation(SimpleSortedBag([1, 1, 2, 3]), 9) == Permutation([2, 3, 1, 1])
        @test permutation(SimpleSortedBag([1, 1, 2, 3]), 10) == Permutation([3, 1, 1, 2])
        @test permutation(SimpleSortedBag([1, 1, 2, 3]), 11) == Permutation([3, 1, 2, 1])
        @test permutation(SimpleSortedBag([1, 1, 2, 3]), 12) == Permutation([3, 2, 1, 1])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 1) == Permutation([4, 4, 5, 5, 6, 7, 7])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 2) == Permutation([4, 4, 5, 5, 7, 6, 7])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 3) == Permutation([4, 4, 5, 5, 7, 7, 6])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 4) == Permutation([4, 4, 5, 6, 5, 7, 7])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 5) == Permutation([4, 4, 5, 6, 7, 5, 7])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 6) == Permutation([4, 4, 5, 6, 7, 7, 5])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 7) == Permutation([4, 4, 5, 7, 5, 6, 7])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 8) == Permutation([4, 4, 5, 7, 5, 7, 6])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 9) == Permutation([4, 4, 5, 7, 6, 5, 7])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 10) == Permutation([4, 4, 5, 7, 6, 7, 5])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 11) == Permutation([4, 4, 5, 7, 7, 5, 6])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 12) == Permutation([4, 4, 5, 7, 7, 6, 5])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 250) == Permutation([5, 5, 4, 7, 6, 7, 4])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 500) == Permutation([7, 4, 7, 4, 5, 6, 5])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 625) == Permutation([7, 7, 6, 4, 4, 5, 5])
        @test permutation(SimpleSortedBag([4, 4, 5, 5, 6, 7, 7]), 630) == Permutation([7, 7, 6, 5, 5, 4, 4])
        @test permutation(SimpleSortedBag([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]), 1000000) == Permutation([2, 7, 8, 3, 9, 1, 5, 4, 6, 0])
        # https://www.quora.com/What-is-the-rank-of-the-word-MISSISSIPPI
        @test permutation(SimpleSortedBag(['I', 'I', 'I', 'I', 'M', 'P', 'P', 'S', 'S', 'S', 'S']), 13737) == Permutation(['M', 'I', 'S', 'S', 'I', 'S', 'S', 'I', 'P', 'P', 'I'])
        
    end

    @testset "SimpleSortedBag" begin
        @test SimpleSortedBag(Permutation([])) == SimpleSortedBag([])
        @test SimpleSortedBag(Permutation([1])) == SimpleSortedBag([1])
    #=    @test groupsizes([1, 2]) == Dict(1=>1, 2=>1)
        @test groupsizes([1, 1]) == Dict(1=>2)
        @test groupsizes([1, 2, 3]) == Dict(1=>1, 2=>1, 3=>1)
        @test groupsizes([1, 1, 2]) == Dict(1=>2, 2=>1)
        @test groupsizes([1, 2, 2]) == Dict(1=>1, 2=>2)
        @test groupsizes([1, 1, 1]) == Dict(1=>3)
        @test groupsizes([1, 2, 3, 4]) == Dict(1=>1, 2=>1, 3=>1, 4=>1)
        @test groupsizes([1, 1, 2, 3]) == Dict([1, 1, 2, 3])
        @test groupsizes([1, 2, 2, 3]) == Dict(1=>1, 2=>2, 3=>1)
        @test groupsizes([1, 2, 3, 3]) == Dict(1=>1, 2=>1, 3=>2)
        @test groupsizes([1, 1, 1, 2]) == Dict(1=>3, 2=>1)
        @test groupsizes([1, 2, 2, 2]) == Dict(1=>1, 2=>3)
        @test groupsizes([1, 1, 2, 2]) == Dict(1=>2, 2=>2)
        @test groupsizes([1, 1, 1, 1]) == Dict(1=>4) =#
    end

    @testset "speed" begin
        @time begin            
            bag = SimpleSortedBag([0, 1, 2, 3, 4, 5, 6, 7, 8, 2, 7])
            limit = npermutations(bag)
            @info "Limit set to ", limit

            @info "First"
            @time for i=1:limit
                perm = Permutation(bag, FIRST)
            end
            
            @info "Last"
            @time for i=1:limit
                perm = Permutation(bag, LAST)
            end

            @info "Random"
            @time for i=1:limit
                perm = Permutation(bag, RANDOM)
            end

            @info "Lexicographic - approximately 100x slower than FIRST for ~4M records"
            @time for i=1:limit
            #    perm = Permutation(bag, i)
            end

            @info "Iteration by next!"
            @time begin
                perm = Permutation(bag, FIRST)
                while !islast(perm)
                    next!(perm)
                end
            end
        end
    end

    @testset "nonincreasingsuffix" begin
        @test nonincreasingsuffix(Permutation([])) == 1
        @test nonincreasingsuffix(Permutation([1])) == 1
        @test nonincreasingsuffix(Permutation([1, 2])) == 2
        @test nonincreasingsuffix(Permutation([2, 1])) == 1
        @test nonincreasingsuffix(Permutation([1, 2, 3])) == 3
        @test nonincreasingsuffix(Permutation([1, 3, 2])) == 2
        @test nonincreasingsuffix(Permutation([2, 1, 3])) == 3
        @test nonincreasingsuffix(Permutation([2, 3, 1])) == 2
        @test nonincreasingsuffix(Permutation([3, 1, 2])) == 3
        @test nonincreasingsuffix(Permutation([3, 2, 1])) == 1

        @test nonincreasingsuffix(Permutation([1, 1, 2, 3])) == 4
        @test nonincreasingsuffix(Permutation([1, 1, 3, 2])) == 3
        @test nonincreasingsuffix(Permutation([1, 2, 1, 3])) == 4
        @test nonincreasingsuffix(Permutation([1, 2, 3, 1])) == 3
        @test nonincreasingsuffix(Permutation([1, 3, 1, 2])) == 4
        @test nonincreasingsuffix(Permutation([1, 3, 2, 1])) == 2

        @test nonincreasingsuffix(Permutation([2, 1, 1, 3])) == 4
        @test nonincreasingsuffix(Permutation([2, 1, 3, 1])) == 3
        @test nonincreasingsuffix(Permutation([2, 3, 1, 1])) == 2

        @test nonincreasingsuffix(Permutation([3, 1, 1, 2])) == 4
        @test nonincreasingsuffix(Permutation([3, 1, 2, 1])) == 3
        @test nonincreasingsuffix(Permutation([3, 2, 1, 1])) == 1
    end

    @testset "rightmostsuccessor" begin
        p1 = Permutation([0, 1, 2, 5, 3, 3, 0])
        nisIndex = nonincreasingsuffix(p1)
        @test nisIndex == 4
        pivotValue = p1[nisIndex - 1]
        @test pivotValue == 2
        rms = rightmostsuccessor(p1, pivotValue, nisIndex)
        @test rms == 6
    end

    @testset "next!" begin
        p1 = next!(Permutation([1, 4, 6, 2, 9, 5, 8, 7, 3])) == Permutation([1, 4, 6, 2, 9, 7, 3, 5, 8])

        bag = SimpleSortedBag([1, 2, 2, 3, 3, 4])
        p2 = Permutation(bag, FIRST)
        for i=1:npermutations(bag)
            @test p2 == Permutation(bag, i)
            if !islast(p2)
                next!(p2)
            end
        end

    end



end