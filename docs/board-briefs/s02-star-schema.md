# S02 - Brief board : schema en etoile

## Recommandation

Le modele recommande est un schema en etoile centre sur `fact_sales`. Ce modele rend la question du CEO repetable chaque mois et chaque trimestre, car les mesures de ventes sont conservees dans une table de faits et les axes d'analyse sont separes dans des dimensions reutilisables.

## Grain

Une ligne dans `fact_sales` represente une ligne de commande vendue, identifiee par `order_number` et `sale_line_id`.

Ce grain est assez fin pour repondre a la question actuelle et a ses variantes futures par produit, magasin, date, client et canal. Il evite aussi de figer le modele a un niveau trop agrege qui cacherait les variations par produit ou par region.

## Schema en etoile

Table de faits :
- `fact_sales`

Dimensions :
- `dim_date`
- `dim_product`
- `dim_store`
- `dim_customer`
- `dim_channel`

L'analyse principale pour le CEO utilise trois dimensions :
- la categorie vient de `dim_product`;
- la region vient de `dim_store`;
- le trimestre vient de `dim_date`.

La mesure principale de revenu vient de `fact_sales.line_total`.

## Visualisation du graphe

Le graphe du schema en etoile est defini dans le script Mermaid `docs/board-briefs/s02-star-schema.mmd`.

Pour le visualiser, il est possible d'executer ou d'ouvrir ce fichier Mermaid avec un outil compatible, par exemple :
- l'extension Mermaid de VS Code;
- le site Mermaid Live Editor;
- une preview Markdown qui supporte les blocs Mermaid.

Le meme diagramme est aussi disponible dans `diagrams/s02-star-schema.mmd`.

## Preuve SQL

La preuve SQL est dans `sql/analysis/s02-first-answer.sql`. Elle retourne les couples categorie-region ou le revenu de 2025 T4 est inferieur au trimestre precedent.

Principaux declins observes :

| Categorie | Region | Revenu T4 | Revenu T3 | Baisse | Variation | Variation unites | Variation commandes |
|---|---:|---:|---:|---:|---:|---:|---:|
| Automotive | Ontario | 3266.55 | 6879.84 | -3613.29 | -52.52% | -24 | -6 |
| Automotive | Quebec | 5276.78 | 7066.78 | -1790.00 | -25.33% | -12 | -3 |
| Automotive | Alberta | 579.82 | 2361.64 | -1781.82 | -75.45% | -12 | -4 |
| Grocery | Ontario | 3903.57 | 5619.46 | -1715.89 | -30.53% | -20 | -6 |
| Pet Supplies | Outaouais | 3300.58 | 4262.35 | -961.77 | -22.56% | -5 | 0 |
| Sports & Outdoors | BC | 554.02 | 1505.37 | -951.35 | -63.20% | -14 | -3 |

## Interpretation executive

Le modele montre que le declin le plus urgent est `Automotive` en Ontario, suivi de `Automotive` au Quebec et en Alberta. Ces baisses sont accompagnees d'une diminution des unites vendues et du nombre de commandes, ce qui pointe davantage vers un probleme de demande ou d'execution regionale qu'un simple effet de prix.

Le schema repond donc a la partie "ou" et "quand" de la question du CEO. Pour expliquer completement le "pourquoi", il faudra integrer plus tard les retours, les budgets, les inventaires ou les promotions.
