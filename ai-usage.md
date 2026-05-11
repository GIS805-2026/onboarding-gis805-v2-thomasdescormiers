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
- **Prompt :** "je reviens a mes moutons, aide moi a acoomplir la seance en te fiant a GIS805-02_lab.md"
- **Resultat :** L'IA a cree les livrables S02: `answers/S02_executive_brief.md`, `docs/schema-v1.md`, `diagrams/schema-v1.mmd`, `sql/analysis/s02-first-answer.sql` et `docs/board-briefs/s02-star-schema.md`.
- **Validation :** La requete SQL a ete testee en lecture seule sur `db/nexamart.duckdb` et retourne les declins par categorie, region et trimestre. Les fichiers ont ete alignes avec la rubrique S02: grain, schema Mermaid, preuve SQL et justification executive.
- **Justification :** Cette interaction etait necessaire pour transformer la question CEO de S01 en schema en etoile documente et en preuve SQL reproductible pour la seance S02.
