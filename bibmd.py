#!/usr/bin/env python
# -*- coding: utf-8 -*-

# bibmd: minimal conversion of bibtex citations into rfc2629 markdown references
# (c) Jordan Augé, 2018
# based on original bibxml code from
# (c) Yaron Sheffer, 2013

from __future__ import print_function
import bibtex
import sys, re

MONTHS = ['January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December']

def _month_name(num):
    return MONTHS[num - 1]


def _clean_anchor(a):
    if a[0].isdigit():
        a = 'ref' + a
    return a.replace('/', ':')

def _make_initials(names):
    return " ".join([(n[0] + '.') for n in names])

def record_to_bibmd(rec):
    """
    This function is based on record_to_bibxml, except that we output markdown
    reference format as described in https://github.com/cabo/kramdown-rfc2629.
     - How to format author and date correctly ?
     - What are the corresponding fields for url and keywords
     - seriesinfo can have ISBN, ITU-T, DOI subfields.
     - what about ann field for annotations
    """
    out = list()

    anchor = _clean_anchor(rec.handle)
    out.append('  {}:'.format(anchor))

    out.append('    title: "{}"'.format(rec.data['title']))
    out.append('    author:')

    if not 'author' in rec.data:
        print("Error: the 'author' field is mandatory", file=sys.stderr)
        return ''
    author = ''
    authors = rec.data['author']
    for a in authors:
        out.append('      -')
        surname = a[1]
        out.append('        surname: "{}"'.format(surname))
        fullname = ' '.join(a[0]) + ' ' + surname if len(a[0]) > 0 else surname
        out.append('        fullname: "{}"'.format(fullname))
        initials = _make_initials(a[0])
        out.append('        ins: "{}"'.format(initials))

    month = _month_name(rec.data['month']) if 'month' in rec.data else None
    year = str(rec.data['year'])
    if month:
        out.append('    date: {}-{}'.format(year, month))
    else:
        out.append('    date: {}'.format(year))

    return '\n'.join(out)

if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] == '--help':
        print('Usage: ' + sys.argv[0] + ' [infile]')
        sys.exit(0)

    if len(sys.argv) == 1:
        bibs = bibtex.read_file('/dev/stdin')
    else:
        bibs = bibtex.read_file(sys.argv[1])
    for bib in bibs:
        print(record_to_bibmd(bib))
