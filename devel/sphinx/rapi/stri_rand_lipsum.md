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
## Lorem ipsum dolor sit amet, tincidunt fermentum erat, penatibus parturient
## porta quis mauris volutpat nunc, urna aliquet! Nec, eros diam molestie sociosqu
## etiam phasellus dis arcu. Varius donec ligula sed tempor semper sed ut, nec.
## Pulvinar sodales ridiculus, quam ut tristique facilisis eu. Erat mauris in erat
## in mauris. In lacinia vestibulum et ut dignissim quisque cursus facilisi et et
## ultricies pretium. Sed, mollis porta elementum dolor nec sed lacus, augue. Velit
## quam. Iaculis in egestas, curabitur proin vitae ligula vivamus morbi vestibulum.
## 
## Non, imperdiet et sed platea sed, donec. Himenaeos luctus id feugiat proin.
## Tincidunt augue efficitur maecenas malesuada adipiscing leo. Ac, tortor mauris
## sem sapien. Cubilia nisl a porttitor eu parturient. Arcu nec porttitor curae
## lacinia magna! Aliquam proin non. Sit, fames pellentesque nibh pretium vel
## sed eros dolor justo, turpis. Molestie, lacus libero natoque condimentum at
## tincidunt penatibus. Massa finibus sapien pulvinar pharetra.
## 
## Himenaeos sit nulla et at sociis vestibulum fermentum aliquet et vitae nunc.
## Et ac dictumst curae eu aptent varius velit est. Imperdiet ut donec dapibus
## aliquam convallis at. Neque nulla sit dis aliquam risus sed faucibus malesuada
## blandit aliquam. Per auctor, pellentesque nisl, nec bibendum magnis felis ipsum
## hac a. Nisi ac sem et nec nulla massa scelerisque nec molestie. Aenean finibus
## non egestas, phasellus tortor ligula vitae in a. Sollicitudin mattis vulputate
## nec eu sociis mi quam nec massa. Nunc a commodo nulla mattis et euismod enim.
## Quisque nullam purus auctor sed mauris imperdiet. At, viverra pellentesque
## commodo torquent ac eu. Accumsan enim proin penatibus ut lorem. Elit, ut
## habitasse eget in eleifend aliquet. Ligula nibh id ut. Nibh amet libero tempor
## primis turpis quam, ut praesent, velit sodales, amet lacus pulvinar in. Viverra
## pellentesque nibh tincidunt sed metus accumsan aptent, sed dictumst pellentesque
## netus.
## 
## Eleifend, est cursus in feugiat. Ligula venenatis libero nunc ultricies
## et convallis. Nulla quisque natoque ut morbi curabitur nisl. Ipsum at odio
## sollicitudin urna tellus consequat urna dui sed. In taciti pulvinar vel,
## tristique ullamcorper velit mattis. Tempus hendrerit, lectus aptent tellus
## justo dis aenean leo! Sed odio sem dignissim, viverra morbi nibh fringilla.
## Non nulla consequat, adipiscing massa tortor in penatibus. Ac et dignissim, dui
## donec fames sed, vitae eleifend mauris aliquam, amet. Ultricies non rutrum ipsum
## sapien elementum et. Sed habitasse massa, pretium per quisque adipiscing in
## aptent molestie condimentum ante in.
## 
## Nibh nunc integer. Nibh pellentesque facilisis sagittis lorem porta et mauris
## magnis dictum. Cursus magna volutpat ultricies, sollicitudin nisl et auctor.
## Vulputate ut vestibulum nisi quisque inceptos risus, odio, sodales? Vivamus
## class in tempor ligula sagittis gravida ac, iaculis. A ut habitant nec tristique
## amet. Sed metus ut nulla magna tellus gravida. Vel lorem est scelerisque
## iaculis. Convallis hendrerit magnis faucibus tortor. Amet risus eget in ex
## pharetra non id massa. Nec et enim egestas sagittis quis sed bibendum donec.
## 
## Elementum tempus ante sit enim elementum metus nullam. Porta sem nisl sed, sed,
## hac ac magna nam laoreet fringilla! Maximus facilisis cras nisi posuere sed
## magna fringilla tristique sociosqu amet tincidunt curabitur dictumst. Aliquam
## sed habitasse non in blandit aliquam. Urna suscipit, ut duis, dis nulla eget nec
## ut suspendisse. Sem augue sollicitudin sed vel arcu a orci dolor odio non. Non
## leo dapibus ullamcorper, inceptos viverra. Accumsan gravida eu eget ipsum eros.
## Ex gravida quis euismod sed ullamcorper mattis lorem, vel sed nulla! Himenaeos
## habitant tempus mauris, sem ultricies eros. Et nulla egestas quis. Diam nibh ac
## in quis parturient sem, risus vulputate. Lacinia in duis, nibh etiam condimentum
## eu vestibulum. Eu volutpat, felis commodo tincidunt, lobortis dictumst laoreet.
## Ut est in donec scelerisque sed rhoncus quam consectetur. Consequat orci
## imperdiet, ultrices id et nascetur.
## 
## Sodales, nisi ac faucibus, quis potenti sed. A eu ipsum fermentum, habitasse
## nam, tempor mi dis. Ac, ut sollicitudin justo in tristique, diam luctus nunc
## nec ac. Dui, faucibus non amet finibus, urna praesent phasellus sed. Duis
## per elementum ac litora phasellus non. Vulputate primis magna vestibulum quis
## mauris, felis facilisis lacinia tempus mattis. Facilisis sed ante in suscipit
## nostra, tempus integer massa lacinia dui. Finibus aptent euismod ut, sed in
## molestie varius tincidunt mus. Volutpat urna nisl aliquam gravida in nibh
## vivamus, efficitur. Eleifend ligula lectus eu aliquet hendrerit. Vel rhoncus
## blandit mus nec, tortor fringilla semper sed sociis sem, velit. Magna et nec
## eros turpis magna.
## 
## Pellentesque suspendisse nec montes in, sapien nascetur malesuada in leo justo,
## dui est porttitor, eu. Class odio faucibus ac finibus risus pretium in euismod
## nunc nulla malesuada cum. Sed ligula, magna lorem iaculis, litora auctor. Ad
## facilisis eu non sit. Enim ut mauris orci erat felis. Convallis maecenas velit,
## aenean ac nunc volutpat nec morbi. Cras risus rhoncus vestibulum in purus lorem.
## 
## Turpis sit dui sed rhoncus suspendisse maecenas. Diam nulla lorem posuere
## tellus. Velit mattis aliquam, massa lacus nunc lectus a. Tempus est, eu
## porttitor faucibus non. Suspendisse justo est. Proin consectetur lacus metus
## vitae ut velit. Sed molestie habitasse aenean venenatis per pharetra lectus
## nulla ultrices vitae. Id nam porta amet pellentesque sapien. Ut iaculis faucibus
## eu ridiculus felis congue cras, fusce ultricies.
## 
## Maecenas auctor nunc. Sed magna egestas velit amet, aliquam leo facilisis. Nunc
## ac sed gravida dolor gravida ut ac eu feugiat. Facilisis habitasse porttitor
## id vel ultricies porta mauris laoreet. Molestie urna blandit netus dis nullam
## ut venenatis. Risus velit vestibulum vitae justo netus. Quis odio vel sit nam.
## Tincidunt, eu in, torquent odio. Ac felis pharetra euismod elit odio consectetur
## dictum. Ante id urna quis convallis.
cat(stri_rand_lipsum(10), sep='\n\n')
## Lorem ipsum dolor sit amet, laoreet ut urna ac, accumsan in suscipit nullam. Vitae nec in sed proin quis, in ligula. Varius curabitur turpis eu rhoncus fusce curae. Ullamcorper eget maecenas. Est vel, lobortis sociis vel mi donec sed et magna in. Sed amet ante tellus donec augue dictum amet sagittis, aliquam. A tincidunt congue eget nostra non mauris auctor quis. Imperdiet laoreet quis, orci inceptos aenean, sagittis, litora. Vestibulum tristique. Non morbi, consequat scelerisque tincidunt lacinia quam tristique aliquet ad. Urna nec nunc eu vitae fermentum auctor, lacus ex, urna. Ipsum rhoncus ex condimentum amet. Erat nascetur ante ut urna dis vivamus faucibus consequat neque nostra, et.
## 
## Neque pretium semper ad mattis non porta facilisis nullam class. Velit montes, lacus vel volutpat nec metus leo venenatis. Felis lacus sit diam, a. Tincidunt molestie purus mi diam proin sed tincidunt ut rutrum. Diam libero. Velit lacus ac sed, sed ut egestas finibus laoreet. Et nascetur non dolor felis torquent euismod libero nisl tempus. Suscipit auctor, et sit placerat, risus. Condimentum cursus vestibulum a luctus sapien hendrerit eu, nec. Maecenas sit consequat arcu. Laoreet donec ac eros. Tempus feugiat amet tellus neque habitant conubia non pellentesque. Efficitur, finibus, dui a, nec tincidunt. In lacinia vulputate, eget quam in et potenti nisi. Maecenas lorem nulla. Primis sed.
## 
## Amet penatibus ultricies platea quis massa ut. Curabitur dignissim sollicitudin, sed vitae. Lobortis nibh aenean in ultrices a nunc scelerisque, amet nisl eleifend. Magna pharetra, lacus eu sed nec ultricies non, ut. Sed magna morbi ipsum purus leo ligula taciti. Taciti nulla porta, mauris, senectus in! Curae at aliquam ac, massa ultrices hac vel cursus luctus cubilia purus fermentum ut. Elementum at litora mattis vivamus cursus magna adipiscing neque.
## 
## Neque turpis, ut class mauris vestibulum, ultrices odio penatibus et, tempus, inceptos fringilla aptent. Mollis nec ac ac enim condimentum aptent, justo mattis quam accumsan. Facilisis dapibus cras tincidunt sit et sed, ad suscipit, ut. Et amet urna sodales, ac et. Lectus id purus ac, nostra scelerisque lorem phasellus id consequat sapien lacinia leo iaculis nulla. Feugiat, orci sed, nibh purus eros tempus bibendum ornare in. Ac tincidunt pellentesque scelerisque non adipiscing. Morbi massa, potenti sed pretium class ac. Quam phasellus quam fusce erat odio ullamcorper id per, eu, suspendisse eget ut finibus.
## 
## Lobortis donec conubia volutpat cum ad nisl nam venenatis himenaeos eu. In curae velit aenean tortor. Nisl nam. Dignissim ac nibh congue at luctus ante lobortis, felis duis viverra lacus. Sapien rutrum arcu laoreet integer purus! Eros integer porta nisi elit vulputate quis. Nulla, vel. Primis nunc neque sed ultricies eros lorem torquent velit, vulputate pretium at in. Ipsum eleifend pulvinar ullamcorper habitant sed, ante, malesuada. Et sed, non. Vulputate morbi ipsum, nunc vitae montes neque duis himenaeos maximus quis litora. Iaculis in elementum morbi ac magnis in amet. Sed velit aenean, ultrices, sem. Ut parturient suspendisse, nam.
## 
## Nulla curabitur auctor class erat pellentesque scelerisque duis. Mi gravida, pellentesque himenaeos elementum condimentum nam nullam elit sit blandit pulvinar. A commodo, et sodales primis, consequat, consequat. Magna eu diam et quisque nibh. Odio nisl vel libero nisl bibendum et in, nec habitant purus. Phasellus sed diam in luctus bibendum vel nulla bibendum sed pretium. Lacus ut, class sit, vulputate enim lacinia sit, etiam, in mauris quis. Pulvinar nisl nulla ut neque lacus curae non proin. Sed mollis a eu sit. Mauris habitant, dictumst tincidunt eu nullam massa turpis viverra.
## 
## Nulla sagittis, eu praesent ut mi dapibus. At primis ante auctor sit ultrices. Sodales, augue semper convallis cubilia consequat malesuada in sit. Sed cras justo cursus non eros consectetur in ipsum condimentum placerat. Semper magnis nisl dis imperdiet justo velit at quisque. Purus lacus ut nibh fames tempus sed nisl ac. Nulla consectetur ante ex, neque gravida massa amet. Netus in, ut placerat magna, nam sodales curae nascetur non.
## 
## Consequat sed augue congue. Ante cum nullam enim vehicula curabitur justo ipsum? Felis, praesent, tellus malesuada pulvinar duis. Molestie et maximus vitae, diam id litora erat felis ut. Primis sodales risus sit. Scelerisque nisi in in lacus sit augue facilisi mauris iaculis non tortor venenatis. Eu euismod vitae, et nec consequat accumsan eu adipiscing non senectus elit. Odio, vitae turpis placerat nostra. Arcu sollicitudin imperdiet justo vestibulum natoque eu dapibus euismod mauris volutpat nec. Eros vitae urna lacinia. Class donec vitae tincidunt a ac nunc. Nostra in tempor posuere vehicula varius vitae massa. Eu dolor et pellentesque accumsan at velit curabitur a ut mollis.
## 
## Lacinia dui at sit maximus in a rutrum vestibulum sed. Nascetur ut vulputate. Vehicula sed morbi faucibus donec, ipsum. Maecenas eu tincidunt massa facilisis faucibus commodo. Sapien class sociis ornare sed tortor ultricies at nisl tempus. Laoreet donec, ipsum justo, nulla auctor in lobortis magna in habitasse auctor. Vehicula erat magnis, ante euismod sed. Fringilla ut cursus tellus dapibus iaculis nulla phasellus vestibulum. Odio in ligula neque urna viverra dui cras volutpat. Pharetra auctor id odio platea litora pulvinar. Sagittis nostra interdum nibh vulputate dolor sed, phasellus. Eros, magnis eu ante, potenti curabitur. Tempor sed eget pellentesque nullam et natoque molestie. Id mi turpis ligula pellentesque himenaeos id molestie cursus sit a consequat quam. Ac non, aliquam lobortis cum justo sociosqu et. Molestie quis id nec, sed et ac. Vel convallis sed nisl himenaeos. Sed tincidunt enim felis, litora arcu feugiat luctus at dui. In condimentum vel vivamus arcu eget viverra ut sed blandit.
## 
## Cras lacus tempor at nam libero in rutrum eget metus ipsum ac integer porttitor cras eu. Lacinia maximus cum massa pellentesque habitant, sagittis justo. Sem pulvinar eget mattis euismod magna inceptos, ut, mattis sem pellentesque luctus. Aliquam ullamcorper inceptos odio ex magna suscipit bibendum nibh. Sem fames quam at accumsan sodales ullamcorper at nascetur sed ad, et. Vehicula lectus lobortis mattis quis in eu. Et amet nascetur vel ipsum, duis duis id vestibulum! Enim nisl class libero lobortis tempor tempor justo. Mauris aliquam, vitae sed mauris penatibus enim natoque eget. Eu felis enim bibendum inceptos, luctus placerat. Id potenti non non. Varius hac libero eu amet condimentum tristique lectus. Vulputate turpis velit ligula porttitor, nec vitae. Cum curae libero in interdum consectetur massa tortor ligula ut eu! Nibh interdum vitae sed tincidunt ut eget. Non sapien non odio tempus nec primis auctor. In amet lacinia class viverra purus nec nec risus erat posuere. Pulvinar erat elementum leo nibh luctus montes risus luctus id.
```
