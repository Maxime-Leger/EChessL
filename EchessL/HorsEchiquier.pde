int nAVictoire = 10;
FeuArtifice feuArtVictoire[] = new FeuArtifice[10];
boolean coeurCredit = false;
String dossierBoutons = "Boutons/";//dossier où on range les images des boutons
PImage boutonInit;
PImage boutonArr, historique, logoEChessL, logoECL;

float tempsJHp=0, tempsJBp=0;
float tempsJH = 0, tempsJB = 0;
float refTempFinTour = 0;
boolean demarrer = false;
float tpsChrDecomptePoss[] = {3*60, 5*60, 10*60, 15*60, 20*60, 25*60, 30*60, 40*60, 666};
int tpsChrDecompteChoix = 3;
float tpsChrDecompte = tpsChrDecomptePoss[tpsChrDecompteChoix];

int numTypeJeu = 0;
String typeJeu[] = {"Classique", "Aléatoire", "Horde"};

int npmp = 0;
ArrayList lettres = new ArrayList() { // pourrait être remplacer par char(97) pour a , char(98) pour b ect ...
  {
    add('a');
    add('b');
    add('c');
    add('d');
    add('e');
    add('f');
    add('g');
    add('h');
  }
};

void affichageHorsEchiquier() {
  //Les textes
  textSize(w/30);
  fill(0);
  //text("Tour :", w/50, h/17);
  text("Pieces Prises", w/20, h/4);
  //text("IA", w/285*10, h/105*100);

  if (equipeBlanche == -1) {
    text("a", w/2.75, h/1.2);
    text("b", w/2.3, h/1.2);
    text("c", w/1.95, h/1.2);
    text("d", w/1.7, h/1.2);
    text("e", w/1.5, h/1.2);
    text("f", w/1.35, h/1.2);
    text("g", w/1.225, h/1.2);
    text("h", w/1.127, h/1.2);
    text("1", w/1.05, h/1.29);
    text("2", w/1.05, h/1.42);
    text("3", w/1.05, h/1.59);
    text("4", w/1.05, h/1.8);
    text("5", w/1.05, h/2.1);
    text("6", w/1.05, h/2.5);
    text("7", w/1.05, h/3.1);
    text("8", w/1.05, h/4);
  } else {
    text("h", w/2.75, h/1.2);
    text("g", w/2.3, h/1.2);
    text("f", w/1.95, h/1.2);
    text("e", w/1.7, h/1.2);
    text("d", w/1.5, h/1.2);
    text("c", w/1.35, h/1.2);
    text("b", w/1.225, h/1.2);
    text("a", w/1.127, h/1.2);
    text("8", w/1.05, h/1.29);
    text("7", w/1.05, h/1.42);
    text("6", w/1.05, h/1.59);
    text("5", w/1.05, h/1.8);
    text("4", w/1.05, h/2.1);
    text("3", w/1.05, h/2.5);
    text("2", w/1.05, h/3.1);
    text("1", w/1.05, h/4);
  }

  // Tour de l'equipe

  stroke(0);
  if (equipeBlanche == -1) {
    fill(255);
  } else {
    fill(0);
  }

  rect(w/2-w/10, h-h/20, w/5, h/20);//bas
  if (equipeBlanche == -1) {
    fill(0);
  } else {
    fill(255);
  }
  if ( tpsChrDecompteChoix != tpsChrDecomptePoss.length-1) {
    text(temps(tpsChrDecompte-tempsJB), 315*w/700, h-h/80);//bas  str(int((tpsChrDecompte-tempsJB)*10)/10.0)
  } else {
    text("∞", w/2-w/10+w/80, h-h/80);
  }
  rect(w/2-w/10, h-3*h/20, w/5, h/20);//haut
  stroke(0);
  if (tour == equipeBlanche) {
    fill(255);
  } else {
    fill(0);
  }
  rect(w/2-w/20, h-2*h/20, w/10, h/20);//dimCase, dimCase);
  if (equipeBlanche == -1) {
    fill(255);
  } else {
    fill(0);
  }
  if (nIA == -1) {
    if ( tpsChrDecompteChoix != tpsChrDecomptePoss.length-1) {
      text(temps(tpsChrDecompte-tempsJH), 315*w/700, h-2*h/20-h/80);//haut  str(int((tpsChrDecompte-tempsJH)*10)/10.0)
    } else {
      text("∞", w/2-w/10+w/80, h-2*h/20-h/80);
    }
  }
  //Pieces mangée
  pushStyle();
  noFill();
  stroke(0);
  rect(dimCase/5, posEchY, 4*dimCase, dimCase);
  fill(200);
  float longueur = 7*dimCase;
  if( int(npmp/2+1)*dimCase*0.7+dimCase*0.5 > longueur){
    longueur = int(npmp/2+1)*dimCase*0.7+dimCase*0.5;
  }
  rect(dimCase/5, posEchY+dimCase, 2*dimCase, longueur);
  rect(dimCase/5+2*dimCase, posEchY+dimCase, 2*dimCase, longueur);
  if (echiquierAff.pieceMorte.size() > 0 ) {
    int npB = 0;
    int npN = 0;
    for (int i = 0; i  < echiquierAff.pieceMorte.size(); i ++) {

      if (echiquierAff.pieceMorte.get(i).equipe == equipeBlanche) {
        image(pieces[echiquierAff.pieceMorte.get(i).type-1][0], dimCase/5+(npB%2)*dimCase, posEchY+(npB/2+1)*dimCase*0.7+dimCase*0.3, dimCase, dimCase);
        npB ++;
      } else {
        image(pieces[echiquierAff.pieceMorte.get(i).type-1][1], (npN%2+2)*dimCase+dimCase/5, posEchY+(npN/2+1)*dimCase*0.7+dimCase*0.3, dimCase, dimCase);
        npN ++;
      }
    }
    npmp = max(npB,npN);
  }
  popStyle();
  if (victorieux != 0) {
    bouton_Victoire_Historique.aff();
  }
  bouton_Jeux_Undo.aff();

  bouton_Jeux_Restart.aff();

  bouton_Jeux_JcJ.aff();
  bouton_Jeux_IA1.aff();
  bouton_Jeux_IA2.aff();
  //bouton_Jeux_IA3.aff();
  
  bouton_Jeux_Menu.aff();
}




