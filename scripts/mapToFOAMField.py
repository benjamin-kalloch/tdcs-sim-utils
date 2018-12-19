#!/usr/bin/python
#
#
# Use this script to map field values of a list file to
# the an OpenFOAM field file.
#
# Prerequisits:
#   1) The input-file must NOT be in the standard OpenFOAM
#      file format, but must only contain a list of values
#      with a new value for each line.
#   2) The OpenFOAM field file must be represented in the
#      ASCII file format.
# 
# Input:
#   --infile  - the file whose values should be transferred
#   --outfile - the OpenFOAM field file whose values should 
#                be overwritten by that of the 'infile'
#
# Configuration:
#   - The script ignores all lines of the infile that equal
#     the IGNORE_LINE constant
#   - The script replaces only lines of the outfile that
#     equal the REPLACE_LINE
#
# Additional remarks:
#   - The script is currently desinged to replace tensor
#     values in the OpenFOAM format with the white matter
#     isotropic conductivity (sigma_wm = 0.126).
#   - Any other value type (scalar, 3-vector, etc.) as well
#     as any other tissue compartment can be used if
#     IGNORE_LINE and REPLACE_LINE are adapted accordingly
#
#

import os;
import re;
import sys;
import getopt;

# +++++++++++++++++++ constants +++++++++++++++++++++++

IGNORE_LINE   = "( 0 0 0 0 0 0 0 0 0 )\n";
REPLACE_LINE  = "(0.126 0 0 0 0.126 0 0 0 0.126)\n";

INPUT_FILE  = ""
OUTPUT_FIL  = ""

# ++++++++++++++ function definitions +++++++++++++++++
def getNumEntries( _field ):
    matchObj = None;

    for lineNo in range( 0, len( _field) ):
        matchObj = re.match(r'^[0-9]+$', _field[ lineNo ], re.M|re.I);
        if matchObj:
            break;

    return -1 if not matchObj else int( matchObj.group( 0 ) );

def seekListStart( _field ):
    ret = -1;

    for lineNo in range( 0, 25 ):
        if _field[ lineNo ] == '(\n':
            ret = lineNo+1;     # note that the next is actually +2 if you do not start counting at 0
            break;

    return ret;

def main( _argv) :
    global INPUT_FILE;
    global OUTPUT_FILE;
    # +++++++++++++commandline argument processing+++++++++++++
    def printHelp():
        print( "Usage: ./mapToFOAMField.py --infile path/to/input --outfile path/to/foam/field" );

    try:                                    # the colon indicates that these options require an argument
                                            # concerning the long-options, '=' indicates that an argument must follow
                                            # the long-options match the short options by the leading characters and thus must be unique
        opts, args = getopt.getopt( _argv, "hi:o:",[ "infile=", "outfile=" ] );
        assert len( opts ) == 2 or len( opts ) == 3;

    except getopt.GetoptError:
        print( "There was an error parsing the provided commandline arguments." );
        printHelp();
        exit();
    except AssertionError:
        print( "Invalid number of commandline options provided!");
        printHelp();
        exit();

    for opt, arg in opts:
        if opt == '-h':
            printHelp();
            exit();
        elif opt in ( "-i", "--infile" ):
            INPUT_FILE  = arg;
        elif opt in ( "-o", "--outfile"):
            OUTPUT_FILE = arg;

    # ++++++++++++++ establish IO-sockets +++++++++++++++++
    try:
        listFile = open( INPUT_FILE, 'r' );
    except IOError:
        print( "Cannot access input list-file!" );
        listFile.close();
        exit();

    try:
        fieldFile = open( OUTPUT_FILE, 'r+' );
    except IOError:
        print( "Cannot access field file!" );
        fieldFile.close()
        exit();

    # ++++++++ cache the files for modification ++++++++++
    print( "Caching files now" );
    tensorList = listFile.readlines();
    field      = fieldFile.readlines();

    if( not len( tensorList ) or not len( field ) ):
        print( "Error: at least one of the two input files is empty; aborting..." );
        exit();

    numEntries = getNumEntries( field);

    if( numEntries == -1 ):
        print( "Invalid OpenFOAM field file, number of entries not found! Aborting..." );
        exit();

    if( numEntries != len( tensorList ) ):
        print( "TensorList and OpenFOAM field do have a non-equal number of entries; aborting..." );
        exit();

    OFFieldListStart = seekListStart( field );

    if( OFFieldListStart == -1 ):
        print( "Starting position of OF-field-list not found; aborting..." );
        exit();

    print( "Mapping list-file onto OF-field..." );

    ctr = 0;
    for lineNo in range( 0, len( tensorList ) ):
        if ( tensorList[ lineNo ] != IGNORE_LINE and field[ lineNo + OFFieldListStart ] == REPLACE_LINE ):
            field[ lineNo + OFFieldListStart ] = tensorList[ lineNo ];
            ctr += 1;

    print( "Mapped " + repr( ctr ) + " values onto OF-field!" );

    fieldFile.seek( 0 );
    fieldFile.writelines( field );
    fieldFile.truncate();

    fieldFile.close()
    listFile.close();

if __name__ == "__main__":
        main( sys.argv[1:] )
