# stri\_rand\_lipsum: A Lorem Ipsum Generator

## Description

Generates (pseudo)random *lorem ipsum* text consisting of a given number of text paragraphs.

## Usage

```r
stri_rand_lipsum(n_paragraphs, start_lipsum = TRUE, nparagraphs = n_paragraphs)
```

## Arguments

|                |                                                                                          |
|----------------|------------------------------------------------------------------------------------------|
| `n_paragraphs` | single integer, number of paragraphs to generate                                         |
| `start_lipsum` | single logical value; should the resulting text start with *Lorem ipsum dolor sit amet*? |
| `nparagraphs`  | deprecated alias of `n_paragraphs`                                                       |

## Details

*Lorem ipsum* is a dummy text often used as a source of data for string processing and displaying/lay-outing exercises.

The current implementation is very simple: words are selected randomly from a Zipf distribution (based on a set of ca. 190 predefined Latin words). The number of words per sentence and sentences per paragraph follows a discretized, truncated normal distribution. No Markov chain modeling, just i.i.d. word selection.

## Value

Returns a character vector of length `n_paragraphs`.

## See Also

Other random: [`stri_rand_shuffle()`,](stri_rand_shuffle.md) `stri_rand_strings()`

## Examples




```r
cat(sapply(
   stri_wrap(stri_rand_lipsum(10), 80, simplify=FALSE),
   stri_flatten, collapse='\n'), sep='\n\n')
## Lorem ipsum dolor sit amet, diam lorem, ut porttitor orci metus, vitae massa
## finibus. Porttitor pellentesque nisl sollicitudin sollicitudin magna imperdiet
## est nec laoreet luctus. Primis at netus efficitur, est mattis pellentesque
## est maximus at eget amet. Lobortis nulla venenatis sem metus vel non ante sed
## pharetra blandit nibh feugiat lectus. Metus diam dui nisl, laoreet potenti
## sodales cum. Nec, eget nibh mattis curae primis, nibh velit aenean faucibus
## aliquet orci aliquam nibh. Suscipit malesuada primis felis convallis sit
## convallis proin tincidunt dui nec malesuada. Venenatis tempus velit erat
## condimentum, tincidunt, lobortis, interdum enim vestibulum. Ut velit nunc
## pellentesque netus suspendisse at lobortis magna a feugiat, tincidunt pharetra
## eleifend penatibus. Placerat vestibulum sed iaculis nisl at ac viverra quis ac.
## Lectus vel enim finibus luctus ultrices.
## 
## Enim conubia eleifend, facilisi in malesuada nisi, facilisi. Neque ac congue
## sit pharetra sed, tincidunt lacinia. Fusce pulvinar amet id maecenas pulvinar
## non sem laoreet. Ac phasellus adipiscing vel, in metus, sed odio ipsum. Mauris
## ac, nulla dictumst molestie egestas ornare, et sed aliquam eget. Tellus ac leo
## aliquam torquent aenean mi mus accumsan pharetra in mauris. Tellus, maximus
## sem vestibulum maecenas leo et id at euismod ligula. Sit sit tristique at
## pellentesque rutrum suspendisse ullamcorper nunc nec. Semper magnis non sed
## tortor lectus non. Eleifend, in luctus vel quam consequat cursus, sed mollis.
## Sit, sed lacinia, in molestie varius non quam volutpat sapien. Turpis molestie
## sociis porttitor felis. Id commodo, conubia sem lorem pulvinar a conubia.
## 
## Tellus eu, per lobortis lacus et dui. Tincidunt, in nibh. Rhoncus, parturient
## risus fames a placerat varius ipsum egestas malesuada. Aliquet, nisi quis netus
## habitasse. Nibh est varius dictumst vulputate ornare risus a leo, dictumst at.
## Risus luctus nec interdum, non purus. Non vivamus.
## 
## Neque parturient sed enim tempor mauris eros faucibus taciti torquent. Fringilla
## non nullam quam, parturient morbi diam primis ipsum sed ligula tincidunt enim
## aptent. Vitae nulla, metus himenaeos volutpat vestibulum primis sed, vel, non.
## Ullamcorper leo metus commodo a at aliquam. Sed quam enim finibus parturient
## congue arcu arcu. Inceptos lacus pharetra elementum hac sed, primis! Justo,
## cubilia, condimentum. Dapibus amet lorem et, tincidunt. Quisque ligula sit. In,
## vitae mauris tempor.
## 
## Elit in. Felis at, volutpat sed lobortis vitae. Amet quis orci sed et cras
## pharetra. Primis sit libero eu. Justo amet sit in hac tempor lorem duis, nostra
## dui accumsan. Enim leo leo sed commodo accumsan commodo aptent. Tristique cras
## mollis sed efficitur commodo a nisi amet diam sed. Libero, conubia, ut porta!
## Ut neque ridiculus purus id pellentesque non sodales in ac. Nec sapien sit sed
## et id inceptos. Sit vestibulum nunc quisque habitasse at vestibulum. Sociosqu
## luctus nec arcu, ultrices est amet ut egestas ligula. Tortor ipsum aenean
## convallis amet et quam. Ipsum enim, porta tincidunt, vitae ut sed amet est
## egestas. Vel, diam leo.
## 
## Eget vel et tincidunt quam vehicula est et ex ante blandit. Ullamcorper magna
## ac phasellus ut curabitur arcu diam. Mi, ad enim sapien facilisi erat ultricies
## vehicula finibus nullam sem. Vel ultricies lacus congue id augue condimentum
## pharetra. Congue ipsum duis ut quisque tempor. Urna imperdiet ut ad, ligula,
## risus, mauris diam eros tincidunt, nibh, primis quis eu donec ligula. Et eros
## neque et augue lacus et consequat vehicula. Scelerisque tellus eget justo.
## 
## Mi ultrices ac nunc pretium in felis eu integer, consectetur, porta consequat
## pellentesque dignissim nisi. Turpis convallis porta id, cursus inceptos ipsum in
## ac, praesent. Efficitur sagittis in augue ridiculus vehicula, montes. Lobortis
## iaculis, lorem integer phasellus facilisis sit ut elementum. Est penatibus
## adipiscing, nullam blandit. Montes eleifend porttitor donec habitasse accumsan
## sodales in fames? Eu, suscipit hendrerit vel, risus sodales, non auctor in,
## consequat. Sed vitae finibus. Sociosqu sed. Rhoncus mattis torquent sed amet
## in in laoreet eu libero sed fermentum magna eu curae. A porttitor in pharetra
## sociosqu. Vehicula libero, elementum in, magna per. Ut et ligula eget neque
## dictumst sed taciti.
## 
## Malesuada platea lacus nec ligula vehicula aliquet vitae nec mauris blandit
## phasellus blandit. Eleifend ligula a nullam porttitor dignissim felis. Fusce
## praesent purus rhoncus sed vel class. Urna malesuada turpis ac hac in mollis
## amet habitant scelerisque. Mus pharetra a, ultrices sed. Lorem fames hendrerit
## cras orci congue, non sed tristique nulla iaculis. Sit turpis ante torquent
## eget. Magnis sit lacinia vitae molestie sollicitudin lacinia ex mattis nunc.
## Ridiculus vulputate, augue elementum imperdiet per sociis. Ultrices vestibulum,
## duis placerat metus sapien. Habitasse dignissim cursus suscipit in consectetur
## rutrum sit pulvinar.
## 
## Nec enim maximus massa taciti netus ut finibus volutpat himenaeos himenaeos. Et
## tempor hendrerit sagittis sit eu molestie consequat. Eu enim sapien, in pharetra
## commodo mus. Nostra, commodo fermentum torquent massa commodo neque habitasse,
## in. Torquent, curabitur, ac et in consectetur, purus rutrum. Vulputate proin
## mi nulla, aliquam donec in sed. Neque eget et aliquam eu bibendum nisl vitae
## platea facilisis, sed iaculis. Dictumst pretium vivamus dictum. Mauris phasellus
## lorem elementum cum amet. Erat augue ultricies semper justo lacinia vitae. Augue
## sollicitudin phasellus et ac purus ipsum nulla lorem.
## 
## Blandit, sociosqu magnis turpis felis eu consequat proin leo enim. Et, vivamus
## erat torquent. In vivamus amet ex sed tincidunt nibh lectus at. Mauris ac,
## venenatis nibh imperdiet pharetra ligula ornare pretium ac, dapibus. Pulvinar
## ultricies a nisi euismod ut et. Torquent lorem ac porta sed quis sed vulputate
## mauris. Tempor metus lobortis mi lacus orci vestibulum nibh, facilisis. Vel
## fusce habitant ac lobortis enim, nulla dapibus ullamcorper, rutrum.
cat(stri_rand_lipsum(10), sep='\n\n')
## Lorem ipsum dolor sit amet, et purus est vulputate a id. Nullam in quis nunc aliquam. Feugiat nascetur, malesuada dictum dapibus tempor non commodo nunc et, duis dignissim sagittis. At sociosqu imperdiet. Et blandit sapien erat, mattis semper ut per tincidunt, ex. Est aenean aptent mi ligula, nunc sed tempor. Mauris, erat nulla et lacus magnis eros vel pharetra nibh habitant. Scelerisque dis porta sapien ultricies facilisis, velit et libero. Condimentum tincidunt sed sed nunc sed blandit cursus, nulla. Dolor facilisis, phasellus massa velit nulla cursus tristique? In bibendum litora in eget semper mauris vel, nunc metus turpis. In mi.
## 
## Enim orci eu id mauris quam, ac nam. Natoque, ut metus convallis fermentum class fermentum in. Aliquam in tortor in, amet finibus tellus a. Magnis nullam hac sit, vel habitasse. Phasellus porttitor velit tempor odio ut quis amet mus faucibus senectus cursus. Sed laoreet, donec elementum eu vulputate libero. Turpis ornare egestas augue sapien aliquam sed nec et enim. Ipsum euismod neque natoque in ut, maecenas. Iaculis mauris ullamcorper? Massa magna vel feugiat ac phasellus egestas sed nullam. Massa sagittis placerat vestibulum nec et donec, sem tempus condimentum ante aliquet. Eu inceptos ut ornare vestibulum consequat quis at, elementum non at nunc rhoncus sagittis magna taciti cum. At eros a adipiscing ac ac sed ac. Rhoncus ex velit, eu, aliquet. Et amet dictumst eu aliquam enim cursus platea, auctor facilisis.
## 
## Quis neque potenti eu nam primis tempor. Porttitor metus orci ac nunc mollis finibus phasellus ligula augue. Finibus neque porttitor, aliquam blandit libero, tempus. Amet vel eros in ut donec! Turpis ligula lacus sed posuere venenatis. Habitasse, praesent, libero praesent eget tincidunt vitae scelerisque nisi pharetra quam. Ullamcorper ullamcorper quisque amet. Enim odio adipiscing ut lorem venenatis nunc. Ac cubilia et, cubilia in leo? Natoque, sed, montes. Et magna, odio fringilla, scelerisque cras eget a.
## 
## Facilisis mauris ornare, in tortor sed, in pharetra sapien. Libero amet, sodales, mauris in congue, felis, consectetur praesent, malesuada sit. Suspendisse id enim efficitur in etiam lorem aliquam. Sed ultrices quis ac lacus. Magnis pretium nunc. Nam commodo hac arcu imperdiet orci, ut. Efficitur ut volutpat consectetur feugiat et nunc conubia elementum fermentum id netus. Tempus sociosqu duis turpis, ornare torquent.
## 
## Non sollicitudin vestibulum ac sociosqu, lectus proin eu ac. Vitae donec fames, ipsum purus. Volutpat conubia, lectus nec habitant. Torquent ut, luctus class ipsum donec. Nunc ligula ut, in nibh mollis himenaeos porta et, vulputate. Fermentum velit et mus leo. Eu eu potenti eros. Dui tristique donec egestas lacus. Eget ut magna nullam vivamus ac et ut eget, nam! Massa class sed et vel nisi aenean. In, sed nec habitant tellus sit pellentesque. Justo justo tincidunt a. Sit curae id blandit a non nec. Dui donec cum nulla at semper etiam. Eu nisl donec, nibh in varius magna aenean. Ipsum vitae, justo condimentum laoreet.
## 
## Libero eros neque aliquam, dignissim in mi in ultrices leo condimentum id. Sed ante quis vestibulum non senectus nascetur. Mi eu pretium, in, nisi eget. Bibendum iaculis nisl nostra nulla nibh pretium sit facilisi! At dolor ad consequat tincidunt ante ut maecenas fringilla, per inceptos pretium velit libero posuere? Ante magna in sapien viverra. Massa, laoreet pretium, integer rhoncus rutrum. Libero volutpat mi in congue quis. Mauris iaculis, magna integer ultrices consequat. Non mauris urna eget enim. Facilisis tellus sollicitudin aliquam urna gravida.
## 
## Ac bibendum commodo vitae id eros vulputate! Convallis ac natoque taciti nunc auctor imperdiet netus hac. Nibh gravida in. Vivamus in, imperdiet diam nunc porttitor turpis nibh. In lectus elit varius, vestibulum eget nisi mi elit enim eu senectus. Praesent neque velit, class, sed nam orci. Tortor felis amet etiam nullam at sagittis pharetra et pharetra. Egestas nunc ridiculus in mi in blandit neque donec montes. Suspendisse scelerisque eget pellentesque malesuada blandit amet class, donec quam. Nibh nibh eu turpis vestibulum nibh cras. Quis posuere pellentesque massa felis aliquam cubilia tristique consequat euismod montes sapien.
## 
## Himenaeos sociosqu diam orci eu venenatis convallis dis neque sem id. Nisi porta, mollis eu lorem. Quisque quam vivamus parturient augue, massa. Ac litora justo semper luctus in aptent eros aliquet. Commodo erat mi at pellentesque, lectus tempus eleifend posuere non porttitor sociosqu. Himenaeos urna mauris, eu dapibus. Convallis eros accumsan magna ullamcorper lorem euismod, nunc turpis. Sed porta felis ac sed eu primis pellentesque orci nulla sem. Purus vivamus, facilisis donec lorem. Libero turpis et auctor nullam in dolor sed nisl tortor. Nulla ligula dolor quam quam efficitur sed. Eros, a vulputate nisl diam suspendisse urna commodo sapien dignissim. Curae vel, egestas porttitor metus quis sociosqu nisi fringilla. Est ac eget efficitur nibh, rhoncus blandit.
## 
## Amet et non ligula egestas sed in bibendum habitant ipsum nulla gravida rhoncus nulla ligula. Tellus sociis velit morbi porttitor vitae ipsum. Ligula justo amet nec quam enim mauris, ullamcorper velit. Aenean vel auctor scelerisque mi nec, lacinia condimentum. Eu in malesuada sed duis, et diam duis ac vel ipsum varius. Et consequat risus et leo. Bibendum pharetra et nunc lectus, venenatis et a dui. Est ut vitae, non bibendum tempus habitant, eget eros lacinia. Posuere velit rhoncus gravida in at a ornare eget, purus vestibulum. Enim mollis ante tellus neque metus faucibus semper semper, rhoncus faucibus. Sapien amet fermentum maximus vitae et in consequat. Imperdiet id vitae magna sed lacus finibus et scelerisque dignissim aptent mauris in rhoncus inceptos. Arcu, fringilla justo eu, eros lacinia hendrerit cras lacinia ipsum tristique.
## 
## Suspendisse volutpat nisi interdum ac in, per, dictum ut gravida. Facilisis lobortis sit, sit curabitur. Mauris ut. Tortor montes lorem fames ac. Lacus, felis praesent ante et duis penatibus dictumst facilisis. Suspendisse at dictum vitae nam, nisi. Etiam sed at augue. Risus quisque mollis aliquam malesuada ipsum eu. Turpis leo in pellentesque enim commodo ac. Ut quam, justo erat. Elit lacinia nulla ut in! Penatibus, pretium interdum, eu ultricies erat sed malesuada lacinia, sapien.
```