void affichagePromotion() {
  // permet de savoir où est le pion
  int liA = 0; 
  int coA = 0;
  for (int i=0; i<8; i = i+7) {
    for (int j=0; j<8; j++) {
      if (echiquierAff.e[i][j].type == 1) {
        liA = i;
        coA = j;
      }
    }
  }

  // Affiche les choix
  for (int i=0; i<4; i++) {
    //println(echiquierAff.e[liA][coA].equipe);
    image(pieces[1+i][int(echiquierAff.e[liA][coA].equipe != equipeBlanche)], posEchX+(i)*dimCase, posEchY-dimCase, dimCase, dimCase);
  }
}

void affichageVictoire() {

  if (victorieux != 0) {
    String equipeGagnante = "Victoire de l'équipe ";
    if (victorieux == -2) {
      equipeGagnante = "Egalité ! ";
    }
    pushStyle();
    stroke(75, 230, 50);
    //strokeWeight(w/100);
    noFill();
    rect(w/3, 55*h/700, w/1.65, h/10);
    fill(0);
    textSize(w/25);

    if (victorieux == equipeBlanche) {
      equipeGagnante += "blanche";
    } else if (victorieux == -equipeBlanche) {
      equipeGagnante += "noire";
    }

    text(equipeGagnante, w/2.77, 100*h/700);

    //strokeWeight(width/100);
    //stroke(0);
    //if (mouseX >345*width/700 && mouseX < 345*width/700+265*width/700 && mouseY > 635*width/700 && mouseY < 635*width/700+50*width/700) {
    //  stroke(70, 80, 200);
    //}

    //fill(255);
    //rect(345*width/700, 635*width/700, 265*width/700-h/10, 50*width/700);
    ////println(mouseX,mouseY);
    //fill(0);
    //textSize(width/35);
    //text("Historique Partie", 360*width/700, 666*height/700);

    if ( (nIA == -1 || (nIA >= 0 && victorieux == -1)) && victorieux != -2) {
      for (int i = 0; i<nAVictoire; i++) {
        feuArtVictoire[i].deplaff();
        if (feuArtVictoire[i].vf) {
          feuArtVictoire[i] = new FeuArtifice(random(width/5.0, 4*width/5.0), height, width/25.0, 0, 90, height);
        }
      }
    }
    popStyle();
  }
}

