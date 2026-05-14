# Board Brief - S03

## Question du CEO

Quels changements dans nos dimensions doivent garder la verite historique, et lesquels peuvent etre ecrases?

## Reponse executive

NexaMart doit conserver l'historique lorsque le changement modifie l'interpretation d'une vente passee. Les changements de segment client, de province, de ville et de region magasin doivent donc etre traites en SCD Type 2, parce qu'un rapport historique doit montrer le client ou le magasin comme il etait au moment de la vente.

Les corrections qui ne changent pas la realite commerciale peuvent etre ecrasees en SCD Type 1. C'est le cas des corrections de nom, de casse, de typo ou de libelle descriptif. Dans ces cas, garder l'ancienne erreur n'aide pas le CEO a mieux comprendre l'historique.

La demonstration SQL montre l'impact concret. Si on utilise un Type 1, toutes les ventes historiques d'un client sont rattachees a son segment courant. Le rapport devient trompeur: il deplace artificiellement du revenu entre les segments. Avec un Type 2, les ventes restent associees au segment valide a la date de commande.

| Segment | Revenu Type 1 | Revenu Type 2 | Distorsion |
|---|---:|---:|---:|
| Bronze | 15987.58 | 26361.69 | -10374.11 |
| Inactive | 17046.86 | 12677.48 | 4369.38 |
| Silver | 24875.21 | 21825.54 | 3049.67 |
| Platinum | 23116.24 | 20300.57 | 2815.67 |
| New | 11702.58 | 9631.38 | 2071.20 |
| Gold | 2634.10 | 4565.91 | -1931.81 |

## Decisions de modelisation

- **SCD Type 1 :** utiliser pour corriger une erreur descriptive sans effet analytique, par exemple une correction de nom (`Pelletier` vers `PELLETIER`) ou une typo.
- **SCD Type 2 :** utiliser pour les attributs qui changent la lecture historique des ventes, par exemple `loyalty_segment`, `city`, `province`, `region` et `store_type`.
- **SCD Type 3 :** garder comme option pour un besoin de comparaison simple entre valeur courante et valeur precedente, mais ne pas l'utiliser comme mecanisme principal de verite historique.

Le modele Type 2 ajoute une cle subrogee par version, une cle naturelle stable, `valid_from`, `valid_to` et `is_current`. Les faits doivent joindre la dimension avec la date de vente comprise entre `valid_from` et `valid_to`.

## Preuve

La preuve SQL est dans `sql/scd/type1_vs_type2_demo.sql`.

Le script charge `customer_changes.csv`, construit un rapport Type 1 et un rapport Type 2 cote a cote, puis verifie que les ventes avant un changement conservent l'ancien segment. Exemple: pour `CUS-00091`, le client passe de `Bronze` a `Inactive` le 2025-03-26. En Type 2, les ventes avant cette date restent `Bronze`; en Type 1, elles seraient toutes rattachees a `Inactive`.

## Validation

- Les changements S03 disponibles dans `raw_customer_changes` couvrent 46 changements de ville, 34 changements de segment, 13 changements de province et 9 corrections de nom.
- Le rapport Type 1 vs Type 2 montre une distorsion de -10374.11 $ pour le segment `Bronze`, ce qui prouve que l'ecrasement de l'historique change la lecture executive.
- La requete de validation Type 2 confirme qu'un client courant n'a qu'une seule ligne `is_current = TRUE`.
- La jointure temporelle conserve toutes les ventes des clients modifies sans les reclasser selon une valeur future.

## Risques / limites

- Le Type 2 augmente le nombre de lignes dans les dimensions et demande une jointure temporelle plus stricte.
- Les attributs doivent etre classes par politique business avant l'implementation; sinon, une correction simple peut etre sur-modelee ou un changement important peut etre perdu.
- Les donnees S03 contiennent peu de changements magasins; la preuve principale est donc faite sur les changements clients.

## Prochaine recommandation

Adopter officiellement la politique SCD dans `docs/scd-policy.md` et l'appliquer aux dimensions partagees avant d'ajouter les prochains faits. La priorite est de proteger les analyses historiques par segment client et par geographie, car ce sont les axes les plus sensibles pour les rapports executifs.
