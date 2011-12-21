# This Python 2.6 script extract useful files for a standalone app

from shutil import *
import os
import glob
import time
import subprocess


source_folder = "C:/Users/ponce/gamesfrommars/d/vibrant"

destination_folder = "C:/Users/ponce/gamesfrommars/d/vibrant/release/"



print "Deleting " + destination_folder
rmtree(destination_folder, True) # ignore errors


def createDir(dirname):    
    try:
        print "Creating folder " + dirname
        os.makedirs(dirname)
    except OSError:
        if os.path.exists(dirname):
            # We are nearly safe
            pass
        else:
            # There was an error on creation, so make sure we know about it
            raise
        

createDir(destination_folder)
createDir(destination_folder + "data/")

def outputFiles(source_dir, dest_dir, filename_with_wildcards):

    def outputFile(source_dir, dest_dir, filename):    
        src = source_folder + source_dir + filename
        dst = destination_folder + dest_dir + filename
        print "Copying " + src + " to " + dst
        copyfile(filename, dst)
        return

    def find(filename_with_wildcards):
        s = glob.glob(filename_with_wildcards)
        if len(s) == 0:
            print "WARNING: no file found for " + filename_with_wildcards
            print "supposedly in '" + source_dir + "'\n"
#            exit(1)
        return s    

    os.chdir(source_folder + source_dir)
    filenames = find(filename_with_wildcards);

    
    for f in filenames:
        outputFile(source_dir, dest_dir, f)
        
        
outputFiles("", "", "data/*.fs")
outputFiles("", "", "data/*.vs")
outputFiles("", "", "*.ogg")
outputFiles("", "", "data/*.wav")
outputFiles("", "", "data/*.bmp")
outputFiles("", "", "data/*.png")
#outputFiles("", "", "*.ico")
outputFiles("", "", "vibrant.exe")
outputFiles("", "", "vibrant.nfo")
outputFiles("", "", "*.dll")



time.sleep(6)