void affichageHistorique() {
  background(255);
  textSize(width/35);
  strokeWeight(width/100);
  stroke(0);
  //if (mouseX >345*width/700 && mouseX < 345*width/700+265*width/700 && mouseY > 635*width/700 && mouseY < 635*width/700+50*width/700) {
  //  stroke(70, 80, 200);
  //}

  //fill(255);
  //rect(345*width/700, 635*width/700, 265*width/700, 50*width/700);
  fill(0);

  String hist = new String();
  for (int i=0; i<echiquierAff.listeHisto.size(); i++) {
    if (i%2 == 0) {
      hist = hist+Integer.toString(i/2+1)+".";
    }
    switch (echiquierAff.listeHisto.get(i)[0]) {
      case(2)://Tour
      hist = hist + "T";
      break;
      case(3)://cavalier
      hist=hist+"C";
      break;
      case(4)://fou
      hist=hist+"F";
      break;
      case(5)://dame
      hist=hist+"D";
      break;
      case(6)://roi
      hist=hist+"R";
      break;
    }
    if (echiquierAff.listeHisto.get(i)[5] != 0) {
      if (echiquierAff.listeHisto.get(i)[0] == 1) {
        if (equipeBlanche == -1) {
          hist = hist+lettres.get(echiquierAff.listeHisto.get(i)[2]);
        } else {
          hist = hist+lettres.get(7-echiquierAff.listeHisto.get(i)[2]);
        }
      }
      hist = hist+'x';
    }
    if (equipeBlanche == -1) {
      hist = hist + lettres.get(echiquierAff.listeHisto.get(i)[4]) + Integer.toString(8-echiquierAff.listeHisto.get(i)[3]);
    } else {
      hist = hist + lettres.get(7-echiquierAff.listeHisto.get(i)[4]) + Integer.toString(echiquierAff.listeHisto.get(i)[3]+1);
    }
    hist = hist+" ";
    float ind = i;
    if ((ind+1)%9 == 0) {
      hist = hist + "\n";
    }
  }
  text(hist, 30*width/700, 66*height/700);
  //text("Retour au Jeu", 360*width/700, 666*height/700);
  if (victorieux != 0) {
    bouton_Victoire_Historique.aff();
  }
}



class FeuArtifice {
  float x, y;
  float montee = 0;
  float Ymontee;
  float deltaM = 0.01;
  float dim;
  int generation;
  color c = color(random(0, 255), random(0, 255), random(0, 255));
  int nFils = int(random(20, 50));
  FeuArtifice fils[] = new FeuArtifice[nFils];
  boolean ini = true;
  float direction;
  boolean fin = false;
  float hauteur;
  boolean vf = false;
  FeuArtifice(float xi, float yi, float dimi, int generationi, float directioni, float hauteuri) {
    x = xi;
    y = yi;
    dim = dimi;
    generation = generationi;
    Ymontee = random(hauteuri/5, hauteuri/1.1);
    direction = directioni;
    if (generation >= 1) {
      fin = true;
    }
    hauteur = hauteuri;
    deltaM = 1.2*(1-Ymontee/hauteur)*random(0.01*pow(generation+1, 0.1), 0.03*pow(generation+1, 0.1));
  }

