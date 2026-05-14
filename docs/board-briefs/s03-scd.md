# S03 - Brief board : politique SCD

## Recommandation

NexaMart doit adopter une politique SCD hybride. Les corrections descriptives doivent etre ecrasees en Type 1, mais les changements qui modifient l'analyse historique doivent etre conserves en Type 2.

La priorite est de traiter `loyalty_segment`, `city`, `province`, `region` et `store_type` comme des attributs historiques. Ces valeurs expliquent comment le CEO interprete les ventes passées.

## Impact executive

Un rapport Type 1 est plus simple, mais il reecrit l'histoire. Quand un client change de segment, toutes ses anciennes ventes sont rattachees au nouveau segment. Le rapport donne alors l'impression que le segment courant a toujours ete vrai.

La demonstration S03 montre une distorsion importante:

| Segment | Revenu Type 1 | Revenu Type 2 | Distorsion |
|---|---:|---:|---:|
| Bronze | 15987.58 | 26361.69 | -10374.11 |
| Inactive | 17046.86 | 12677.48 | 4369.38 |
| Silver | 24875.21 | 21825.54 | 3049.67 |
| Platinum | 23116.24 | 20300.57 | 2815.67 |
| New | 11702.58 | 9631.38 | 2071.20 |
| Gold | 2634.10 | 4565.91 | -1931.81 |

Le Type 2 corrige ce probleme en ajoutant une nouvelle ligne de dimension pour chaque version historique, avec `valid_from`, `valid_to` et `is_current`.

## Decision de gouvernance

- Garder l'historique pour les changements qui expliquent les ventes passees.
- Ecraser seulement les corrections qui n'ont pas de valeur analytique.
- Documenter chaque attribut dans `docs/scd-policy.md`.
- Joindre les faits Type 2 avec la date de l'evenement, pas seulement avec la cle naturelle.

## Preuve SQL

La preuve reproductible est dans `sql/scd/type1_vs_type2_demo.sql`.

Le script charge `customer_changes.csv`, construit les versions Type 1 et Type 2 de la dimension client, puis compare les revenus par segment. Il inclut aussi des validations pour confirmer qu'il n'y a qu'une ligne courante par client et que chaque vente rejoint une seule version historique.
