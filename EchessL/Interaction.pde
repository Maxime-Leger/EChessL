void mousePressed() {//Fonction lorsqu'on clic

  if (etat == 0) {// jeu
    //Selection de case
    if (victorieux == 0 && mouseX > posEchX && mouseX < posEchX+dimEch && mouseY > posEchY && mouseY < posEchY+dimEch) {
      if (demarrer == false) {
        refTempFinTour = millis()/1000.0;
        demarrer = true;
      }
      PVector clic = new PVector( int((mouseX-posEchX)/dimCase), int((mouseY-posEchY)/dimCase) );
      caseSelectionner(clic);
    }


    if (victorieux != 0) {
      //if (mouseX >345*width/700 && mouseX < 345*width/700+265*width/700-h/10 && mouseY > 635*width/700 && mouseY < 635*width/700+50*width/700) {
      //  etat = 1;
      //}
    }
  } else if (etat == 1) { // historique
    //if (mouseX >345*width/700 && mouseX < 345*width/700+265*width/700-h/10 && mouseY > 635*width/700 && mouseY < 635*width/700+50*width/700) {
    //  etat = 0;
    //}
  } else if (etat == 2) { // promotion de pion

    for (int k = 0; k<4; k++) {
      if (mouseX >posEchX+k*dimCase && mouseX < posEchX+(k+1)*dimCase && mouseY > posEchY-dimCase && mouseY < posEchY) {
        int liA = 0; 
        int coA = 0;
        for (int i=0; i<8; i = i+7) {
          for (int j=0; j<8; j++) {
            if (numTypeJeu == 2) {//horde
              liA = int(pieceUp.x);
              coA = int(pieceUp.y);
            } else {
              if (echiquierAff.e[i][j].type == 1) {
                liA = i;
                coA = j;
              }
            }
          }
        }

        echiquierAff.e[liA][coA] = new Piece(2+k, valeurPieces[k], echiquierAff.e[liA][coA].equipe);
        etat = 0;
      }
    }
  }

  if (etat == 4) {
    if (mouseX > 275*w/700 && mouseX < 275*w/700+160*w/700 && mouseY > 475*h/700 && mouseY < 475*h/700+200*h/700) {
      coeurCredit = true;
    }
  }

  bouton_menuP_Jouer.exec();
  bouton_menuP_Quitter.exec();
  bouton_Jeux_Undo.exec();
  bouton_Jeux_Restart.exec();
  bouton_Jeux_JcJ.exec();
  bouton_Jeux_IA1.exec();
  bouton_Jeux_IA2.exec();
  //bouton_Jeux_IA3.exec();
  if (victorieux != 0) {
    bouton_Victoire_Historique.exec();
  }
  bouton_Jeux_Menu.exec();
  bouton_menuP_ProfondeurIAp.exec();
  bouton_menuP_ProfondeurIAm.exec();
  bouton_menuP_Chronop.exec();
  bouton_menuP_Chronom.exec();
  bouton_menuP_Jeum.exec();
  bouton_menuP_Jeup.exec();
  bouton_menuP_credits.exec();
  bouton_credits_menuP.exec();
}

void reinitialisation() {// Réinitialisation du jeu
  echiquierAff = new Echiquier();
  float r = random(0, 1);
  if (r<0.5) {
    equipeBlanche = 1;
  } else {
    equipeBlanche = -1;
  }

  if (nIA < 0) {
    equipeBlanche = -1;
  }
  tour = equipeBlanche;
  echiquierAff.initial();
  echiquierAff.vraiEch = true;
  listeEchiquier.clear();
  victorieux = 0;
  caseSelect = new PVector(-1, -1); // case sélectionnée, si x négatif, aucune case sélectionnée
  casesPoss = new int[0][2];//cases où la piece selectionnée peut aller
  tempsJH = 0;
  tempsJB = 0;
  tempsJHp = 0;
  tempsJBp = 0;
  demarrer = false;
  npmp = 0;
}



void caseSelectionner(PVector clic) {//ce qu'il se passe lorsqu'on selectionne une case
  int xTemp = int(clic.x);
  int yTemp = int(clic.y);
  if (!dedans(yTemp, xTemp, casesPoss)) {//si on clic sur une cases qui n'est pas un déplacement possible on selectionne une nouvelle case
    caseSelect = clic;
    if (xTemp >= 0 && yTemp >= 0) {
      //casesPoss = echiquierAff.e[yTemp][xTemp].deplacementPossible(yTemp, xTemp, echiquierAff, echecs, true);
      casesPoss = echiquierAff.deplacementPossible(yTemp, xTemp);
    } else {
      casesPoss = new int[0][2];
    }
  } else if ( echiquierAff.e[int(caseSelect.y)][int(caseSelect.x)].equipe == tour ) {//on clic sur une case de déplacement -> on y déplace la piece si c'est notre tour
    if ( (nIA >= 0 && tour == -1) || nIA < 0) {
      echiquierAff.deplacement(int(caseSelect.y), int(caseSelect.x), yTemp, xTemp);
      finTour();
    }
  }
}

boolean dedans(int xd, int yd, int liste[][]) {//dit si xd,yd est dans liste[nombre][2] -> Utile dans caseSelectionner
  boolean rep = false;
  int i = 0;
  while (!rep && i < liste.length) {
    rep = (xd == liste[i][0] && yd == liste[i][1]);
    i ++;
  }
  return rep;
}

int codeTriche[] = {69, 67, 76, 153, 51};
int etatTriche = -1;

void keyPressed() {
  if (keyCode == 71) {//g
    victorieux = 1;
    for (int i = 0; i<nAVictoire; i++) {
      feuArtVictoire [i]= new FeuArtifice(random(width/5.0, 4*width/5.0), height, width/25.0, 0, 90, height);
    }
  }
  if (etat == 0 && keyCode == codeTriche[etatTriche+1]) {
    etatTriche++;
    if (etatTriche >=codeTriche.length-1) {
      etatTriche = -1;
      echiquierAff.e[int(caseSelect.y)][int(caseSelect.x)] = new Piece(5, valeurPieces[4], echiquierAff.e[int(caseSelect.y)][int(caseSelect.x)].equipe);
    }
  }
}
