# Rétroaction automatisée -- S04 (Panier d'achat et drapeaux : les patterns que l'étoile simple ne couvre pas)

_Générée le 2026-05-29T13:05:10+00:00 -- Run `20260529T125432Z-0258cabb`_

Ce document est produit par un pipeline reproductible (validation automatique du livrable + analyse LLM du brief et de la déclaration IA). Une revue humaine précède toujours sa publication. **À ce stade expérimental, aucune note ni étiquette de niveau n'est diffusée : l'objectif est purement formatif.**

---

## 1. Vérification automatique de la requête SQL

La requête extraite de votre brief n'a pas pu être validée automatiquement. Quelques pistes constructives ci-dessous pour vous aider à la rendre exécutable et alignee avec la question posée.

_Observation technique : erreur d'exécution SQL: Catalog Error: Table with name s03_type1_vs_type2_comparison does not exist!_

<details><summary>Requête analysée — cliquez pour déplier</summary>

```sql
SELECT *
FROM s03_type1_vs_type2_comparison
```

</details>


**Pistes :**
> Aucun bloc ```sql ... ``` détecté et l'extracteur LLM n'a trouvé aucune requête. Encadrez votre requête finale dans la section « Preuve » avec un bloc ```sql ... ``` pour fiabiliser l'auto-validation.
> Extracteur LLM : Le brief décrit les requêtes et résultats (emplacements de fichiers) mais n'inclut aucune requête SQL explicite à extraire.
> Requête extraite depuis les fichiers SQL du repo (`sql\scd\type1_vs_type2_demo.sql`, `sql\templates\04_validation_check.sql`) — aucun bloc SQL inline dans le brief. Ajoutez un bloc ```sql ... ``` dans la section « Preuve » de votre brief pour fiabiliser l'auto-validation à l'avenir.
> Tables référencées dans votre requête mais absentes de la base : `s03_type1_vs_type2_comparison`.
> Tables disponibles dans `db/nexamart.duckdb` : `bridge_customer_segment`, `dim_channel`, `dim_customer`, `dim_date`, `dim_order_profile`, `dim_product`, `dim_store`, `fact_budget`, `fact_daily_inventory`, `fact_order_pipeline`, `fact_promo_exposure`, `fact_returns`, `fact_sales`, `junk_order_profile`, `raw_bridge_campaign_allocation`, `raw_bridge_customer_segment`, `raw_customer_changes`, `raw_customer_profile_bands`, `raw_customer_scd3_history`, `raw_dim_channel`.

## 2. Rétroaction pédagogique sur le brief

> Le brief présente un modèle dimensionnel cohérent (junk dimension) et traduit les résultats en implications opérationnelles claires. Renforcez la reproductibilité et la validation technique en ajoutant requêtes complètes, gestion des cas limites et historique de commits.

### Observations par dimension

**Model quality**
- Observation : Le brief décrit explicitement le grain (commande vs ligne), la création de dim_order_profile comme junk dimension et justifie pourquoi order_number reste une dimension dégénérée.
- Piste d'amélioration : Ajouter un diagramme (schéma) montrant fact_sales_enriched, dim_order_profile et les clés pour clarifier l'implémentation et les dépendances.

**Validation quality**
- Observation : La section Validation indique les comptages du seed (461 commandes, 1326 lignes), le nombre de combinaisons observées (110) et décrit que la requête de panier évite les doublons A-B/B-A.
- Piste d'amélioration : Fournir la requête SQL complète de validation exécutée et documenter le traitement des NULLs et des cas limites (ex. produits multi-qty, items identiques).

**Executive justification**
- Observation : La Reponse executive résume les implications opérationnelles, priorise les profils à suivre (incitatif, ramassage en ligne, manutention spéciale) et propose une recommandation claire pour le suivi et la validation avec les opérations.
- Piste d'amélioration : Ajouter un KPI chiffré (ex. impact estimé sur temps de préparation ou coût) pour renforcer la recommandation décisionnelle.

**Process trace**
- Observation : Le brief mentionne des fichiers (sql/dims/dim_order_profile.sql, sql/analysis/basket_pairs.sql, docs/profiles.md) mais ne décrit pas d'historique de commits ni de note IA détaillée.
- Piste d'amélioration : Inclure un court git log avec ≥3 commits incrémentaux et une note IA précisant outils et validation humaine.

**Reproducibility**
- Observation : Le brief cite les scripts et docs nécessaires mais n'indique pas d'instructions de clonage/exécution ni l'absence de chemins codés en dur.
- Piste d'amélioration : Fournir un README étape‑par‑étape pour cloner, lancer le seed et exécuter les checks automatiquement (DuckDB ou script SQL).

## 3. Déclaration d'utilisation de l'IA

> La déclaration documente bien quand et comment l'IA a été utilisée et décrit les validations humaines. Il manque toutefois une discussion des limites ou des erreurs observées et les modèles sont cités sans version précise.

**Sujets bien couverts dans votre déclaration :**

- outils utilisés (nom + version/modèle)
- à quelle étape l'IA a été utilisée
- comment la sortie a été validée par l'humain

**Sujets à ajouter ou expliciter pour la prochaine itération :**

- limites ou erreurs observées

## 4. Pistes d'action pour la prochaine itération

- Reprendre la requête de la section « Preuve » pour qu'elle s'exécute sur db/nexamart.duckdb et qu'elle produise la forme attendue (voir pistes en section 1).
- Compléter i-usage.md en y ajoutant : limites ou erreurs observées.

---

## 5. Traçabilité

- **Run ID :** `20260529T125432Z-0258cabb`
- **Devoir :** `S04`
- **Étudiant·e :** `thomasdescormiers`
- **Commit analysé :** `2286a3d`
- **Audit (côté instructeur) :** `tools/instructor/feedback_pipeline/audit/20260529T125432Z-0258cabb/thomasdescormiers/`
- **Prompts (SHA-256) :**
  - `sql_extractor_system` : `90ee9e277de7a27f...`
  - `rubric_grader_system` : `505f32d1d8319d66...`
  - `ai_usage_grader_system` : `81cb7fdf89bda55a...`
- **Fournisseur (rubrique) :** `openai`
- **Fournisseur (IA-usage) :** `openai` (gpt-5-mini-2025-08-07)

_Ce feedback a été produit par un pipeline automatisé et **revu par l'équipe pédagogique avant publication**. Aucun chiffre ni étiquette de niveau n'est diffusé à ce stade expérimental : l'objectif est uniquement formatif. Ouvrez une issue dans ce dépôt pour toute question._
