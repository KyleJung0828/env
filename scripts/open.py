#!/usr/bin/python3

import glob
import sys
import getpass
import locale

from subprocess import call

"""
def exportLANG(locale):
    call(['export LANG=', locale])

def caseInsensitiveCompare(c):
    return '[%s%s]' % (c.lower(), c.upper()) if c.isalpha() else c

def searchFile(locale):
    filelist = []
    for filename in glob.iglob(''.join(caseInsensitiveCompare(char) for char in locale), recursive=True):
        filelist.append(filename)
    return filelist

def PrintListAndOpenSelected(filelist):
    if len(filelist) > 0:
        for i, filename in enumerate(filelist):
            print(i, ': ', filename)
        selected = int(input('please select file number:'))
        openWithVim(filelist[selected])
"""

def searchAndOpenFile():
    localeList = locale.locale_alias
    for loc in localeList :
        print ("locale is : "+ loc)
"""
    if len(filelist) == 0:
        print('file not found')
        similar_list = searchFile('/home/'+getpass.getuser()+'/office/src/**/*'+sys.argv[1]+'*')
        PrintListAndOpenSelected(similar_list)
    elif len(filelist) == 1:
        openWithVim(filelist[0])
    else:
        PrintListAndOpenSelected(filelist)
"""

if __name__ == '__main__':
    searchAndOpenFile()
