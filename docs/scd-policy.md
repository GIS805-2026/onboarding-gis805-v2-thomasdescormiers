# Politique SCD - NexaMart

## Principe directeur

Un changement de dimension doit etre conserve en historique lorsqu'il change l'interpretation d'une vente passee. Un changement peut etre ecrase seulement lorsqu'il corrige une erreur descriptive sans modifier la realite business de l'evenement.

Cette politique repond a la question du CEO: les rapports doivent representer la verite du moment de la vente, pas uniquement la verite d'aujourd'hui.

## Types retenus

| Dimension | Attribut | Type SCD | Politique |
|---|---|---:|---|
| `dim_customer` | `loyalty_segment` | Type 2 | Conserver l'historique. Une vente faite quand le client etait `Bronze` doit rester `Bronze`, meme si le client devient `Silver`. |
| `dim_customer` | `province`, `city` | Type 2 | Conserver l'historique geographique pour eviter de deplacer des ventes passees vers une nouvelle province ou ville. |
| `dim_customer` | `first_name`, `last_name` | Type 1 | Ecraser les corrections de nom, de casse ou de typo. L'ancienne erreur n'a pas de valeur analytique. |
| `dim_customer` | `email_domain` | Type 1 | Ecraser sauf si le domaine devient un axe analytique officiel. |
| `dim_store` | `region` | Type 2 | Conserver l'historique. Une reassignment regionale ne doit pas reecrire les ventes passees. |
| `dim_store` | `store_type` | Type 2 | Conserver l'historique si le changement represente une conversion operationnelle, par exemple `standard` vers `flagship`. |
| `dim_store` | `store_name` | Type 1 | Ecraser les corrections ou renommages cosmetiques qui ne changent pas l'analyse. |
| `dim_product` | `category` | Type 2 | Conserver si la categorie change la lecture historique des revenus. |
| `dim_product` | libelles descriptifs | Type 1 | Ecraser les corrections de texte sans impact analytique. |

## Usage limite du Type 3

Le Type 3 peut etre utile quand le besoin est de comparer uniquement la valeur courante et la valeur precedente dans la meme ligne, par exemple `previous_segment` et `current_segment`. Ce n'est pas le mecanisme principal de NexaMart pour preserver l'histoire, car il ne garde pas une chaine complete de changements.

## Regle de jointure pour les faits

Les tables de faits doivent joindre une dimension Type 2 avec la cle naturelle et la date de l'evenement:

```sql
fact.customer_id = dim_customer_type2.customer_id
and fact.order_date >= dim_customer_type2.valid_from
and (
    dim_customer_type2.valid_to is null
    or fact.order_date < dim_customer_type2.valid_to
)
```

Cette regle garantit qu'une vente est rattachee a la version de dimension valide au moment de la vente.

## Distinction valeur courante et valeur historique

Le schema de demonstration distingue explicitement:

- `historical_value` : valeur qui etait vraie avant le changement;
- `current_value` : valeur courante apres le changement;
- `valid_from`, `valid_to` et `is_current` : colonnes qui indiquent quelle version Type 2 etait valide au moment de chaque vente.

Pour `dim_store.region`, la politique retenue est Type 2: une vente passee doit rester rattachee a la region historique du magasin, meme si la region courante change plus tard.

## Preuve attendue

Le script `sql/scd/type1_vs_type2_demo.sql` montre que le Type 1 produit un rapport trompeur par segment. Pour les clients dont le segment a change, le Type 1 deplace 10374.11 $ hors du segment `Bronze` par rapport au Type 2.

La politique retenue est donc:

- Type 1 pour corriger les erreurs.
- Type 2 pour les changements qui expliquent les rapports historiques.
- Type 3 seulement pour des comparaisons simples entre valeur precedente et valeur courante.
