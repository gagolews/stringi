#!/usr/bin/python3

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
