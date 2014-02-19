# which files possibly might not be compiled
# basing on data in icu/source/(common|i18n)/Makefile.in

# icu 52.1
obj_i18n <- c("ucln_in.o fmtable.o format.o msgfmt.o umsg.o numfmt.o unum.o
decimfmt.o dcfmtsym.o ucurr.o digitlst.o fmtable_cnv.o choicfmt.o datefmt.o
smpdtfmt.o reldtfmt.o dtfmtsym.o udat.o dtptngen.o udatpg.o nfrs.o nfrule.o
nfsubs.o rbnf.o numsys.o unumsys.o ucsdet.o ucal.o calendar.o gregocal.o
timezone.o simpletz.o olsontz.o astro.o taiwncal.o buddhcal.o persncal.o
islamcal.o japancal.o gregoimp.o hebrwcal.o indiancal.o chnsecal.o cecal.o
coptccal.o dangical.o ethpccal.o coleitr.o coll.o tblcoll.o sortkey.o bocsu.o
ucoleitr.o ucol.o ucol_res.o ucol_bld.o ucol_sit.o ucol_tok.o ucol_wgt.o
ucol_cnt.o ucol_elm.o strmatch.o usearch.o search.o stsearch.o translit.o
utrans.o esctrn.o unesctrn.o funcrepl.o strrepl.o tridpars.o cpdtrans.o rbt.o
rbt_data.o rbt_pars.o rbt_rule.o rbt_set.o nultrans.o remtrans.o casetrn.o
titletrn.o tolowtrn.o toupptrn.o anytrans.o name2uni.o uni2name.o nortrans.o
quant.o transreg.o brktrans.o regexcmp.o rematch.o repattrn.o regexst.o
regextxt.o regeximp.o uregex.o uregexc.o ulocdata.o measfmt.o currfmt.o
curramt.o currunit.o measure.o utmscale.o csdetect.o csmatch.o csr2022.o
csrecog.o csrmbcs.o csrsbcs.o csrucode.o csrutf8.o inputext.o wintzimpl.o
windtfmt.o winnmfmt.o basictz.o dtrule.o rbtz.o tzrule.o tztrans.o vtzone.o
zonemeta.o upluralrules.o plurrule.o plurfmt.o selfmt.o dtitvfmt.o dtitvinf.o
udateintervalformat.o tmunit.o tmutamt.o tmutfmt.o currpinf.o uspoof.o
uspoof_impl.o uspoof_build.o uspoof_conf.o uspoof_wsconf.o decfmtst.o smpdtfst.o
ztrans.o zrule.o vzone.o fphdlimp.o fpositer.o locdspnm.o decNumber.o
decContext.o alphaindex.o tznames.o tznames_impl.o tzgnames.o tzfmt.o
compactdecimalformat.o gender.o region.o scriptset.o identifier_info.o
uregion.o")

obj_common <- c("errorcode.o putil.o umath.o utypes.o uinvchar.o umutex.o
ucln_cmn.o uinit.o uobject.o cmemory.o charstr.o udata.o ucmndata.o udatamem.o
umapfile.o udataswp.o ucol_swp.o utrace.o uhash.o uhash_us.o uenum.o ustrenum.o
uvector.o ustack.o uvectr32.o uvectr64.o ucnv.o ucnv_bld.o ucnv_cnv.o ucnv_io.o
ucnv_cb.o ucnv_err.o ucnvlat1.o ucnv_u7.o ucnv_u8.o ucnv_u16.o ucnv_u32.o
ucnvscsu.o ucnvbocu.o ucnv_ext.o ucnvmbcs.o ucnv2022.o ucnvhz.o ucnv_lmb.o
ucnvisci.o ucnvdisp.o ucnv_set.o ucnv_ct.o uresbund.o ures_cnv.o uresdata.o
resbund.o resbund_cnv.o messagepattern.o ucat.o locmap.o uloc.o locid.o
locutil.o locavailable.o locdispnames.o loclikely.o locresdata.o bytestream.o
stringpiece.o stringtriebuilder.o bytestriebuilder.o bytestrie.o
bytestrieiterator.o ucharstrie.o ucharstriebuilder.o ucharstrieiterator.o
dictionarydata.o appendable.o ustr_cnv.o unistr_cnv.o unistr.o unistr_case.o
unistr_props.o utf_impl.o ustring.o ustrcase.o ucasemap.o
ucasemap_titlecase_brkiter.o cstring.o ustrfmt.o ustrtrns.o ustr_wcs.o utext.o
unistr_case_locale.o ustrcase_locale.o unistr_titlecase_brkiter.o
ustr_titlecase_brkiter.o normalizer2impl.o normalizer2.o filterednormalizer2.o
normlzr.o unorm.o unormcmp.o unorm_it.o chariter.o schriter.o uchriter.o uiter.o
patternprops.o uchar.o uprops.o ucase.o propname.o ubidi_props.o ubidi.o
ubidiwrt.o ubidiln.o ushape.o uscript.o uscript_props.o usc_impl.o unames.o
utrie.o utrie2.o utrie2_builder.o bmpset.o unisetspan.o uset_props.o
uniset_props.o uniset_closure.o uset.o uniset.o usetiter.o ruleiter.o caniter.o
unifilt.o unifunct.o uarrsort.o brkiter.o ubrk.o brkeng.o dictbe.o rbbi.o
rbbidata.o rbbinode.o rbbirb.o rbbiscan.o rbbisetb.o rbbistbl.o rbbitblb.o
serv.o servnotf.o servls.o servlk.o servlkf.o servrbf.o servslkf.o uidna.o
usprep.o uts46.o punycode.o util.o util_props.o parsepos.o locbased.o cwchar.o
wintz.o dtintrv.o ucnvsel.o propsvec.o ulist.o uloc_tag.o icudataver.o icuplug.o
listformatter.o")


require("stringi")
obj_i18n  <- stri_split_charclass(obj_i18n, "WHITESPACE")[[1]]
obj_common  <- stri_split_charclass(obj_common, "WHITESPACE")[[1]]

getRedundantFiles <- function(objects, d, prefix) {
   objects1 <- stri_replace_all_regex(objects, "\\.o$", "")
   objects2 <- dir(d, stri_c(prefix, ".*\\.(cpp|c)$"))
   objects2 <- stri_replace_first_regex(objects2, stri_c("^", prefix), "")
   objects2 <- stri_replace_first_regex(objects2, "\\.(cpp|c)$", "")
   setdiff(objects1, objects2)
}


getRedundantFiles(obj_common, "src/", "icu52_common_")
getRedundantFiles(obj_i18n, "src/", "icu52_i18n_")
