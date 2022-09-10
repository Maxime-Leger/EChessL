class Echiquier {
  Piece e[][];
  //int nPieceMorte = 0;
  ArrayList<Piece> pieceMorte = new ArrayList<Piece>();
  ArrayList<int[]> deplacements = new ArrayList<int[]>();
  boolean vraiEch = false;
  ArrayList<int[]> listeHisto = new ArrayList<int[]>();

  boolean roiBoug[] = new boolean[2]; // [equipe bas (nb : -1) ; equipe haut (nb : 1)]
  boolean tourBoug[][] = new boolean [2][2]; // [bas/haut][gauche / droite]
  boolean dansOuverture = true;
  int ilADoubleColonne = -1;
  Echiquier() {
    e = new Piece[8][8];
  }

  void initial() {// initialise l'emplacement des pièces de l'echiquier
    //nPieceMorte = 0;

    pieceMorte = new ArrayList<Piece>();
    for (int i = 0; i < 8; i ++) {
      for (int j = 0; j < 8; j ++) {
        e[i][j] = new Piece(0, 0, 0);
      }
    }
    if (numTypeJeu == 1) {//aléatoire
      for (int i = 0; i < 8; i ++) {
        int r = int(random(1, 6));
        e[0][i] = new Piece(r, valeurPieces[r-1], 1);
        e[7][i] = new Piece(r, valeurPieces[r-1], -1);
        r = int(random(1, 6));
        e[1][i] = new Piece(r, valeurPieces[r-1], 1);
        e[6][i] = new Piece(r, valeurPieces[r-1], -1);
      }
      if (equipeBlanche == -1) {
        e[0][4] = new Piece(6, valeurPieces[4], 1);
        e[7][4] = new Piece(6, valeurPieces[4], -1);
      } else {
        e[0][3] = new Piece(6, valeurPieces[4], 1);
        e[7][3] = new Piece(6, valeurPieces[4], -1);
      }
    } else if (numTypeJeu == 2) {//horde
      for (int i = 0; i < 8; i ++) {
        e[7-(int(equipeBlanche+0.1)*5+1)][i] = new Piece(1, valeurPieces[0], equipeBlanche);
      }
      for (int i = 0; i < 3; i ++) {
        e[7-int(equipeBlanche+0.1)*7][i] = new Piece(2+i, valeurPieces[i+1], equipeBlanche);
        e[7-int(equipeBlanche+0.1)*7][7-i] = new Piece(2+i, valeurPieces[i+1], equipeBlanche);
      }
      if (equipeBlanche == -1) {
        e[7-int(equipeBlanche+0.1)*7][3] = new Piece(5, valeurPieces[4], equipeBlanche);
        e[7-int(equipeBlanche+0.1)*7][4] = new Piece(6, valeurPieces[5], equipeBlanche);
      } else {
        e[7-int(equipeBlanche+0.1)*7][3] = new Piece(6, valeurPieces[5], equipeBlanche);
        e[7-int(equipeBlanche+0.1)*7][4] = new Piece(5, valeurPieces[4], equipeBlanche);
      }

      for (int i = 0; i < 8; i ++) {
        for (int j = 4-4*int(equipeBlanche+0.1); j <= 7-4*int(equipeBlanche+0.1); j++) {
          e[7-j][i] = new Piece(1, valeurPieces[0], -equipeBlanche);
        }
      }
      e[7-(3+int(equipeBlanche+0.1))][1] = new Piece(1, valeurPieces[0], -equipeBlanche);
      e[7-(3+int(equipeBlanche+0.1))][2] = new Piece(1, valeurPieces[0], -equipeBlanche);
      e[7-(3+int(equipeBlanche+0.1))][5] = new Piece(1, valeurPieces[0], -equipeBlanche);
      e[7-(3+int(equipeBlanche+0.1))][6] = new Piece(1, valeurPieces[0], -equipeBlanche);
    } else {

      for (int i = 0; i < 8; i ++) {
        e[1][i] = new Piece(1, valeurPieces[0], 1);
        e[6][i] = new Piece(1, valeurPieces[0], -1);
      }
      for (int i = 0; i < 3; i ++) {
        e[0][i] = new Piece(2+i, valeurPieces[i+1], 1);
        e[0][7-i] = new Piece(2+i, valeurPieces[i+1], 1);
        e[7][i] = new Piece(2+i, valeurPieces[i+1], -1);
        e[7][7-i] = new Piece(2+i, valeurPieces[i+1], -1);
      }
      if (equipeBlanche == -1) {
        e[0][3] = new Piece(5, valeurPieces[4], 1);
        e[0][4] = new Piece(6, valeurPieces[5], 1);
        e[7][4] = new Piece(6, valeurPieces[5], -1);
        e[7][3] = new Piece(5, valeurPieces[4], -1);
      } else {
        e[0][3] = new Piece(6, valeurPieces[5], 1);
        e[0][4] = new Piece(5, valeurPieces[4], 1);
        e[7][4] = new Piece(5, valeurPieces[4], -1);
        e[7][3] = new Piece(6, valeurPieces[5], -1);
      }
    }
  }

  int miseEnEchec() {//renvoie 1 si le roi de l'equipe 1 sur l'echiquier echiquierMEE est en échecs (-1 pour l'equipe -1 et 0 pour pas de checkmate)
    int rep = 0;
    int caseMangeable[][] = new int[8][8]; //forme d'echiquier, si caseMangeable[0][0] = 1, alors cette case peut être mangé par un pion de l'équipe 1, si elle vaut 0 elle ne peut pas être mangé
    PVector roi[] = new PVector[2]; // 0 -> position du roi de l'equipe -1 ; 1-> de l'equipe 1

    for (int l = 0; l < 8; l ++) {
      for (int c = 0; c < 8; c ++) {
        // Pour chaques pièces de l'echiquier on regarde où il peut manger
        int casePoss[][] = e[l][c].deplacementPossible(l, c, this, 0, false); // Attention, il faut vérifier que ça ne boucle pas -------
        int equipePiece = e[l][c].equipe;
        if (casePoss.length > 0) {
          for (int i = 0; i < casePoss.length; i ++) {
            caseMangeable[casePoss[i][0]][casePoss[i][1]] = equipePiece;
          }
        }
        //On enregistre la position des rois
        if (e[l][c].type == 6) {
          roi[int(equipePiece+0.1)] = new PVector(l, c);
        }
      }
    }
    //si les roi sont mangeable
    try {
      if (caseMangeable[int(roi[0].x)][int(roi[0].y)] == 1) {
        rep = -1;
      } else if (caseMangeable[int(roi[1].x)][int(roi[1].y)] == -1) {
        rep = 1;
      }//NullPointerException
    }
    catch(NullPointerException e) {
      print("");
    }

    return rep;
  }

  void printlnE(Piece ech[][]) {//Affiche dans la console un echiquier -> utile pour le debbugage
    for (int i = 0; i < 8; i ++) {
      for (int j = 0; j < 8; j ++) {
        if (ech[i][j].type==0) {
          print("·");
        } else {
          print(ech[i][j].type);
        }
      }
      println("");
    }
  }

  Piece[][] copieEchiquier() {
    Piece echiquierBis[][] = new Piece[8][8];
    for (int l = 0; l < 8; l ++) {
      for (int c = 0; c < 8; c ++ ) {
        echiquierBis[l][c] = e[l][c];
      }
    }
    return echiquierBis;
  }


  void deplacement(int liD, int coD, int liA, int coA) {//déplace une pièce, Attention : effet de bord avec echiquier
    //avant le déplacement, on garde en mémoire l'ancienne échiquier (celui actuel)
    if (vraiEch) {
      listeEchiquier.add(this.copieEchiqu());
    }

    //Si un roi ou une tour bouge, on l'enregistre pour le roque
    if (roiBoug[int(0.1+e[liD][coD].equipe)] == false && e[liD][coD].type == 6) {
      roiBoug[int(0.1+e[liD][coD].equipe)] = true;
    }

    if (tourBoug[int(0.1+e[liD][coD].equipe)][0] == false && e[liD][coD].type == 2 && coD == 0) {
      tourBoug[int(0.1+e[liD][coD].equipe)][0] = true;
    }
    if (tourBoug[int(0.1+e[liD][coD].equipe)][1] == false && e[liD][coD].type == 2 && coD == 7) {
      tourBoug[int(0.1+e[liD][coD].equipe)][1] = true;
    }
    if (e[liD][coD].type == 6 && abs(coA-coD) == 2) {// e[liD][coD].type == 6 && e[liA][coA].type == 2 && e[liD][coD].equipe == e[liA][coA].equipe) {// Si on roque
      int coAr = 0;
      if (coA > 4) {
        coAr = 7;
      }
      roiBoug[int(0.1+e[liD][coD].equipe)] = true;
      Piece tour = e[liA][coAr];
      Piece roi = e[liD][coD];
      if (coA > 4) {
        e[liD][coD+2] = roi;//e[liD][coD];
        e[liD][coD+1] = tour;//e[liA][coA];
        e[liD][coD] = new Piece(0, 0, 0);
        e[liA][coAr] = new Piece(0, 0, 0);
      }
      if (coA <4) {
        e[liD][coD-2] = roi;//e[liD][coD];
        e[liD][coD-1] = tour;//e[liA][coA];
        e[liD][coD] = new Piece(0, 0, 0);
        e[liA][coAr] = new Piece(0, 0, 0);
      }
    } else {// Si c'est un déplacement normal
      if (e[liD][liA].type == 1 && abs(liA-liD) == 2) {//si c'est un pion
        ilADoubleColonne = coA;
      } else {
        ilADoubleColonne = -1;
      }


      if (e[liD][coD].type == 1 && e[liA][coA].type == 0 && abs(coA-coD) == 1) {//si c'est en passant

        if (vraiEch) {
          println(liD, coA);
          pieceMorte.add(e[liD][coA]);
        }
        e[liD][coA] =new Piece(0, 0, 0);
      }
      if (vraiEch && e[liA][coA].type > 0) {//si c'est un vrai déplacement et qu'une pièce est mangé, on l'enregistre dans les pièces mortes
        pieceMorte.add(e[liA][coA]);
        //nPieceMorte ++;
        if (vraiEch && e[liA][coA].type == 6) {//si c'est un roi -> Victoire !
          victorieux = tour;
          for (int i = 0; i<nAVictoire; i++) {
            feuArtVictoire [i]= new FeuArtifice(random(width/5.0, 4*width/5.0), height, width/25.0, 0, 90, height);
          }
        }
      }

      if (e[liA][coA].type == 2) {//si une pièce meurt et que c'est une tour. sans ça un roi peut roquer avec le fantome de sa tour pour se venger
        tourBoug[int(e[liA][coA].equipe+0.1)][int(coA/7)] =true; // [bas/haut][gauche / droite]
      }

      if (vraiEch) {
        int depla[] = {liD, coD, liA, coA};
        deplacements.add(depla);
        int h[] = {e[liD][coD].type, liD, coD, liA, coA, e[liA][coA].type};
        listeHisto.add(h);
      }
      //déplace
      if ((e[liD][coD].type == 1) && ((liA == 0) || (liA == 7))) {// Condition pour la promotion de pions
        if (entrainer == false) {
          if (tour == -1) {
            etat = 2;
            e[liA][coA] = e[liD][coD];
            e[liD][coD] = new Piece(0, 0, 0);
            pieceUp = new PVector(liA, coA);
          } else {
            if (nIA == -1) {
              etat = 2;
              e[liA][coA] = e[liD][coD];
              e[liD][coD] = new Piece(0, 0, 0);
              pieceUp = new PVector(liA, coA);
            } else {
              e[liA][coA] = new Piece(5, valReine, e[liD][coD].equipe);
              e[liD][coD] = new Piece(0, 0, 0);
            }
          }
        } else {
          e[liA][coA] = new Piece(5, valReine, e[liD][coD].equipe);
          e[liD][coD] = new Piece(0, 0, 0);
        }
      } else {
        e[liA][coA] = e[liD][coD];
        e[liD][coD] = new Piece(0, 0, 0);
      }
      if (vraiEch && e[liA][coA].equipe != 0 && this.miseEnEchec() == e[liA][coA].equipe) {//Si après notre coup on est en echec --> victoire pour l'autre equipe
        victorieux = -1* e[liA][coA].equipe;
        for (int i = 0; i<nAVictoire; i++) {
          feuArtVictoire [i]= new FeuArtifice(random(width/5.0, 4*width/5.0), height, width/25.0, 0, 90, height);
        }
      }
      if (vraiEch && e[liA][coA].equipe != 0 && this.miseEnEchec() == -1*e[liA][coA].equipe) {//Si après notre coup l'équipe ennemie est en echec
        //println("Equipe ennemie en echec");
        boolean coupPossible = false;
        int coT = 0;
        int liT = 0;
        while (liT < 8 && coupPossible == false) {
          if (e[liT][coT].equipe == -1*e[liA][coA].equipe && this.deplacementPossible(liT, coT).length > 0) {
            coupPossible = true;
            //println(liT,coT);
          }
          coT ++;
          if (coT >= 8) {
            coT = 0;
            liT ++;
          }
        }

        if (coupPossible == false) {//Si aucun coups possible
          //println("egalite");
          victorieux =  e[liA][coA].equipe;
          for (int i = 0; i<nAVictoire; i++) {
            feuArtVictoire [i]= new FeuArtifice(random(width/5.0, 4*width/5.0), height, width/25.0, 0, 90, height);
          }
        }
      }

      if (vraiEch) {
        //test d'égalité
        Boolean egalite = true;// on check si il reste au moins un coup à jouer au joueur adverse
        int equipe = e[liA][coA].equipe;
        boolean egaliteRois = true; //check s'il ne reste que 2 rois
        for (int i = 0; i < 8; i++) {
          for (int j = 0; j < 8; j++) {
            if (echiquierAff.e[i][j].equipe == -equipe && echiquierAff.e[i][j].deplacementPossible(i, j, echiquierAff, 0, false).length > 0) {
              egalite = false;
              //print(egalite);
            }
            if (echiquierAff.e[i][j].type != 0 && echiquierAff.e[i][j].type != 6) {
              egaliteRois = false;
            }
          }
        }
        Boolean egalite2 = false;// on check si on a joué 3 fois le même coup
        int n = echiquierAff.listeHisto.size() -1;
        if (n >= 9 &&
          Arrays.equals(echiquierAff.listeHisto.get(n), echiquierAff.listeHisto.get(n-4)) &&
          Arrays.equals(echiquierAff.listeHisto.get(n), echiquierAff.listeHisto.get(n-8)) && 
          Arrays.equals(echiquierAff.listeHisto.get(n-1), echiquierAff.listeHisto.get(n-5)) && 
          Arrays.equals(echiquierAff.listeHisto.get(n-1), echiquierAff.listeHisto.get(n-9))) {
          egalite2 = true;
        }
        if ((egalite || egalite2 || egaliteRois) && victorieux == 0) {
          victorieux = -2;
        }
      }
      if (numTypeJeu == 2) {//horde
        int npieceHorde=0;
        for (int i = 0; i < 8; i ++) {
          for (int j = 0; j < 8; j ++) {
            if (e[i][j].equipe == -equipeBlanche) {
              npieceHorde ++;
              i=7;
              j=7;
            }
          }
        }
        if (npieceHorde == 0) {
          victorieux =  equipeBlanche;
          for (int i = 0; i<nAVictoire; i++) {
            feuArtVictoire [i]= new FeuArtifice(random(width/5.0, 4*width/5.0), height, width/25.0, 0, 90, height);
          }
        }
      }
    }
  }

  Echiquier copieEchiqu() {//Permet d'obtenir une copie de cet echiquier
    Echiquier ech=new Echiquier();
    for (int l = 0; l < 8; l ++) {
      for (int c = 0; c < 8; c ++ ) {
        ech.e[l][c] = e[l][c];
      }
    }
    ArrayList<Piece> pieceMorteCop = new ArrayList<Piece>();
    for (int i = 0; i < pieceMorte.size(); i ++) {
      pieceMorteCop.add(pieceMorte.get(i));
    }
    ech.pieceMorte = pieceMorteCop;
    ech.deplacements = deplacements;
    ech.vraiEch = false;//vraiEch;
    ech.listeHisto=listeHisto;

    ech.roiBoug= new boolean[2];
    ech.roiBoug[0] = roiBoug[0];
    ech.roiBoug[1] = roiBoug[1];
    ech.tourBoug=new boolean[2][2];
    ech.tourBoug[0][0] = tourBoug[0][0];
    ech.tourBoug[0][1] = tourBoug[0][1];
    ech.tourBoug[1][0] = tourBoug[1][0];
    ech.tourBoug[1][1] = tourBoug[1][1];
    //ech.roiBoug = roiBoug;
    //ech.tourBoug = tourBoug;

    return ech;
  }

  void rmEchiqu(Echiquier ech) {//Permet de remplacer cet échiquier par ech (procédé inverse de copieEchiqu)
    for (int l = 0; l < 8; l ++) {
      for (int c = 0; c < 8; c ++ ) {
        e[l][c] = ech.e[l][c];
      }
    }
    pieceMorte = ech.pieceMorte;
    deplacements = ech.deplacements;
    vraiEch = ech.vraiEch;
    listeHisto = ech.listeHisto;

    roiBoug = ech.roiBoug;
    tourBoug = ech.tourBoug;
  }

  void defEchi(Piece trE[][]) {//Permet de définir l'echiquier
    e = trE;
  }

  boolean roquable(int equipeR, int numR) {//equipeR --> equipe qui veut roquer | numR --> 0 pour tour gauche / 1 pour tour droite
    boolean rep = false;

    if (this.miseEnEchec() != equipeR) {//n'est pas en echec
      if (!roiBoug[int(equipeR+0.1)] && !tourBoug[int(equipeR+0.1)][numR]) {// tour et roi n'ont pas bougé
        boolean champLibre = true;
        int colonneDepartV = 1;
        int ligneV = 7-7*int(0.1+equipeR);
        if (numR == 1) {
          while (colonneDepartV <7 && e[ligneV][7-colonneDepartV].type == 0 ) {
            colonneDepartV ++;
          }
          if (e[ligneV][7-colonneDepartV].type != 6) {
            champLibre = false;
          }
        } else {
          while (colonneDepartV <7 && e[ligneV][colonneDepartV].type == 0 ) {
            colonneDepartV ++;
          }
          //println(ligneV,colonneDepartV);
          if (e[ligneV][colonneDepartV].type != 6) {
            champLibre = false;
          }
        }
        if (champLibre) {
          Echiquier copie = copieEchiqu();
          int colonneRoi =3;
          if (equipeBlanche == -1) {//les blancs sont en bas
            colonneRoi=4;
          }
          if (numR == 0) {
            //println(victorieux);
            copie.deplacement(7-7*int(0.1+equipeR), colonneRoi, 7-7*int(0.1+equipeR), 0);
            //println(victorieux);
          } else {
            //println(victorieux);
            copie.deplacement(7-7*int(0.1+equipeR), colonneRoi, 7-7*int(0.1+equipeR), 7);
            //println(victorieux);
          }
          if (copie.miseEnEchec() == equipeR) {
            champLibre = false;
          }
        }
        rep = champLibre;
      }
    }
    return rep;
  }



  int[][]deplacementPossible(int ligne, int colonne) {
    int [][] deplacementSimple = deplacementSimple(e, ligne, colonne);
    ArrayList<int[]> deplacementsPoss = new ArrayList<int[]>();
    int equipe = e[ligne][colonne].equipe;
    int typePiece = e[ligne][colonne].type;
    for (int i = 0; i < deplacementSimple.length; i ++) {
      deplacementsPoss.add(deplacementSimple[i]);
    }

    if (ilADoubleColonne >= 0 && ligne == int(equipe+0.1)+3 && abs(ilADoubleColonne-colonne) == 1) {
      int enPassant[] = {ligne+equipe, ilADoubleColonne};
      deplacementsPoss.add(enPassant);
    }

    for (int i = 0; i < deplacementsPoss.size(); i ++) {
      Piece [][] eP = this.copieEchiquier();
      int[] depla = deplacementsPoss.get(i);
      eP[depla[0]][depla[1]] = eP[ligne][colonne];
      eP[ligne][colonne] = new Piece(0, 0, 0);
      int enEchecn = enEchec(eP);
      if (enEchecn == equipe || enEchecn == 2) {
        deplacementsPoss.remove(i);
        i --;
      }
    }
    //println(random(0,100));
    //println("Roquabilité Gauche : "+roquable(equipe, 0));
    if (typePiece == 6 && this.roquable(equipe, 0)) {//roque gauche
      int [] roqueM = {7-7*int(0.1+equipe), colonne-2};
      deplacementsPoss.add(roqueM);
    }
    //println("Roquabilité Droite : "+roquable(equipe,1));
    if (typePiece == 6 && this.roquable(equipe, 1)) {//roque droit
      int [] roqueM = {7-7*int(0.1+equipe), colonne+2};
      deplacementsPoss.add(roqueM);
    }
    //println(!roiBoug[0],!tourBoug[0][1]);


    int [][] reponse = new int[deplacementsPoss.size()][2];
    for (int i = 0; i < deplacementsPoss.size(); i ++) {
      reponse[i] = deplacementsPoss.get(i);
    }
    return reponse;
  }
}


