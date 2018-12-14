// GEC_mdMake: creates a single metadata file for CrispRVariants 
// NGS analysis. Designed for the format of NGS data used in the
// Genome Editing Core 
// Written by Cody Hasty in VSCode on Ubuntu 16.04 LTS
// 1-8-2017

// NOTE: This program used to create a metadata file using an ofstream.
// Now it uses cout, which must be redirected to a file. This allows 
// bash scripts looping mdMake versatility in where they redirect the 
// resulting file

//command line input: MdMake infile sgRNA counter
//  infile = ls written to a txt file
//  sgRNA = sgRNA name
//  counter = starting number

#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>

using namespace std;

//
// printHeader creates the header of the metadata file
//
void printHeader()
{
    cout << "bamfile" << "\t" << "directory" << "\t" << "Short.name" <<"\t" 
    << "Targeting.type" << "\t" << "sgRNA1"  << "\t" << "sgRNA2" <<
    "\t" << "Group" << endl;

    return;
}

//
//validateInput checks to see if the input file can be opened
//
int validateInput(std::ifstream& infs)
{
    if(!infs)
    {
        std::cerr <<"Cannot open the input file." << std::endl;
        return 1;
    }
    return 0;
}

//
//printMD loops through the input stream, printing metadata entries
// for each filename in the stream
//
void printMD(std::ifstream& infs, int& counter, string& guide)
{
    std::string input;

    infs >> input;
    while (!infs.eof())
    {
        //bamfile, directory
        //Short.name, 
        //Targeting.type
        //sgRNA1, sgRNA2
        //Group
       cout << input << "\t" << "NA" <<
        "\t" << guide << "_" << counter << 
        "\t" << "Single" <<
        "\t" << guide << "\t" << "NA" <<
        "\t" << "1" << endl;

        counter++;
        infs >> input;
    }

    return;
}

int main (int argc, char** argv)
{
    //TO DO: validate command line arguments

    //declare variables from $1 $2 $3
    std::ifstream infs(argv[1]);
    string guide = argv[2];
    int counter = atoi(argv[3]);

    //std::ofstream outfs("metaData.txt");
    //validateFilePath(outfs);

    validateInput(infs);
    printHeader();
    printMD(infs, counter, guide);
    
    //close stream
    infs.close();

//end
}