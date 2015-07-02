
function isless(a::Array{Int,1}, b::Array{Int,1})
    for i = 1:length(a)
        if a[i] < b[i]
            return true
        elseif a[i] > b[i]
            return false
        end
    end
    return false
end

a = [4, 5, 6, 7, 8, 9, 1, 2, 3]
b = [2, 3, 1, 6, 4, 5, 7, 8, 9]
c = [2, 1, 3, 5, 4, 6, 8, 7, 9]


s1 = [1, 2, 4, 5, 6]
s2 = [1, 2, 4, 5, 9]


fs = Array{Int,1}[];
fs2 = Array{Int,1}[];
push!(fs, s1, s2);

while length(fs2) == 0 || !issubset(fs2, fs)
    fs = union(fs, fs2)
    for f in fs
        push!(fs2, sort(a[f]), sort(b[f]), sort(c[f]));
    end
end
sort!(fs, lt = isless)


println(fs)

