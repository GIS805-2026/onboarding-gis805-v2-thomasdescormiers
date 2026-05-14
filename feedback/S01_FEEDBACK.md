# Rétroaction automatisée -- S01 (Diagnostic fondamental -- NexaMart kickoff)

_Générée le 2026-05-14T22:29:37+00:00 -- Run `20260514T221333Z-7d34bf6a`_

Ce document est produit par un pipeline reproductible (vérification SQL déterministe + analyse LLM du brief et de la déclaration IA). Une revue humaine précède toujours sa publication. **À ce stade expérimental, aucune note ni étiquette de niveau n'est diffusée : l'objectif est purement formatif.**

---

## 1. Vérification automatique de la requête SQL

La requête extraite de votre brief n'a pas pu être validée automatiquement. Quelques pistes constructives ci-dessous pour vous aider à la rendre exécutable et alignee avec la question posée.

_Observation technique : erreur d'exécution SQL: Catalog Error: Table with name fact_sales does not exist!_

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


**Pistes :**
> Votre `db/nexamart.duckdb` est absente ou vide ; la requête a été exécutée contre une **base de référence cohorte** (seed instructeur). Les chiffres retournés ne correspondent donc pas à vos propres données : reconstruisez votre base avec `python src/run_pipeline.py` (ou `.\run.ps1 load`) pour valider vos calculs sur votre seed personnel.
> Tables référencées dans votre requête mais absentes de la base : `dim_date`, `dim_product`, `dim_store`, `fact_sales`.
> Tables disponibles dans `db/nexamart.duckdb` : `raw_bridge_campaign_allocation`, `raw_bridge_customer_segment`, `raw_customer_changes`, `raw_customer_profile_bands`, `raw_customer_scd3_history`, `raw_dim_channel`, `raw_dim_customer`, `raw_dim_date`, `raw_dim_geography`, `raw_dim_product`, `raw_dim_segment_outrigger`, `raw_dim_store`, `raw_fact_budget`, `raw_fact_daily_inventory`, `raw_fact_inventory_snapshot`, `raw_fact_order_pipeline`, `raw_fact_orders_transaction`, `raw_fact_promo_exposure`, `raw_fact_returns`, `raw_fact_sales`.
> Pour `dim_date`, peut-être vouliez-vous : `raw_dim_date` ?
> Pour `dim_product`, peut-être vouliez-vous : `raw_dim_product` ?
> Pour `dim_store`, peut-être vouliez-vous : `raw_dim_store` ?
> Pour `fact_sales`, peut-être vouliez-vous : `raw_fact_sales` ?

## 2. Rétroaction pédagogique sur le brief

> Bon diagnostic exécutif avec priorisation claire et preuves chiffrées; le modèle dimensionnel est cohérent et le SQL exploratoire approprié. Renforcez la traçabilité (commits, note IA) et les contrôles de validation/cas limites pour rendre la solution robuste et entièrement reproductible.

### Observations par dimension

**Model quality**
- Observation : Le brief énonce un grain clair (ligne de commande : order_number + sale_line_id), la table fact_sales, les dimensions et mesures principales (quantity, unit_price, line_total).
- Piste d'amélioration : Ajouter la justification SCD (historisation des catégories) et expliciter pourquoi un pattern (ex. SCD Type 2) est choisi pour préserver l'historique.

**Validation quality**
- Observation : Une requête SQL de validation est fournie (agrégation par catégorie, région, année/trimestre avec SUM(line_total), SUM(quantity), COUNT(DISTINCT order_number)).
- Piste d'amélioration : Inclure des contrôles de cas limites (NULLs, doublons de grain, vérification que SUM(quantity × unit_price)=SUM(line_total) ou traitement des remises) et des tests reproductibles.

**Executive justification**
- Observation : La réponse exécutive priorise clairement les catégories et régions (ex. Automotive en Ontario/Québec/Alberta) avec chiffres et recommandation d'investigation prioritaire.
- Piste d'amélioration : Ajouter une phrase décisionnelle explicite à destination du CEO (ex. approbation pour lancer une enquête terrain sur X régions et allouer Y ressources).

**Process trace**
- Observation : Le brief mentionne génération de données synthétiques et l'usage de DuckDB ainsi que 'make check', mais n'inclut pas d'historique de commits ni de note IA détaillée.
- Piste d'amélioration : Fournir un petit historique git (≥3 commits incrémentaux avec messages) et une note IA précisant l'outil utilisé et comment la sortie a été validée par l'humain.

**Reproducibility**
- Observation : La reproduction est suggérée (DuckDB, make check) mais il manque des scripts/chemins clairs et un README reproduisible pas à pas.
- Piste d'amélioration : Ajouter un README minimal et un script 'run_checks.sh' qui clone, charge les données synthétiques et exécute les vérifications sans chemins codés en dur.

## 3. Déclaration d'utilisation de l'IA

> La déclaration documente clairement quand et comment l'IA a été utilisée et la validation humaine des livrables. Elle omet toutefois des précisions sur les versions/modèles exacts utilisés et ne rapporte pas de limites ou d'erreurs observées de l'IA.

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

- **Run ID :** `20260514T221333Z-7d34bf6a`
- **Devoir :** `S01`
- **Étudiant·e :** `thomasdescormiers`
- **Commit analysé :** `94649c8`
- **Audit (côté instructeur) :** `tools/instructor/feedback_pipeline/audit/20260514T221333Z-7d34bf6a/thomasdescormiers/`
- **Prompts (SHA-256) :**
  - `sql_extractor_system` : `90ee9e277de7a27f...`
  - `rubric_grader_system` : `505f32d1d8319d66...`
  - `ai_usage_grader_system` : `81cb7fdf89bda55a...`
- **Fournisseur (rubrique) :** `openai`
- **Fournisseur (IA-usage) :** `openai` (gpt-5-mini-2025-08-07)

_Ce feedback a été produit par un pipeline automatisé et **revu par l'équipe pédagogique avant publication**. Aucun chiffre ni étiquette de niveau n'est diffusé à ce stade expérimental : l'objectif est uniquement formatif. Ouvrez une issue dans ce dépôt pour toute question._
