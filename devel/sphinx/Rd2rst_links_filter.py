#!/usr/bin/python3

# ############################################################################ #
#                                                                              #
#   Copyleft (C) 2020, Marek Gagolewski <https://www.gagolewski.com>           #
#                                                                              #
#                                                                              #
#   This program is free software: you can redistribute it and/or modify       #
#   it under the terms of the GNU Affero General Public License                #
#   Version 3, 19 November 2007, published by the Free Software Foundation.    #
#   This program is distributed in the hope that it will be useful,            #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the               #
#   GNU Affero General Public License Version 3 for more details.              #
#   You should have received a copy of the License along with this program.    #
#   If this is not the case, refer to <https://www.gnu.org/licenses/>.         #
#                                                                              #
# ############################################################################ #


import panflute
import sys

def action(elem, doc):
    #print(elem, file=sys.stderr)
    if isinstance(elem, panflute.Link) and elem.url.endswith('.html'):
        elem.url = "rapi/"+elem.url[:-5]
        #print(elem, file=sys.stderr)
        return elem

if __name__ == '__main__':
    panflute.run_filter(action)