  void deplaff() {
    if (vf == false) {
      if (montee < 1) {
        pushMatrix();
        noStroke();
        fill(c);
        translate(x+dim/2.0, y+dim/2.0);
        rotate(radians(360*montee*5));
        rect(-dim/2.0, -dim/2.0, dim, dim);
        popMatrix();
        montee += deltaM;
        y -= sin(radians(direction))*deltaM*Ymontee;
        x += cos(radians(direction))*deltaM*Ymontee;
      } else if (fin == false) {
        if (ini) {
          ini = false;
          for (int i = 0; i < nFils; i ++) {
            fils[i] = new FeuArtifice(x, y, dim/2.0, generation+1, random(0, 360), hauteur*0.2);
          }
        } else {
          boolean vie = false;
          for (int i = 0; i < nFils; i ++) {
            fils[i].deplaff();
            if (vie == false && fils[i].vf == false) {
              vie = true;
            }
          }
          if (vie == false) {
            vf = true;
          }
        }
      } else {
        vf = true;
      }
    }
  }
}

/*Créé un bouton :
 Bouton nomBt;
 dans initialisationBoutons :
 nomBt = new Bouton(x,y,longueur,largeur,Texte,position texte x, "" y, numéro d'action, liste des etats ou le bouton est présent)
 dans actionBoutons :
 case(numéro d'action):
 action réalisée
 break;
 Dans la fonction d'affichage correspondant :
 nomBt.aff();
 dans mousePressed :
 nomBt.exec();
 
 */
PImage neutre;

Bouton bouton_menuP_Jouer;
Bouton bouton_menuP_Quitter;
Bouton bouton_menuP_ProfondeurIAp;
Bouton bouton_menuP_ProfondeurIAm;
Bouton bouton_menuP_Chronop;
Bouton bouton_menuP_Chronom;
Bouton bouton_menuP_Jeup;
Bouton bouton_menuP_Jeum;
Bouton bouton_menuP_credits;

Bouton bouton_Jeux_Undo;
Bouton bouton_Jeux_Restart;
Bouton bouton_Jeux_JcJ;
Bouton bouton_Jeux_IA1;
Bouton bouton_Jeux_IA2;
//Bouton bouton_Jeux_IA3;
Bouton bouton_Jeux_Menu;

Bouton bouton_Victoire_Historique;

Bouton bouton_credits_menuP;

void initialisationBoutons() {
  float ls3 []= {3};
  bouton_menuP_Jouer = new Bouton(width/3.0, height/2.0-height/20.0, width/3.0, height/10.0, "Jouer", width/70.0, height/70.0, 0, ls3, false, neutre);
  bouton_menuP_Quitter = new Bouton(width*0.85, 0, width*0.15, height*0.05, "Quitter", -width/100.0, height/120.0, 1, ls3, false, neutre);
  bouton_menuP_ProfondeurIAp = new Bouton(width/10, height/2.0+height/5.0, width/10, height/20.0, "+", 0, height/80.0, 8, ls3, false, neutre);
  bouton_menuP_ProfondeurIAm = new Bouton(width/10, height/2.0+height/5.0+height/10.0, width/10, height/20.0, "-", 0, height/80.0, 9, ls3, false, neutre);
  bouton_menuP_Chronop = new Bouton(width/2.0-width/20.0, height/2.0+height/5.0, width/10.0, height/20.0, "+", 0, height/80.0, 10, ls3, false, neutre);
  bouton_menuP_Chronom = new Bouton(width/2.0-width/20.0, height/2.0+height/5.0+height/10.0, width/10.0, height/20.0, "-", 0, height/80.0, 11, ls3, false, neutre);
  bouton_menuP_Jeup = new Bouton(505*w/700, height/2.0+height/5.0, 120*w/700, height/20.0, "    +   ", 0, height/80.0, 12, ls3, false, neutre);
  bouton_menuP_Jeum = new Bouton(505*w/700, height/2.0+height/5.0+height/10.0, 120*w/700, height/20.0, "    -   ", 0, height/80.0, 13, ls3, false, neutre);
  bouton_menuP_credits = new Bouton(0, 0, width*0.15, height*0.05, "Crédits", -width/100.0, height/120.0, 14, ls3, false, neutre);
  float ls0 [] = {0};
  float ls03[] = {0, 3};
  bouton_Jeux_Undo = new Bouton(w-2*w/10, h-h/10, w/10, h/10, "Retour Arriere", 0, 0, 2, ls0, true, boutonArr);
  bouton_Jeux_Restart = new Bouton(w-w/10, h-h/10, w/10, h/10, "Redemarrer", 0, 0, 3, ls0, true, boutonInit);
  bouton_Jeux_JcJ = new Bouton(w/20, h-h/10, w/10, h/20, "JcJ", 0, h/70, 4, ls03, false, neutre);
  bouton_Jeux_IA1 = new Bouton(w/10+w/20, h-h/10, w/7, h/20, "MinMax", -w/50, h/70, 5, ls03, false, neutre);
  bouton_Jeux_IA2 = new Bouton(w/10+w/20+w/7, h-h/10, w/7, h/20, "Neurone", -w/50, h/70, 16, ls03, false, neutre);
  //bouton_Jeux_IA3 = new Bouton(w/10+w/20+2*w/10, h-h/10, w/10, h/20, "IA3", 0, h/70, 17, ls03, false, neutre);
  if (nIA == -1) {
    bouton_Jeux_JcJ.select = true;
  } else if (nIA == 1) {
    bouton_Jeux_IA1.select = true;
  } else if (nIA == 2) {
    bouton_Jeux_IA2.select = true;
  } 
  //else if (nIA == 3) {
  //  bouton_Jeux_IA3.select = true;
  //}
  float ls01[] = {0, 1};
  bouton_Victoire_Historique = new Bouton(w-3*w/10, h-h/10, w/10, h/10, "Historique", 0, 0, 6, ls01, true, historique);
  bouton_Jeux_Menu = new Bouton(width*0.85, 0, width*0.15, height*0.05, "Menu", -width/100.0, height/120.0, 7, ls0, false, neutre);
  float ls4[] = {4};
  bouton_credits_menuP = new Bouton(width-width*0.15, 0, width*0.15, height*0.05, "Menu", -width/100.0, height/120.0, 15, ls4, false, neutre);
}

