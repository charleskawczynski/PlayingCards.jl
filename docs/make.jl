using Documenter, HoldemCards

format = Documenter.HTML(
    prettyurls = !isempty(get(ENV, "CI", "")),
    collapselevel = 1,
)

makedocs(
    sitename = "HoldemCards.jl",
    strict = true,
    format = format,
    checkdocs = :exports,
    clean = true,
    doctest = true,
    modules = [HoldemCards],
    pages = Any[
        "Home" => "index.md",
        "API" => "api.md",
    ],
)

deploydocs(
    repo = "github.com/charleskawczynski/HoldemCards.jl.git",
    target = "build",
    push_preview = true,
    devbranch = "main",
    forcepush = true,
)
