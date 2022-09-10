int nReseau = 64;//cf entrainer
ReseauNeurone lesReseaux[] = new ReseauNeurone[nReseau];//Réseaux d'entrainement
int nInter = 32;// Nombre de perceptron dans la couche intermediaire
int log2(int n) {return int(log(n)/log(2));} // Fonction log2

boolean chargerIA = true;//Charge l'IA 3 à partir de mei et mis 
boolean baseIA1 = false;//Lors de l'entrainement, les premieres IA seront de base l'IA1 (avec quelques modulations)
boolean entrainer = false;//On entraine (series de nEvolution tournois de nReseau participants)
boolean reentrainer = false;//Lors de l'entrainement, les premieres IA seront de base l'IA3 (il faut alors mettre chargerIA à true)
boolean entrainerEvalIA1 = false;//Entraine le réseau sur la base de l'IA1
int nEntrainerEvalIA1 = 8;//nombre de série d'entrainement sur la base de l'IA1 (cf entrainerEvalIA1)
int nEvolution = 10;//Nombre de série de combat (cf entrainer)

float vitesseApp = 0.01;//Vitesse d'apprentissage
float variationsEntrainer = 0.5/2500.0;//variation de valeur lors de la définition des fils


void exerciceIA2() {

  if (chargerIA) {// on charge les matrices de poids à partir de fichiers
    float mei[][], mis[][];
    String meiS[] = loadStrings("mei32.txt");
    String misS[] = loadStrings("mis32.txt");
    mei = new float[meiS.length][meiS[0].split(" ").length];
    mis = new float[misS.length][misS[0].split(" ").length];
    for (int i = 0; i < meiS.length; i ++) {
      String ligne[] = meiS[i].split(" ");
      for (int j = 0; j < ligne.length; j ++) {
        mei[i][j] = float(ligne[j]);
      }
    }
    for (int i = 0; i < misS.length; i ++) {
      String ligne[] = misS[i].split(" ");
      for (int j = 0; j < ligne.length; j ++) {
        mis[i][j] = float(ligne[j]);
      }
    }

    eval2 = new ReseauNeurone(64, nInter, 1, mei, mis);
  } else {//Sinon on les initialise avec "neutreM" qui permet ensuite de les initialiser aléatoirement (cf la fonction de construction de ReseauNeurone)
    eval2 = new ReseauNeurone(64, nInter, 1, neutreM, neutreM);
  }
  eval2IA1 = new ReseauNeurone(64, nInter, 1, neutreM, neutreM);//Réseau neurone qui reproduit l'ia 1 
  eval2IA1.special();// On modifit les matrices de poids pour avoir le comportement de l'ia 1

  if (entrainer) {
    boolean evolution = true;
    int evoluN = 0;
    ReseauNeurone victPrec[][] = new ReseauNeurone[log2(nReseau)][nReseau];
    while (evolution) {
      if (evoluN == 0) {//Si c'est la première évolution il faut initialiser les IA
        if (reentrainer) {
          for (int i = 0; i < nReseau; i ++) {
            lesReseaux[i] = new ReseauNeurone(64, nInter, 1, eval2.mei, eval2.mis);
          }
        } else {

          for (int i = 0; i < nReseau; i ++) {
            if (baseIA1) {
              if (i == 0) {
                lesReseaux[i] = new ReseauNeurone(64, nInter, 1, neutreM, neutreM);
                lesReseaux[i].special();
              } else {
                lesReseaux[i] = new ReseauNeurone(64, nInter, 1, deltaM(lesReseaux[0].mei, variationsEntrainer*i), deltaM(lesReseaux[0].mis, variationsEntrainer*i));
              }
            } else {
              lesReseaux[i] = new ReseauNeurone(64, nInter, 1, neutreM, neutreM);
            }
          }
        }
      } else {
        ReseauNeurone premier = victPrec[victPrec.length-1][0];
        ReseauNeurone second = victPrec[victPrec.length-2][0];
        if (second == premier) {
          second = victPrec[victPrec.length-2][1];
        }
        for (int i = 0; i < nReseau; i ++) {

          if (i < nReseau*0.3) {// 30prc -> fils 1er
            lesReseaux[i] = new ReseauNeurone(64, nInter, 1, deltaM(premier.mei, variationsEntrainer*i), deltaM(premier.mis, variationsEntrainer*i));
          } else if (i < nReseau*0.5) {//20prc -> fils 2nd
            lesReseaux[i] = new ReseauNeurone(64, nInter, 1, deltaM(second.mei, variationsEntrainer*(i-nReseau*0.3)), deltaM(second.mis, variationsEntrainer*(i-nReseau*0.3)));
          } else if (i < nReseau*0.7) {//20prc -> fils 1er
            lesReseaux[i] = new ReseauNeurone(64, nInter, 1, deltaM(premier.mei, variationsEntrainer*(i-nReseau*0.7)), deltaM(premier.mis, variationsEntrainer*(i-nReseau*0.7)));
          } else {//Restes
            lesReseaux[i] = new ReseauNeurone(64, nInter, 1, neutreM, neutreM);
          }
        }
      }
      ReseauNeurone vict[][] = new ReseauNeurone[log2(nReseau)][nReseau];
      vict[0] = lesReseaux;
      int nTourMoy = 0;
      int nPartie = 0;
      for (int n = 1; n <log2(nReseau); n ++) {
        for (int i = 0; i < nReseau/pow(2, n); i ++) {
          println("Evolution "+str(evoluN)+", Tour "+str(n)+", combat "+str(i));
          boolean gagnant = false;
          ReseauNeurone v = vict[n-1][i];
          int tourNB = 0;
          while (!gagnant) {
            if (tour/equipeBlanche == 1) {
              IA2(vict[n-1][i+1], tour);
            } else {
              IA2(vict[n-1][i], tour);
            }
            if (victorieux == 1) {
              v = vict[n-1][i+1];
              gagnant = true;
            } else if (victorieux == -1) {
              v = vict[n-1][i];
              gagnant = true;
            } else if (victorieux == 2 || tourNB > 50) {
              gagnant = true;
              int somme = 0;
              for (int ligne = 0; ligne < 8; ligne ++) {
                for (int colonne = 0; colonne < 8; colonne ++) {
                  somme += echiquierAff.e[ligne][colonne].valeur*echiquierAff.e[ligne][colonne].equipe;
                }
              }
              if (somme > 0) {
                v = vict[n-1][i+1];
                gagnant = true;
              } else {
                v = vict[n-1][i];
                gagnant = true;
              }
            }

            tourNB ++;
            nTourMoy ++;
          }
          reinitialisation();
          vict[n][i] = v;
          nPartie ++;
        }
      }
      println(float(nTourMoy)/nPartie);
      evoluN ++;
      if (mousePressed || evoluN > nEvolution) {
        vict[vict.length-1][0].exportPoids("");
        evolution = false;
        println("Fini");
      }
      if (evoluN%10 == 0) {
        vict[vict.length-1][0].exportPoids("save"+str(evoluN));
      }
      victPrec = vict;
      //printM(victPrec[victPrec.length-1][0].mei);
    }
  } else if (entrainerEvalIA1) {
    ReseauNeurone lentrainee = new ReseauNeurone(64, nInter, 1, neutreM, neutreM);
    lentrainee.biais = 0;
    lentrainee.special();
    for (int n = 0; n < nEntrainerEvalIA1; n ++) {
      Piece echiquierTest[][] = new Piece[8][8];
      for (int i = 0; i < 8; i ++) {
        for (int j = 0; j < 8; j ++) {
          float rdm = random(0, 1);
          int  equipe  = int(random(0, 100));
          if ( equipe < 50) {
            equipe = 1;
          } else {
            equipe = -1;
          }
          if (rdm < 0.5) {
            echiquierTest[i][j] = new Piece(0, 0, 0);
          } else if (rdm < 0.75) {
            echiquierTest[i][j] = new Piece(1, valeurPieces[0], equipe);
          } else if (rdm < 0.8125) {
            echiquierTest[i][j] = new Piece(2, valeurPieces[1], equipe);
          } else if (rdm < 0.875) {
            echiquierTest[i][j] = new Piece(3, valeurPieces[2], equipe);
          } else if (rdm < 0.9375) {
            echiquierTest[i][j] = new Piece(4, valeurPieces[3], equipe);
          } else if (rdm < 0.96875) {
            echiquierTest[i][j] = new Piece(5, valeurPieces[4], equipe);
          } else {
            echiquierTest[i][j] = new Piece(6, valeurPieces[5], equipe);
          }
        }
      }
      float resIA1 = evaluationIA1bis(echiquierTest);
      //println(resIA1);
      float []vObj = {resIA1};
      float []vEntre = new float[64];
      int ncompt = 0;
      for (int i = 0; i < 8; i ++) {
        for (int j = 0; j < 8; j ++) {
          vEntre[ncompt] = echiquierTest[i][j].valeur*echiquierTest[i][j].equipe;
          ncompt ++;
        }
      }
      //print("Veente : ");
      //printV(vEntre);
      lentrainee.apprentissage(vEntre, vObj);
      println(n*100.0/nEntrainerEvalIA1+"%");
    }
    lentrainee.exportPoids("");
    println("Fini");
  }
}

