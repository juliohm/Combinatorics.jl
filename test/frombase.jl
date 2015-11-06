using Combinatorics
using Base.Test

import Combinatorics: isperm, invperm, ipermute!, combinations, nthperm,
    nthperm!, parity, permute!, permutations, levicivita

p = shuffle([1:1000;])
@test isperm(p)
@test all(invperm(invperm(p)) .== p)

push!(p, 1)
@test !isperm(p)

a = randcycle(10)
@test ipermute!(permute!([1:10;], a),a) == [1:10;]

# PR 12785
let a = 2:-1:1
    @test ipermute!(permute!([1, 2], a), a) == [1, 2]
end

@test collect(combinations("abc",3)) == Any[['a','b','c']]
@test collect(combinations("abc",2)) == Any[['a','b'],['a','c'],['b','c']]
@test collect(combinations("abc",1)) == Any[['a'],['b'],['c']]
@test collect(combinations("abc",0)) == Any[Char[]]
@test collect(combinations("abc",-1)) == Any[]
@test collect(permutations("abc")) == Any[['a','b','c'],['a','c','b'],['b','a','c'],
                                          ['b','c','a'],['c','a','b'],['c','b','a']]

@test collect(filter(x->(iseven(x[1])),permutations([1,2,3]))) == Any[[2,1,3],[2,3,1]]
@test collect(filter(x->(iseven(x[3])),permutations([1,2,3]))) == Any[[1,3,2],[3,1,2]]
@test collect(filter(x->(iseven(x[1])),combinations([1,2,3],2))) == Any[[2,3]]

@test collect(partitions(4)) ==  Any[[4], [3,1], [2,2], [2,1,1], [1,1,1,1]]
@test collect(partitions(8,3)) == Any[[6,1,1], [5,2,1], [4,3,1], [4,2,2], [3,3,2]]
@test collect(partitions(8, 1)) == Any[[8]]
@test collect(partitions(8, 9)) == []
@test collect(partitions([1,2,3])) == Any[Any[[1,2,3]], Any[[1,2],[3]], Any[[1,3],[2]], Any[[1],[2,3]], Any[[1],[2],[3]]]
@test collect(partitions([1,2,3,4],3)) == Any[Any[[1,2],[3],[4]], Any[[1,3],[2],[4]], Any[[1],[2,3],[4]],
                                              Any[[1,4],[2],[3]], Any[[1],[2,4],[3]], Any[[1],[2],[3,4]]]
@test collect(partitions([1,2,3,4],1)) == Any[Any[[1, 2, 3, 4]]]
@test collect(partitions([1,2,3,4],5)) == []

@test length(permutations(0)) == 1
@test length(partitions(0)) == 1
@test length(partitions(-1)) == 0
@test length(collect(partitions(30))) == length(partitions(30))
@test length(collect(partitions(90,4))) == length(partitions(90,4))
@test length(collect(partitions('a':'h'))) == length(partitions('a':'h'))
@test length(collect(partitions('a':'h',5))) == length(partitions('a':'h',5))

for n = 0:7, k = 1:factorial(n)
    p = nthperm!([1:n;], k)
    @test isperm(p)
    @test nthperm(p) == k
end

@test_throws ArgumentError parity([0])
@test_throws ArgumentError parity([1,2,3,3])
@test levicivita([1,1,2,3]) == 0
@test levicivita([1]) == 1 && parity([1]) == 0
@test map(levicivita, collect(permutations([1,2,3]))) == [1, -1, -1, 1, 1, -1]
@test let p = [3, 4, 6, 10, 5, 2, 1, 7, 8, 9]; levicivita(p) == 1 && parity(p) == 0; end
@test let p = [4, 3, 6, 10, 5, 2, 1, 7, 8, 9]; levicivita(p) == -1 && parity(p) == 1; end

@test Combinatorics.nsetpartitions(-1) == 0
@test collect(permutations([])) == Vector[[]]
