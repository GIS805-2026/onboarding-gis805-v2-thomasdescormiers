# Board Brief - S01

## Question du CEO

« Quelles catégories déclinent dans quelles régions et pourquoi ? »

Pour NexaMart, je reformule la question exécutive ainsi : **quel est le revenu par catégorie de produit, par région et par trimestre, et quelles baisses doivent être investiguées en priorité ?**

## Réponse exécutive

À ce stade, NexaMart possède des données de ventes, clients, produits, magasins, canaux et dates, mais elles ne sont pas encore organisées sous forme d'entrepôt analytique fiable. La question du CEO est simple en apparence, mais elle exige de croiser une mesure de vente avec plusieurs dimensions business : catégorie, région et trimestre.

Le diagnostic principal est que les systèmes opérationnels enregistrent les transactions, mais ne rendent pas encore la réponse répétable chaque mois. La priorité est donc de construire une étoile de ventes centrée sur `fact_sales`, puis de l'utiliser pour produire une vue stable du revenu par catégorie, région et période.

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
