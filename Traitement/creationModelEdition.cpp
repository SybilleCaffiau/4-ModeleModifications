#include <fst/fstlib.h>

using namespace fst;


int main(int argc, char *argv[]){	
	
	//affectation de la SymbolTable passee en parametre
	string nomFichier= argv[1];
	SymbolTable *syms = SymbolTable::ReadText(nomFichier);
	
	int i=0; //indice de parcours de la table des symbols
	
	string symbol;
	symbol = syms ->Find(i);
	
	//le fichier modèle d'édition (pour essai, que les omissions)
	
	ofstream leModeleEdition("modeleEdition.txt");
	
	while (symbol!=""){
		
		//cout << "symbol" << symbol << "fin symbol" << endl;
		if((symbol!="eps") &&(symbol !="R")){
		
		leModeleEdition << "0 0 " <<symbol<<" " <<symbol<<" 1 "<< endl;
		leModeleEdition << "0 0 eps " <<symbol<<" 1 "<< endl;
		//pour le moment que les omissions
		//leModeleEdition << "0 0 " <<symbol<<" eps 1 "<< endl;
		}
		i++;
		symbol = syms ->Find(i);
	}
	
	leModeleEdition << "0 " << endl;


	return 0;

}