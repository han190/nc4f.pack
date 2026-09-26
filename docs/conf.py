"""Sphinx configuration for the nc4f documentation site."""

project = "NC4F"
author = "Han Tang"
copyright = "2019-2026, Han Tang"

extensions = ["myst_parser", "sphinx_design"]
source_suffix = {".rst": "restructuredtext", ".md": "markdown"}
exclude_patterns = ["_build"]

html_theme = "sphinx_book_theme"
html_title = "NC4F"
html_static_path = ["_static"]
html_css_files = ["custom.css"]
html_theme_options = {
    "repository_url": "https://github.com/han190/nc4f.pack",
    "use_repository_button": True,
    "use_issues_button": True,
}

myst_enable_extensions = ["colon_fence", "deflist", "fieldlist"]