void afficheList(int[] l) {//affiche une liste d'entiers (je sais pas où la mettre, mais peut être utile)
  int n = l.length;
  for (int i = 0; i<n; i++) {
    print(l[i]);
  }
  print("\n");
}

int enEchec(Piece[][] echiquier) {//permet de savoir si l'echiquier en entrée est en echec
  int rep = 0;
  int caseMangeable[][] = new int[8][8]; //forme d'echiquier, si caseMangeable[0][0] = 1, alors cette case peut être mangé par un pion de l'équipe 1, si elle vaut 0 elle ne peut pas être mangé
  PVector roi[] = new PVector[2]; // 0 -> position du roi de l'equipe -1 ; 1-> de l'equipe 1

  for (int l = 0; l < 8; l ++) {
    for (int c = 0; c < 8; c ++) {
      // Pour chaques pièces de l'echiquier on regarde où il peut manger
      int casePoss[][] = deplacementSimple(echiquier, l, c);
      int equipePiece = echiquier[l][c].equipe;
      if (casePoss.length > 0) {
        for (int i = 0; i < casePoss.length; i ++) {
          caseMangeable[casePoss[i][0]][casePoss[i][1]] = equipePiece;
        }
      }
      //On enregistre la position des rois
      if (echiquier[l][c].type == 6) {
        roi[int(equipePiece+0.1)] = new PVector(l, c);
      }
    }
  }
  //si les roi sont mangeable
  try {
    if (caseMangeable[int(roi[0].x)][int(roi[0].y)] == 1 && caseMangeable[int(roi[1].x)][int(roi[1].y)] == -1) {
      rep = 2;
    } else if (caseMangeable[int(roi[0].x)][int(roi[0].y)] == 1) {
      rep = -1;
    } else if (caseMangeable[int(roi[1].x)][int(roi[1].y)] == -1) {
      rep = 1;
    }
  }
  catch(NullPointerException e) {
    print("");
  }

  return rep;
}

