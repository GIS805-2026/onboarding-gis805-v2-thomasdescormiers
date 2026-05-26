# Rétroaction automatisée -- S03 (Dimensions à changement lent : garder la vérité historique chez NexaMart)

_Générée le 2026-05-26T01:47:39+00:00 -- Run `20260526T014406Z-11c1baa8`_

Ce document est produit par un pipeline reproductible (vérification SQL déterministe + analyse LLM du brief et de la déclaration IA). Une revue humaine précède toujours sa publication. **À ce stade expérimental, aucune note ni étiquette de niveau n'est diffusée : l'objectif est purement formatif.**

> ⚠️ **Avertissement instructeur (à retirer avant publication) :** cette analyse a été générée avec `--skip-pull`. Le contenu correspond au commit local et **n'est peut-être pas la dernière version poussée par l'étudiant·e**.

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
> Tables référencées dans votre requête mais absentes de la base : `s03_type1_vs_type2_comparison`.
> Tables disponibles dans `db/nexamart.duckdb` : `bridge_customer_segment`, `dim_channel`, `dim_customer`, `dim_date`, `dim_product`, `dim_store`, `fact_budget`, `fact_daily_inventory`, `fact_order_pipeline`, `fact_promo_exposure`, `fact_returns`, `fact_sales`, `junk_order_profile`, `raw_bridge_campaign_allocation`, `raw_bridge_customer_segment`, `raw_customer_changes`, `raw_customer_profile_bands`, `raw_customer_scd3_history`, `raw_dim_channel`, `raw_dim_customer`.

## 2. Rétroaction pédagogique sur le brief

> Bon brief centré sur la décision: il explique pourquoi privilégier SCD Type 2 et inclut une recommandation claire pour la gouvernance SCD. Pour atteindre l'excellence technique, ajoutez du DDL/ER, des requêtes de validation exploitables et un historique de processus (commits, note IA, README reproductible).

### Observations par dimension

**Model quality**
- Observation : Le brief précise l'usage de SCD Type 2 pour 'loyalty_segment, city, province, region' et décrit la structure (cle subrogee, valid_from, valid_to, is_current).
- Piste d'amélioration : Ajouter un schéma ER ou un extrait de DDL montrant les colonnes exactes et un exemple de données versionnées pour lever toute ambiguïté de grain.

**Validation quality**
- Observation : Le document indique que la preuve SQL est dans 'sql/scd/type1_vs_type2_demo.sql' et mentionne des vérifications comme 'un client courant n'a qu'une seule ligne is_current = TRUE'.
- Piste d'amélioration : Inclure la requête de validation principale et ses résultats chiffrés (rows, agrégats) ou joindre un extrait de sortie pour permettre une vérification immédiate.

**Executive justification**
- Observation : La recommandation est claire et en langage décisionnel: 'Adopter officiellement la politique SCD ... priorite est de proteger les analyses historiques par segment client et par geographie.'
- Piste d'amélioration : Préciser l'impact attendu sur KPI clés (p. ex. % de distorsion projetée) et un plan d'incidence temporelle (coût / effort / calendrier) pour faciliter la prise de décision.

**Process trace**
- Observation : Le brief mentionne le script SQL et des comptages de changements mais n'inclut pas d'historique git ni de note d'utilisation IA détaillée.
- Piste d'amélioration : Ajouter un journal de commits (≥3) avec messages significatifs et une note IA décrivant l'outil utilisé et les étapes de validation humaine.

**Reproducibility**
- Observation : Le chemin du script est fourni ('sql/scd/type1_vs_type2_demo.sql') mais il n'y a pas d'instructions Runbook/README garantissant l'exécution sur un clone propre.
- Piste d'amélioration : Fournir un README exécutif avec étapes 'git clone → exécuter script → vérifier résultats', et éliminer les chemins codés en dur ou documenter les dépendances.

## 3. Déclaration d'utilisation de l'IA

> La déclaration documente bien les séances, les prompts et les vérifications humaines réalisées. Il manque cependant des informations sur les limites ou erreurs observées dans les sorties de l'IA, et la mention des outils reste générique (modèle sans version).

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

- **Run ID :** `20260526T014406Z-11c1baa8`
- **Devoir :** `S03`
- **Étudiant·e :** `thomasdescormiers`
- **Commit analysé :** `a380fb8`
- **Audit (côté instructeur) :** `tools/instructor/feedback_pipeline/audit/20260526T014406Z-11c1baa8/thomasdescormiers/`
- **Prompts (SHA-256) :**
  - `rubric_grader_system` : `505f32d1d8319d66...`
  - `ai_usage_grader_system` : `81cb7fdf89bda55a...`
- **Fournisseur (rubrique) :** `openai`
- **Fournisseur (IA-usage) :** `openai` (gpt-5-mini-2025-08-07)

_Ce feedback a été produit par un pipeline automatisé et **revu par l'équipe pédagogique avant publication**. Aucun chiffre ni étiquette de niveau n'est diffusé à ce stade expérimental : l'objectif est uniquement formatif. Ouvrez une issue dans ce dépôt pour toute question._
