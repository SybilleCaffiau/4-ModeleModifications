#Ce fichier ne prend en compte que les cas d'omission de tâche dans les evenements
echo "Début du processus de création du modèle des possibles (étape 4)"

#---le modèle d'édition
#demande les informations pour executer le programme de création du modèle d'édition 
echo "fichier de symboles (.syms) ? "
read label

#compile le programme cpp de detection : remplacer les chemin pour mettre ceux où se trouve la librairie openFst
g++ -std=c++11 -I ../../../EvaluationMaquetteMdT/VerifMaquettesMdTCogtool/testCpp/openfst-1.5.0/src/include creationModelEdition.cpp -L ../../../EvaluationMaquetteMdT/VerifMaquettesMdTCogtool/testCpp/openfst-1.5.0/src/lib -lfst -o myapp

./myapp $label

#compile le programme pour mettre au format l'automate en entree
g++ -std=c++11 -I ../../../EvaluationMaquetteMdT/VerifMaquettesMdTCogtool/testCpp/openfst-1.5.0/src/include format.cpp -L ../../../EvaluationMaquetteMdT/VerifMaquettesMdTCogtool/testCpp/openfst-1.5.0/src/lib -lfst -o formate

#compilation de toutes les transitions possibles pour avoir le modèle d'édition (pour le moment, le fichier txt est édité à la main

fstcompile --isymbols=$label --osymbols=$label modeleEdition.txt | fstarcsort > modeleEdition.fst

fstrmepsilon modeleEdition.fst| fstarcsort > modeleEditionOmissionEvtModif.fst

echo "Modèle d'Edition avec les omission d'Evt"
fstprint --isymbols=$label --osymbols=$label modeleEditionOmissionEvtModif.fst

#------le modèle de tâches
#pré-traitement pour avoir un modele avec que des acceptors
echo "automate du modèle de tâches (.txt) ? "
read mdt

./formate $mdt testfinal.txt


fstcompile --isymbols=$label --acceptor testfinal.txt | fstarcsort > modelTrace.fst

echo "automate du MdT"

fstprint --isymbols=$label --osymbols=$label modelTrace.fst

#le modèle d'edition du MdT
fstcompose modeleEditionOmissionEvtModif.fst modelTrace.fst | fstarcsort > Model_possible.fst

echo "Model edition du MdT"
fstprint --isymbols=$label --osymbols=$label Model_possible.fst

#------la trace à tester
#compilation de l'entrée sous la forme d'un acceptor (pas de sortie) pour que se soit vu comme une trace
echo "fichier de traces/scenario (.txt) ? "
read scenario
fstcompile --isymbols=$label --acceptor $scenario | fstarcsort > Scenario.fst

#---------Production des chemins possibles conformes au modèle de tâches en fonction de la trace

fstcompose Scenario.fst Model_possible.fst  | fstarcsort > Resultat.fst

echo "Resultat"
fstprint --isymbols=$label --osymbols=$label Resultat.fst
	
echo "Fin du processus de création du modèle des chemins possibles par omissions (étape 4) -L'automate se nomme Resultat.fst"