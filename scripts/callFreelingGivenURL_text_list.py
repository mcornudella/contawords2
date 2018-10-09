#!/usr/bin/env python
# -*- coding: utf-8 -*-

import io
import sys
import subprocess
import urllib2
import time
import random
import string

'''This script gets a file containing a file with several URLs as an input for Contawords

It:
- recovers the list of URLs
- For each URL, it runs the script freeling4.sh
- It merges the output of freeling for each file into an outputfile
'''

scripts_dir="/mnt/vmdata/contawords-iulaterm/var/rails/contawords2/scripts/"
tempFiles_dir="/mnt/vmdata/contawords-iulaterm/var/rails/contawords2/storage/temp_files/"

URLlist=[]
downloadedFileNames=[]
processedFileNamesAfterFL=[]

def generateOutputFile():
    
    global processedFileNamesAfterFL
    
    #generate random name for outputFile 
    outputFile = time.strftime("%d%m%Y_%H%M%S_")+ "".join(random.choice(string.ascii_uppercase + string.digits) for _ in range(6)) + ".txt"
    
    with open(tempFiles_dir + outputFile,"w+") as outfile:
        for fname in processedFileNamesAfterFL:
            #print "Copying the content of file " + fname + " into " +  outputFile + "..."
            with open(tempFiles_dir + fname) as infile:
                for line in infile:
                    outfile.write(line)
    return outputFile
    

def recoverURLListFromText(listText):
    global URLlist
    for line in listText.split(' '):
        URLlist.append(line)
    #for line in listText.split('\\n'):
    #    URLlist.append(line.split("\\r")[0])
    #print "printing list of urls:"
    #for url in URLlist:
    #    print url 
    
def makeLocalCopy():
    global URLlist
    global downloadedFileNames
    for url in URLlist:
        urlName = url.split("/")[-1]
        #print "urlName: " + urlName
        downloadedFileNames.append(urlName)
        filedata = urllib2.urlopen(url)
        open(tempFiles_dir + urlName, 'wb').write(filedata.read())
    
def runFreeLingScriptInParallel(lang):
    processes = []
    global downloadedFileNames
    global processedFileNamesAfterFL
    
    #execute freeling4.sh for each file in the list
    for filename in downloadedFileNames: 
        command = scripts_dir + "freeling4.sh " + tempFiles_dir+ filename + " " + lang
        
        #print command
        
        process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
        #process = subprocess.Popen(command, shell=True)
        processes.append(process)
        
    # Wait for all processes to finish
    for p in processes:
        p.wait()

    # Collect outputfiles
    processedFileNamesAfterFL = [p.stdout.read().split("/")[-1].split("\n")[0] for p in processes]
    #print processed files list:
    #print "printing processed files list:"
    #for procF in processedFileNamesAfterFL:
    #    print procF 
    
            

def main():
    if (len(sys.argv) != 3):
        print "You should specify an input file containing a list of URLs and the language of the files"
        print "The call to this script should be as follows: python callFreelingGivenURLList.py list-file \"ca\" "
        sys.exit(1)
    
    # store the input file
    listFile = sys.argv[1]
    lang = sys.argv[2]
    
    #print("Step 1. Processing the input file and recovering the list of URLs...")
    recoverURLListFromText(listFile)
    
    #print("Step 2. Make a local copy of each file...")
    makeLocalCopy()
    
    #print("Step 3. Run the script freeling4.sh for each file...")
    runFreeLingScriptInParallel(lang)
    
    #print("Step 4. Concatenate the resulting files from freeeling4.sh into one file")
    outputFile= generateOutputFile()
    
    #we return the outputfile in order to continue the pipe
    print tempFiles_dir + outputFile
    #print("Mission accomplished. My job here is done. Bye")

main()
