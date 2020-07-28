module ShowTools

# copy verbatim https://github.com/JuliaLang/julia/blob/3909294e78d223c740b7e7a4d00eb2d4771055a7/base/show.jl#L393-L426

function _show_default(io::IO, @nospecialize(x))
    t = typeof(x)
    show(io, inferencebarrier(t))
    print(io, '(')
    nf = nfields(x)
    nb = sizeof(x)
    if nf != 0 || nb == 0
        if !show_circular(io, x)
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
    print(io,')')
end


end
