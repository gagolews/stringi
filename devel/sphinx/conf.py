# Copyleft (C) 2020-2023, Marek Gagolewski <https://www.gagolewski.com>
# Configuration file for the Sphinx documentation builder.

import sys, os, sphinx_rtd_theme, re
sys.path.append(os.getcwd())

def get_package_version():
    with open("../../DESCRIPTION") as f:
        return re.search(r'Version:[ ]*([0-9.-]+)', f.read()).group(1)


# -- Project information -----------------------------------------------------

project = 'stringi'
copyright = '2013–2023, Marek Gagolewski'
author = 'Marek Gagolewski'
html_title = project
html_short_title = project

version = get_package_version()
release = version

print("This is %s %s by %s.\n" % (project, version, author))


github_project_url = "https://github.com/gagolews/stringi/"
html_baseurl = "https://stringi.gagolewski.com/"

nitpicky = True
smartquotes = True
today_fmt = "%Y-%m-%dT%H:%M:%S%Z"
highlight_language = "r"

extensions = [
    'myst_parser',
    'sphinx.ext.mathjax',
    'sphinx_rtd_theme',
    'sphinxcontrib.bibtex',
]

myst_enable_extensions = [
    "colon_fence",
    "dollarmath",
    "deflist",
]

templates_path = ['_templates']

exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

todo_include_todos = True

source_suffix = ['.rst', '.md']


html_theme = 'sphinx_rtd_theme'

html_theme_path = [sphinx_rtd_theme.get_html_theme_path()]
html_show_sourcelink = False

html_theme_options = {
    'prev_next_buttons_location': 'both',
    'sticky_navigation': True,
    'display_version': True,
    'style_external_links': True,
    #'display_github': True,
    #'github_url': github_project_url,
    #'style_nav_header_background': '#ff704d',
}

html_last_updated_fmt = today_fmt
html_static_path = ['_static']
html_css_files = ['css/custom.css']


pygments_style = 'colorful'

# BibTeX biblography + Marek's custom pybtex style
import alphamarek
bibtex_default_style = "alphamarek"
bibtex_bibfiles = ["bibliography.bib"]