class ReseauNeurone {
  int nEntr, nInter, nSortie;//Nombre de perceptron pour la couche d'entrée, intérmédiaire, sortie
  float mei[][], mis[][];// Matrice des poids : Matrice entrée intermédiaire / Matrice intermédiaire sortie
  float biais = 0;// Valeur d'entrée du biais
  float poidsBiais[] = {0.1, 0.1};// Poid lié au biais

  ReseauNeurone(int nEntr_, int nInter_, int nSortie_, float mei_[][], float mis_[][] ) {
    nEntr = nEntr_;
    nInter = nInter_;
    nSortie = nSortie_;
    mei = new float[nInter][nEntr];
    mis = new float[nSortie][nInter];
    if (mei_.length == 0) {
      initPoids(mei);//Initialise aléatoirement
      initPoids(mis);
    } else {
      mei = mei_;
      mis = mis_;
    }
  }


  void initPoids(float m[][]) {// initialise une matrice (valeur de -1 à 1)
    for (int i = 0; i < m.length; i ++) {
      for (int l = 0; l < m[i].length; l ++) {
        m[i][l] = random(-1, 1);
      }
    }
  }

  void exportPoids(String nomFichier) {//Permet de sauvegarder les matrices de poids
    String repMEI[] = new String[mei.length];
    String repMIS[] = new String[mis.length];
    for (int i = 0; i < mei.length; i ++) {
      String ligne = "";
      for (int j = 0; j < mei[0].length; j ++) {
        ligne += str(mei[i][j]);
        if (j != mei[0].length-1) {
          ligne += " ";
        }
      }
      repMEI[i] = ligne;
    }
    for (int i = 0; i < mis.length; i ++) {
      String ligne = "";
      for (int j = 0; j < mis[0].length; j ++) {
        ligne += str(mis[i][j]);
        if (j != mis[0].length-1) {
          ligne += " ";
        }
      }
      repMIS[i] = ligne;
    }
    saveStrings("mei"+str(nInter)+nomFichier+".txt", repMEI);
    saveStrings("mis"+str(nInter)+nomFichier+".txt", repMIS);
  }

