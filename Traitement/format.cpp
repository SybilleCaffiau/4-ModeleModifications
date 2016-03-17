#include <iostream>
#include <fstream>
#include <string>
#include <string>
#include <iostream>
#include <sstream>

using namespace std;

//fichier en txt de l'automate en entree
int main(int argc, char *argv[]){	

	//affectation des valeurs des variables en fonction des données en paramètre
	//on récupére le nom du fichier .txt qui décrit l'automate qu'on va traiter
	string automate= argv[1];
	string automateSortie=argv[2];
	
	int ns1;
	int ns2;

	string li;

	string ligne;
		stringstream buffer;

	ifstream a(automate);
	ofstream a2(automateSortie);
	
	
	if(a)
	{
		
		getline(a, ligne);
		
		while(!a.eof()){
			//cout << endl;
			//cout << "changement de ligne " << endl;
			//cout << "taille dde la ligne : "<<ligne.size() << endl; 
			ligne=ligne+" 1";
			buffer.str("");
			buffer.str(ligne);
			
			
			//cout << "taille du buffer : "<<buffer.str().size() << endl; 
			if(buffer.str().size()>4){
				//cout << "contenu du nouveau buffer : " <<buffer.str()<<endl;
			
				buffer>>ns1;
				//cout << "ns1 : " <<ns1<< endl;
			
				buffer>>ns2;
				//cout << "ns2 : " <<ns2<< endl;
		
				buffer>>li;
				//cout << "li : " <<li<< endl;
	
				a2<<ns1<<" "<<ns2<<" "<<li<<endl;
				
			}
			else {
				buffer>>ns1;
				a2<<ns1<<endl;
			}
			getline(a, ligne);
		}
		a.close();
	}
	else
		cout << "Impossible d'ouvrir le fichier!"<<endl;
	
	return 0;
}