void menuPrincipale() {
  pushStyle();
  background(255);
  bouton_menuP_Jouer.aff();
  bouton_menuP_Quitter.aff();
  bouton_menuP_ProfondeurIAp.aff();
  bouton_menuP_ProfondeurIAm.aff();
  bouton_menuP_Chronop.aff();
  bouton_menuP_Chronom.aff();
  bouton_menuP_Jeup.aff();
  bouton_menuP_Jeum.aff();
  bouton_Jeux_JcJ.aff();
  bouton_Jeux_IA1.aff();
  bouton_Jeux_IA2.aff();
  //bouton_Jeux_IA3.aff();
  bouton_menuP_credits.aff();
  popStyle();
  image(logoEChessL, 270*width/700, 50*height/700, w/6.4*1.5, h/4.6*1.5);
  noFill();
  stroke(0);
  strokeWeight(3);
  rect(width/10, height/2.0+height/5.0+height/20.0, width/10, height/20.0);//rectangle de la profondeur de l'IA
  rect(width/2.0-width/20.0, height/2.0+height/5.0+height/20.0, width/10, height/20.0);
  rect(505*w/700, height/2.0+height/5.0+height/20.0, 120*w/700, height/20.0);
  //rect(8*w/700,440*h/700,192*w/700,35*h/700);
  fill(0);
  textSize(height/20.0*0.7);
  text(profondeurIA1, 97*w/700, 553*h/700);//Affiche la profondeur de l'IA

  if (tpsChrDecompteChoix == tpsChrDecomptePoss.length-1) {
    text("∞", 320*w/700, 552*h/700);
  } else {
    text(int(tpsChrDecompte/60), 320*w/700, 553*h/700);
  }
  textSize(height/20.0*0.5);
  text(typeJeu[numTypeJeu], 515*w/700, 550*h/700);
  text("min", 350*w/700, 552*h/700);
  textSize(height/20.0*0.7);
  text("Pronfondeur IA", 15*w/700, 466*h/700);
  text("Chronomètre", 266*w/700, 466*h/700);
  text("Type de Jeu", 500*w/700, 466*h/700);
  //println(mouseX, mouseY);
}