  float [] solution(float vEntr[]) {// Permet d'utiliser le réseau de neurone, en entrée l'entrée du réseau, et en sortie la sortie
    float []vInter = new float[nInter];
    for (int i = 0; i < nInter; i ++) {//calcul le vecteur intermédiaire à partir du vecteur d'entrée
      float somme = biais*poidsBiais[0];//on ajoute le biais
      for (int j = 0; j < nEntr; j ++) {
        somme += mei[i][j]*vEntr[j];
      }
      vInter[i] = fctActivation(somme);
    }
    //printV(vInter);
    float []vSortie = new float[nSortie];
    for (int i = 0; i < nSortie; i ++) {//calcul le vecteur de sortie à partir du vecteur intermediaire
      float somme = biais*poidsBiais[1];
      for (int j = 0; j < nInter; j ++) {
        somme += mis[i][j]*vInter[j];
      }
      vSortie[i] = fctActivation(somme);
    }
    return vSortie;
  }

  void apprentissage(float[] vEntr, float []vObjectif) {//Modifie les matrices mei et mis, ne marche pas très bien
    float []vInter = new float[nInter];
    for (int i = 0; i < nInter; i ++) {
      float somme = biais*poidsBiais[0];
      for (int j = 0; j < nEntr; j ++) {
        somme += mei[i][j]*vEntr[j];
      }
      vInter[i] = fctActivation(somme);
    }
    //printV(vInter);
    float []vSortie = new float[nSortie];
    for (int i = 0; i < nSortie; i ++) {
      float somme = biais*poidsBiais[1];
      for (int j = 0; j < nInter; j ++) {
        somme += mis[i][j]*vInter[j];
      }
      vSortie[i] = fctActivation(somme);
    }
    print("Sortie : "+vSortie[0]);
    print(" ,");
    print("Objectif : "+vObjectif[0]);
    print("  |  ");

    float erreurSortie[] = addV(vObjectif, prodV(vSortie, -1));
    float erreurInter[] = prodTMV(mis, erreurSortie);

    float unMs[] = new float[vSortie.length];
    float unMi[] = new float[vInter.length];
    for (int i = 0; i < vSortie.length; i ++) {
      unMs[i] = 1-vSortie[i];
    }
    for (int i = 0; i < vInter.length; i ++) {
      unMi[i] = 1-vInter[i];
    }

    float gradient_psi[][] = prodVVT(erreurSortie, vInter);//prodVVT(prodTaT(prodTaT(erreurSortie, vSortie), unMs), vInter);
    float gradient_pie[][] = prodVVT(erreurInter, vEntr);//prodVVT(prodTaT(prodTaT(erreurInter, vInter), unMi), vEntr);
    //println("Valeur gradient psi : "+gradient_psi[0][0]);

    println("Erreur intermediaire : ");
    printV(erreurInter);
    println("gradient pie");
    println(gradient_pie[0][0]);

    maj(mis, gradient_psi);
    maj(mei, gradient_pie);
  }

