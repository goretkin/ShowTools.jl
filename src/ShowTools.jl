module ShowTools

function show_fields(io::IO, @nospecialize(x))
    t = typeof(x)
    nf = nfields(x)
    nb = sizeof(x)
    if nf != 0 || nb == 0
        if !Base.show_circular(io, x)
            recur_io = IOContext(io, Pair{Symbol,Any}(:SHOWN_SET, x),
                                 Pair{Symbol,Any}(:typeinfo, Any))
            for i in 1:nf
                f = fieldname(t, i)
                if !isdefined(x, f)
                    print(io, undef_ref_str)
                else
                    show(recur_io, getfield(x, i))
                end
                if i < nf
                    print(io, ", ")
                end
            end
        end
    else
        print(io, "0x")
        r = Ref(x)
        GC.@preserve r begin
            p = unsafe_convert(Ptr{Cvoid}, r)
            for i in (nb - 1):-1:0
                print(io, string(unsafe_load(convert(Ptr{UInt8}, p + i)), base = 16, pad = 2))
            end
        end
    end
end

"""
When `show(f)` reveals `typeof(f)`, then it's redundant to include the type params.
In those cases, use this representation.
"""
function show_default_no_typeparams(io::Base.IO, x)
    print(io, typeof(x).name)
    print(io, "(")
    show_fields(io, x)
    print(io, ")")
end

is_show_type_evident(x) = is_show_type_evident(typeof(x))
is_show_type_evident(t::Type{<:Any}) = false
is_show_type_evident(t::Type{<:Tuple}) = all(map(is_show_type_evident, t.parameters))
is_show_type_evident(t::Type{<:Base.OneTo}) = true
# I believe you want this to be true even though e.g. Int32 and Int64 print the same and so the type is not evident.
is_show_type_evident(t::Type{Int64}) = true
end
