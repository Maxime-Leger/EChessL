import java.util.*;

int valeurEmplacementIA1 = 2;
int profondeurIA1 = 2;

int evaluationIA1(Piece echiquier[][]) {
  int points = 0;

  for (int ligne = 0; ligne < 8; ligne ++) {
    for (int colonne = 0; colonne < 8; colonne ++) {
      points += echiquier[ligne][colonne].valeur*echiquier[ligne][colonne].equipe;
      points += valeurEmplacementIA1*(ligne-3.5)*echiquier[ligne][colonne].equipe;
      points += valeurEmplacementIA1*( 7-abs(ligne-3.5)+ abs(colonne-3.5))*echiquier[ligne][colonne].equipe;
    }
  }
  //println("IA1 : "+points);
  return points;
}

int fonctionEval(Echiquier ech) {
  return evaluationIA1(ech.e);
}

public int[] minimax(int equipe, int profondeur, Echiquier echiquierNoeud, int alpha, int beta) {//retourne la position de départ et d'arrivée du meilleur coût et sa valeur, alpha=-oo, beta=+oo
  int[] m = new int[0];//m={valeur coût,ligne départ,colonne départ,ligne arrivée,colonne arrivée}

  if (equipe == 1) {// l'équipe 1 maximise les poids
    m = new int[]{-1000009, -1, -1, -1, -1};
  } else if (equipe==-1) {// l'équipe -1 minimise les poids
    m = new int[]{1000009, -1, -1, -1, -1};
  }

  Stack<int[]> stack = new Stack<int[]>();
  Echiquier echiquierFils = new Echiquier();//échiquier qui explore les fils du noeud

  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (echiquierNoeud.e[i][j].equipe == equipe) {
        int deplaPossi[][] = echiquierNoeud.deplacementPossible(i, j); //.e[i][j]  , echiquierNoeud, 0, true
        int nbMov = deplaPossi.length;
        if (nbMov > 0) {
          nbMov--;

          echiquierFils = echiquierNoeud.copieEchiqu();
          echiquierFils.deplacement(i, j, deplaPossi[nbMov][0], deplaPossi[nbMov][1]);//déplace la pièce

          if (profondeur > 1) {//dans ce cas, on applique récursivement l'algorithme
            m = minimax(-equipe, profondeur - 1, echiquierFils, alpha, beta);
            m = new int[]{m[0], i, j, deplaPossi[nbMov][0], deplaPossi[nbMov][1]};

            if (m[0] > beta && equipe==1) {
              return m;
            }
            if (m[0] < alpha && equipe==-1) {
              return m;
            }//élagage
            if (equipe == 1) {
              alpha = max(alpha, m[0]);
            }
            if (equipe == -1) {
              beta = min(beta, m[0]);
            }

            if (stack.isEmpty()) {
              stack.push(m);
            } else if ((stack.peek()[0] < m[0] && equipe==1) || (stack.peek()[0] > m[0] && equipe==-1)) {
              stack.clear();
              stack.push(m);
            } else if (stack.peek()[0] == m[0]) {
              stack.push(m);
            }

            while (nbMov > 0) { //on parcours tous les mov possibles
              nbMov--;

              echiquierFils = echiquierNoeud.copieEchiqu();
              echiquierFils.deplacement(i, j, deplaPossi[nbMov][0], deplaPossi[nbMov][1]);//déplace la pièce

              m = minimax(-equipe, profondeur - 1, echiquierFils, alpha, beta);
              m = new int[]{m[0], i, j, deplaPossi[nbMov][0], deplaPossi[nbMov][1]};

              if (m[0] > beta && equipe==1) {
                return m;
              }
              if (m[0] < alpha && equipe==-1) {
                return m;
              }//élagage
              if (equipe == 1) {
                alpha = max(alpha, m[0]);
              }
              if (equipe == -1) {
                beta = min(beta, m[0]);
              }


              if ((stack.peek()[0] < m[0] && equipe==1) || (stack.peek()[0] > m[0] && equipe==-1)) {// l'équipe 1 maximise les poids
                stack.clear();
                stack.push(m);
              } else if (stack.peek()[0] == m[0]) {
                stack.push(m);
              }
            }
          } else { //ici, on utilise la fonction d'évaluation (même fonctionnement que l'autre boucle)
            m = new int[]{fonctionEval(echiquierFils), i, j, deplaPossi[nbMov][0], deplaPossi[nbMov][1]};

            if (m[0] > beta && equipe==1) {
              return m;
            }
            if (m[0] < alpha && equipe==-1) {
              return m;
            }//élagage
            if (equipe == 1) {
              alpha = max(alpha, m[0]);
            }
            if (equipe == -1) {
              beta = min(beta, m[0]);
            }


            if (stack.isEmpty()) {
              stack.push(m);
            } else if ((stack.peek()[0] < m[0] && equipe==1) || (stack.peek()[0] > m[0] && equipe==-1)) {
              stack.clear();
              stack.push(m);
            } else if (stack.peek()[0] == m[0]) {
              stack.push(m);
            }

            while (nbMov > 0) {
              nbMov--;
              echiquierFils = echiquierNoeud.copieEchiqu();
              echiquierFils.deplacement(i, j, deplaPossi[nbMov][0], deplaPossi[nbMov][1]);//déplace la pièce

              m = new int[]{fonctionEval(echiquierFils), i, j, deplaPossi[nbMov][0], deplaPossi[nbMov][1]};

              if (m[0] > beta && equipe==1) {
                return m;
              }
              if (m[0] < alpha && equipe==-1) {
                return m;
              }//élagage
              if (equipe == 1) {
                alpha = max(alpha, m[0]);
              }
              if (equipe == -1) {
                beta = min(beta, m[0]);
              }


              if ((stack.peek()[0] < m[0] && equipe==1) || (stack.peek()[0] > m[0] && equipe==-1)) {// l'équipe 1 maximise les poids
                stack.clear();
                stack.push(m);
              } else if (stack.peek()[0] == m[0]) {
                stack.push(m);
              }
            }
          }
        }
      }
    }
  }
  int ln = stack.size();
  if (ln <= 0) {
    return m;
  }
  ln = int(random(0, ln));
  while (ln > 0) {
    ln--;
    stack.pop();
  }
  return stack.pop();
}

