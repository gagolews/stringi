# Copyleft (C) 2020-2025, Marek Gagolewski <https://www.gagolewski.com/>

# based on https://bitbucket.org/pybtex-devs/pybtex/src/HEAD/pybtex/style/formatting/unsrt.py

################################################################################

from pybtex.richtext import Symbol, Text
from pybtex.style.formatting import BaseStyle, toplevel
from pybtex.style.template import (
    field, first_of, href, join, names, optional, optional_field, sentence,
    tag, together, words
)
from pybtex.style.formatting.alpha import Style as AlphaStyle

from pybtex.style.names import BaseNameStyle, name_part
import pybtex.plugin

#import pybtex.style.labels.number
#pybtex.style.labels.number.LabelStyle

################################################################################

import re
def dashify(text):
    dash_re = re.compile(r'-+')
    return Text(Symbol('ndash')).join(text.split(dash_re))

pages = field('pages', apply_func=dashify)

date = join ["(", field('year'), ")"]


################################################################################

class NameMarek(BaseNameStyle):
    def format(self, person, abbr=False):
        if person.last_names[0] == "others":
            return "others"
        else:
            return join [
                name_part(tie=True) [person.rich_prelast_names],
                name_part [person.rich_last_names],
                name_part(before=' ') [person.rich_lineage_names],
                name_part(before=', ', abbr=abbr) [person.rich_first_names + person.rich_middle_names],
            ]


################################################################################

pybtex.plugin.register_plugin(
    "pybtex.style.names", "namemarek", NameMarek
)


################################################################################

class AlphaMarek(AlphaStyle):

    default_name_style = "namemarek"
    default_label_style = "number"

    def format_names(self, role, as_sentence=True):
        formatted_names = names(
            role, sep=', ', sep2 = ' and ', last_sep=', and ')
        if as_sentence:
            return sentence [formatted_names]
        else:
            return formatted_names

    def format_doi(self, e):
        return join[
            'DOI: ',
            href[
                join[
                    'https://doi.org/',
                    field('doi', raw=True)
                ],
                field('doi', raw=True)
            ]
        ]

    def get_article_template(self, e):
        volume_and_pages = first_of [
            # volume and pages, with optional issue number
            optional [
                join [
                    field('volume'),
                    optional['(', field('number'),')'],
                    ':', pages
                ],
            ],
            # pages only
            words ['pages', pages],
        ]
        template = toplevel [
            self.format_names('author'),
            join [ date, ". " ],
            self.format_title(e, 'title'),
            sentence [
                tag('em') [field('journal')],
                optional[ volume_and_pages ],
            ],
            sentence [ optional_field('note') ],
            self.format_web_refs(e),
        ]
        return template


    def get_book_template(self, e):
        template = toplevel [
            self.format_author_or_editor(e),
            join [ date, ". " ],
            self.format_btitle(e, 'title'),
            self.format_volume_and_series(e),
            sentence [
                optional_field('publisher'),
                optional_field('address'),
                self.format_edition(e)
            ],
            optional[ sentence [ self.format_isbn(e) ] ],
            sentence [ optional_field('note') ],
            self.format_web_refs(e),
        ]
        return template


    def format_chapter_and_pages(self, e):
        return join(sep=', ') [
            optional [together ['chapter', field('chapter')]],
            optional [together ['pp.', pages]],
        ]


    def get_incollection_template(self, e):
        template = toplevel [
            sentence [self.format_names('author')],
            join [ date, ". " ],
            self.format_title(e, 'title'),
            words [
                'In:',
                sentence [
                    optional[ self.format_editor(e, as_sentence=False) ],
                    self.format_btitle(e, 'booktitle', as_sentence=False),
                    self.format_volume_and_series(e, as_sentence=False),
                    self.format_chapter_and_pages(e),
                ],
            ],
            sentence [
                optional_field('publisher'),
                optional_field('address'),
                self.format_edition(e)
            ],
            sentence [ optional_field('note') ],
            self.format_web_refs(e),
        ]
        return template


    def get_inproceedings_template(self, e):
        return self.get_incollection_template(e)


    def get_manual_template(self, e):
        # TODO this only corresponds to the bst style if author is non-empty
        # for empty author we should put the organization first
        template = toplevel [
            optional [ sentence [ self.format_names('author') ] ],
            join [ date, ". " ],
            self.format_btitle(e, 'title'),
            sentence [
                optional_field('organization'),
                optional_field('address'),
                self.format_edition(e)
            ],
            sentence [ optional_field('note') ],
            self.format_web_refs(e),
        ]
        return template


    def get_misc_template(self, e):
        template = toplevel [
            optional[ sentence [self.format_names('author')] ],
            join [ date, ". " ],
            optional[ self.format_btitle(e, 'title') ],
            sentence[
                optional[ field('howpublished') ]
            ],
            sentence [ optional_field('note') ],
            self.format_web_refs(e),
        ]
        return template


    def get_phdthesis_template(self, e):
        template = toplevel [
            sentence [self.format_names('author')],
            join [ date, ". " ],
            self.format_btitle(e, 'title'),
            sentence[
                first_of [
                    optional_field('type'),
                    'PhD thesis',
                ],
                field('school'),
                optional_field('address')
            ],
            sentence [ optional_field('note') ],
            self.format_web_refs(e),
        ]
        return template


    def get_techreport_template(self, e):
        template = toplevel [
            sentence [self.format_names('author')],
            join [ date, ". " ],
            self.format_title(e, 'title'),
            sentence [
                words[
                    first_of [
                        optional_field('type'),
                        'Technical Report',
                    ],
                    optional_field('number'),
                ],
                field('institution'),
                optional_field('address'),
            ],
            sentence [ optional_field('note') ],
            self.format_web_refs(e),
        ]
        return template


    def get_unpublished_template(self, e):
        template = toplevel [
            sentence [self.format_names('author')],
            join [ date, ". " ],
            self.format_title(e, 'title'),
            sentence [
                field('note'),
            ],
            self.format_web_refs(e),
        ]
        return template


################################################################################

pybtex.plugin.register_plugin(
    "pybtex.style.formatting", "alphamarek", AlphaMarek
)

################################################################################
