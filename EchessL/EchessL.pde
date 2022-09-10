String parametres[] = new String[1];//Parametres du fichier parametres.txt (taille de la fenetre)
float w, h;// largeur et hauteur -> ATTENTION chaque élement graphique doit être définit par rapport à eux et non en pixels (car la taille de la fenetre peut varier)
Echiquier echiquierAff = new Echiquier();// Echiquier qui est afficher
float etat = 3; // si 0 -> jeux d'echec ; si 1 -> historique partie ; si 2 -> promotion de pion ; si 3 -> menu principale ; si 4 -> crédits

void settings() {
  //Charge les parametres
  String para[] = loadStrings("parametres.txt");
  for (int i = 0; i < para.length; i ++) {
    parametres[i] = para[i].split("=")[1];
  }

  //Créé la fenetre
  size(int(parametres[0]), int(parametres[0]));
}

void setup() {

  //Initialisations
  w = width;
  h = height;
  initialisationCaracteristiqueEchiquier();
  initialisationImages();
  initialisationBoutons();
  echiquierAff.initial();
  echiquierAff.vraiEch = true;

  exerciceIA2();
}

void draw() {
  affichageGlobal();
}

boolean frameJouee = false;

void affichageGlobal() {
  if (etat == 0) {// jeu
    background(255);//Fond d'écran blanc

    affichageEchiquier();
    affichageHorsEchiquier();
    affichageVictoire();
    if (frameJouee == false) {
      jouerIA();
    } else {
      frameJouee = false;
    }
    //if (tour == 1) {
    //  //println("IA1");
    //  IA2(eval2IA1, tour);
    //} else {
    //  //println("IA3");
    //  IA2(eval2, tour);
    //}
    //int somme = 0;
    //for (int ligne = 0; ligne < 8; ligne ++) {
    //  for (int colonne = 0; colonne < 8; colonne ++) {
    //    somme += echiquierAff.e[ligne][colonne].valeur*echiquierAff.e[ligne][colonne].equipe;
    //  }
    //}
    //println(somme);
  } else if (etat == 1) {// historique
    affichageHistorique();
  } else if (etat == 2) {// promotion d'un pion
    affichagePromotion();
  } else if (etat == 3) {//menu principale
    menuPrincipale();
  } else if (etat == 4) {
    affichageCredits();
  }
}


void jouerIA() { // definit les fonctions des IA à utilisé
  if (nIA >=0 && tour == 1 && victorieux == 0) { //L'IA est l'équipe 1 (haut)
    switch(nIA) {

      case(1):
      IA1();
      break;

      case(2):
      IA2(eval2, 1);
      break;
    }
  }
}