void IA1() {
  Echiquier echiquierNoeud = echiquierAff.copieEchiqu();
  echiquierNoeud.vraiEch = false;
  if (echiquierAff.dansOuverture) {
    switch (echiquierAff.listeHisto.size()) {
      case (0):
      //e4
      echiquierAff.deplacement(1, 3, 3, 3);
      finTour();
      break;
      case (1):
      if (echiquierAff.listeHisto.get(0)[0] == 1 && echiquierAff.listeHisto.get(0)[1] == 6 && echiquierAff.listeHisto.get(0)[2] == 4 && echiquierAff.listeHisto.get(0)[3] == 4 && echiquierAff.listeHisto.get(0)[4] == 4) {
        //c5 after e4
        echiquierAff.deplacement(1, 2, 3, 2);
        finTour();
      } else {
        if (echiquierAff.listeHisto.get(0)[0] == 1 && echiquierAff.listeHisto.get(0)[1] == 6 && echiquierAff.listeHisto.get(0)[2] == 3 && echiquierAff.listeHisto.get(0)[3] == 4 && echiquierAff.listeHisto.get(0)[4] == 3) {
          //kf6 after d4
          echiquierAff.deplacement(0, 6, 2, 5);
          finTour();
        } else {
          //calcul du coup
          echiquierAff.dansOuverture = false;
          int[] m = minimax(1, 3, echiquierNoeud, -1000000, 1000000);
          echiquierAff.deplacement(m[1], m[2], m[3], m[4]);
          finTour();
        }
      }
      break;
      case  (2):
      if (echiquierAff.listeHisto.get(1)[0] == 1 && echiquierAff.listeHisto.get(1)[1] == 6 && echiquierAff.listeHisto.get(1)[2] == 5 && echiquierAff.listeHisto.get(1)[3] == 4 && echiquierAff.listeHisto.get(1)[4] == 5) {
        //Kf3 after c5
        echiquierAff.deplacement(0, 1, 2, 2);
        finTour();
      } else {
        if (echiquierAff.listeHisto.get(1)[0] == 1 && echiquierAff.listeHisto.get(1)[1] == 6 && echiquierAff.listeHisto.get(1)[2] == 3 && echiquierAff.listeHisto.get(1)[3] == 4 && echiquierAff.listeHisto.get(1)[4] == 3) {
          //Kf3 after e5
          echiquierAff.deplacement(0, 1, 2, 2);
          finTour();
        } else {
          echiquierAff.dansOuverture = false;
          int[] m = minimax(1, 3, echiquierNoeud, -1000000, 1000000);
          echiquierAff.deplacement(m[1], m[2], m[3], m[4]);
          finTour();
        }
      }
      break;
      case (3):
      if (echiquierAff.listeHisto.get(2)[0] == 3 && echiquierAff.listeHisto.get(2)[1] == 7 && echiquierAff.listeHisto.get(2)[2] == 6 && echiquierAff.listeHisto.get(2)[3] == 5 && echiquierAff.listeHisto.get(2)[4] == 5) {
        //Kc6 after Kf3
        echiquierAff.deplacement(0, 1, 2, 2);
        echiquierAff.dansOuverture = false;
        finTour();
      } else {
        if (echiquierAff.listeHisto.get(2)[0] == 3 && echiquierAff.listeHisto.get(2)[1] == 7 && echiquierAff.listeHisto.get(2)[2] == 1 && echiquierAff.listeHisto.get(2)[3] == 5 && echiquierAff.listeHisto.get(2)[4] == 2) {
          //Kc6 after Kc3
          echiquierAff.deplacement(0, 1, 2, 2);
          echiquierAff.dansOuverture = false;
          finTour();
        } else {
          echiquierAff.dansOuverture = false;
          int[] m = minimax(1, 3, echiquierNoeud, -1000000, 1000000);
          echiquierAff.deplacement(m[1], m[2], m[3], m[4]);
          finTour();
        }
      }
      break;
      case (4):
      if (echiquierAff.listeHisto.get(3)[0] == 3 && echiquierAff.listeHisto.get(3)[1] == 7 && echiquierAff.listeHisto.get(3)[2] == 6 && echiquierAff.listeHisto.get(3)[3] == 5 && echiquierAff.listeHisto.get(3)[4] == 5) {
        //Bc5 after Kc6
        echiquierAff.deplacement(0, 2, 4, 6);
        echiquierAff.dansOuverture = false;
        finTour();
      } else {
        if (echiquierAff.listeHisto.get(3)[0] == 1 && echiquierAff.listeHisto.get(3)[1] == 6 && echiquierAff.listeHisto.get(3)[2] == 4 && echiquierAff.listeHisto.get(3)[3] == 5 && echiquierAff.listeHisto.get(3)[4] == 4) {
          //Kc6 after Kc3
          echiquierAff.deplacement(1, 4, 3, 4);
          echiquierAff.dansOuverture = false;
          finTour();
        } else {
          echiquierAff.dansOuverture = false;
          int[] m = minimax(1, 3, echiquierNoeud, -1000000, 1000000);
          echiquierAff.deplacement(m[1], m[2], m[3], m[4]);
          finTour();
        }
      }
      break;
    }
  } else {
    int[] m = minimax(1, profondeurIA1, echiquierNoeud, -1000000, 1000000);
    echiquierAff.deplacement(m[1], m[2], m[3], m[4]);
    finTour();
  }
}


void copyTableau(Piece[][] echiquier, Piece[][] newEchiquier) {
  for (int i=0; i<8; i++) {
    for (int j=0; j<8; j++) {
      newEchiquier[i][j] = echiquier[i][j];
    }
  }
}
