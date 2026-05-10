# Trace d'usage IA — GIS805

> Chaque interaction significative avec un outil IA doit être documentée ici.
> Ce fichier est **obligatoire** et évalué à chaque remise.

## Format par entrée

```md
### YYYY-MM-DD — Séance SXX
- **Modèle :** (ChatGPT-4o, Claude, Copilot, etc.)
- **Prompt :** (copier-coller exact)
- **Résultat :** (résumé de ce que l'IA a produit)
- **Validation :** (comment vous avez vérifié/modifié le résultat)
- **Justification :** (pourquoi cette interaction était nécessaire)
```

---

### 2026-05-09 — Séance S01
- **Modèle :** ChatGPT / Codex
- **Prompt :** « Je dois faire les sql/dims/ -- vos tables de dimensions, sql/facts/ -- vos tables de faits, sql/views/ -- vos requêtes analytiques, answers/ -- vos exécutive briefs, docs/ -- vos décisions, politiques, documentation puisque lorsque je fais make check, j'ai des erreurs. Aide-moi à faire les requêtes SQL au bon endroit pour les tables. »
- **Résultat :** L'IA a proposé et créé des requêtes SQL pour les dimensions dans `sql/dims/`, les tables de faits dans `sql/facts/`, la bridge dans `sql/bridges/` et des vues analytiques dans `sql/views/`.
- **Validation :** J'ai relu les fichiers SQL créés, vérifié qu'ils suivent la structure du dépôt et que les tables correspondent aux attentes de `validation/checks.sql`.
- **Justification :** Cette interaction était nécessaire pour corriger les erreurs de validation et placer les requêtes SQL dans les bons dossiers du projet.

### 2026-05-09 — Séance S01
- **Modèle :** ChatGPT / Codex
- **Prompt :** « Comment remplir le fichier S01_executive_brief en fonction de la question du CEO ? »
- **Résultat :** L'IA a identifié la question du CEO dans le guide de la séance S01 et a rempli `answers/S01_executive_brief.md` avec une réponse exécutive, des décisions de modélisation, une preuve SQL, une validation, des risques et une prochaine recommandation.
- **Validation :** J'ai comparé la question du CEO avec `docs/lab-guides/GIS805-01_lab.md` et relu le brief pour vérifier qu'il correspond à ma compréhension de NexaMart et du livrable S01.
- **Justification :** Cette interaction était nécessaire pour structurer le brief exécutif S01 selon les sections attendues et expliquer clairement la première question d'affaires.

<!-- Ajoutez vos entrées ci-dessous -->

### 2026-05-10 — Séance S01
- **Modèle :** ChatGPT / Codex
- **Prompt :** « Peux tu m'aider à trouver quelles catégories déclinent dans quelles régions et pourquoi? Formatte bien le tableau de résultats et met le tableau comme dernière section parmis la section "reponse executive" Aussi, peux tu ajouter une entrée dans le fichier ai usage svp? »
- **Résultat :** L'IA a réorganisé `answers/S01_executive_brief.md` autour d'une réponse chiffrée au CEO, déplacé le tableau à la fin de la section `Réponse exécutive`, ajusté les sections de preuve, validation, risques et recommandation, puis ajouté cette entrée dans `ai-usage.md`.
- **Validation :** J'ai vérifié que les chiffres du tableau proviennent de la requête dans `sql/sandbox/exploration.sql` et que le brief répond directement à la question du CEO.
- **Justification :** Cette interaction était nécessaire pour transformer le brief S01 en réponse exécutive concrète, alignée avec les résultats SQL et avec la politique de traçabilité de l'usage IA.
