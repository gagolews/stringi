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
## Lorem ipsum dolor sit amet, id ipsum urna rutrum lorem turpis nam, nisl montes
## nascetur eu. Sit at feugiat ornare dolor fames. Laoreet eros, purus ac ac cursus
## dapibus eleifend. Auctor torquent convallis vehicula, sed. Dictum habitant
## mauris ligula ante efficitur sit. Rutrum, erat, amet odio lorem sem id velit sed
## feugiat curabitur ligula ad sed. Quam ac, nostra ut ut nascetur augue, laoreet
## nulla quis sed semper. Dolor elementum dignissim eu varius id euismod imperdiet,
## eu libero. Rutrum in lobortis habitant augue primis sapien. Commodo lectus amet
## non sed ante magna finibus? Rutrum vel urna eros ac egestas facilisis, senectus
## scelerisque iaculis egestas. Urna aenean montes sagittis eros ornare. Nam sem
## convallis tincidunt. Consectetur ut iaculis et enim enim ultricies praesent
## venenatis neque, maecenas. Sit in quis lacinia blandit magna, tempus dignissim.
## Ut nec at, quis donec, placerat cras.
## 
## Vitae primis nisi vitae ligula cras. Consectetur id, tempus parturient in!
## Pharetra feugiat vitae magna a nulla fusce dui mollis enim. Nunc himenaeos
## vivamus dictumst eu, tincidunt tempor ultricies sed ipsum egestas. Venenatis
## dictumst, neque mi sit mattis dictum dui mauris iaculis sociosqu. Magnis,
## dictum, mattis faucibus integer eu accumsan rhoncus purus lacus. Ad mauris eros
## sit? Ultricies ut, justo arcu elit tellus cubilia hendrerit. Vel eget iaculis
## magnis lacinia non id lorem, mi lacus. Cubilia magna iaculis aenean conubia,
## consequat donec magna dui vehicula tellus imperdiet nulla. Potenti montes
## phasellus erat penatibus montes fusce sed, parturient morbi. At est id nibh in
## ultricies in aliquam, a.
## 
## Nunc sed magna et mollis. Egestas ligula nullam sapien posuere erat fames
## vehicula commodo ex, nunc id. Netus pellentesque, bibendum fusce praesent
## egestas. Tempus eleifend velit quisque dictumst curabitur sed et, eros.
## Tincidunt sapien, nec in diam pharetra hac mauris lacus vel risus sed amet amet
## accumsan a in feugiat. Sed tempor eu et class erat ac. Volutpat porta. Et a,
## maecenas pellentesque sed volutpat erat.
## 
## Id placerat metus quam non lectus non tincidunt interdum. Tristique et et
## maecenas efficitur laoreet, suscipit proin nunc. Tortor ex sodales, curae
## laoreet congue eleifend porttitor nulla ipsum. Pulvinar neque in eu diam eget
## maecenas. At vestibulum ut vestibulum in sed vitae integer mi. Nunc pretium
## parturient eleifend nulla proin erat platea eu elementum. Leo amet magna libero
## pretium. In inceptos quis phasellus pellentesque maecenas faucibus mus fringilla
## nulla maximus ut nisl. Himenaeos id sed, quam massa convallis sem primis. Sed,
## nunc scelerisque ex mauris, faucibus tempor nec donec vestibulum ut tortor.
## Purus volutpat ac amet est urna vehicula ridiculus.
## 
## In purus inceptos sed senectus sit maecenas. Luctus nunc ornare integer, nulla a
## cum orci elementum accumsan ligula semper aenean vulputate sed, metus parturient
## bibendum! Sagittis sed lacinia vitae velit conubia libero. Nisl donec posuere
## sit phasellus. Pellentesque ipsum non morbi varius. Neque interdum et. Sit
## tincidunt efficitur maximus suspendisse dictumst lectus. Amet sed est ut nunc
## tempus vitae finibus sed ornare. Lorem enim odio donec lacus.
## 
## Dis pellentesque consequat mauris in faucibus mattis condimentum quis augue.
## Curabitur vel fusce nullam, magnis suscipit. Sed eu sed torquent tincidunt in.
## Arcu ut lacus tempor lorem. Nostra a egestas cubilia et cursus vitae elit donec
## interdum metus. Vitae amet magna. Vulputate non maecenas, tristique felis. Donec
## in, est vel mi elementum ligula eu.
## 
## Orci sed tortor in arcu habitasse feugiat. Ac erat, sed facilisis eu mauris
## lorem etiam. Maecenas, consequat ut nisl scelerisque vitae ut sed primis quis
## nulla potenti ac. Elementum in libero potenti tristique sociis. Et ac blandit,
## dui habitasse consectetur non, aliquet ut. Metus eu efficitur laoreet montes
## turpis tellus nunc parturient. Sit, tristique turpis ipsum in egestas. Feugiat
## placerat id ac condimentum vel. Interdum est vestibulum sed quam et quam
## platea sed, ullamcorper. Tincidunt efficitur amet. Vel senectus taciti, dapibus
## pharetra in leo ut ornare, nostra vitae.
## 
## Eu blandit taciti nunc turpis porttitor in. Urna at sed ac congue auctor
## habitasse augue. Maximus mus, nisl ligula erat, enim tellus consectetur in,
## bibendum. Sed eleifend ut maximus tellus. At gravida eget ad sit nibh sapien
## odio orci consequat accumsan. At sed nascetur potenti non pharetra iaculis
## tempor. Proin non sed convallis tincidunt efficitur bibendum eu. Arcu gravida.
## Sed feugiat metus semper tortor et ligula. Justo, litora, amet tristique maximus
## eu, habitant.
## 
## Amet mauris leo. Eu non, ipsum hac phasellus aliquam viverra adipiscing
## scelerisque velit neque tincidunt. Risus nisl id mattis sodales aliquam.
## Dignissim sed, ridiculus curabitur scelerisque vel sapien at fermentum. Pretium
## pharetra vitae ridiculus ut tortor lacinia consectetur dictumst sed a iaculis.
## Ultrices dictumst sed. Ac, tortor congue orci libero semper pharetra amet
## mollis.
## 
## Venenatis ac mattis efficitur lectus litora nec ante tellus bibendum, risus.
## Vulputate tempor lacinia neque, sed proin ad commodo non. Consequat faucibus
## auctor porta molestie sed eget in libero metus. Hac quisque quam pharetra nisl
## per quis et at eu. Sed vel ut lacus massa fringilla diam nulla. Tortor, erat
## justo conubia suscipit phasellus feugiat eros ligula. Sociosqu eu viverra, augue
## magna metus accumsan vestibulum.
cat(stri_rand_lipsum(10), sep='\n\n')
## Lorem ipsum dolor sit amet, neque habitasse aenean sociosqu justo ridiculus pulvinar mollis in neque. Dictumst curabitur, penatibus, porta. Mauris mi fames lorem justo tempus. Nibh metus odio volutpat sem primis nunc facilisi vestibulum. Vulputate donec odio conubia, facilisis, ut a. Sed ut arcu lorem tempus dolor congue, commodo pulvinar. Ridiculus suscipit cras nam aliquet senectus elit sit vitae eu sodales interdum. Ridiculus porta ex porttitor adipiscing. Ante, senectus suscipit enim accumsan feugiat ut pharetra purus, eleifend blandit.
## 
## Donec inceptos, ac ligula. Facilisi sed nisl sed malesuada nam lorem dui dolor risus ante. Penatibus eros erat sed maecenas efficitur nulla enim imperdiet. Sapien sodales placerat, vestibulum blandit a ad, morbi at varius non. Diam nascetur quam metus tempor in ex mauris sit eu. Sem ac sem sem tincidunt ligula nunc hendrerit non ac praesent. Non non, facilisi donec ex in risus nec. Morbi purus ultricies accumsan ante. Lobortis ullamcorper turpis varius sit sit.
## 
## Penatibus dolor sed nascetur ut in, quam duis. Eleifend eget viverra aptent purus tempus, varius dictum urna eu placerat pulvinar sed. Finibus tempor mus, vulputate hendrerit, sit ipsum cursus eget lacinia velit. Tristique iaculis dolor et ipsum in mollis ut ac luctus. Eu nam neque curabitur sed, tristique nascetur. Et sapien, consectetur. Magna laoreet sollicitudin metus pharetra in, viverra sollicitudin egestas, nisl nec non nibh. Lorem posuere commodo purus condimentum tempor.
## 
## Massa vulputate sociosqu dapibus, aenean interdum porttitor ut ligula! In inceptos posuere placerat vivamus maecenas purus ipsum, molestie risus proin. Mauris elit accumsan, torquent mauris magna, metus. Consequat donec accumsan ac, congue, nec phasellus? Tortor ullamcorper luctus mattis tincidunt nisl non neque tincidunt vitae conubia dapibus et tincidunt est? Vitae ut tellus quam consequat ut nullam feugiat at, sed tempus. Sociis maximus. Praesent, lobortis, in taciti scelerisque at sociosqu sed in congue. Ex sagittis erat.
## 
## Aptent venenatis pulvinar non natoque, lacinia. Cubilia sed adipiscing ante penatibus amet et ad in nec. Leo egestas, imperdiet et sed nullam. Tellus arcu lacinia nec blandit at aliquam nam. Lacus dolor. Auctor, suscipit nunc in sapien suscipit nec sociosqu. Ornare hendrerit hendrerit ridiculus eget mattis, blandit adipiscing ultrices vel. Sagittis, laoreet nec congue sed adipiscing. Euismod id gravida ac leo orci lacus ornare. Montes odio condimentum tortor lobortis nec sodales, vulputate pulvinar at. Sed sociosqu pellentesque sed phasellus pretium a ante et id. Nunc mauris ipsum orci turpis tempor class per sem sed ac. Mi accumsan vitae placerat luctus orci. Integer libero nam imperdiet eget, pretium lorem aliquet sit, ut. Lorem arcu consectetur et risus sociosqu, in in eu. Amet elit erat potenti eu felis amet ad suspendisse posuere vel pellentesque.
## 
## In, vivamus in, sed at, eu penatibus ut eu sed. Cursus fermentum eget in lobortis est proin diam aliquam habitant ut taciti. Risus est ex phasellus, iaculis dolor laoreet sed posuere. Sapien in tempus nibh nostra venenatis quam. Tortor tempus turpis integer et mattis sed iaculis ridiculus felis sed id amet. Euismod conubia ultrices senectus nulla porttitor ridiculus. Eleifend suspendisse luctus euismod nullam sapien leo sed lacus eleifend. Euismod, augue urna faucibus nascetur ac auctor in.
## 
## Facilisi, eu himenaeos nisi ac mauris auctor nec id, nullam quis malesuada blandit. Volutpat eget habitant tempus eu! Eros eu eleifend tincidunt et adipiscing. Sed, velit lacinia, faucibus mollis neque nulla. Fusce imperdiet purus turpis mattis a est vitae consequat cras vestibulum venenatis congue? Vitae nunc enim vivamus tortor aptent, himenaeos maximus. Vulputate vitae semper ut pellentesque vestibulum id habitasse. Quam nibh senectus sociosqu eget condimentum ac porttitor sed aenean amet. Hendrerit aliquam vitae ligula vestibulum litora elit montes.
## 
## Duis sed pulvinar mauris. Luctus pharetra eu vel inceptos sit. Enim tellus? Hendrerit dis pretium sit eu porttitor sit, pharetra nibh quam eu nulla mauris. Vitae, lacinia lorem sed himenaeos at. Ultricies duis non sapien donec, potenti scelerisque sapien. Enim parturient senectus non? Ut orci mi hendrerit mauris, non, velit quis. Rhoncus mattis erat velit. Sem, sed pulvinar sociosqu urna, eget nam nisl posuere urna. Nec suscipit, enim enim elementum.
## 
## Sodales, habitasse vitae vel, inceptos. Vulputate sed, sociis sapien, scelerisque curabitur justo maecenas. Vitae scelerisque pulvinar etiam libero et, aliquet velit efficitur turpis fusce euismod eu eu. Orci vulputate ornare habitant lobortis magna at accumsan. Sed sed dolor, lacinia nec sit at et placerat class lacinia aliquam ligula sed. Tempus aliquet blandit faucibus elit curabitur lacinia ligula pellentesque vestibulum mattis. Dapibus ultricies netus. Enim nisi in feugiat nec convallis tempus tincidunt, lectus. Est porttitor arcu et sed quisque nisl nec ut. Porttitor vel mauris, felis pellentesque nibh mollis nulla fames maximus mi. Odio maecenas, duis, interdum mattis mattis ut sed nunc placerat vel faucibus in et, gravida.
## 
## Cum quam sapien erat nibh bibendum est maecenas. Eros sit gravida nec eget imperdiet non at. Risus ac porta nec morbi lectus in efficitur maximus imperdiet sit tellus. Nulla eu accumsan morbi dictum, placerat euismod, purus nunc. In in condimentum in fermentum. Ac sed ac sagittis metus egestas volutpat sollicitudin ac eget dapibus purus. Fermentum, ac augue sapien amet ut netus, imperdiet risus venenatis ex fermentum. At et elementum eu gravida in tempor. Suscipit purus, class tempus viverra sit praesent volutpat vulputate ullamcorper mattis potenti. Ullamcorper mauris justo phasellus a et. Amet fusce nunc donec mauris id. Augue neque ac erat tempor volutpat ullamcorper. Pharetra ex quis, in, nam mauris neque aenean tincidunt.
```
