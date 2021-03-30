using Documenter, PlayingCards

format = Documenter.HTML(
    prettyurls = !isempty(get(ENV, "CI", "")),
    collapselevel = 1,
)

makedocs(
    sitename = "PlayingCards.jl",
    strict = true,
    format = format,
    checkdocs = :exports,
    clean = true,
    doctest = true,
    modules = [PlayingCards],
    pages = Any[
        "Home" => "index.md",
        "API" => "api.md",
    ],
)

deploydocs(
    repo = "github.com/charleskawczynski/PlayingCards.jl.git",
    target = "build",
    push_preview = true,
    devbranch = "main",
    forcepush = true,
)
