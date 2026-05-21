# Rétroaction automatisée -- S02 (Première étoile -- schéma en étoile, grain et dimensions conformes)

_Générée le 2026-05-21T20:48:06+00:00 -- Run `20260521T204029Z-63dae822`_

Ce document est produit par un pipeline reproductible (vérification SQL déterministe + analyse LLM du brief et de la déclaration IA). Une revue humaine précède toujours sa publication. **À ce stade expérimental, aucune note ni étiquette de niveau n'est diffusée : l'objectif est purement formatif.**

---

## 1. Vérification automatique de la requête SQL

La requête extraite de votre brief n'a pas pu être validée automatiquement. Quelques pistes constructives ci-dessous pour vous aider à la rendre exécutable et alignee avec la question posée.

_Observation technique : aucune requête SQL détectée dans le brief_


**Pistes :**
> Aucun bloc ```sql ... ``` détecté et l'extracteur LLM n'a trouvé aucune requête. Encadrez votre requête finale dans la section « Preuve » avec un bloc ```sql ... ``` pour fiabiliser l'auto-validation.
> Extracteur LLM : Le brief décrit la requête et indique son emplacement (sql/analysis/s02-first-answer.sql) mais n'inclut pas le SQL lui‑même à extraire.

## 2. Rétroaction pédagogique sur le brief

> Excellent brief : le grain, le schéma en étoile et les dimensions conformes sont clairement exposés et la recommandation exécutive priorise les baisses à investiguer. Améliorer la traçabilité (commits, note IA/validation humaine) et ajouter un petit extrait SQL/DDL pour faciliter la revue et la reproductibilité immédiate.

### Observations par dimension

**Model quality**
- Observation : Le brief précise le grain («une ligne dans fact_sales = ligne de commande») et décrit une étoile avec fact_sales jointe à dim_product, dim_store et dim_date pour calculer revenu par catégorie, région et trimestre.
- Piste d'amélioration : Ajouter un petit diagramme inline ou un extrait DDL montrant clés primaires/étrangères pour lever toute ambiguïté sur les jointures.

**Validation quality**
- Observation : La section Validation indique que la requête s'est exécutée dans DuckDB, que le script sql/analysis/s02-first-answer.sql calcule SUM(f.line_total) et compare Q/Q avec LAG, et que run_checks.py retourne 32 PASS, 0 FAIL.
- Piste d'amélioration : Joindre l'extrait SQL principal et un petit échantillon de sortie (quelques lignes de résultat) pour faciliter la revue sans exécuter le pipeline.

**Executive justification**
- Observation : La réponse exécutive explique en langage business que l'étoile permet la répétabilité mensuelle et recommande d'investiguer en priorité les catégories/régions avec baisses (ex. Automotive Ontario/Québec/Alberta).
- Piste d'amélioration : Ajouter une recommandation chiffrée de seuils d'alerte opérationnels (ex. baisse >20 % et >X $) pour prioriser les enquêtes.

**Process trace**
- Observation : Le brief référence des fichiers (sql/, diagrams/) et des checks, mais ne fournit pas d'historique git ni de note IA ou d'explication sur la validation humaine des résultats.
- Piste d'amélioration : Inclure le log de commits (≥3 commits significatifs) et une courte note IA précisant outils/usage et qui a validé manuellement les résultats.

**Reproducibility**
- Observation : La validation mentionne l'exécution dans DuckDB et le script python src/run_checks.py avec 32 PASS, ce qui suggère un flux reproductible.
- Piste d'amélioration : Documenter explicitement les étapes pour cloner et exécuter (README avec commandes exactes et versions) afin d'atteindre l'état 'clone → résultat' en <5 minutes.

## 3. Déclaration d'utilisation de l'IA

> La déclaration décrit clairement quand et comment l'IA a été utilisée et comment les sorties ont été vérifiées. Il manque des précisions sur les versions/modèles exacts et aucune limite ou erreur observée n'est documentée.

**Sujets bien couverts dans votre déclaration :**

- à quelle étape l'IA a été utilisée
- comment la sortie a été validée par l'humain

**Sujets à ajouter ou expliciter pour la prochaine itération :**

- outils utilisés (nom + version/modèle)
- limites ou erreurs observées

## 4. Pistes d'action pour la prochaine itération

- Reprendre la requête de la section « Preuve » pour qu'elle s'exécute sur `db/nexamart.duckdb` et qu'elle produise la forme attendue (voir pistes en section 1).
- Compléter `ai-usage.md` en y ajoutant : outils utilisés (nom + version/modèle).
- Compléter `ai-usage.md` en y ajoutant : limites ou erreurs observées.

---

## 5. Traçabilité

- **Run ID :** `20260521T204029Z-63dae822`
- **Devoir :** `S02`
- **Étudiant·e :** `thomasdescormiers`
- **Commit analysé :** `013fb3c`
- **Audit (côté instructeur) :** `tools/instructor/feedback_pipeline/audit/20260521T204029Z-63dae822/thomasdescormiers/`
- **Prompts (SHA-256) :**
  - `ai_usage_grader_system` : `81cb7fdf89bda55a...`
  - `rubric_grader_system` : `505f32d1d8319d66...`
  - `sql_extractor_system` : `90ee9e277de7a27f...`
- **Fournisseur (rubrique) :** `openai`
- **Fournisseur (IA-usage) :** `openai` (gpt-5-mini-2025-08-07)

_Ce feedback a été produit par un pipeline automatisé et **revu par l'équipe pédagogique avant publication**. Aucun chiffre ni étiquette de niveau n'est diffusé à ce stade expérimental : l'objectif est uniquement formatif. Ouvrez une issue dans ce dépôt pour toute question._
