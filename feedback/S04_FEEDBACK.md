# Rétroaction automatisée -- S04 (Panier d'achat et drapeaux : les patterns que l'étoile simple ne couvre pas)

_Générée le 2026-05-28T19:11:04+00:00 -- Run `20260528T190711Z-122cea87`_

Ce document est produit par un pipeline reproductible (vérification SQL déterministe + analyse LLM du brief et de la déclaration IA). Une revue humaine précède toujours sa publication. **À ce stade expérimental, aucune note ni étiquette de niveau n'est diffusée : l'objectif est purement formatif.**

> ⚠️ **Avertissement instructeur (à retirer avant publication) :** cette analyse a été générée avec `--skip-pull`. Le contenu correspond au commit local et **n'est peut-être pas la dernière version poussée par l'étudiant·e**.

---

## 1. Vérification automatique de la requête SQL

La requête extraite de votre brief n'a pas pu être validée automatiquement. Quelques pistes constructives ci-dessous pour vous aider à la rendre exécutable et alignee avec la question posée.

_Observation technique : aucune requête SQL détectée dans le brief_


**Pistes :**
> Aucun bloc ```sql ... ``` détecté et l'extracteur LLM n'a trouvé aucune requête. Encadrez votre requête finale dans la section « Preuve » avec un bloc ```sql ... ``` pour fiabiliser l'auto-validation.
> Extracteur LLM : Le brief décrit des requêtes et fichiers (dim_order_profile.sql, basket_pairs.sql) mais n'inclut aucune requête SQL explicite à extraire.

## 2. Rétroaction pédagogique sur le brief

> Le brief est bien ciblé sur la question CEO : grain explicite, justification de la junk dimension et recommandations opérationnelles claires. Manquent des artefacts de traçabilité (commits, note IA) et des checks reproduisibles détaillés pour faciliter l'industrialisation.

### Observations par dimension

**Model quality**
- Observation : Le brief précise le grain (niveau commande), justifie la junk dimension (110 combinaisons observées) et décrit dim_order_profile pour regrouper les 8 flags opérationnels.
- Piste d'amélioration : Ajouter un diagramme simple (schéma de faits/dimensions) montrant où dim_order_profile s'intègre pour clarifier les jointures et le grain.

**Validation quality**
- Observation : Le document indique les comptes du seed (461 commandes, 1326 lignes), décrit la requête de panier self-join et l'évitement des doublons A-B/B-A.
- Piste d'amélioration : Fournir la requête SQL exacte et des checks sur cas limites (NULLs, commandes vides, vérification des poids summant à 1) et ajouter un exemple de sortie reproduisible.

**Executive justification**
- Observation : La section 'Reponse executive' formule une recommandation claire: monitorer les profils opérationnels (manutention spéciale, ramassage en ligne) et prioriser leur suivi par canal/magasin.
- Piste d'amélioration : Ajouter un indicateur chiffré d'impact opérationnel (ex. minutes de préparation ou coût moyen) pour prioriser la mise en œuvre.

**Process trace**
- Observation : Le brief mentionne les fichiers (sql/dims/dim_order_profile.sql, sql/analysis/basket_pairs.sql, docs/profiles.md) mais n'inclut pas d'historique de commits ni de note IA détaillée.
- Piste d'amélioration : Inclure un petit journal de décisions et au moins 3 commits git avec messages significatifs et une note IA indiquant outils utilisés et validation humaine.

**Reproducibility**
- Observation : Les scripts SQL sont référencés et le seed est décrit, mais il n'y a pas d'instructions pas-à-pas ou README expliquant comment exécuter les checks sur un clone propre.
- Piste d'amélioration : Ajouter un README 'runme' avec commandes précises (ex. DuckDB + chemins relatifs) et un script check.sh qui produit les nombres clés en moins de 5 minutes.

## 3. Déclaration d'utilisation de l'IA

> La déclaration liste clairement les séances d'utilisation et décrit les validations humaines effectuées. Il manque une mention explicite des limites ou des erreurs observées et les outils sont nommés sans version/modèle précis, ce qui réduit la conformité.

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

- **Run ID :** `20260528T190711Z-122cea87`
- **Devoir :** `S04`
- **Étudiant·e :** `thomasdescormiers`
- **Commit analysé :** `446a8e3`
- **Audit (côté instructeur) :** `tools/instructor/feedback_pipeline/audit/20260528T190711Z-122cea87/thomasdescormiers/`
- **Prompts (SHA-256) :**
  - `rubric_grader_system` : `505f32d1d8319d66...`
  - `ai_usage_grader_system` : `81cb7fdf89bda55a...`
  - `sql_extractor_system` : `90ee9e277de7a27f...`
- **Fournisseur (rubrique) :** `openai`
- **Fournisseur (IA-usage) :** `openai` (gpt-5-mini-2025-08-07)

_Ce feedback a été produit par un pipeline automatisé et **revu par l'équipe pédagogique avant publication**. Aucun chiffre ni étiquette de niveau n'est diffusé à ce stade expérimental : l'objectif est uniquement formatif. Ouvrez une issue dans ce dépôt pour toute question._
