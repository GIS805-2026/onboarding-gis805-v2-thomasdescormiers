# Rétroaction automatisée -- S03 (Dimensions à changement lent : garder la vérité historique chez NexaMart)

_Générée le 2026-05-25T22:10:19+00:00 -- Run `20260525T220643Z-3ddee3eb`_

Ce document est produit par un pipeline reproductible (vérification SQL déterministe + analyse LLM du brief et de la déclaration IA). Une revue humaine précède toujours sa publication. **À ce stade expérimental, aucune note ni étiquette de niveau n'est diffusée : l'objectif est purement formatif.**

---

## 1. Vérification automatique de la requête SQL

La requête extraite de votre brief n'a pas pu être validée automatiquement. Quelques pistes constructives ci-dessous pour vous aider à la rendre exécutable et alignee avec la question posée.

_Observation technique : aucune requête SQL détectée dans le brief_


**Pistes :**
> Aucun bloc ```sql ... ``` détecté et l'extracteur LLM n'a trouvé aucune requête. Encadrez votre requête finale dans la section « Preuve » avec un bloc ```sql ... ``` pour fiabiliser l'auto-validation.
> Extracteur LLM : Le brief mentionne un script SQL et décrit les résultats, mais n'inclut aucune requête SQL textuelle exploitable dans la section Preuve ou ailleurs.

## 2. Rétroaction pédagogique sur le brief

> Le brief répond clairement à la question CEO et recommande correctement l'usage du SCD Type 2 pour les attributs qui impactent l'interprétation des ventes. Il manque cependant des preuves chiffrées non redacted, un historique de commits et des instructions de reproduction complètes pour un examen complet.

### Observations par dimension

**Model quality**
- Observation : Le brief indique clairement d'utiliser SCD Type 2 pour loyalty_segment, city, province, region et store_type et décrit les colonnes ajoutées (cle subrogee, valid_from, valid_to, is_current).
- Piste d'amélioration : Préciser le grain exact du modèle (par ex. customer_id + version_num) et montrer un diagramme simple de tables/fact pour lever toute ambiguïté de jointure.

**Validation quality**
- Observation : Le document renvoie au script sql/scd/type1_vs_type2_demo.sql et décrit des checks (ex. un client courant n'a qu'une seule ligne is_current = TRUE).
- Piste d'amélioration : Inclure une requête SQL principale complète dans le brief (avec résultats chiffrés non redacted) et traiter explicitement les cas limites (NULLs, chevauchements de périodes).

**Executive justification**
- Observation : La section 'Reponse executive' répond à la question du CEO et recommande d'adopter la politique SCD2 pour les attributs qui changent l'interprétation d'une vente passée.
- Piste d'amélioration : Ajouter un impact chiffré synthétique (ex. % d'écart attendu sur les KPIs prioritaires) pour renforcer l'appel à la décision.

**Process trace**
- Observation : Le brief mentionne le script et les données sources (customer_changes.csv) mais n'indique pas d'historique git ni de note IA détaillée.
- Piste d'amélioration : Fournir un log de commits (≥3) avec messages significatifs et une note IA précisant outils et validation humaine.

**Reproducibility**
- Observation : Le chemin du script est documenté (sql/scd/type1_vs_type2_demo.sql) mais il manque des indications sur l'environnement d'exécution et les dépendances.
- Piste d'amélioration : Ajouter un README reproduisible avec les commandes exactes (ex. clone → charger CSV → exécuter script) et nettoyer tout chemin codé en dur.

## 3. Déclaration d'utilisation de l'IA

> La déclaration documente bien quand et comment l'IA a été utilisée et comment les résultats ont été relus ou testés. Il manque des informations sur la version/modèle précis utilisé et aucune limite ou erreur observée n'est décrite — ajoutez ces éléments pour améliorer la conformité.

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

- **Run ID :** `20260525T220643Z-3ddee3eb`
- **Devoir :** `S03`
- **Étudiant·e :** `thomasdescormiers`
- **Commit analysé :** `a380fb8`
- **Audit (côté instructeur) :** `tools/instructor/feedback_pipeline/audit/20260525T220643Z-3ddee3eb/thomasdescormiers/`
- **Prompts (SHA-256) :**
  - `rubric_grader_system` : `505f32d1d8319d66...`
  - `ai_usage_grader_system` : `81cb7fdf89bda55a...`
  - `sql_extractor_system` : `90ee9e277de7a27f...`
- **Fournisseur (rubrique) :** `openai`
- **Fournisseur (IA-usage) :** `openai` (gpt-5-mini-2025-08-07)

_Ce feedback a été produit par un pipeline automatisé et **revu par l'équipe pédagogique avant publication**. Aucun chiffre ni étiquette de niveau n'est diffusé à ce stade expérimental : l'objectif est uniquement formatif. Ouvrez une issue dans ce dépôt pour toute question._
