# Board Brief - S04

## Question du CEO

Quels patterns de commande NexaMart sont importants pour les operations, et quels produits sont achetes ensemble?

## Reponse executive

NexaMart doit suivre les patterns de commande au niveau de la commande, pas seulement au niveau des lignes de vente. Dans le seed S04, il y a 461 commandes et 1326 lignes de commande. Les 8 drapeaux operationnels produisent 110 combinaisons reelles sur 256 possibles, ce qui confirme qu'une junk dimension est plus lisible que 8 flags disperses dans les rapports.

Les profils les plus utiles pour les operations sont les commandes avec incitatif, le ramassage en ligne, les achats employes et les commandes prioritaires avec manutention speciale. Ces profils representent les cas qui changent le travail des equipes: preparation, emballage, promesse de livraison, verification promo/fidelite et manipulation d'articles fragiles ou surdimensionnes.

| Profil operationnel | Commandes | Part des commandes |
|---|---:|---:|
| Incentive order | 114 | 24.7 % |
| Online pickup | 88 | 19.1 % |
| Employee order | 75 | 16.3 % |
| Priority special handling | 54 | 11.7 % |
| Special handling | 40 | 8.7 % |
| Standard | 39 | 8.5 % |
| Gift order | 36 | 7.8 % |
| Operational flags | 15 | 3.3 % |

Pour les paniers, les paires de produits les plus frequentes restent modestes, avec un maximum de 7 commandes ensemble. Elles sont donc de bons signaux pour tester des regroupements, pas encore des conclusions definitives de merchandising. Les meilleurs signaux de categories sont `Toys & Games` avec `Pet Supplies`, `Clothing` avec `Toys & Games`, et `Toys & Games` avec `Books & Media`.

## Decisions de modelisation

- Garder `order_number` dans la table de faits comme dimension degeneree, parce que le numero de commande identifie le panier mais n'a pas d'attributs descriptifs propres.
- Creer `dim_order_profile` comme junk dimension pour regrouper les 8 flags operationnels et leur donner des noms exploitables par les operations.
- Ne pas placer de faits dans `dim_order_profile`: les frequences de commandes sont calculees par requete, pas stockees dans la dimension.
- Utiliser une analyse de panier par self-join sur `order_number` pour trouver les produits presents dans la meme commande.

## Preuve

La junk dimension est definie dans `sql/dims/dim_order_profile.sql`.

La requete de panier est dans `sql/analysis/basket_pairs.sql`. Elle relie `raw_order_lines` a elle-meme sur le meme `order_number`, puis garde seulement les paires ou `product_id` du premier produit est inferieur au second pour eviter les doublons A-B / B-A.

Exemples de paires observees:

| Produit A | Produit B | Commandes ensemble |
|---|---|---:|
| Electronics Item 9 | Toys & Games Item 3 | 7 |
| Clothing Item 7 | Toys & Games Item 1 | 6 |
| Automotive Item 6 | Automotive Item 9 | 5 |
| Automotive Item 5 | Automotive Item 6 | 5 |
| Books & Media Item 3 | Pet Supplies Item 1 | 5 |

## Validation

- Le seed S04 contient 461 commandes et 1326 lignes de commande.
- Les 8 flags donnent 110 combinaisons reelles sur 256 possibles.
- `dim_order_profile` a une ligne par combinaison observee de flags, sans mesure ni montant.
- La requete panier compte les commandes distinctes par paire de produits et evite les auto-paires.
- `docs/profiles.md` documente les profils nommes et leurs frequences observees.

## Risques / limites

- Les paires de produits les plus frequentes ont peu d'occurrences; il faut les traiter comme des hypotheses de cross-sell.
- Les noms de profils sont des regroupements operationnels. Ils devraient etre valides avec le VP Operations avant de devenir des libelles officiels.
- La junk dimension couvre les combinaisons observees dans le seed. Si de nouveaux flags apparaissent, il faudra revoir la nomenclature.

## Prochaine recommandation

Ajouter `order_profile_key` au fait de commande ou de ligne de commande lors de la prochaine evolution du modele, puis suivre les profils par canal, magasin et periode. La priorite operationnelle est de monitorer les commandes avec manutention speciale et les commandes de ramassage en ligne, car elles changent directement la charge de travail en magasin.
