library(data.table)
library(stringr)

dolq <- fread("donnees_nettes/DOLQ16.tsv")

setnames(dolq, old = c("notice_id", "nom_complet", "titre_complet", "parution", "notice_nom_complet", "description", "volume", "depouillement", "details_bibliographiques"),
         new = c("Id", "Auteur_oeuvre", "Titre", "Annee_parution",  "Auteur_notice", "Article", "Volume", "Depouillement", "Details_bibliographiques"))


dolq_min <-
  dolq[, .(
    Id,
    Auteur_oeuvre,
    Titre,
    Annee_parution,
    Auteur_notice,
    Volume,
    Article,
    Depouillement,
    Details_bibliographiques
  )]

dolq_min[, Annee_unique:=as.integer(str_extract(Annee_parution, "^[[:digit:]]{4}"))]

# dolq_min <- dolq_min[!is.na(Article) & ! Article == "" & !duplicated(Titre) & !duplicated(Article)]
saveRDS(dolq_min, "donnees_nettes/dolq_min.RDS")
