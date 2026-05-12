# Board Brief - S02

## Question du CEO

Quel schema en etoile rend la question CEO repetable et fiable chaque mois?

La question executive suivie depuis S01 est : **quel est le revenu par categorie de produit, par region et par trimestre, et quelles baisses doivent etre investiguees en priorite?**

## Reponse executive

Le schema recommande est une etoile centree sur `fact_sales`. Cette table de faits contient les ventes au grain ligne de commande, tandis que les dimensions `dim_product`, `dim_store` et `dim_date` donnent les axes d'analyse necessaires pour repondre a la question du CEO.

Ce modele rend la question repetable parce que le revenu est calcule a partir d'une mesure stable, `fact_sales.line_total`, et que les regroupements business viennent de dimensions conformes : la categorie dans `dim_product`, la region dans `dim_store` et le trimestre dans `dim_date`.

La preuve SQL montre que les declins les plus importants entre 2025 T3 et 2025 T4 sont concentres dans `Automotive`, surtout en Ontario, au Quebec et en Alberta. D'autres baisses importantes apparaissent aussi dans `Grocery` en Ontario, `Pet Supplies` en Outaouais et `Sports & Outdoors` en Colombie-Britannique.

| Categorie | Region | Revenu T4 | Revenu T3 | Baisse | Variation | Signal principal |
|---|---:|---:|---:|---:|---:|---|
| Automotive | Ontario | 3266.55 | 6879.84 | -3613.29 | -52.52% | -24 unites, -6 commandes |
| Automotive | Quebec | 5276.78 | 7066.78 | -1790.00 | -25.33% | -12 unites, -3 commandes |
| Automotive | Alberta | 579.82 | 2361.64 | -1781.82 | -75.45% | -12 unites, -4 commandes |
| Grocery | Ontario | 3903.57 | 5619.46 | -1715.89 | -30.53% | -20 unites, -6 commandes |
| Pet Supplies | Outaouais | 3300.58 | 4262.35 | -961.77 | -22.56% | -5 unites, commandes stables |
| Sports & Outdoors | BC | 554.02 | 1505.37 | -951.35 | -63.20% | -14 unites, -3 commandes |

## Decisions de modelisation

- **Processus principal :** ventes clients NexaMart.
- **Table de faits :** `fact_sales`.
- **Grain :** une ligne dans `fact_sales` represente une ligne de commande vendue, identifiee par `order_number` et `sale_line_id`.
- **Dimensions :** `dim_date`, `dim_product`, `dim_store`, `dim_customer` et `dim_channel`.
- **Mesures principales :** `quantity`, `unit_price`, `discount_pct`, `net_price`, `line_total` et `gross_amount`.
- **Dimensions conformes :** `dim_date`, `dim_product` et `dim_store`, car elles pourront etre reutilisees avec les retours, budgets, inventaires et promotions.

Le choix du grain est volontairement fin. Il permet de repondre a la question actuelle par categorie, region et trimestre, tout en conservant la possibilite de descendre plus tard par produit, magasin, client ou canal.

## Preuve

La preuve SQL est dans `sql/analysis/s02-first-answer.sql`.

Cette requete :
- agrege les ventes par categorie, region, annee et trimestre;
- calcule le revenu avec `SUM(f.line_total)`;
- compare 2025 T4 au trimestre precedent avec `LAG`;
- retourne les combinaisons categorie-region ou le revenu a diminue.

Le diagramme de l'etoile est dans `diagrams/s02-star-schema.mmd` et peut etre visualise avec une extension Mermaid, Mermaid Live Editor ou une preview Markdown compatible Mermaid.

## Validation

- La requete `sql/analysis/s02-first-answer.sql` a ete executee dans DuckDB et retourne les declins attendus.
- Les tables necessaires existent : `fact_sales`, `dim_product`, `dim_store`, `dim_date`, `dim_customer` et `dim_channel`.
- La validation du projet avec `python src/run_checks.py` retourne 32 PASS, 0 FAIL, 0 SKIP.
- Le check de grain confirme que `fact_sales` est unique par `(order_number, sale_line_id)`.

## Risques / limites

- Le modele S02 repond au "quoi", au "ou" et au "quand", mais il n'explique pas encore completement le "pourquoi".
- Les ventes seules ne suffisent pas pour distinguer une baisse de demande d'un probleme de retours, de stocks, de budget ou de promotion.
- `discount_pct` ne doit pas etre additionne directement; il doit etre interprete comme une mesure non additive.
- Les comparaisons trimestrielles doivent toujours respecter le meme grain d'analyse pour eviter les doubles comptes.

## Prochaine recommandation

Conserver `fact_sales` comme table centrale de l'etoile et reutiliser `dim_date`, `dim_product` et `dim_store` comme dimensions conformes dans les prochaines seances. La prochaine etape analytique sera d'ajouter les retours, budgets, stocks ou promotions pour expliquer les causes des declins observes, surtout pour `Automotive` en Ontario, au Quebec et en Alberta.
