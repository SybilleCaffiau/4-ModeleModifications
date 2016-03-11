#/usr/bash


echo "Début du processus de création du modèle d'édition (étape 4)"

#demande les informations pour executer le programme 
echo "fichier de symboles (.syms) ? "
read label

#compile le programme cpp de detection : remplacer les chemin pour mettre ceux où se trouve la librairie openFst
g++ -std=c++11 -I ../../../EvaluationMaquetteMdT/VerifMaquettesMdTCogtool/testCpp/openfst-1.5.0/src/include creationModelEdition.cpp -L ../../../EvaluationMaquetteMdT/VerifMaquettesMdTCogtool/testCpp/openfst-1.5.0/src/lib -lfst -o myapp
./myapp $label


#---le modèle d'édition
#compilation de toutes les transitions possibles pour avoir le modèle d'édition (pour le moment, le fichier txt est édité à la main

fstcompile --isymbols=$label --osymbols=$label modeleEdition.txt | fstarcsort > modeleEdition.fst

fstrmepsilon modeleEdition.fst| fstarcsort > modeleEditionModif.fst

fstprint --isymbols=$label --osymbols=$label modeleEditionModif.fst

#------la trace à tester
#compilation de l'entrée sous la forme d'un acceptor (pas de sortie) pour que se soit vu comme une trace
#Pour le moment les traces sont issues du csv généré par cogtool, la transformation en .txt est faite à la main
fstcompile --isymbols=$label --acceptor Scenario.txt | fstarcsort > Scenario.fst

#-------le modèle d'édition pour la trace
#composition pour voir toutes les reecritures possibles de la trace (avec omissions, ajouts, échanges)
#fstcompose Scenario.fst modeleEditionModif.fst | fstarcsort > Model_possible.fst

echo "MdT"
# MdT fait à la main pour le test
fstcompile --isymbols=$label --acceptor MdT_test.txt | fstarcsort > MdT_test.fst
fstprint --isymbols=$label --osymbols=$label MdT_test.fst

#le modèle d'edition valide pour le MdT
fstcompose MdT_test.fst modeleEditionModif.fst | fstarcsort > Model_possible.fst


#fstrmepsilon Model_possible.fst | fstarcsort > ModelTache_Edition.fst
echo "Model possible"
fstprint --isymbols=$label --osymbols=$label Model_possible.fst
#fstprint --isymbols=$label --osymbols=$label ModelTache_Edition.fst

#-------Le modele d edition de la trace pour etre valide vis à vis du modèle de tâches
#echo "MdT"
# MdT fait à la main pour le test
#fstcompile --isymbols=$label --acceptor MdT_test.txt | fstarcsort > MdT_test.fst
#fstprint --isymbols=$label --osymbols=$label MdT_test.fst

#fstcompose MdT.fst Model_Trace_Edition.fst | fstarcsort > Resultat.fst

fstcompose ModelTache_Edition.fst Scenario.fst | fstarcsort > Resultat.fst

fstrmepsilon Resultat.fst Res.fst
echo "Resultat"
fstprint --isymbols=$label --osymbols=$label Res.fst

#------Le chemin le plus court
#fstshortestpath Resultat.fst | fstarcsort > solution.fst 
#echo "Le chemin le plus court"
#fstprint --isymbols=labelsModel.syms --osymbols=labelsModel.syms solution.fst

	
echo "Fin du processus de création du modèle d'édition (étape 4)"