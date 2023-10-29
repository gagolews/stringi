require('stringi')
fname <- '/tmp/test.txt'

# http://code.google.com/p/nlipsum/

words <- stri_split_charclass("ihr naht euch wieder schwankende gestalten
   die früh sich einst dem trüben blick gezeigt
	versuch ich wohl euch diesmal festzuhalten
   fühl ich mein herz noch jenem wahn geneigt
   ihr drängt euch zu  nun gut so mögt ihr walten
   wie ihr aus dunst und nebel um mich steigt
   mein busen fühlt sich jugendlich erschüttert
   vom zauberhauch der euren zug umwittert

   ihr bringt mit euch die bilder froher tage
   und manche liebe schatten steigen auf
   gleich einer alten halbverklungnen sage
   kommt erste lieb und freundschaft mit herauf
   der schmerz wird neu es wiederholt die klage
   des lebens labyrinthisch irren lauf
   und nennt die guten die um schöne stunden
   vom glück getäuscht vor mir hinweggeschwunden

   sie hören nicht die folgenden gesänge
   die seelen denen ich die ersten sang
   zerstoben ist das freundliche gedränge
   verklungen ach  der erste widerklang
   mein lied ertönt der unbekannten menge
   ihr beifall selbst macht meinem herzen bang
   und was sich sonst an meinem lied erfreuet
   wenn es noch lebt irrt in der welt zerstreuet

   und mich ergreift ein längst entwöhntes sehnen
   nach jenem stillen ernsten geisterreich
   es schwebet nun in unbestimmten tönen
   mein lispelnd lied der äolsharfe gleich
   ein schauer faßt mich träne folgt den tränen
   das strenge herz es fühlt sich mild und weich
   was ich besitze seh ich wie im weiten
   und was verschwand wird mir zu wirklichkeiten", "WHITESPACE", omit_empty=TRUE)[[1]]

npars <- 10000

f <- file(fname, open='w')
for (i in 1:npars) {
   cat(stri_flatten(strwrap(stri_flatten(sample(words, 100, replace=TRUE), collapse=" "), width=76), '\n'), file=f, sep='\n')
   cat('\n', file=f)
}
close(f)
