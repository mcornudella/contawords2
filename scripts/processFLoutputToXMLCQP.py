#!/usr/bin/env python
# -*- coding: utf-8 -*-

import io
import sys

'''This script responds to the fact that the option "--xmlcqp" is no longer available in FreeLing 4.0
It takes as an input a regular FL output and process it to generate and equivalent file with the --xmlcqp format

The xmlcqp:
- adds "<xml>" at the first line of the file
- adds "</xml>" at the last line of the file
- adds "<s>" before the first element of a sentence
- adds "</s>" after the last element of a sentence
'''

def generateOutputFile(inputFile,outputFile):
    
    iFile = io.open(inputFile, 'r', encoding='utf8')
    #oFile = io.open(outputFile, 'w', encoding='utf8')
    oFile = open(outputFile,"w+")
    lastLineEmpty = False
    
    #Step 1. Write the opening lines
    #oFile.write(("<s>\n").encode('utf-8'))
    oFile.write(("<xml>\n" 
             + "<s>\n").encode('utf-8'))
    
    
    for line in iFile:
        
        #if line not empty
        if (line != '\n'):
            if(lastLineEmpty):
                oFile.write(("<s>\n").encode('utf-8'))
                lastLineEmpty = False
            oFile.write("\t".join(line.split(" ")).encode('utf-8'))
        else:
            oFile.write(("</s>\n" 
             + "\n").encode('utf-8'))
            lastLineEmpty = True
    oFile.write(("\n</xml>\n").encode('utf-8'))
            

def main():
    if (len(sys.argv) != 3):
        print "You should specify the input file and the name of the output file"
        print "The call to this script should be as follows: python processFLoutputToXMLCQP.py input-file output-file"
        sys.exit(1)
    print "Thank you for using this script to generate a xmlcqp version of the output of Freeling"
    if (len(sys.argv) == 3):
        # store the input file
        inputFile = sys.argv[1]
        outputFile = sys.argv[2]
    
    
    print("Processing the input file and generating the output file...")
    
    generateOutputFile(inputFile,outputFile)
    
    print("Mission accomplished. My job here is done. Bye")

main()