class Bouton {
  float x, y, dx, dy, decalX, decalY;
  String txt;
  int numeroAction;
  float etatPres[];
  boolean Affimg;
  PImage img;
  boolean select = false;
  Bouton(float xR, float yR, float dx, float dy, String txt, float decalX, float decalY, int numAct, float etatPresents[], boolean Affimg, PImage img) {
    this.x=xR;
    this.y=yR;
    this.dx=dx;
    this.dy=dy;
    this.txt = txt;
    this.decalX = decalX;
    this.decalY = decalY;
    numeroAction = numAct;
    etatPres = etatPresents;
    this.Affimg = Affimg;
    this.img = img;
  }

  void aff() {
    if ( in(etat, etatPres)) {
      pushStyle();
      if (Affimg) {
        strokeWeight(6);
      } else {
        strokeWeight(3);
      }
      if (mouseX > x && mouseX < x+dx && mouseY > y && mouseY < y + dy) {
        stroke(75, 100, 200);
      } else {
        stroke(0);
      }
      if (select) {
        fill(150);
      } else {
        fill(255);
      }

      rect(x, y, dx, dy);
      if (Affimg) {
        image(img, x, y, dx, dy);
      } else {
        textSize(dy*3.0/5);
        fill(0);
        text(txt, x+dy*3.0/4+decalX, y+dy/2.0+decalY);
      }
      popStyle();
    }
  }

  void exec() {
    if ( in(etat, etatPres)) {
      if (mouseX > x && mouseX < x+dx && mouseY > y && mouseY < y + dy) {
        actionBoutons(numeroAction);
      }
    }
  }
}

void actionBoutons(int numAction) {
  switch(numAction) {
    case(0)://jouer
    reinitialisation();
    passageEtat(int(etat), 0);
    break;

    case(1)://quitter
    exit();
    break;

    case(2)://retour arriere
    int n = listeEchiquier.size();
    if (mouseX > w - w/5.3 && mouseX < w-w/5.3+dimCase && mouseY > h-h/11.5 && n > 0) {//mouseX > w-2*w/10 && mouseX < w-w/10 && mouseY > h-h/10
      if (victorieux != 0) {
        victorieux = 0;
      }
      int z = 1;
      if (nIA >0) {
        z++;
      }
      int i = 0;
      while (i<z && n > 0) {
        echiquierAff.rmEchiqu(listeEchiquier.get(n-1));
        echiquierAff.vraiEch = true;
        listeEchiquier.remove(n-1);

        affichageEchiquier();
        i++;
        n--;
        tour *= -1;
      }
    }
    break;

    case(3)://reinitialisation
    reinitialisation();
    break;

    case(4)://JcJ
    bouton_Jeux_JcJ.select = true;
    bouton_Jeux_IA1.select = false;
    bouton_Jeux_IA2.select = false;
    //bouton_Jeux_IA3.select = false;
    nIA = -1;
    break;

    case(5)://IA1
    bouton_Jeux_JcJ.select = false;
    bouton_Jeux_IA1.select = true;
    bouton_Jeux_IA2.select = false;
    //bouton_Jeux_IA3.select = false;
    nIA = 1;
    break;

    case(6)://historique
    if (etat == 0) {
      passageEtat(0, 1);
    } else if (etat == 1) {
      passageEtat(1, 0);
    }
    break;

    case(7):
    passageEtat(0, 3);
    break;

    case(8):
    profondeurIA1 ++;
    break;

    case(9):
    profondeurIA1 --;
    break;

    case(10):
    tpsChrDecompteChoix ++;
    if (tpsChrDecompteChoix >= tpsChrDecomptePoss.length) {
      tpsChrDecompteChoix = 0;
    }
    tpsChrDecompte = tpsChrDecomptePoss[tpsChrDecompteChoix];
    break;

    case(11):
    tpsChrDecompteChoix --;
    if (tpsChrDecompteChoix < 0) {
      tpsChrDecompteChoix = tpsChrDecomptePoss.length-1;
    }
    tpsChrDecompte = tpsChrDecomptePoss[tpsChrDecompteChoix];
    break;

    case(12):
    numTypeJeu ++;
    if (numTypeJeu >= typeJeu.length) {
      numTypeJeu = 0;
    }
    break;

    case(13):
    numTypeJeu --;
    if (numTypeJeu < 0) {
      numTypeJeu = typeJeu.length-1;
    }
    break;

    case(14):
    passageEtat(3, 4);
    break;

    case(15):
    passageEtat(4, 3);
    break;
    
    case(16)://IA1
    bouton_Jeux_JcJ.select = false;
    bouton_Jeux_IA1.select = false;
    bouton_Jeux_IA2.select = true;
    //bouton_Jeux_IA3.select = false;
    nIA = 2;
    break;
    
    case(17)://IA1
    bouton_Jeux_JcJ.select = false;
    bouton_Jeux_IA1.select = false;
    bouton_Jeux_IA2.select = false;
    //bouton_Jeux_IA3.select = true;
    nIA = 3;
    break;
  }
}


