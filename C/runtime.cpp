#include "../../IsoSpec/IsoSpec++/unity-build.cpp"
#include <iostream>
#include <fstream>
#include <string>
#include <ctime>

int main(){
	double threshold = .0001;
	int repeats_no = 13; /* Number of repetitions of the calculations */
	std::fstream ff("/Users/matteo/Projects/isospec/tests/formulas_small.txt");
	std::string formula;
	
	long long int i;
	while(std::getline(ff, formula)){
		for(int j=0; j<repeats_no; j++){
			std::clock_t start=std::clock();
			IsoSpec::IsoThresholdGenerator T(formula.c_str(), threshold, false);
			while(T.advanceToNextConfiguration()){}
			std::clock_t end=std::clock();
			std::cout << formula << " " << (end - start)/(double)(CLOCKS_PER_SEC / 1000) << " ms" << std::endl;
		}
		std::cout << std::flush;
	}
	
	return 0;
}

