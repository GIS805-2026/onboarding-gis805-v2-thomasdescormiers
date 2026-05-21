# Rétroaction automatisée -- S02 (Première étoile -- schéma en étoile, grain et dimensions conformes)

_Générée le 2026-05-21T17:49:06+00:00 -- Run `20260521T173854Z-8262142b`_

Ce document est produit par un pipeline reproductible (vérification SQL déterministe + analyse LLM du brief et de la déclaration IA). Une revue humaine précède toujours sa publication. **À ce stade expérimental, aucune note ni étiquette de niveau n'est diffusée : l'objectif est purement formatif.**

---

## 1. Vérification automatique de la requête SQL

La requête extraite de votre brief n'a pas pu être validée automatiquement. Quelques pistes constructives ci-dessous pour vous aider à la rendre exécutable et alignee avec la question posée.

_Observation technique : aucune requête SQL détectée dans le brief_


**Pistes :**
> Aucun bloc ```sql ... ``` détecté et l'extracteur LLM n'a trouvé aucune requête. Encadrez votre requête finale dans la section « Preuve » avec un bloc ```sql ... ``` pour fiabiliser l'auto-validation.
> Extracteur LLM : Le brief décrit la requête et son fichier source mais n'inclut pas la requête SQL elle‑même à extraire.

## 2. Rétroaction pédagogique sur le brief

> Le brief présente un bon schéma en étoile avec grain et dimensions conformes, des preuves d'exécution et une recommandation claire pour investiguer les baisses de vente (Automotive). Pour atteindre l'excellence complète, détaillez le traitement des cas limites, fournissez l'historique git/notes IA et ajoutez des artefacts facilitant la reproduction immédiate.

### Observations par dimension

**Model quality**
- Observation : Le brief précise le grain («une ligne dans fact_sales représente une ligne de commande identifiée par order_number et sale_line_id») et décrit une étoile centrée sur fact_sales avec dim_date, dim_product et dim_store conformes.
- Piste d'amélioration : Ajouter un diagramme exporté (PNG/SVG) ou DDL succinct pour montrer les clés et types de colonnes afin de lever toute ambiguïté structurelle.

**Validation quality**
- Observation : L'auteur indique que la requête a été exécutée dans DuckDB, que sql/analysis/s02-first-answer.sql calcule SUM(f.line_total) et compare 2025 T4 à T3 avec LAG, et que run_checks.py retourne 32 PASS, 0 FAIL.
- Piste d'amélioration : Documenter et montrer explicitement le traitement des cas limites (NULLs, valeurs manquantes, vérification des agrégations pour valeurs non additives) et fournir la requête d'exemple et ses résultats bruts.

**Executive justification**
- Observation : La section 'Reponse executive' explique en langage d'affaires que le schéma étoile rend la question répétable, identifie les catégories/régions en baisse et recommande d'enquêter prioritairement sur Automotive en Ontario/Québec/Alberta.
- Piste d'amélioration : Ajouter une recommandation chiffrée claire (par ex. seuils et ordre d'investigation) et un impact business attendu pour prioriser les actions du board.

**Process trace**
- Observation : Le brief mentionne des fichiers SQL et diagrammes et l'exécution de run_checks.py, mais n'inclut pas d'historique git ni de note détaillée sur l'usage d'IA ou validation humaine.
- Piste d'amélioration : Fournir l'historique git avec ≥3 commits significatifs et une note IA précisant outils/usage et qui a validé les sorties.

**Reproducibility**
- Observation : Le candidat indique que la requête a été exécutée dans DuckDB et donne les chemins des scripts SQL et diagrammes (sql/analysis/... ; diagrams/...), suggérant qu'un clone peut reproduire l'analyse.
- Piste d'amélioration : Ajouter un README pas-à-pas (prérequis, commandes exactes pour DuckDB) ou un script unique 'run_all.sh' pour permettre une reproduction en <5 minutes.

## 3. Déclaration d'utilisation de l'IA

> La déclaration documente bien les sessions, les usages et les validations humaines, et nomme les outils employés. En revanche elle ne mentionne pas explicitement les limites ou erreurs de l'IA ni de version/modèle précise, ce qui empêche une conformité complète.

**Sujets bien couverts dans votre déclaration :**

- outils utilisés (nom + version/modèle)
- à quelle étape l'IA a été utilisée
- comment la sortie a été validée par l'humain

**Sujets à ajouter ou expliciter pour la prochaine itération :**

- limites ou erreurs observées

## 4. Pistes d'action pour la prochaine itération

- Reprendre la requête de la section « Preuve » pour qu'elle s'exécute sur `db/nexamart.duckdb` et qu'elle produise la forme attendue (voir pistes en section 1).
- Compléter `ai-usage.md` en y ajoutant : limites ou erreurs observées.

---

## 5. Traçabilité

- **Run ID :** `20260521T173854Z-8262142b`
- **Devoir :** `S02`
- **Étudiant·e :** `thomasdescormiers`
- **Commit analysé :** `b7357b8`
- **Audit (côté instructeur) :** `tools/instructor/feedback_pipeline/audit/20260521T173854Z-8262142b/thomasdescormiers/`
- **Prompts (SHA-256) :**
  - `ai_usage_grader_system` : `81cb7fdf89bda55a...`
  - `rubric_grader_system` : `505f32d1d8319d66...`
  - `sql_extractor_system` : `90ee9e277de7a27f...`
- **Fournisseur (rubrique) :** `openai`
- **Fournisseur (IA-usage) :** `openai` (gpt-5-mini-2025-08-07)

_Ce feedback a été produit par un pipeline automatisé et **revu par l'équipe pédagogique avant publication**. Aucun chiffre ni étiquette de niveau n'est diffusé à ce stade expérimental : l'objectif est uniquement formatif. Ouvrez une issue dans ce dépôt pour toute question._
