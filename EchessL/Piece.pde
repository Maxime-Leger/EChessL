float valPion = 10;//valeur pas réfléchie
float valTour = 50;
float valCavalier = 32; 
float valFou = 33;
float valReine = 90;
float valRoi = 2000;
float valeurPieces[] = {valPion, valTour, valCavalier, valFou, valReine, valRoi};

PVector pieceUp = new PVector(0,0);
class Piece {
  int type; //1 : pion | 2 : tour | 3 : cavalier | 4 : fou | 5 : reine | 6 : roi
  float valeur;// valeur de la pièce | pion : | tour : ...
  int equipe;// equipe de la pièce | haut : 1 | bas : -1 | case vide : 0

  Piece(int typei, float valeuri, int equipei) {
    type = typei;
    valeur = valeuri;
    equipe = equipei;
  }

  int[][] deplacementPossible(int ligne, int colonne, Echiquier echiquier, int miseEchec, boolean verifRoque) {//Piece[][] | verifRoque --> true si on prend en compte les cases de déplacement de roque (false si on veut pas les mettres)
    int [][] depPosTot = new int[64][2]; // deplacement possible total : un grand tableau du lequel on rentre tout les mouvements possible et qu'on redimensionne ensuite pour ne pas avoir de case vide
    int nPos = 0;//nombre de position possible

    //if (miseEchec == equipe && type != 6) {
    //} else {

    switch(type) {

      case(1)://pion
      //les premières conditions permettent de ne pas sortir de l'echiquier
      if ( (ligne+equipe >= 0 && ligne+equipe < 8 && echiquier.e[ligne+equipe][colonne].equipe == 0) ) {//avance
        depPosTot[nPos][0] = ligne+equipe;
        depPosTot[nPos][1] = colonne;
        nPos ++;
      }
      if (ligne == (1-equipe)*3+(equipe+1)/2 && echiquier.e[ligne+2*equipe][colonne].equipe == 0 && echiquier.e[ligne+equipe][colonne].equipe == 0) {//double avance
        depPosTot[nPos][0] = ligne+2*equipe;
        depPosTot[nPos][1] = colonne;
        nPos ++;
      }
      if ( ligne+equipe >= 0 && ligne+equipe < 8 && colonne+1 >= 0 && colonne+1 < 8 && echiquier.e[ligne+equipe][colonne+1].equipe != equipe && echiquier.e[ligne+equipe][colonne+1].type != 0) {
        depPosTot[nPos][0] = ligne+equipe;
        depPosTot[nPos][1] = colonne+1;
        nPos ++;
      }
      if ( ligne+equipe >= 0 && ligne+equipe < 8 && colonne-1 >= 0 && colonne-1 < 8 && echiquier.e[ligne+equipe][colonne-1].equipe != equipe && echiquier.e[ligne+equipe][colonne-1].type != 0) {
        depPosTot[nPos][0] = ligne+equipe;
        depPosTot[nPos][1] = colonne-1;
        nPos ++;
      }
      break;

      case(2)://tour
      int k = 1;
      boolean toucher = false;
      while (ligne-k >= 0 && echiquier.e[ligne-k][colonne].equipe != equipe && !toucher) {//haut
        depPosTot[nPos][0] = ligne-k;
        depPosTot[nPos][1] = colonne;
        if (echiquier.e[ligne-k][colonne].equipe != equipe && echiquier.e[ligne-k][colonne].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      k = 1;
      toucher = false;
      while (ligne+k < 8 && echiquier.e[ligne+k][colonne].equipe != equipe && !toucher) {//bas
        depPosTot[nPos][0] = ligne+k;
        depPosTot[nPos][1] = colonne;
        if (echiquier.e[ligne+k][colonne].equipe != equipe && echiquier.e[ligne+k][colonne].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      k = 1;
      toucher = false;
      while (colonne-k >= 0 && echiquier.e[ligne][colonne-k].equipe != equipe && !toucher) {//gauche
        depPosTot[nPos][0] = ligne;
        depPosTot[nPos][1] = colonne-k;
        if (echiquier.e[ligne][colonne-k].equipe != equipe && echiquier.e[ligne][colonne-k].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      k = 1;
      toucher = false;
      while (colonne+k < 8  && echiquier.e[ligne][colonne+k].equipe != equipe && !toucher) {//gauche
        depPosTot[nPos][0] = ligne;
        depPosTot[nPos][1] = colonne+k;
        if (echiquier.e[ligne][colonne+k].equipe != equipe && echiquier.e[ligne][colonne+k].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }
      break;

      case(3)://cavalier
      //for (int i = 0; i < 8; i ++) {
      //  for (int j = 0; j  < 8; j ++) {
      //    if ( !(i == ligne || j == colonne) && Math.abs(ligne-i)+Math.abs(j-colonne) == 3 ) {
      //      if (echiquier.e[i][j].equipe != equipe) {
      //        depPosTot[nPos][0] = i;
      //        depPosTot[nPos][1] = j;
      //        nPos ++;
      //      }
      //    }
      //  }
      //}
      int[][] cases = {{-1, -2}, {1, -2}, {2, -1}, {2, 1}, {1, 2}, {-1, 2}, {-2, 1}, {-2, -1}};
      for (int i = 0; i < 8; i ++) {
        if (ligne+cases[i][0] >= 0 && ligne+cases[i][0] < 8 && colonne+cases[i][1] >= 0 && colonne+cases[i][1] < 8 ) {
          if (echiquier.e[ligne+cases[i][0]][colonne+cases[i][1]].equipe != equipe) {
            depPosTot[nPos][0] = ligne+cases[i][0];
            depPosTot[nPos][1] = colonne+cases[i][1];
            nPos ++;
          }
        }
      }
      break;

      case(4)://fou
      k = 1;
      toucher = false;
      while (ligne-k >= 0 && colonne-k >= 0 && echiquier.e[ligne-k][colonne-k].equipe != equipe && !toucher) {//haut gauche
        depPosTot[nPos][0] = ligne-k;
        depPosTot[nPos][1] = colonne-k;
        if (echiquier.e[ligne-k][colonne-k].equipe != equipe && echiquier.e[ligne-k][colonne-k].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      k = 1;
      toucher = false;
      while (ligne-k >= 0 && colonne+k < 8 && echiquier.e[ligne-k][colonne+k].equipe != equipe && !toucher) {//haut droite
        depPosTot[nPos][0] = ligne-k;
        depPosTot[nPos][1] = colonne+k;
        if (echiquier.e[ligne-k][colonne+k].equipe != equipe && echiquier.e[ligne-k][colonne+k].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      k = 1;
      toucher = false;
      while (ligne+k < 8 && colonne-k >= 0 && echiquier.e[ligne+k][colonne-k].equipe != equipe && !toucher) {//bas gauche
        depPosTot[nPos][0] = ligne+k;
        depPosTot[nPos][1] = colonne-k;
        if (echiquier.e[ligne+k][colonne-k].equipe != equipe && echiquier.e[ligne+k][colonne-k].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      k = 1;
      toucher = false;
      while (ligne+k < 8 && colonne+k < 8  && echiquier.e[ligne+k][colonne+k].equipe != equipe && !toucher) {//bas droite
        depPosTot[nPos][0] = ligne+k;
        depPosTot[nPos][1] = colonne+k;
        if (echiquier.e[ligne+k][colonne+k].equipe != equipe && echiquier.e[ligne+k][colonne+k].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      break;

      case(5): //reine
      k = 1;
      toucher = false;
      while (ligne-k >= 0 && echiquier.e[ligne-k][colonne].equipe != equipe && !toucher) {//haut
        depPosTot[nPos][0] = ligne-k;
        depPosTot[nPos][1] = colonne;
        if (echiquier.e[ligne-k][colonne].equipe != equipe && echiquier.e[ligne-k][colonne].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      k = 1;
      toucher = false;
      while (ligne+k < 8 && echiquier.e[ligne+k][colonne].equipe != equipe && !toucher) {//bas
        depPosTot[nPos][0] = ligne+k;
        depPosTot[nPos][1] = colonne;

        if (echiquier.e[ligne+k][colonne].equipe != equipe && echiquier.e[ligne+k][colonne].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      k = 1;
      toucher = false;
      while (colonne-k >= 0 && echiquier.e[ligne][colonne-k].equipe != equipe && !toucher) {//gauche
        depPosTot[nPos][0] = ligne;
        depPosTot[nPos][1] = colonne-k;
        if (echiquier.e[ligne][colonne-k].equipe != equipe && echiquier.e[ligne][colonne-k].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      k = 1;
      toucher = false;
      while (colonne+k < 8  && echiquier.e[ligne][colonne+k].equipe != equipe && !toucher) {//gauche
        depPosTot[nPos][0] = ligne;
        depPosTot[nPos][1] = colonne+k;
        if (echiquier.e[ligne][colonne+k].equipe != equipe && echiquier.e[ligne][colonne+k].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      k = 1;
      toucher = false;
      while (ligne-k >= 0 && colonne-k >= 0 && echiquier.e[ligne-k][colonne-k].equipe != equipe && !toucher) {//haut gauche
        depPosTot[nPos][0] = ligne-k;
        depPosTot[nPos][1] = colonne-k;
        if (echiquier.e[ligne-k][colonne-k].equipe != equipe && echiquier.e[ligne-k][colonne-k].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      k = 1;
      toucher = false;
      while (ligne-k >= 0 && colonne+k < 8 && echiquier.e[ligne-k][colonne+k].equipe != equipe && !toucher) {//haut droite
        depPosTot[nPos][0] = ligne-k;
        depPosTot[nPos][1] = colonne+k;
        if (echiquier.e[ligne-k][colonne+k].equipe != equipe && echiquier.e[ligne-k][colonne+k].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      k = 1;
      toucher = false;
      while (ligne+k < 8 && colonne-k >= 0 && echiquier.e[ligne+k][colonne-k].equipe != equipe && !toucher) {//bas gauche
        depPosTot[nPos][0] = ligne+k;
        depPosTot[nPos][1] = colonne-k;
        if (echiquier.e[ligne+k][colonne-k].equipe != equipe && echiquier.e[ligne+k][colonne-k].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      k = 1;
      toucher = false;
      while (ligne+k < 8 && colonne+k < 8  && echiquier.e[ligne+k][colonne+k].equipe != equipe && !toucher) {//bas droite
        depPosTot[nPos][0] = ligne+k;
        depPosTot[nPos][1] = colonne+k;
        if (echiquier.e[ligne+k][colonne+k].equipe != equipe && echiquier.e[ligne+k][colonne+k].equipe != 0) {
          toucher = true;
        }
        nPos ++;
        k ++;
      }

      break;

      case(6): // roi
      int[][] cases2 = {{1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {1, -1}, {1, 0}};
      for (int i = 0; i < 8; i ++) {
        if (ligne+cases2[i][0] >= 0 && ligne+cases2[i][0] < 8 && colonne+cases2[i][1] >= 0 && colonne+cases2[i][1] < 8 ) {
          if (echiquier.e[ligne+cases2[i][0]][colonne+cases2[i][1]].equipe != equipe) {
            int res=0; // 0 Le coup ne suicide pas si >0 l'inverse
            for (int l = 0; l < 8; l ++) {
              for (int c = 0; c < 8; c ++) {
                if (echiquier.e[l][c].type == 1 && echiquier.e[l][c].equipe!=equipe) {//Cas des pions 
                  int[][] cases3={{-1*equipe, 1}, {-1*equipe, -1}};
                  int casePoss[][]= new int [2][2];
                  ;
                  for (int o = 0; o < 2; o ++) {
                    if (l+cases3[o][0] >= 0 && l+cases3[o][0] < 8 && c+cases3[o][1] >= 0 && c+cases3[o][1] < 8 ) {
                      casePoss[o][0]=l+cases3[o][0];
                      casePoss[o][1]=c+cases3[o][1];
                    }
                  }
                  for (int j = 0; j < casePoss.length; j ++) {
                    if (casePoss[j][0]==ligne+cases2[i][0] && casePoss[j][1]==colonne+cases2[i][1] ) {
                      res+=1;
                    }
                  }
                }
                if (echiquier.e[l][c].type != 6 && echiquier.e[l][c].type != 1 && echiquier.e[l][c].equipe!=equipe ) { // Les cas classiques sauf roi adverse (sinon stackoverflow avec deplacementpossible et sauf Pions 
                  int casePoss[][] = echiquier.e[l][c].deplacementPossible(l, c, echiquier, 0, false);
                  if (casePoss.length > 0) {
                    for (int j = 0; j < casePoss.length; j ++) {
                      if (casePoss[j][0]==ligne+cases2[i][0] && casePoss[j][1]==colonne+cases2[i][1] && echiquier.e[l][c].equipe!=equipe) {
                        res+=1;
                      }
                    }
                  }
                }
                if (echiquier.e[l][c].type == 6 && echiquier.e[l][c].equipe!=equipe) {// Cas du roi adverse 
                  int casePoss[][]= new int [8][2];
                  ;
                  for (int o = 0; o < 8; o ++) {
                    if (l+cases2[o][0] >= 0 && l+cases2[o][0] < 8 && c+cases2[o][1] >= 0 && c+cases2[o][1] < 8 ) {
                      if (echiquier.e[l+cases2[o][0]][c+cases2[o][1]].equipe != equipe) {
                        casePoss[o][0]= l+cases2[o][0];
                        casePoss[o][1]=c+cases2[o][1];
                      }
                    }
                  }
                  if (casePoss.length > 0) {
                    for (int j = 0; j < casePoss.length; j ++) {
                      if (casePoss[j][0]==ligne+cases2[i][0] && casePoss[j][1]==colonne+cases2[i][1] && echiquier.e[l][c].equipe!=equipe) {
                        res+=1;
                      }
                    }
                  }
                }
              }
            }
            if (res==0) {
              depPosTot[nPos][0] = ligne+cases2[i][0];
              depPosTot[nPos][1] = colonne+cases2[i][1];
              nPos+=1;
            }
          }
        }
      }
      if (verifRoque) {// Si on vérifie le roque
        if (echiquier.roquable(equipe, 0)) {//roque gauche
          depPosTot[nPos][0] = 7-7*int(0.1+equipe);
          depPosTot[nPos][1] = 0;
          //println(7-7*int(0.1+equipe),0);
          nPos ++;
        }
        if (echiquier.roquable(equipe, 1)) {//roque droit
          depPosTot[nPos][0] = 7-7*int(0.1+equipe);
          depPosTot[nPos][1] = 7;
          //println(7-7*int(0.1+equipe),7);
          nPos ++;
        }
      }
      break;
    }



    int [][] depPosRep = new int[nPos][2]; // on redimensionne le tableau
    if (nPos > 0) {
      for (int i = 0; i < nPos; i ++) {
        depPosRep[i][0] = depPosTot[i][0];
        depPosRep[i][1] = depPosTot[i][1];
      }
    }

    if (equipe != 0 && equipe == miseEchec) {//si l'équipe est en echec
      if (type != 6 && depPosRep.length > 0) {
        boolean sortEchec[] = new boolean [depPosRep.length];
        for (int i = 0; i < depPosRep.length; i ++) {
          Piece echiquierP[][] = new Piece[8][8];
          for (int l = 0; l < 8; l ++) {
            for (int c = 0; c < 8; c ++) {
              echiquierP[l][c] = echiquier.e[l][c];
            }
          }
          Echiquier echiquierPe = new Echiquier();
          echiquierPe.defEchi(echiquierP);
          echiquierPe.deplacement(ligne, colonne, depPosRep[i][0], depPosRep[i][1]);
          int resEchec = echiquierPe.miseEnEchec();
          if (resEchec != 0) {
            sortEchec[i] = false;
          } else {
            sortEchec[i] = true;
          }
        }
        int nMvt = 0;
        for (int i = 0; i < depPosRep.length; i ++) {
          if (sortEchec[i]) {
            nMvt ++;
          }
        }
        if (nMvt == 0) {
          int vide[][] = new int[0][2];
          depPosRep = vide;
        } else {
          int nouv [][] = new int[nMvt][2];
          int compt = 0;
          for (int i = 0; i < depPosRep.length; i ++) {
            if (sortEchec[i]) {
              nouv[compt] = depPosRep[i];
              compt ++;
            }
          }
          depPosRep = nouv;
        }
      }
    }

    return depPosRep;
  }
}