void passageEtat(int etatBase, int etatArr) {//beaucoup de choses inutiles ici, mais qui peuvent se rendre pratique si on fait des boutons + complexes
  etat = etatArr;
}

boolean in(float nb, float liste[]) {
  boolean rep = false;
  for (int i = 0; i< liste.length; i ++) {
    if ( liste[i] == nb) {
      rep = true;
    }
  }
  return rep;
}

String temps(float nsec) {
  String rep = "";
  rep += int(nsec/60);
  rep += "'";
  if (int(nsec%60) < 10) {
    rep += "0";
  }
  rep += int(nsec%60);
  rep += "''";
  return rep;
}

void affichageCredits() {
  background(255);
  fill(0);
  bouton_credits_menuP.aff();

  textSize(width/15);
  text("PE-36", 280*w/700, 90*h/700);
  text("EChessL", 255*w/700, 140*h/700);
  textSize(width/20);
  text("Élèves :", 55*w/700, 235*h/700);
  text("Encadrants :", 415*w/700, 235*h/700);
  textSize(width/30);
  text("Frédéric Legrand", 77*w/700, 290*h/700);
  text("Matthieu Baboulène", 77*w/700, 290*h/700+width/22);
  text("Antoine Zurcher", 77*w/700, 290*h/700+2*width/22);
  text("Maxime Léger", 77*w/700, 290*h/700+3*width/22);
  text("Pierre Corbani", 77*w/700, 290*h/700+4*width/22);
  text("Nicolas Malleton", 77*w/700, 290*h/700+5*width/22);

  text("Alexandre Saidi", 442*w/700, 290*h/700);
  text("Abdel Malek Zine", 442*w/700, 290*h/700+width/22);
  text("Philippe Michel", 442*w/700, 290*h/700+2*width/22);
  text("Caroline Beslin", 442*w/700, 290*h/700+3*width/22);
  text("Olivier Dessombz", 442*w/700, 290*h/700+4*width/22);

  image(logoECL, 275*w/700, 475*h/700, 160*w/700, 200*h/700);

  if (coeurCredit) {
    pushMatrix();
    translate(80*w/700, 52*h/700);
    smooth();
    noStroke();
    fill(255, 0, 0);
    beginShape();
    vertex(50*2*w/700, 15*2*w/700);
    bezierVertex(50*2*w/700, -5*2*w/700, 90*2*w/700, 5*2*w/700, 50*2*w/700, 40*2*w/700);
    vertex(50*2*w/700, 15*2*w/700);
    bezierVertex(50*2*w/700, -5*2*w/700, 10*2*w/700, 5*2*w/700, 50*2*w/700, 40*2*w/700);
    endShape();
    translate(333*w/700, 0);
    smooth();
    noStroke();
    fill(255, 0, 0);
    beginShape();
    vertex(50*2*w/700, 15*2*w/700);
    bezierVertex(50*2*w/700, -5*2*w/700, 90*2*w/700, 5*2*w/700, 50*2*w/700, 40*2*w/700);
    vertex(50*2*w/700, 15*2*w/700);
    bezierVertex(50*2*w/700, -5*2*w/700, 10*2*w/700, 5*2*w/700, 50*2*w/700, 40*2*w/700);
    endShape();

    popMatrix();
  }
  //println(mouseX,mouseY);
}
