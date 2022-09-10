//Copie (à peu près) de l'ia 1, mais avec une fonction d'évaluation différente

import java.util.*;

//int valeurEmplacementIA3 = 2;
float neutreM[][] = {};
ReseauNeurone eval2,eval2IA1;

float evaluationIA2(Piece echiquier[][],ReseauNeurone rsN) {
  float points = 0;
  float matrEntr[] = new float[64];
  int compt = 0;
  for (int ligne = 0; ligne < 8; ligne ++) {
    for (int colonne = 0; colonne < 8; colonne ++) {
      matrEntr[compt] = echiquier[ligne][colonne].valeur*echiquier[ligne][colonne].equipe;
      compt ++;
    }
  }
  points = rsN.solution(matrEntr)[0];
  return points;
}

float evaluationIA1bis(Piece echiquier[][]) {
  float points = 0;

  for (int ligne = 0; ligne < 8; ligne ++) {
    for (int colonne = 0; colonne < 8; colonne ++) {
      points += echiquier[ligne][colonne].valeur*echiquier[ligne][colonne].equipe;
    }
  }
  return points/2500.0;
}

float fonctionEval2(Echiquier ech,ReseauNeurone rsN) {
  return evaluationIA2(ech.e,rsN);
}

public float[] minimax3(int equipe, int profondeur, Echiquier echiquierNoeud, float alpha, float beta,ReseauNeurone rsN,float equipeBase) {//retourne la position de départ et d'arrivée du meilleur coût et sa valeur, alpha=-oo, beta=+oo 
float[] m = new float[0];//m={valeur coût,ligne départ,colonne départ,ligne arrivée,colonne arrivée}

  if (equipe == equipeBase) {// l'équipe 1 maximise les poids
    m = new float[]{-1000009, -1, -1, -1, -1};
  } else if (equipe==-equipeBase) {// l'équipe -1 minimise les poids
    m = new float[]{1000009, -1, -1, -1, -1};
  }

  Stack<float[]> stack = new Stack<float[]>();
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
            m = minimax3(-equipe, profondeur - 1, echiquierFils, alpha, beta,rsN,equipeBase);
            m = new float[]{m[0], i, j, deplaPossi[nbMov][0], deplaPossi[nbMov][1]};

            if (m[0] > beta && equipe==equipeBase) {
              return m;
            }
            if (m[0] < alpha && equipe==-equipeBase) {
              return m;
            }//élagage
            if (equipe == equipeBase) {
              alpha = max(alpha, m[0]);
            }
            if (equipe == -equipeBase) {
              beta = min(beta, m[0]);
            }

            if (stack.isEmpty()) {
              stack.push(m);
            } else if ((stack.peek()[0] < m[0] && equipe==equipeBase) || (stack.peek()[0] > m[0] && equipe==-equipeBase)) {
              stack.clear();
              stack.push(m);
            } else if (stack.peek()[0] == m[0]) {
              stack.push(m);
            }

            while (nbMov > 0) { //on parcours tous les mov possibles
              nbMov--;

              echiquierFils = echiquierNoeud.copieEchiqu();
              echiquierFils.deplacement(i, j, deplaPossi[nbMov][0], deplaPossi[nbMov][1]);//déplace la pièce

              m = minimax3(-equipe, profondeur - 1, echiquierFils, alpha, beta,rsN,equipeBase);
              m = new float[]{m[0], i, j, deplaPossi[nbMov][0], deplaPossi[nbMov][1]};

              if (m[0] > beta && equipe==equipeBase) {
                return m;
              }
              if (m[0] < alpha && equipe==-equipeBase) {
                return m;
              }//élagage
              if (equipe == equipeBase) {
                alpha = max(alpha, m[0]);
              }
              if (equipe == -equipeBase) {
                beta = min(beta, m[0]);
              }


              if ((stack.peek()[0] < m[0] && equipe==equipeBase) || (stack.peek()[0] > m[0] && equipe==-equipeBase)) {// l'équipe 1 maximise les poids
                stack.clear();
                stack.push(m);
              } else if (stack.peek()[0] == m[0]) {
                stack.push(m);
              }
            }
          } else { //ici, on utilise la fonction d'évaluation (même fonctionnement que l'autre boucle)
            m = new float[]{fonctionEval2(echiquierFils,rsN), i, j, deplaPossi[nbMov][0], deplaPossi[nbMov][1]};

            if (m[0] > beta && equipe==equipeBase) {
              return m;
            }
            if (m[0] < alpha && equipe==-equipeBase) {
              return m;
            }//élagage
            if (equipe == equipeBase) {
              alpha = max(alpha, m[0]);
            }
            if (equipe == -equipeBase) {
              beta = min(beta, m[0]);
            }


            if (stack.isEmpty()) {
              stack.push(m);
            } else if ((stack.peek()[0] < m[0] && equipe==equipeBase) || (stack.peek()[0] > m[0] && equipe==-equipeBase)) {
              stack.clear();
              stack.push(m);
            } else if (stack.peek()[0] == m[0]) {
              stack.push(m);
            }

            while (nbMov > 0) {
              nbMov--;
              echiquierFils = echiquierNoeud.copieEchiqu();
              echiquierFils.deplacement(i, j, deplaPossi[nbMov][0], deplaPossi[nbMov][1]);//déplace la pièce

              m = new float[]{fonctionEval2(echiquierFils,rsN), i, j, deplaPossi[nbMov][0], deplaPossi[nbMov][1]};

              if (m[0] > beta && equipe==equipeBase) {
                return m;
              }
              if (m[0] < alpha && equipe==-equipeBase) {
                return m;
              }//élagage
              if (equipe == equipeBase) {
                alpha = max(alpha, m[0]);
              }
              if (equipe == -equipeBase) {
                beta = min(beta, m[0]);
              }


              if ((stack.peek()[0] < m[0] && equipe==equipeBase) || (stack.peek()[0] > m[0] && equipe==-equipeBase)) {// l'équipe 1 maximise les poids
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

void IA2(ReseauNeurone rsN,int equipeBase) {
  Echiquier echiquierNoeud = echiquierAff.copieEchiqu();
  echiquierNoeud.vraiEch = false;
  float[] m = minimax3(equipeBase, profondeurIA1, echiquierNoeud, -100000, 1000000,rsN,equipeBase);
  echiquierAff.deplacement(int(m[1]), int(m[2]), int(m[3]), int(m[4]));
  finTour();
}