int[][] deplacementSimple(Piece [][] e, int ligne, int colonne) {//Renvoie les deplacements possible sans prendre en compte le roque, ni les mises en echecs
  int [][] depPosTot = new int[64][2]; // deplacement possible total : un grand tableau du lequel on rentre tout les mouvements possible et qu'on redimensionne ensuite pour ne pas avoir de case vide
  int nPos = 0;//nombre de position possible

  Piece laPice = e[ligne][colonne];
  int equipe = laPice.equipe;
  //if (miseEchec == equipe && type != 6) {
  //} else {

  switch(laPice.type) {

    case(1)://pion
    //les premières conditions permettent de ne pas sortir de l'echiquier
    if ( (ligne+laPice.equipe >= 0 && ligne+laPice.equipe < 8 && e[ligne+laPice.equipe][colonne].equipe == 0) ) {//avance
      depPosTot[nPos][0] = ligne+laPice.equipe;
      depPosTot[nPos][1] = colonne;
      nPos ++;
    }
    if (ligne == (1-laPice.equipe)*3+(laPice.equipe+1)/2 && e[ligne+2*equipe][colonne].equipe == 0 && e[ligne+laPice.equipe][colonne].equipe == 0) {//double avance
      depPosTot[nPos][0] = ligne+2*equipe;
      depPosTot[nPos][1] = colonne;
      nPos ++;
    }
    if ( ligne+equipe >= 0 && ligne+equipe < 8 && colonne+1 >= 0 && colonne+1 < 8 && e[ligne+equipe][colonne+1].equipe != equipe && e[ligne+equipe][colonne+1].type != 0) {
      depPosTot[nPos][0] = ligne+equipe;
      depPosTot[nPos][1] = colonne+1;
      nPos ++;
    }
    if ( ligne+equipe >= 0 && ligne+equipe < 8 && colonne-1 >= 0 && colonne-1 < 8 && e[ligne+equipe][colonne-1].equipe != equipe && e[ligne+equipe][colonne-1].type != 0) {
      depPosTot[nPos][0] = ligne+equipe;
      depPosTot[nPos][1] = colonne-1;
      nPos ++;
    }
    break;

    case(2)://tour
    int k = 1;
    boolean toucher = false;
    while (ligne-k >= 0 && e[ligne-k][colonne].equipe != equipe && !toucher) {//haut
      depPosTot[nPos][0] = ligne-k;
      depPosTot[nPos][1] = colonne;
      if (e[ligne-k][colonne].equipe != equipe && e[ligne-k][colonne].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    k = 1;
    toucher = false;
    while (ligne+k < 8 && e[ligne+k][colonne].equipe != equipe && !toucher) {//bas
      depPosTot[nPos][0] = ligne+k;
      depPosTot[nPos][1] = colonne;
      if (e[ligne+k][colonne].equipe != equipe && e[ligne+k][colonne].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    k = 1;
    toucher = false;
    while (colonne-k >= 0 && e[ligne][colonne-k].equipe != equipe && !toucher) {//gauche
      depPosTot[nPos][0] = ligne;
      depPosTot[nPos][1] = colonne-k;
      if (e[ligne][colonne-k].equipe != equipe && e[ligne][colonne-k].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    k = 1;
    toucher = false;
    while (colonne+k < 8  && e[ligne][colonne+k].equipe != equipe && !toucher) {//gauche
      depPosTot[nPos][0] = ligne;
      depPosTot[nPos][1] = colonne+k;
      if (e[ligne][colonne+k].equipe != equipe && e[ligne][colonne+k].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }
    break;

    case(3)://cavalier
    int[][] cases = {{-1, -2}, {1, -2}, {2, -1}, {2, 1}, {1, 2}, {-1, 2}, {-2, 1}, {-2, -1}};
    for (int i = 0; i < 8; i ++) {
      if (ligne+cases[i][0] >= 0 && ligne+cases[i][0] < 8 && colonne+cases[i][1] >= 0 && colonne+cases[i][1] < 8 ) {
        if (e[ligne+cases[i][0]][colonne+cases[i][1]].equipe != equipe) {
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
    while (ligne-k >= 0 && colonne-k >= 0 && e[ligne-k][colonne-k].equipe != equipe && !toucher) {//haut gauche
      depPosTot[nPos][0] = ligne-k;
      depPosTot[nPos][1] = colonne-k;
      if (e[ligne-k][colonne-k].equipe != equipe && e[ligne-k][colonne-k].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    k = 1;
    toucher = false;
    while (ligne-k >= 0 && colonne+k < 8 && e[ligne-k][colonne+k].equipe != equipe && !toucher) {//haut droite
      depPosTot[nPos][0] = ligne-k;
      depPosTot[nPos][1] = colonne+k;
      if (e[ligne-k][colonne+k].equipe != equipe && e[ligne-k][colonne+k].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    k = 1;
    toucher = false;
    while (ligne+k < 8 && colonne-k >= 0 && e[ligne+k][colonne-k].equipe != equipe && !toucher) {//bas gauche
      depPosTot[nPos][0] = ligne+k;
      depPosTot[nPos][1] = colonne-k;
      if (e[ligne+k][colonne-k].equipe != equipe && e[ligne+k][colonne-k].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    k = 1;
    toucher = false;
    while (ligne+k < 8 && colonne+k < 8  && e[ligne+k][colonne+k].equipe != equipe && !toucher) {//bas droite
      depPosTot[nPos][0] = ligne+k;
      depPosTot[nPos][1] = colonne+k;
      if (e[ligne+k][colonne+k].equipe != equipe && e[ligne+k][colonne+k].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    break;

    case(5): //reine
    k = 1;
    toucher = false;
    while (ligne-k >= 0 && e[ligne-k][colonne].equipe != equipe && !toucher) {//haut
      depPosTot[nPos][0] = ligne-k;
      depPosTot[nPos][1] = colonne;
      if (e[ligne-k][colonne].equipe != equipe && e[ligne-k][colonne].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    k = 1;
    toucher = false;
    while (ligne+k < 8 && e[ligne+k][colonne].equipe != equipe && !toucher) {//bas
      depPosTot[nPos][0] = ligne+k;
      depPosTot[nPos][1] = colonne;

      if (e[ligne+k][colonne].equipe != equipe && e[ligne+k][colonne].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    k = 1;
    toucher = false;
    while (colonne-k >= 0 && e[ligne][colonne-k].equipe != equipe && !toucher) {//gauche
      depPosTot[nPos][0] = ligne;
      depPosTot[nPos][1] = colonne-k;
      if (e[ligne][colonne-k].equipe != equipe && e[ligne][colonne-k].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    k = 1;
    toucher = false;
    while (colonne+k < 8  && e[ligne][colonne+k].equipe != equipe && !toucher) {//gauche
      depPosTot[nPos][0] = ligne;
      depPosTot[nPos][1] = colonne+k;
      if (e[ligne][colonne+k].equipe != equipe && e[ligne][colonne+k].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    k = 1;
    toucher = false;
    while (ligne-k >= 0 && colonne-k >= 0 && e[ligne-k][colonne-k].equipe != equipe && !toucher) {//haut gauche
      depPosTot[nPos][0] = ligne-k;
      depPosTot[nPos][1] = colonne-k;
      if (e[ligne-k][colonne-k].equipe != equipe && e[ligne-k][colonne-k].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    k = 1;
    toucher = false;
    while (ligne-k >= 0 && colonne+k < 8 && e[ligne-k][colonne+k].equipe != equipe && !toucher) {//haut droite
      depPosTot[nPos][0] = ligne-k;
      depPosTot[nPos][1] = colonne+k;
      if (e[ligne-k][colonne+k].equipe != equipe && e[ligne-k][colonne+k].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    k = 1;
    toucher = false;
    while (ligne+k < 8 && colonne-k >= 0 && e[ligne+k][colonne-k].equipe != equipe && !toucher) {//bas gauche
      depPosTot[nPos][0] = ligne+k;
      depPosTot[nPos][1] = colonne-k;
      if (e[ligne+k][colonne-k].equipe != equipe && e[ligne+k][colonne-k].equipe != 0) {
        toucher = true;
      }
      nPos ++;
      k ++;
    }

    k = 1;
    toucher = false;
    while (ligne+k < 8 && colonne+k < 8  && e[ligne+k][colonne+k].equipe != equipe && !toucher) {//bas droite
      depPosTot[nPos][0] = ligne+k;
      depPosTot[nPos][1] = colonne+k;
      if (e[ligne+k][colonne+k].equipe != equipe && e[ligne+k][colonne+k].equipe != 0) {
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
        if (e[ligne+cases2[i][0]][colonne+cases2[i][1]].equipe != equipe) {
          depPosTot[nPos][0] = ligne+cases2[i][0];
          depPosTot[nPos][1] = colonne+cases2[i][1];
          nPos ++;
        }
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
  return depPosRep;
}
