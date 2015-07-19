ops = [+, -, *, /]
nums = Rational[1, 5, 6, 7]

function applyop!(nums::Array{Rational,1}, op)
    assert(length(nums) >= 2)
    a = shift!(nums)
    b = shift!(nums)
    c = op(a, b)
    unshift!(nums, c)
    nums
end

function calc!(nums::Array{Rational,1}, ops, trace::Array{Any,1}, target::Rational)
    if length(nums) == 1
        push!(trace, nums[1])
        if (nums[1] == target)
            println(trace)
        end
        return;
    end
    for op in ops
        for i = 1:factorial(length(nums))
            nums2 = nthperm(nums, i)
            trace2 = copy(trace)
            push!(trace2, op, nums2[1], nums2[2])
            applyop!(nums2, op)
            calc!(nums2, ops, trace2, target)
        end
    end
end

calc!(nums, ops, Any[], Rational(21))