  float fctActivation(float x) {//Fonction d'activation du perceptron
    return x;//(1.0/(1+exp(-x))-0.5)*2;
  }

  void special() {//modifit les matrices de poids mei et mis pour qu'elles corespondent à l'IA1 (avec biais = 0 et la fonction d'ativation y=x)
    for (int i = 0; i < mei.length; i ++) {//32
      for (int j = 0; j < mei[0].length; j ++) {//64
        if (i == int(j/2)) {
          mei[i][j] = 1/2500.0;
        } else {
          mei[i][j] = 0;
        }
      }
    }
    for (int i = 0; i < mis.length; i ++) {//1
      for (int j = 0; j < mis[0].length; j ++) {//32
        mis[i][j] = 1;
      }
    }
  }
}

void printM(float [][]ma) {
  println("Affichage matrice :");
  for (int c = 0; c < ma[0].length; c ++) {
    for (int l = 0; l< ma.length; l++) {
      print(ma[l][c]+" ");
    }
    println("");
  }
}

void printV(float []ve) {
  println("Affichage vecteur : ");
  for (int i = 0; i < ve.length; i ++) {
    print(ve[i] + " , ");
  }
  println("");
}

float [][] deltaM(float m[][], float delta) {
  float [][] rep = new float[m.length][m[0].length];
  for (int i = 0; i < m.length; i ++) {
    for (int j = 0; j < m[0].length; j ++) {
      rep[i][j] = m[i][j]+random(-delta, delta);
    }
  }
  return rep;
}

float []addV(float []v1, float []v2) {
  float []rep = new float[v1.length];

  for (int i = 0; i < v1.length; i ++) {
    rep[i] = v1[i]+v2[i];
  }
  return rep;
}

float []prodV(float v[], float a) {
  float []rep = new float[v.length];
  for (int i = 0; i < v.length; i ++) {
    rep[i] = a*v[i];
  }
  return rep;
}

float []prodTMV(float m[][], float v[]) {
  float rep[] = new float[m[0].length];
  for (int i = 0; i < m[0].length; i ++) {
    float somme = 0;
    for (int j = 0; j < v.length; j ++) {
      somme += v[j]*m[j][i];
    }
    rep[i] = somme;
  }
  return rep;
}

float []prodTaT(float []v1, float []v2) {
  float rep[] = new float[v1.length];
  for (int i = 0; i < v1.length; i ++) {
    rep[i] = v1[i]*v2[i];
  }
  return rep;
}

float [][]prodVVT(float v1[], float v2[]) {
  float [][]rep = new float[v1.length][v2.length];
  for (int i = 0; i < v1.length; i ++) {
    for (int j = 0; j < v2.length; j ++) {
      rep[i][j] = v1[i]*v2[j];
    }
  }
  return rep;
}

void maj(float [][]m1, float [][]m2) {
  for (int i = 0; i < m1.length; i ++) {
    for (int j = 0; j < m1[0].length; j ++) {
      m1[i][j] = m1[i][j] + vitesseApp*m2[i][j];
    }
  }
}
