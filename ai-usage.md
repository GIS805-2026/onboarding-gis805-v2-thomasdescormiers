# Trace d'usage IA - GIS805

> Chaque interaction significative avec un outil IA doit etre documentee ici.
> Ce fichier est obligatoire et evalue a chaque remise.

## Format par entree

```md
### YYYY-MM-DD - Seance SXX
- **Modele :** (ChatGPT-4o, Claude, Copilot, etc.)
- **Prompt :** (copier-coller exact)
- **Resultat :** (resume de ce que l'IA a produit)
- **Validation :** (comment vous avez verifie/modifie le resultat)
- **Justification :** (pourquoi cette interaction etait necessaire)
```

---

### 2026-05-09 - Seance S01
- **Modele :** ChatGPT / Codex
- **Prompt :** "Je dois faire les sql/dims/ -- vos tables de dimensions, sql/facts/ -- vos tables de faits, sql/views/ -- vos requetes analytiques, answers/ -- vos executive briefs, docs/ -- vos decisions, politiques, documentation puisque lorsque je fais make check, j'ai des erreurs. Aide-moi a faire les requetes SQL au bon endroit pour les tables."
- **Resultat :** L'IA a propose et cree des requetes SQL pour les dimensions dans `sql/dims/`, les tables de faits dans `sql/facts/`, la bridge dans `sql/bridges/` et des vues analytiques dans `sql/views/`.
- **Validation :** J'ai relu les fichiers SQL crees, verifie qu'ils suivent la structure du depot et que les tables correspondent aux attentes de `validation/checks.sql`.
- **Justification :** Cette interaction etait necessaire pour corriger les erreurs de validation et placer les requetes SQL dans les bons dossiers du projet.

### 2026-05-09 - Seance S01
- **Modele :** ChatGPT / Codex
- **Prompt :** "Comment remplir le fichier S01_executive_brief en fonction de la question du CEO ?"
- **Resultat :** L'IA a identifie la question du CEO dans le guide de la seance S01 et a rempli `answers/S01_executive_brief.md` avec une reponse executive, des decisions de modelisation, une preuve SQL, une validation, des risques et une prochaine recommandation.
- **Validation :** J'ai compare la question du CEO avec `docs/lab-guides/GIS805-01_lab.md` et relu le brief pour verifier qu'il correspond a ma comprehension de NexaMart et du livrable S01.
- **Justification :** Cette interaction etait necessaire pour structurer le brief executif S01 selon les sections attendues et expliquer clairement la premiere question d'affaires.

### 2026-05-10 - Seance S01
- **Modele :** ChatGPT / Codex
- **Prompt :** "Peux tu m'aider a trouver quelles categories declinent dans quelles regions et pourquoi? Formatte bien le tableau de resultats et met le tableau comme derniere section parmis la section \"reponse executive\" Aussi, peux tu ajouter une entree dans le fichier ai usage svp?"
- **Resultat :** L'IA a reorganise `answers/S01_executive_brief.md` autour d'une reponse chiffree au CEO, deplace le tableau a la fin de la section `Reponse executive`, ajuste les sections de preuve, validation, risques et recommandation, puis ajoute cette entree dans `ai-usage.md`.
- **Validation :** J'ai verifie que les chiffres du tableau proviennent de la requete dans `sql/sandbox/exploration.sql` et que le brief repond directement a la question du CEO.
- **Justification :** Cette interaction etait necessaire pour transformer le brief S01 en reponse executive concrete, alignee avec les resultats SQL et avec la politique de tracabilite de l'usage IA.

