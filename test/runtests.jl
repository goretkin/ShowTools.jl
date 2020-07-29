using SafeTestsets: @safetestset

# r"Main\..*\."

@safetestset "no type param" begin
    io = IOBuffer()
    struct Foo
        x::Int64
    end

    show(io, Foo(3))
    @show String(take!(io)) # because of safetestset it will be like "Main.##257.Foo(3)""
end

@safetestset "type param" begin
    using ShowTools: ShowTools
    io = IOBuffer()
    struct Foo{T}
        x::T
    end

    Base.show(io::Base.IO, x::Foo) = ShowTools.show_default_no_typeparams(io, x)
    show(io, Foo(3))
    @show String(take!(io)) # because of safetestset it will be like "Main.##123.Foo(3)""
    #Foo(3)
end

@safetestset "type param" begin
    using ShowTools: ShowTools
    io = IOBuffer()
    struct Foo{S, T}
        x::T
    end

    Base.show(io::Base.IO, x::Foo) = ShowTools.show_default_no_typeparams(io, x)
    show(io, Foo{Some{Float64}, Int64}(3))
    @show String(take!(io))
    # maybe Foo{Some{Float64}, _}(3)
end

@safetestset "type param" begin
    using ShowTools: ShowTools
    io = IOBuffer()
    struct Foo{S, T}
        x::T
    end

    # Base.show(io::Base.IO, x::Foo) = ShowTools.show_default_no_typeparams(io, x)
    show(io, Foo{:bitsbits, Int64}(3))
    @show String(take!(io))
    # maybe Foo{:bitsbits, _}(3)
end
