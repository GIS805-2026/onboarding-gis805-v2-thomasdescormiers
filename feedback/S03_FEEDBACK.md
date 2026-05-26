# Rétroaction automatisée -- S03 (Dimensions à changement lent : garder la vérité historique chez NexaMart)

_Générée le 2026-05-26T01:52:28+00:00 -- Run `20260526T014859Z-8caeb97f`_

Ce document est produit par un pipeline reproductible (vérification SQL déterministe + analyse LLM du brief et de la déclaration IA). Une revue humaine précède toujours sa publication. **À ce stade expérimental, aucune note ni étiquette de niveau n'est diffusée : l'objectif est purement formatif.**

> ⚠️ **Avertissement instructeur (à retirer avant publication) :** cette analyse a été générée avec `--skip-pull`. Le contenu correspond au commit local et **n'est peut-être pas la dernière version poussée par l'étudiant·e**.

---

## 1. Vérification automatique de la requête SQL

La requête extraite de votre brief n'a pas pu être validée automatiquement. Quelques pistes constructives ci-dessous pour vous aider à la rendre exécutable et alignee avec la question posée.

_Observation technique : erreur d'exécution SQL: Catalog Error: Table with name scd_region_report_impact does not exist!_

<details><summary>Requête analysée — cliquez pour déplier</summary>

```sql
SELECT * FROM scd_region_report_impact LIMIT 100
```

</details>


**Pistes :**
> Tables référencées dans votre requête mais absentes de la base : `scd_region_report_impact`.
> Tables disponibles dans `db/nexamart.duckdb` : `bridge_customer_segment`, `dim_channel`, `dim_customer`, `dim_date`, `dim_product`, `dim_store`, `fact_budget`, `fact_daily_inventory`, `fact_order_pipeline`, `fact_promo_exposure`, `fact_returns`, `fact_sales`, `junk_order_profile`, `raw_bridge_campaign_allocation`, `raw_bridge_customer_segment`, `raw_customer_changes`, `raw_customer_profile_bands`, `raw_customer_scd3_history`, `raw_dim_channel`, `raw_dim_customer`.

## 2. Rétroaction pédagogique sur le brief

> Le brief répond clairement à la question CEO et recommande explicitement l'usage de SCD Type 2 pour les attributs impactant l'historique, avec une démonstration SQL référencée. Pour obtenir l'excellence technique, ajoutez des requêtes de validation complètes non redacted, un schéma détaillé et un historique de commits/reproductibilité documentée.

### Observations par dimension

**Model quality**
- Observation : Le brief précise d'utiliser SCD Type 2 pour "loyalty_segment, city, province, region" et décrit les clefs surrogate, valid_from/valid_to et la jointure temporelle.
- Piste d'amélioration : Fournir un diagramme de schéma (colonnes exactes de dim_customer) et un exemple concret de jointure/fact row montrant les clefs pour lever toute ambiguïté sur le grain.

**Validation quality**
- Observation : La preuve SQL est indiquée dans `sql/scd/type1_vs_type2_demo.sql` et le brief décrit des vérifications (unicité is_current, comparaison Type1 vs Type2).
- Piste d'amélioration : Inclure une ou deux requêtes SQL complètes et leurs résultats chiffrés (non redacted) et documenter le traitement des NULLs et des cas limites temporels.

**Executive justification**
- Observation : La section 'Reponse executive' explique clairement que "NexaMart doit conserver l'historique..." et recommande d'adopter la politique SCD pour protéger les analyses historiques.
- Piste d'amélioration : Ajouter un bref chiffrage (impact estimé en % ou $) sur l'indicateur clé pour renforcer la décision et prioriser le déploiement.

**Process trace**
- Observation : Le brief mentionne le script `sql/scd/type1_vs_type2_demo.sql` et le dataset `raw_customer_changes` mais n'indique pas d'historique de commits ni de note IA détaillée.
- Piste d'amélioration : Fournir un log de commits git (≥3 commits) avec messages clairs et ajouter une note IA précisant l'outil utilisé et comment la sortie a été validée par un humain.

**Reproducibility**
- Observation : Le chemin du script est cité (`sql/scd/type1_vs_type2_demo.sql`) mais il n'y a pas d'instructions d'exécution ni garantie d'absence de chemins codés en dur.
- Piste d'amélioration : Ajouter un README pas-à-pas pour cloner le repo et exécuter le script (commandes, dépendances, sample data), et éliminer les chemins codés en dur.

## 3. Déclaration d'utilisation de l'IA

> La déclaration décrit clairement quand et comment l'IA a été utilisée et comment vous avez validé les sorties. Elle manque toutefois de précisions sur les versions/modèles exacts et n'indique pas les limites ou erreurs observées.

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

- **Run ID :** `20260526T014859Z-8caeb97f`
- **Devoir :** `S03`
- **Étudiant·e :** `thomasdescormiers`
- **Commit analysé :** `a380fb8`
- **Audit (côté instructeur) :** `tools/instructor/feedback_pipeline/audit/20260526T014859Z-8caeb97f/thomasdescormiers/`
- **Prompts (SHA-256) :**
  - `rubric_grader_system` : `505f32d1d8319d66...`
  - `ai_usage_grader_system` : `81cb7fdf89bda55a...`
- **Fournisseur (rubrique) :** `openai`
- **Fournisseur (IA-usage) :** `openai` (gpt-5-mini-2025-08-07)

_Ce feedback a été produit par un pipeline automatisé et **revu par l'équipe pédagogique avant publication**. Aucun chiffre ni étiquette de niveau n'est diffusé à ce stade expérimental : l'objectif est uniquement formatif. Ouvrez une issue dans ce dépôt pour toute question._
