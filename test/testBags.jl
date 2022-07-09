using Combinatorials

@testset verbose = true "summary for SimpleSortedBag" begin

    @testset "constructors" begin
        @test hash(SimpleSortedBag{Int}()) != 0
        @test hash(SimpleSortedBag([])) != 0
    end

    empty1 = SimpleSortedBag{Int}()
    empty2 = SimpleSortedBag{Int}()
    empty3 = SimpleSortedBag([])
    filled1 = SimpleSortedBag([1,2,3])
    filled2 = SimpleSortedBag([1,2,3])
    reordered = SimpleSortedBag([3,1,2])
    different1 = SimpleSortedBag([1,4,3])
    different2 = SimpleSortedBag([1,2,3,1,1,2,3])

    @testset "equivalence" begin
        @test empty1 == empty1
        @test empty1 == empty2
        @test empty1 == empty3
        @test filled1 == filled1
        @test filled1 == filled2
        @test filled1 == reordered
        @test filled1 != empty1
        @test filled1 != different1
        @test filled1 != different2
        @test different1 != different2

        @test isequal(empty1, empty1)
        @test isequal(empty1, empty2)
        @test isequal(empty1, empty3)
        @test isequal(filled1, filled1)
        @test isequal(filled1, filled2)
        @test isequal(filled1, reordered)
        @test !isequal(filled1, empty1)
        @test !isequal(filled1, different1)
        @test !isequal(filled1, different2)
        @test !isequal(different1, different2)

        @test hash(empty1) == hash(empty1)
        @test hash(empty1) == hash(empty2)
        @test hash(empty1) == hash(empty3)
        @test hash(filled1) == hash(filled1)
        @test hash(filled1) == hash(filled2)
        @test hash(filled1) == hash(reordered)
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
        @test keys(different1) == [1, 3, 4]
        @test keys(different2) == [1, 2, 3]
    end

    @testset "values" begin
        @test values(empty1) == []
        @test values(empty2) == []
        @test values(empty3) == []
        @test values(filled1) == [1, 2, 3]
        @test values(filled2) == [1, 2, 3]
        @test values(reordered) == [1, 2, 3]
        @test values(different1) == [1, 3, 4]
        @test values(different2) == [1, 1, 1, 2, 2, 3, 3]
    end

    @testset "getindex" begin
        @test different2[1] == 1
        @test different2[2] == 1
        @test different2[3] == 1
        @test different2[4] == 2
        @test different2[5] == 2
        @test different2[6] == 3
        @test different2[7] == 3
    end

    @testset "setindex!" begin
        x = SimpleSortedBag([1, 2, 4, 8])
        x[1] = 3
        @test x == SimpleSortedBag([2, 3, 4, 8])
        x[2] = 4
        @test x == SimpleSortedBag([2, 4, 4, 8])
        x[3] = 2
        @test x == SimpleSortedBag([2, 2, 4, 8])
        x[4] = 1
        @test x == SimpleSortedBag([1, 2, 2, 4])
        x[2] = 0
        @test x == SimpleSortedBag([0, 1, 2, 4])
        @test_throws BoundsError x[5] == 1
    end

    @testset "firstindex" begin
        @test firstindex(empty1) == 1
        @test firstindex(empty3) == 1
        @test firstindex(filled1) == 1
        @test firstindex(reordered) == 1
        @test firstindex(different2) == 1
    end

    @testset "lastindex" begin
        @test lastindex(empty1) == 0
        @test lastindex(empty3) == 0
        @test lastindex(filled1) == 3
        @test lastindex(reordered) == 3
        @test lastindex(different2) == 7
    end

    @testset "empty!" begin
        x = SimpleSortedBag([])
        empty!(x)
        @test x == SimpleSortedBag([])

        y = SimpleSortedBag([4, 5, 6, 7])
        empty!(y)
        @test y == SimpleSortedBag([])

        z = SimpleSortedBag([2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 7, 7, 7, 7, 7])
        empty!(z)
        @test isempty(z)
    end

    @testset "add!" begin
        x = SimpleSortedBag([])
        add!(x, 5)
        @test x == SimpleSortedBag([5])
        add!(x, 6)
        @test x == SimpleSortedBag([5, 6])
        add!(x, 5)
        @test x == SimpleSortedBag([5, 5, 6])
        add!(x, 7)
        @test x == SimpleSortedBag([5, 5, 6, 7])
        add!(x, 7)
        @test x == SimpleSortedBag([5, 5, 6, 7, 7])
        add!(x, 4)
        @test x == SimpleSortedBag([4, 5, 5, 6, 7, 7])

        y = SimpleSortedBag([])
        add!(y, 8, 3)
        @test y == SimpleSortedBag([8, 8, 8])
        add!(y, 3, 2)
        @test y == SimpleSortedBag([3, 3, 8, 8, 8])
        add!(y, 9, 2)
        @test y == SimpleSortedBag([3, 3, 8, 8, 8, 9, 9])
        add!(y, 8, 2)
        @test y == SimpleSortedBag([3, 3, 8, 8, 8, 8, 8, 9, 9])
        add!(y, 2, 2)
        @test y == SimpleSortedBag([2, 2, 3, 3, 8, 8, 8, 8, 8, 9, 9])
        add!(y, 2, 2)
        @test y == SimpleSortedBag([2, 2, 2, 2, 3, 3, 8, 8, 8, 8, 8, 9, 9])

        z = SimpleSortedBag([])
        add!(z, 5, 0)
        @test z == SimpleSortedBag([])
        add!(z, 6, 1)
        @test z == SimpleSortedBag([6])
        add!(z, 8, 1)
        @test z == SimpleSortedBag([6, 8])
        add!(z, 6, 1)
        @test z == SimpleSortedBag([6, 6, 8])
        add!(z, 9, 0)
        @test z == SimpleSortedBag([6, 6, 8])
        add!(z, 7, 0)
        @test z == SimpleSortedBag([6, 6, 8])
        add!(z, 6, 0)
        @test z == SimpleSortedBag([6, 6, 8])
        add!(z, 5, 0)
        @test z == SimpleSortedBag([6, 6, 8])
    end

    @testset "remove!" begin
        x = SimpleSortedBag([4, 5, 6, 7])
        remove!(x, 5)
        @test x == SimpleSortedBag([4, 6, 7])
        remove!(x, 7)
        @test x == SimpleSortedBag([4, 6])
        remove!(x, 4)
        @test x == SimpleSortedBag([6])
        remove!(x, 6)
        @test x == SimpleSortedBag([])
        @test_throws KeyError remove!(x, 6)

        y = SimpleSortedBag([2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 7, 7, 7, 7, 7])
        @test_throws KeyError remove!(y, 4)
        @test_throws KeyError remove!(y, 4, 1)
        @test_throws KeyError remove!(y, 4, 2)
        @test_throws KeyError remove!(y, 2, 6)
        @test_throws KeyError remove!(y, 2, 7)
        @test_throws KeyError remove!(y, 3, 7)
        @test_throws KeyError remove!(y, 3, 8)
        @test_throws KeyError remove!(y, 3, 11)
        @test_throws KeyError remove!(y, 3, 12)
        @test_throws KeyError remove!(y, 3, 13)
        @test_throws KeyError remove!(y, 7, 6)
        remove!(y, 2, 3)
        @test y == SimpleSortedBag([2, 2, 3, 3, 3, 3, 3, 3, 7, 7, 7, 7, 7])
        remove!(y, 3, 5)
        @test y == SimpleSortedBag([2, 2, 3, 7, 7, 7, 7, 7])
        remove!(y, 7, 2)
        @test y == SimpleSortedBag([2, 2, 3, 7, 7, 7])
        remove!(y, 7, 3)
        @test y == SimpleSortedBag([2, 2, 3])
        remove!(y, 2, 2)
        @test y == SimpleSortedBag([3])
        remove!(y, 3, 1)
        @test y == SimpleSortedBag([])
    end

    @testset "removeall!" begin
        x = SimpleSortedBag([4, 5, 6, 7])
        removeall!(x, 5)
        @test x == SimpleSortedBag([4, 6, 7])
        removeall!(x, 7)
        @test x == SimpleSortedBag([4, 6])
        removeall!(x, 4)
        @test x == SimpleSortedBag([6])
        removeall!(x, 6)
        @test x == SimpleSortedBag([])
        @test_throws KeyError removeall!(x, 6)

        y = SimpleSortedBag([2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 7, 7, 7, 7, 7])
        @test_throws KeyError removeall!(y, 4)
        removeall!(y, 2)
        @test y == SimpleSortedBag([3, 3, 3, 3, 3, 3, 7, 7, 7, 7, 7])
        removeall!(y, 7)
        @test y == SimpleSortedBag([3, 3, 3, 3, 3, 3])
        removeall!(y, 3)
        @test y == SimpleSortedBag([])
    end

    @testset "multiplicities" begin
        @test multiplicities(SimpleSortedBag([])) == [0]
        @test multiplicities(SimpleSortedBag([1])) == [1]
        @test multiplicities(SimpleSortedBag([1, 2])) == [1, 1]
        @test multiplicities(SimpleSortedBag([1, 1])) == [2]
        @test multiplicities(SimpleSortedBag([1, 2, 3])) == [1, 1, 1]
        @test multiplicities(SimpleSortedBag([1, 1, 2])) == [2, 1]
        @test multiplicities(SimpleSortedBag([1, 2, 2])) == [1, 2]
        @test multiplicities(SimpleSortedBag([1, 1, 1])) == [3]
        @test multiplicities(SimpleSortedBag([1, 2, 3, 4])) == [1, 1, 1, 1]
        @test multiplicities(SimpleSortedBag([1, 1, 2, 3])) == [2, 1, 1]
        @test multiplicities(SimpleSortedBag([1, 2, 2, 3])) == [1, 2, 1]
        @test multiplicities(SimpleSortedBag([1, 2, 3, 3])) == [1, 1, 2]
        @test multiplicities(SimpleSortedBag([1, 1, 1, 2])) == [3, 1]
        @test multiplicities(SimpleSortedBag([1, 2, 2, 2])) == [1, 3]
        @test multiplicities(SimpleSortedBag([1, 1, 2, 2])) == [2, 2]
        @test multiplicities(SimpleSortedBag([1, 1, 1, 1])) == [4]    
    end

    @testset "Set" begin
        @test Set(SimpleSortedBag([])) == Set([])
        @test Set(SimpleSortedBag([3, 4, 5])) == Set([3, 4, 5])
        @test Set(SimpleSortedBag([4, 4, 5, 5, 5, 7, 8, 8, 8, 10])) == Set([4, 5, 7, 8, 10])
    end

end



