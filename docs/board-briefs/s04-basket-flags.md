# S04 - Brief board : panier et profils operationnels

## Recommandation

NexaMart doit adopter `dim_order_profile` comme junk dimension pour les drapeaux operationnels et conserver `order_number` comme dimension degeneree dans les faits de commande.

Cette decision rend les operations plus lisibles: au lieu de surveiller 8 colonnes booleennes, le VP Operations peut suivre des profils comme `Incentive order`, `Online pickup`, `Employee order` et `Priority special handling`.

## Impact executive

Le seed S04 contient 461 commandes et 1326 lignes. Les 8 flags peuvent produire 256 combinaisons, mais 110 combinaisons apparaissent vraiment dans les donnees. Les profils nommes donnent donc un langage de pilotage sans perdre le detail des flags.

| Profil | Commandes | Part |
|---|---:|---:|
| Incentive order | 114 | 24.7 % |
| Online pickup | 88 | 19.1 % |
| Employee order | 75 | 16.3 % |
| Priority special handling | 54 | 11.7 % |
| Special handling | 40 | 8.7 % |
| Standard | 39 | 8.5 % |
| Gift order | 36 | 7.8 % |
| Operational flags | 15 | 3.3 % |

Les profils prioritaires pour les operations sont `Online pickup` et `Priority special handling`, parce qu'ils affectent directement la preparation, la manutention et la promesse client.

## Panier

Les paires de produits detectees par self-join donnent des pistes de regroupement et de cross-sell. Les plus fortes paires de produits atteignent 7 commandes ensemble, donc elles doivent etre testees avant d'etre transformees en regles commerciales.

Les paires de categories les plus visibles sont:

| Categories | Commandes ensemble |
|---|---:|
| Toys & Games + Pet Supplies | 60 |
| Clothing + Toys & Games | 60 |
| Toys & Games + Books & Media | 53 |
| Books & Media + Pet Supplies | 52 |
| Home & Garden + Toys & Games | 50 |

## Decision de gouvernance

- Utiliser la junk dimension pour les flags operationnels.
- Garder les mesures hors de la dimension.
- Utiliser `order_number` comme cle de regroupement de panier, pas comme dimension separee.
- Revoir les noms de profils avec le VP Operations avant publication officielle.

## Preuve SQL

Les fichiers reproductibles sont:

- `sql/dims/dim_order_profile.sql`
- `sql/analysis/basket_pairs.sql`

La requete panier utilise une self-join sur `order_number` et la condition `product_id < product_id` entre les deux alias pour eviter les doublons.
