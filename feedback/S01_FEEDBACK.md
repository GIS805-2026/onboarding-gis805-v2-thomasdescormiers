# Rétroaction automatisée -- S01 (Diagnostic fondamental -- NexaMart kickoff)

_Générée le 2026-05-15T12:42:27+00:00 -- Run `20260515T122624Z-00a5a04f`_

Ce document est produit par un pipeline reproductible (vérification SQL déterministe + analyse LLM du brief et de la déclaration IA). Une revue humaine précède toujours sa publication. **À ce stade expérimental, aucune note ni étiquette de niveau n'est diffusée : l'objectif est purement formatif.**

> ⚠️ **Avertissement instructeur (à retirer avant publication) :** cette analyse a été générée avec `--skip-pull`. Le contenu correspond au commit local et **n'est peut-être pas la dernière version poussée par l'étudiant·e**.

---

## 1. Vérification automatique de la requête SQL

La requête extraite de votre brief s'exécute correctement et produit la forme attendue. Bon travail sur l'auto-validation.

<details><summary>Requête analysée — cliquez pour déplier</summary>

```sql
SELECT
    p.category,
    s.region,
    d.year,
    d.quarter,
    SUM(f.line_total) AS revenue,
    SUM(f.quantity) AS units_sold,
    COUNT(DISTINCT f.order_number) AS orders
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
JOIN dim_store s ON f.store_key = s.store_key
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY
    p.category,
    s.region,
    d.year,
    d.quarter
ORDER BY
    d.year,
    d.quarter,
    revenue DESC;
```

</details>

- Colonnes retournées : `category, region, year, quarter, revenue, units_sold, orders`
- Correspondance avec les colonnes attendues :
  - `category` → `category`
  - `region` → `region`
  - `quarter` → `quarter`
  - `revenue` → `revenue`
- Présence de NULLs dans des colonnes de groupement : `category` =0, `region` =0, `quarter` =0. Pensez à documenter le traitement de ces cas.

## 2. Rétroaction pédagogique sur le brief

> Bon diagnostic exécutif: le brief identifie clairement les catégories et régions prioritaires avec chiffres et une requête de validation opérationnelle. Améliorer la solidité architecturale en documentant les choix SCD, les contrôles de qualité (NULLs, grain) et l'historique de travail pour rendre la livraison totalement reproductible.

### Observations par dimension

**Model quality**
- Observation : Le brief précise le grain (« une ligne représente une ligne de commande identifiée par order_number et sale_line_id »), les mesures et les dimensions requises.
- Piste d'amélioration : Mentionner explicitement les patterns SCD (ex. SCD Type 2) et les risques liés à unit_price non-additif, et justifier un choix de pattern pour l'historisation.

**Validation quality**
- Observation : Une requête SQL de validation est fournie (agrégation par category, region, year, quarter avec SUM(line_total), units et orders) et un `make check` est mentionné.
- Piste d'amélioration : Ajouter des contrôles de cas limites (NULLs, vérification du grain, contrôle de doublons, et justification de l'utilisation de line_total vs quantity×unit_price).

**Executive justification**
- Observation : La section « Réponse exécutive » identifie clairement les catégories/régions prioritaires et recommande d'investiguer Automotive (Ontario, Québec, Alberta) avec des chiffres synthétiques pour étayer la décision.
- Piste d'amélioration : Ajouter une recommandation opérationnelle concrète à court terme (ex. test A/B promotionnel par région ou audit stock/prix) pour transformer le diagnostic en action immédiate.

**Process trace**
- Observation : Le brief mentionne la génération de données synthétiques et l'usage de DuckDB et `make check` mais n'indique pas d'historique de commits ni de note d'usage IA détaillée.
- Piste d'amélioration : Fournir un log de commits (≥3 commits avec messages) et une note IA précisant outil, prompts et validation humaine.

**Reproducibility**
- Observation : L'auteur indique que les données synthétiques ont été chargées dans DuckDB et que `make check` / `run.ps1 check` existe pour vérifier les tables attendues.
- Piste d'amélioration : Inclure un README pas-à-pas et s'assurer qu'aucun chemin codé en dur n'est utilisé pour que le clone → exécution fonctionne sans modification.

## 3. Déclaration d'utilisation de l'IA

> La déclaration documente bien quand et comment l'IA a été utilisée et comment les sorties ont été relues. Il manque toutefois des précisions sur les versions/modèles exacts et aucune limite ou erreur observée n'est explicitement décrite.

**Sujets bien couverts dans votre déclaration :**

- à quelle étape l'IA a été utilisée
- comment la sortie a été validée par l'humain

**Sujets à ajouter ou expliciter pour la prochaine itération :**

- outils utilisés (nom + version/modèle)
- limites ou erreurs observées

## 4. Pistes d'action pour la prochaine itération

- Compléter `ai-usage.md` en y ajoutant : outils utilisés (nom + version/modèle).
- Compléter `ai-usage.md` en y ajoutant : limites ou erreurs observées.

---

## 5. Traçabilité

- **Run ID :** `20260515T122624Z-00a5a04f`
- **Devoir :** `S01`
- **Étudiant·e :** `thomasdescormiers`
- **Commit analysé :** `33be743`
- **Audit (côté instructeur) :** `tools/instructor/feedback_pipeline/audit/20260515T122624Z-00a5a04f/thomasdescormiers/`
- **Prompts (SHA-256) :**
  - `sql_extractor_system` : `90ee9e277de7a27f...`
  - `rubric_grader_system` : `505f32d1d8319d66...`
  - `ai_usage_grader_system` : `81cb7fdf89bda55a...`
- **Fournisseur (rubrique) :** `openai`
- **Fournisseur (IA-usage) :** `openai` (gpt-5-mini-2025-08-07)

_Ce feedback a été produit par un pipeline automatisé et **revu par l'équipe pédagogique avant publication**. Aucun chiffre ni étiquette de niveau n'est diffusé à ce stade expérimental : l'objectif est uniquement formatif. Ouvrez une issue dans ce dépôt pour toute question._
