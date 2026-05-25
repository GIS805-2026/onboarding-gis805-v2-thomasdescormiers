# S04 - Profils de commande observes

Ce document liste les profils operationnels nommes pour la junk dimension `dim_order_profile`.

## Resume

Le seed S04 contient 461 commandes. Les 8 flags operationnels donnent 110 combinaisons observees sur 256 combinaisons possibles.

| Famille de profil | Combinaisons observees | Commandes | Part des commandes |
|---|---:|---:|---:|
| Incentive order | 21 | 114 | 24.7 % |
| Online pickup | 22 | 88 | 19.1 % |
| Employee order | 37 | 75 | 16.3 % |
| Priority special handling | 20 | 54 | 11.7 % |
| Special handling | 3 | 40 | 8.7 % |
| Standard | 1 | 39 | 8.5 % |
| Gift order | 5 | 36 | 7.8 % |
| Operational flags | 1 | 15 | 3.3 % |

## Profils nommes les plus frequents

| Profil nomme | Famille | Commandes |
|---|---|---:|
| Standard order | Standard | 39 |
| promo | Incentive order | 25 |
| fragile | Special handling | 23 |
| pickup | Online pickup | 21 |
| express | Operational flags | 15 |
| gift | Gift order | 15 |
| express + promo | Incentive order | 14 |
| promo + fragile | Incentive order | 14 |
| employee | Employee order | 13 |
| oversized | Special handling | 12 |
| gift + fragile | Gift order | 11 |
| promo + oversized | Incentive order | 9 |
| gift + promo | Incentive order | 9 |
| promo + pickup | Online pickup | 9 |
| loyalty | Incentive order | 8 |

## Requete de reproduction

```sql
SELECT
    p.profile_name,
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
GROUP BY p.profile_name, p.profile_family
ORDER BY orders DESC, p.profile_name;
```
