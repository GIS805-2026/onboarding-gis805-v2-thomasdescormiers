# Schema v1 - Ventes NexaMart

## Question du CEO

"Quelles categories declinent dans quelles regions et pourquoi?"

Pour la seance S02, la version analytique reproductible est: quel est le revenu par categorie de produit, region et trimestre, et quels declins doivent etre investigues en premier?

## Enonce du grain

Une ligne dans `fact_sales` represente une ligne de commande vendue, identifiee par la combinaison de `order_number` et `sale_line_id`.

Ce grain est le contrat de conception de la premiere etoile NexaMart. Les mesures comme `quantity`, `line_total` et `gross_amount` sont additives a ce niveau et peuvent etre agregees correctement par produit, magasin, date, client ou canal.

## Processus d'affaires

Le processus d'affaires modelise est la vente client. Chaque ligne enregistre un produit vendu dans une commande client.

## Table de faits

`fact_sales` est le centre de l'etoile.

Cles:
- `date_key`
- `product_key`
- `store_key`
- `customer_key`
- `channel_key`

Dimensions degenerees:
- `order_number`
- `sale_line_id`

Mesures:
- `quantity`
- `unit_price`
- `discount_pct`
- `net_price`
- `line_total`
- `gross_amount`

## Dimensions

`dim_date` permet l'analyse par annee, trimestre, mois, semaine et jour.

`dim_product` permet l'analyse par categorie, sous-categorie, marque et produit.

`dim_store` permet l'analyse par region, province, ville et type de magasin.

`dim_customer` permet l'analyse par identite client, geographie et segment de fidelite.

`dim_channel` permet l'analyse par nom de canal et type de canal.

## Dimensions conformes

`dim_date`, `dim_product` et `dim_store` sont des dimensions conformes pour le modele NexaMart. Elles pourront etre reutilisees plus tard avec les faits de retours, budgets, inventaire et promotions.

Cette reutilisation rend le drill-across possible, parce que plusieurs tables de faits peuvent etre resumees avec les memes definitions de date, produit et magasin.

## Requete de validation

La requete de preuve est stockee dans `sql/analysis/s02-first-answer.sql`. Elle agrege `fact_sales.line_total` par `dim_product.category`, `dim_store.region` et `dim_date.quarter`, puis compare le T4 2025 avec le trimestre precedent.

## Diagramme

La source Mermaid est stockee dans `diagrams/schema-v1.mmd`.
