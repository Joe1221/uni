

facets = Array{Int,1}[];

d = -1
for fstr in ARGS
    f = Int[];
    df = -1
    for pstr in fstr
        df += 1
        push!(f, parseint(pstr))
    end
    d = max(d, df)
    push!(facets, f)
end

println("d = $d")

faces = Any[];

for k = 1:d+1
    push!(faces, Array{Int,1}[])
    for facet in facets
        for s in combinations(facet, k)
            push!(faces[k], sort(s))
        end
    end
    faces[k] = unique(faces[k]);
end

println("faces:")
dump(faces)



fs = union(faces...)
dump(fs)

println("vertex links:")
for vf in faces[1]
    v = vf[1]
    println("\nprocessing vertex $v")
    # compute star
    star = Array{Int,1}[]
    for s in fs
        if !(v in s)
            continue
        end
        for k = 1:length(s)
            for sf in combinations(s, k)
                push!(star, sort(sf))
            end
        end
    end
    star = unique(star)
    # compute link out of star
    link = Array{Int,1}[]
    for s in star
        if v in s
            continue
        end
        push!(link, s)
    end
    #dump(star)
    println("link contains $(length(link)) faces")
    println(link)
end





