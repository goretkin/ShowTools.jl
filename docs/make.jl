using ShowTools
using Documenter

makedocs(;
    modules=[ShowTools],
    authors="Gustavo Goretkin <gustavo.goretkin@gmail.com> and contributors",
    repo="https://github.com/goretkin/ShowTools.jl/blob/{commit}{path}#L{line}",
    sitename="ShowTools.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://goretkin.github.io/ShowTools.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/goretkin/ShowTools.jl",
)