### 2026-05-11 - Seance S02
- **Modele :** ChatGPT / Codex
- **Prompt :** "En te basant sur mes requêtes SQL sous sql/dims, aide moi à créé le fichier mermaid pour visualiser les relations entre les tables"
- **Resultat :** L'IA a cree les livrables S02: `answers/S02_executive_brief.md`, `docs/schema-v1.md`, `diagrams/schema-v1.mmd`, `sql/analysis/s02-first-answer.sql` et `docs/board-briefs/s02-star-schema.md`.
- **Validation :** La requete SQL a ete testee en lecture seule sur `db/nexamart.duckdb` et retourne les declins par categorie, region et trimestre. Les fichiers ont ete alignes avec la rubrique S02: grain, schema Mermaid, preuve SQL et justification executive.
- **Justification :** Cette interaction etait necessaire pour transformer la question CEO de S01 en schema en etoile documente et en preuve SQL reproductible pour la seance S02.

### 2026-05-13 - Seance S03
- **Modele :** ChatGPT / Codex
- **Prompt :** "En te basant sur les consignes de la seance 3, peux-tu m'aider a identifier les livrables et expliquer quand utiliser SCD Type 1 vs Type 2?"
- **Resultat :** L'IA a resume les livrables demandes et explique la difference entre SCD Type 1 et Type 2 dans le contexte du laboratoire.
- **Validation :** J'ai compare les explications avec les consignes du laboratoire avant de commencer les modifications.
- **Justification :** Cette interaction m'a aide a mieux comprendre les attentes de la seance et la logique des SCD avant l'implementation.

### 2026-05-13 - Seance S03
- **Modele :** ChatGPT / Codex
- **Prompt :** "Type 1 overwrite les anciennes donnees tandis que Type 2 conserve l'historique avec une nouvelle ligne, c'est bien ca?"
- **Resultat :** L'IA a confirme ma comprehension des SCD et donne un exemple simple pour chaque type.
- **Validation :** J'ai utilise cette validation pour rediger la politique SCD et verifier la logique du script SQL.
- **Justification :** Cette interaction etait utile pour confirmer les concepts avant de finaliser les fichiers demandes.

### 2026-05-13 - Seance S03
- **Modele :** ChatGPT / Codex
- **Prompt :** "Peux-tu m'aider a completer les fichiers `answers/S03_executive_brief.md`, `sql/scd/type1_vs_type2_demo.sql`, `docs/scd-policy.md` et `docs/board-briefs/s03-scd.md` selon les consignes de la seance 3?"
- **Resultat :** L'IA a aide a rediger le brief executif, la politique SCD, le brief pour le board ainsi que le script SQL comparant les comportements Type 1 et Type 2.
- **Validation :** J'ai relu les fichiers generes et execute le script SQL pour verifier que l'historique etait bien preserve avec le SCD Type 2.
- **Justification :** Cette interaction etait necessaire pour produire les livrables demandes et valider la demonstration des changements historiques.

### 2026-05-25 - Seance S04
- **Modele :** ChatGPT / Codex
- **Prompt :** "Peux-tu m'aider a construire `dim_order_profile` et la requete `basket_pairs.sql` pour identifier les patterns de commande et les produits souvent achetes ensemble?"
- **Resultat :** L'IA a aide a creer la logique SQL pour les profils de commande et les analyses de paniers d'achat.
- **Validation :** J'ai execute les requetes SQL localement pour verifier les profils observes et les principales paires de produits.
- **Justification :** Cette interaction etait utile pour valider la logique analytique et produire les scripts SQL demandes.

### 2026-05-25 - Seance S04
- **Modele :** ChatGPT / Codex
- **Prompt :** "Peux-tu m'aider a completer les fichiers `answers/S04_executive_brief.md`, `docs/schema-v2.md`, `docs/board-briefs/s04-basket-flags.md` et mettre a jour `ai-usage.md` selon les consignes de la seance 4?"
- **Resultat :** L'IA a aide a rediger le brief executif, mettre a jour la documentation du schema et documenter les patterns operationnels demandes.
- **Validation :** J'ai relu les fichiers generes et valide les modifications avant leur integration dans le projet.
- **Justification :** Cette interaction etait necessaire pour produire les livrables demandes et documenter les analyses pour le CEO.
