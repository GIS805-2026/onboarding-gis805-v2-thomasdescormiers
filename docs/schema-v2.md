# Schema v2 - Commandes, paniers et drapeaux operationnels NexaMart

## Question du CEO

"Quels patterns de commande NexaMart sont importants pour les operations, et quels produits sont achetes ensemble?"

## Enonce du grain

Pour la seance S04, le grain operationnel est une ligne d'en-tete de commande dans `raw_orders` et une ligne de commande dans `raw_order_lines`.

`order_number` relie ces deux grains. C'est une dimension degeneree: elle identifie la transaction d'affaires, mais elle n'a pas d'attributs descriptifs utiles qui justifieraient une dimension separee.

## Processus d'affaires

Le processus d'affaires modelise est la commande client. S04 etend le modele des ventes avec des drapeaux operationnels de commande et des patterns de cooccurrence dans les paniers.

## Dimension degeneree

`order_number` reste directement dans les donnees de faits ou de lignes de commande, parce que c'est seulement un identifiant.

Il doit etre utilise pour:
- regrouper toutes les lignes du meme panier;
- compter les commandes distinctes;
- joindre les en-tetes de commande aux lignes de commande;
- retracer une transaction pendant la validation.

Il ne devrait pas devenir une dimension autonome `dim_order`, parce que les attributs descriptifs sont deja modelises ailleurs: date, client, magasin, canal, produit et profil de commande.

## Junk dimension

`dim_order_profile` consolide les 8 drapeaux operationnels a faible cardinalite:

- `is_gift_wrapped`
- `is_express_shipping`
- `is_loyalty_redeemed`
- `is_promo_applied`
- `is_employee_purchase`
- `is_online_pickup`
- `is_fragile`
- `is_oversized`

La dimension ajoute:
- `order_profile_key`;
- `profile_name`;
- `profile_family`;
- `active_flag_count`.

Il y a 110 combinaisons observees dans le seed S04, comparativement a 256 combinaisons possibles. C'est la raison d'utiliser une junk dimension: le VP Operations peut lire des profils nommes au lieu d'interpreter 8 flags separes dans chaque rapport.

## Utilisation dans les faits

Le livrable S04 ne cree pas de nouvelle table de faits persistee. Le pattern de modele vise est le suivant:

- le fait de commande ou de ligne de commande conserve `order_number`;
- le fait de commande ou de ligne de commande reference `order_profile_key`;
- les mesures comme les comptes de commandes, les quantites et le revenu restent dans la couche de faits ou de requetes.

## Analyse de panier

`sql/analysis/basket_pairs.sql` utilise une self-join sur `raw_order_lines`.

La regle `l1.product_id < l2.product_id` evite les paires dupliquees et les auto-paires. Par exemple, elle compte A-B une seule fois et evite de compter a la fois A-B et B-A.

## Requete de validation

Le modele peut etre valide avec:

```sql
SELECT
    p.profile_family,
    COUNT(DISTINCT o.order_number) AS orders
FROM raw_orders o
JOIN dim_order_profile p
    ON CAST(o.is_gift_wrapped AS BOOLEAN) = p.is_gift_wrapped
   AND CAST(o.is_express_shipping AS BOOLEAN) = p.is_express_shipping
   AND CAST(o.is_loyalty_redeemed AS BOOLEAN) = p.is_loyalty_redeemed
   AND CAST(o.is_promo_applied AS BOOLEAN) = p.is_promo_applied
   AND CAST(o.is_employee_purchase AS BOOLEAN) = p.is_employee_purchase
   AND CAST(o.is_online_pickup AS BOOLEAN) = p.is_online_pickup
   AND CAST(o.is_fragile AS BOOLEAN) = p.is_fragile
   AND CAST(o.is_oversized AS BOOLEAN) = p.is_oversized
GROUP BY p.profile_family
ORDER BY orders DESC;
```

Resultat attendu pour le seed S04: 110 combinaisons de profils sur 461 commandes.
