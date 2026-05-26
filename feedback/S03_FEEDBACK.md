# Rétroaction automatisée -- S03 (Dimensions à changement lent : garder la vérité historique chez NexaMart)

_Générée le 2026-05-26T01:04:41+00:00 -- Run `20260526T010307Z-64bc65ed`_

Ce document est produit par un pipeline reproductible (vérification SQL déterministe + analyse LLM du brief et de la déclaration IA). Une revue humaine précède toujours sa publication. **À ce stade expérimental, aucune note ni étiquette de niveau n'est diffusée : l'objectif est purement formatif.**

---

## 1. Vérification automatique de la requête SQL

La requête extraite de votre brief n'a pas pu être validée automatiquement. Quelques pistes constructives ci-dessous pour vous aider à la rendre exécutable et alignee avec la question posée.

_Observation technique : aucune requête SQL détectée dans le brief_


**Pistes :**
> Aucun bloc ```sql ... ``` détecté et l'extracteur LLM n'a trouvé aucune requête. Encadrez votre requête finale dans la section « Preuve » avec un bloc ```sql ... ``` pour fiabiliser l'auto-validation.
> Extracteur LLM : Le brief mentionne un script et décrit les résultats mais n'inclut aucune requête SQL exploitable dans le texte fourni.

## 2. Rétroaction pédagogique sur le brief

> Le brief explique clairement pourquoi SCD Type 2 est nécessaire pour les attributs qui modifient l'interprétation des ventes et fournit une recommandation opérationnelle. Il manque toutefois des éléments concrets de validation reproductible (requête principale, gestion des cas limites, historique de commits) pour être entièrement opérationnel.

### Observations par dimension

**Model quality**
- Observation : Vous proposez SCD Type 2 pour loyalty_segment, city, province et region, et décrivez la clef subrogee, valid_from/valid_to et la jointure temporelle des faits.
- Piste d'amélioration : Préciser le grain exact du fait et montrer un schéma simple (DDL ou diagramme) avec les clés et exemples de valeurs pour vérifier qu'aucune relation clé n'est manquante.

**Validation quality**
- Observation : Le script de démonstration est référencé (sql/scd/type1_vs_type2_demo.sql) et vous mentionnez des vérifications comme 'un client courant n'a qu'une seule ligne is_current = TRUE'.
- Piste d'amélioration : Inclure la requête principale complète qui répond à la question CEO et ajouter le traitement explicite des cas limites (NULLs, chevauchements de périodes, et vérification SUM(weight)=1 si pertinent).

**Executive justification**
- Observation : La section 'Reponse executive' explique en langage métier que les changements qui modifient l'interprétation d'une vente doivent être historisés et recommande d'adopter la politique SCD pour protéger les analyses historiques.
- Piste d'amélioration : Ajouter un chiffre synthétique clé (ex: % de distorsion attendu ou impact financier résumé) pour rendre la recommandation encore plus actionnable en une phrase.

**Process trace**
- Observation : Vous signalez le script SQL et décrivez les données source ('raw_customer_changes' couvre 46 changements...), mais il n'y a pas d'historique de commits ni de note IA/validation humaine détaillée.
- Piste d'amélioration : Publier au moins 3 commits incrémentaux avec messages significatifs et ajouter une note IA précisant l'outil utilisé et la validation humaine effectuée.

**Reproducibility**
- Observation : Le chemin du script est indiqué (sql/scd/type1_vs_type2_demo.sql) mais vous ne fournissez pas d'instructions de reproduction (README, dépendances, commandes).
- Piste d'amélioration : Ajouter un README avec instructions pas-à-pas (clone → charger csv → exécuter script → commandes exactes) et éviter les chemins codés en dur.

## 3. Déclaration d'utilisation de l'IA

> La déclaration décrit clairement quand et comment l'IA a été utilisée et donne des exemples concrets de validation humaine. En revanche, l'identification des outils reste générique (pas de version/modèle précis) et il manque une section explicite sur les limites ou erreurs observées de l'IA.

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

- **Run ID :** `20260526T010307Z-64bc65ed`
- **Devoir :** `S03`
- **Étudiant·e :** `thomasdescormiers`
- **Commit analysé :** `a380fb8`
- **Audit (côté instructeur) :** `tools/instructor/feedback_pipeline/audit/20260526T010307Z-64bc65ed/thomasdescormiers/`
- **Prompts (SHA-256) :**
  - `rubric_grader_system` : `505f32d1d8319d66...`
  - `ai_usage_grader_system` : `81cb7fdf89bda55a...`
  - `sql_extractor_system` : `90ee9e277de7a27f...`
- **Fournisseur (rubrique) :** `openai`
- **Fournisseur (IA-usage) :** `openai` (gpt-5-mini-2025-08-07)

_Ce feedback a été produit par un pipeline automatisé et **revu par l'équipe pédagogique avant publication**. Aucun chiffre ni étiquette de niveau n'est diffusé à ce stade expérimental : l'objectif est uniquement formatif. Ouvrez une issue dans ce dépôt pour toute question._
