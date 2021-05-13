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
## Lorem ipsum dolor sit amet, laoreet nam taciti vitae. Et massa ac efficitur
## erat platea, et posuere nec hac, posuere. Tincidunt felis non mollis eu velit.
## Ligula porta, non donec urna, ut rhoncus eros, lobortis a. Massa lectus et
## ultrices ridiculus velit conubia. Ac non eu. Eu euismod lobortis luctus a eros,
## proin odio donec suscipit. Blandit eros id interdum pretium libero in. Non, nisi
## himenaeos dapibus convallis risus.
## 
## Praesent vel in dictumst lorem potenti, iaculis habitasse cursus non sodales.
## Ante eu sed non viverra lobortis, lacus, sed. Lacinia, efficitur erat fermentum
## sed vestibulum velit fringilla. Senectus ex risus, urna habitant praesent.
## Est finibus auctor. Accumsan arcu etiam ridiculus. Tempor sed elementum quam
## suspendisse curae et id magna platea ac. Vitae amet nisl egestas pretium id at
## sollicitudin tristique risus. Posuere et, eu dictumst magna elementum viverra.
## Congue porttitor aenean id nunc sed et posuere. Ante venenatis fermentum tempus
## sit consectetur, fusce. At, laoreet aliquam dignissim maecenas accumsan in, sem.
## Nec rhoncus cursus, dapibus in nisi tempus.
## 
## Suspendisse ut hendrerit morbi tellus pulvinar, venenatis in fermentum. At
## sit consequat vulputate odio vel tortor conubia. Sit ad erat sed urna ac hac
## sit odio, tempor. Nunc nec consequat vitae tempor, nunc a porttitor venenatis?
## Aliquam lacinia augue finibus vitae curabitur efficitur nunc. In at metus
## viverra curabitur tortor turpis, gravida ullamcorper in duis. Eu ipsum fusce sed
## et lorem erat. Maximus hendrerit suspendisse donec eu donec neque. Risus, ut dis
## commodo ac. Neque eu quisque dapibus aliquam, ut sagittis fringilla, ante. Nunc
## magna mauris augue volutpat sapien vel eros magna ut. Diam, cursus lectus, nunc
## lacus dolor feugiat faucibus. Dapibus vitae, duis sit. Aenean commodo vivamus
## ut nec consequat in malesuada nostra ac. Ut, scelerisque sed velit blandit. Nisl
## fermentum aliquam, nisl magna et, mus class sed, augue sed ac.
## 
## Non scelerisque et vehicula magna, eros tellus. Ultricies tincidunt nunc commodo
## diam platea vel orci lacinia ridiculus amet natoque morbi aptent et. Egestas
## montes tincidunt tincidunt in mattis arcu porta? Vel amet, velit quis. Id in cum
## ut leo tempus vel. Magna sed ligula dolor eros volutpat sed et eros himenaeos
## tortor aptent. Risus hendrerit arcu mollis at, eu. Odio a lectus accumsan donec
## in lorem fringilla nibh conubia eu. Ultrices quisque consectetur facilisis
## tincidunt proin magna nulla sed amet. In a habitasse tortor nulla dolor morbi
## bibendum praesent sed. Suscipit eros dolor libero, arcu aptent et purus sapien
## duis, pretium. Volutpat auctor felis risus, vestibulum. Conubia erat et vehicula
## suspendisse, pellentesque dolor sed neque est fringilla eros, suspendisse. Et
## massa sem fames fusce nisi duis, sit non amet. Amet amet morbi sit. Ullamcorper,
## turpis mauris ultrices curae, mauris curae. Ipsum tincidunt consectetur tortor
## velit leo habitant, inceptos scelerisque.
## 
## Sit et id erat, rutrum quis leo eu lobortis urna. Ut a ultrices arcu, fusce
## montes, tellus et condimentum nunc velit. Porta amet aliquet eu nullam
## dictum etiam sociis. Libero erat nulla at mauris primis, justo. Augue litora,
## taciti luctus eleifend felis eget ac risus, et molestie. Interdum magna nulla
## curae diam blandit. Ut augue tortor sapien facilisis primis eget varius quis
## hendrerit. Ac at faucibus viverra nam tortor ornare.
## 
## Lacus eros per turpis turpis eu rutrum. Duis sit, natoque bibendum feugiat,
## senectus, sed nostra primis sed. Risus, lorem fringilla nulla fermentum. Varius
## ut sed auctor, phasellus vehicula eget facilisis nibh vel et? Pellentesque
## pellentesque sem neque risus ut, maximus faucibus. Interdum maximus himenaeos
## gravida, etiam congue metus augue posuere. Commodo ipsum molestie proin odio
## hendrerit. Cum enim ultricies. In eros tristique, phasellus nunc. Eu, netus
## in in. Maximus at tincidunt. Nulla lectus sit congue ut sed, metus rutrum.
## Nulla volutpat ut senectus diam mauris malesuada interdum magna proin. A urna
## arcu, a ligula faucibus ut elementum. Et vitae, suspendisse nullam dapibus
## et sollicitudin velit. Arcu diam cras inceptos conubia et diam, lacus in,
## ullamcorper felis vulputate elit finibus. Ipsum habitant volutpat nulla
## venenatis odio.
## 
## Sagittis, fusce volutpat primis purus aenean ullamcorper natoque condimentum.
## Aenean vestibulum donec ut et mi maecenas, mus eget, diam nec proin. Fusce, orci
## dui et pellentesque sagittis ante consectetur elementum bibendum. Aptent quisque
## suspendisse blandit luctus malesuada feugiat facilisis dignissim, sed elementum
## vestibulum, taciti. Ullamcorper efficitur vel adipiscing, et in, a inceptos
## a, maximus. A maecenas gravida enim facilisi lorem venenatis euismod velit
## pharetra tincidunt, purus mollis tortor. Adipiscing amet dolor tortor, pretium
## egestas enim velit eros. Integer ultricies, ipsum faucibus sit, at cursus duis
## id. A bibendum in accumsan in consectetur ipsum tincidunt odio potenti ligula.
## Molestie varius nunc maximus sapien. Lectus ipsum ullamcorper non fusce nibh
## urna metus. Auctor quam, dis nibh, sociis elementum euismod.
## 
## Lacus sed mauris ligula volutpat vestibulum porta. Turpis, accumsan est
## tincidunt ultrices nec magnis lectus consequat nec. Dignissim, cursus dolor
## at scelerisque conubia elementum. Vestibulum arcu diam? Euismod enim diam amet
## leo, finibus felis. Mi vestibulum, congue tincidunt fermentum maecenas at nunc
## consequat felis augue, odio. Himenaeos etiam, maecenas vivamus in ornare et.
## Magnis in integer. Donec sollicitudin nec quisque tellus. Blandit nec sit nulla
## bibendum interdum et ridiculus.
## 
## Mollis quis eu aliquam consectetur ac elit tincidunt, purus, vitae! Potenti
## massa risus vitae. Mus mollis, eget purus. Tortor netus urna montes blandit in
## natoque. Velit tempus suspendisse dis in sed tempor aenean. Quis quis turpis,
## ligula ac vel pulvinar in dictumst nibh interdum. Nec commodo ullamcorper
## ipsum ligula et ad ut. In consectetur semper taciti ipsum lacinia. Sit magnis
## sed fames pulvinar. Penatibus dignissim nunc consequat id est sed. Risus nunc
## pretium at ut ac quis, suscipit sit convallis. Vestibulum amet pellentesque amet
## at vulputate, eros vel. Tellus sed mauris euismod cras erat netus amet gravida
## et. Quisque magnis magna, suspendisse nunc eget risus.
## 
## Sed porttitor phasellus sed. Ac eleifend sem natoque ut est per in. Eu aliquam
## at sit dignissim sodales ligula sed litora suspendisse vitae. Class rhoncus
## in dictum, nibh. Vulputate mauris maecenas taciti hac venenatis tincidunt,
## enim mauris vehicula. Nec faucibus lobortis consequat metus facilisis lectus
## vulputate. Eget, lobortis id, dui, blandit non elementum fusce. Auctor nam
## in vitae hendrerit velit ut eu suscipit. Dolor et sed leo, consectetur eget
## pulvinar vehicula, metus, ligula. Donec pulvinar quis phasellus torquent massa
## auctor habitasse eros varius pellentesque. In magna maximus eget mi accumsan hac
## sed volutpat semper quam potenti, rhoncus ullamcorper eu.
cat(stri_rand_lipsum(10), sep='\n\n')
## Lorem ipsum dolor sit amet, bibendum dictum, cursus fringilla morbi luctus venenatis vel. Amet, diam in varius himenaeos sapien eu, a tristique. Lorem risus consequat scelerisque vitae ipsum. Quis felis amet egestas sem felis. Tortor nunc ut et magna diam nunc dis dolor tortor accumsan potenti. Litora leo, aliquet varius tristique metus tellus. Vel ligula felis in sodales leo purus egestas potenti, eleifend.
## 
## Eros id in egestas viverra non iaculis. Sapien nulla sit nec turpis. Sed ligula dui integer sed leo vitae. Hac cum tellus finibus tristique nec, vitae dis sit. Eu augue imperdiet tortor sed at ornare tincidunt! Montes lectus maximus maecenas commodo libero vulputate auctor ante. Rutrum vitae nunc eget, at tellus scelerisque neque egestas natoque in ante. Neque in nisl eget eu. Tincidunt aptent vitae lectus scelerisque sed. Finibus libero vitae vel ullamcorper maximus a, tristique quam adipiscing. Ornare pretium eget nisi duis eget nullam amet nunc, sagittis.
## 
## Venenatis ac suspendisse nunc leo, nullam interdum nunc sed donec ac. Nunc nisi feugiat quam id lacus. Pellentesque lacinia praesent metus ullamcorper magna, sed justo imperdiet aliquet cubilia. Nec, luctus, lectus. Sed leo platea scelerisque gravida. Vel nibh ligula, eu varius convallis mauris. Accumsan eros, et mi aliquet. Ultrices pharetra ultricies tincidunt ut erat, faucibus in. Vitae lacus morbi ullamcorper laoreet suscipit odio vivamus dictum ullamcorper.
## 
## Habitasse, ipsum sit rhoncus in natoque. Ac euismod et, faucibus maximus arcu nisl facilisi. Dapibus auctor eget dis, est vestibulum torquent auctor, pulvinar pharetra. Neque nec! Luctus elementum, nec vestibulum leo efficitur maecenas non vestibulum vestibulum. Sapien dis et sed ac ipsum. Cubilia felis felis sapien ut nulla. Platea ut condimentum fusce venenatis nam ut at vitae hac nibh in faucibus ultricies donec ante. Amet et ipsum facilisis eros fermentum faucibus elit fermentum morbi pharetra. Dui purus inceptos velit semper laoreet vehicula pulvinar. Lectus a curabitur cubilia orci non ac ac, turpis amet, porttitor.
## 
## Blandit luctus risus non morbi odio sed. Sed duis rhoncus velit, tortor ornare ac luctus amet. Lacus nec ac aptent, vitae maximus enim penatibus aptent augue. Scelerisque in justo. Porttitor vel metus fames ut vel, eros eget tortor nisi non vivamus. Tempus nam et a metus orci scelerisque urna amet. Ligula suspendisse risus varius, posuere nisl ut, sem aliquam cras. Id quis, ac ac nulla sapien amet et amet cursus cursus cubilia laoreet dui.
## 
## Finibus vitae, suspendisse molestie sociis risus. Orci ut ut massa ac sapien at cras. Risus leo elit morbi. Fusce aptent sed varius tellus, lacus, non ipsum sit et commodo. Inceptos at leo cursus in vivamus magna aliquam nisl netus, himenaeos aliquam. Et in sed amet, quam platea. Sagittis augue ipsum etiam vulputate mi.
## 
## Imperdiet congue augue interdum mauris, sed neque phasellus arcu ipsum pellentesque. Iaculis accumsan cubilia ornare nunc tempus felis. Rutrum rutrum pellentesque efficitur eu convallis amet dictum eros. Odio class nisi non scelerisque lacus. Primis risus himenaeos faucibus amet torquent quis. Porta primis ultricies amet felis, non. Id ut sapien habitant in erat, a in purus tellus. Justo ac non in est cursus, at, diam ut.
## 
## Dapibus mauris, tortor ut metus ut augue sed euismod. Interdum gravida ultrices convallis, eu maecenas, in nisl nunc tempor sed. Nec ipsum felis parturient sed. Iaculis risus nec dui erat. Purus imperdiet et phasellus at, vestibulum tellus lacus class nunc eu. Dui nulla volutpat erat sem. Eleifend lorem. Fames cras placerat quam sed vel in tortor fermentum. Sit a nec ornare molestie, ipsum non? Enim, ut turpis cursus pulvinar. Ex aptent, massa euismod sit risus adipiscing magnis pellentesque. Et tellus tincidunt montes, quis scelerisque. A quam ante, vel donec. Eu pulvinar enim ac ut nascetur taciti vel arcu a.
## 
## Vivamus vitae vel ut pulvinar eu. Et fames odio leo maecenas sit orci eget. Sit quisque eget dolor diam magna senectus a faucibus sed at per. Urna aliquet ante fames morbi pellentesque. Ad taciti praesent in cubilia, consequat sem eros, ut nisl. Auctor lacinia in finibus id metus. Eget cras ac sed lacus praesent lacus fringilla. Sem justo luctus. In nibh est ut, aliquam, quis non ullamcorper vel aliquam sit diam.
## 
## Aliquet sed quis hendrerit ex. Ex in sem turpis nulla nibh ex rhoncus. A, sit hendrerit in sem in non nunc aenean risus ad. Volutpat nibh fermentum viverra nisl donec erat. Lectus orci, posuere, ornare justo facilisis sed blandit sed augue. Ac quisque interdum a proin molestie felis sem sed ante. Sociis ad id tincidunt praesent. Hac turpis dictumst, leo tristique amet non. Ac congue dolor pellentesque tempus cursus purus at. Tellus vel, tempor purus id in. Nam leo risus in senectus. Porttitor adipiscing, malesuada vitae sed laoreet quis ac nec. Consectetur amet diam aliquet ultrices leo potenti, erat, neque sapien. Tempus ad pharetra sed lacinia vivamus mi per sem.
```
