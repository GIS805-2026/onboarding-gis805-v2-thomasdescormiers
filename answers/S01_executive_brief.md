# Board Brief - S01

## Question du CEO

« Quelles catégories déclinent dans quelles régions et pourquoi ? »

Pour NexaMart, je reformule la question exécutive ainsi : **quel est le revenu par catégorie de produit, par région et par trimestre, et quelles baisses doivent être investiguées en priorité ?**

## Réponse exécutive

Au dernier trimestre disponible, soit **2025 T4 comparé à 2025 T3**, les déclins les plus préoccupants sont concentrés dans `Automotive`, surtout en Ontario, au Québec et en Alberta. D'autres baisses importantes apparaissent aussi dans `Grocery` en Ontario, `Pet Supplies` en Outaouais et `Sports & Outdoors` en Colombie-Britannique.

La cause principale visible dans les données est une baisse du volume vendu, pas seulement un problème de prix. Dans les cas prioritaires, les unités vendues et le nombre de commandes diminuent fortement. Par exemple, `Automotive` en Ontario perd 24 unités et 6 commandes entre T3 et T4, ce qui explique directement la baisse de revenu.

Les retours et les remises peuvent aggraver certains cas, mais ils ne semblent pas être la cause principale du déclin. Les premiers indicateurs pointent davantage vers une baisse de demande ou un problème commercial régional qu'un simple problème de prix. La priorité d'investigation devrait donc être `Automotive` en Ontario, Québec et Alberta, puis `Grocery` en Ontario.

| Catégorie | Région | Revenu T4 | Revenu T3 | Baisse | Variation | Signal principal |
|---|---:|---:|---:|---:|---:|---|
| Automotive | Ontario | 3 266,55 $ | 6 879,84 $ | -3 613,29 $ | -52,5 % | -24 unités, -6 commandes |
| Automotive | Québec | 5 276,78 $ | 7 066,78 $ | -1 790,00 $ | -25,3 % | -12 unités, -3 commandes |
| Automotive | Alberta | 579,82 $ | 2 361,64 $ | -1 781,82 $ | -75,4 % | -12 unités, -4 commandes |
| Grocery | Ontario | 3 903,57 $ | 5 619,46 $ | -1 715,89 $ | -30,5 % | -20 unités, -6 commandes |
| Pet Supplies | Outaouais | 3 300,58 $ | 4 262,35 $ | -961,77 $ | -22,6 % | -5 unités, commandes stables |
| Sports & Outdoors | BC | 554,02 $ | 1 505,37 $ | -951,35 $ | -63,2 % | -14 unités, -3 commandes |

## Décisions de modélisation

- **Processus principal :** ventes clients NexaMart.
- **Table de faits identifiée :** `fact_sales`.
- **Grain visé :** une ligne représente une ligne de commande vendue, identifiée par `order_number` et `sale_line_id`.
- **Mesures principales :** `quantity`, `unit_price`, `discount_pct`, `net_price`, `line_total`.
- **Dimensions nécessaires :** `dim_product` pour la catégorie, `dim_store` pour la région, `dim_date` pour le trimestre, `dim_customer` pour le profil client et `dim_channel` pour le canal de vente.
- **Hypothèse S01 :** une catégorie est considérée comme préoccupante si son revenu baisse d'un trimestre à l'autre dans une région donnée. La cause exacte du déclin demandera plus tard les retours, budgets, stocks et campagnes.

## Preuve

Requête exploratoire proposée pour répondre à la première partie de la question :

```sql
SELECT
    p.category,
    s.region,
    d.year,
    d.quarter,
    SUM(f.line_total) AS revenue,
    SUM(f.quantity) AS units_sold,
    COUNT(DISTINCT f.order_number) AS orders
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
JOIN dim_store s ON f.store_key = s.store_key
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY
    p.category,
    s.region,
    d.year,
    d.quarter
ORDER BY
    d.year,
    d.quarter,
    revenue DESC;
```

Cette requête montre que la question du CEO demande une structure multidimensionnelle : une mesure (`revenue`) analysée par produit, géographie et temps.

## Validation

- Les données synthétiques ont été générées et chargées dans DuckDB.
- `make check` / `.\run.ps1 check` sert à vérifier que les tables attendues existent, que les clés sont uniques et que `fact_sales` respecte son grain.
- La validation attendue pour S01 est surtout diagnostique : confirmer qu'une requête exploratoire retourne des lignes non nulles et que les dimensions nécessaires à la question sont identifiées.

## Risques / limites

- Le brief S01 ne prouve pas encore la cause du déclin; il identifie seulement la question, les données nécessaires et les obstacles.
- Les données de ventes seules ne suffisent pas pour expliquer le « pourquoi ». Il faudra intégrer les retours, budgets, inventaires et campagnes pour distinguer une baisse de demande d'un problème opérationnel.
- Sans grain clair, la même commande pourrait être comptée deux fois ou agrégée au mauvais niveau.

## Prochaine recommandation

Construire l'étoile `fact_sales` avec les dimensions `dim_product`, `dim_store`, `dim_date`, `dim_customer` et `dim_channel`, puis produire une requête stable qui compare le revenu par catégorie, région et trimestre. Cette étape rendra la question du CEO répétable et vérifiable pour les séances suivantes.
