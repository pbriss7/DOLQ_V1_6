# Extraction des notices et métadonnées des volumes 1 à 6 du DOLQ fournis par BAnQ-CRILQ en format xml

library(xml2)
library(magrittr)
library(stringr)
library(data.table)

# Création des chemins
dolq_dirs <- dir(pattern = "^v")
vols_fichiers <- list(rep(NA, length(dolq_dirs)))

for(i in 1:length(dolq_dirs)){
  vols_fichiers[[i]] <- paste(dolq_dirs[i],list.files(dolq_dirs[i]), sep = "/")
}

# Création d'une liste pour emmagasiner les notices en XML
notice_temp_large_l <- list()

for(i in seq_along(vols_fichiers)){
  notice_temp_l <- lapply(vols_fichiers[[i]], read_xml)
  notice_temp_large_l <- append(notice_temp_large_l, notice_temp_l)
}

# Création d'un tableau de données pour emmagasiner les extractions
DOLQ1_6 <- data.table(notice_id=rep(NA, length(notice_temp_large_l)),
                      auteur_nom=rep(NA, length(notice_temp_large_l)),
                      auteur_prenom=rep(NA, length(notice_temp_large_l)),
                      notice_nom_complet=rep(NA, length(notice_temp_large_l)),
                      titre=rep(NA, length(notice_temp_large_l)),
                      sous_titre=rep(NA, length(notice_temp_large_l)),
                      titre_complet=rep(NA, length(notice_temp_large_l)),
                      complement_titre=rep(NA, length(notice_temp_large_l)),
                      genres=rep(NA, length(notice_temp_large_l)),
                      parution=rep(NA, length(notice_temp_large_l)),
                      epoque=rep(NA, length(notice_temp_large_l)),
                      notice_nom_auteur=rep(NA, length(notice_temp_large_l)),
                      notice_prenom_auteur=rep(NA, length(notice_temp_large_l)),
                      nom_complet=rep(NA, length(notice_temp_large_l)),
                      nom_recherche=rep(NA, length(notice_temp_large_l)),
                      volume=rep(NA, length(notice_temp_large_l)),
                      dalfan=rep(NA, length(notice_temp_large_l)),
                      description=rep(NA, length(notice_temp_large_l)),
                      depouillement=rep(NA, length(notice_temp_large_l)),
                      details_bibliographiques=rep(NA, length(notice_temp_large_l)),
                      etudes=rep(NA, length(notice_temp_large_l))
)

# Extraction et écriture dans le tableau de données
DOLQ1_6[, `:=`(notice_id=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//noticeID") %>% xml_text(.)),
               auteur_nom=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/auteur_nom") %>% xml_text(.)),
               auteur_prenom=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/auteur_prenom") %>% xml_text(.)),
               notice_nom_complet=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/notice_nom_complet") %>% xml_text(.)),
               titre=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/titre") %>% xml_text(.)),
               sous_titre=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/sous-titre") %>% xml_text(.)),
               titre_complet=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/titre_complet") %>% xml_text(.)),
               complement_titre=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/complement_de_titre") %>% xml_text(.)),
               genres=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/genres") %>% xml_text(.)),
               parution=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/parution") %>% xml_text(.)),
               epoque=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/epoque") %>% xml_text(.)),
               notice_nom_auteur=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/notice_nom_auteur") %>% xml_text(.)),
               notice_prenom_auteur=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/notice_prenom_auteur") %>% xml_text(.)),
               nom_recherche=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/nom_recherche") %>% xml_text(.)),
               volume=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//supp/volume") %>% xml_text(.)),
               dalfan=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//dalfan") %>% xml_text(.)),
               description=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//description") %>% xml_text(.) %>% str_replace_all(.,"([[:lower:]])([[:upper:]])","\\1 \\2")),
               depouillement=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//depouillement") %>% xml_text(.)),
               details_bibliographiques=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//detailsBibliographiques") %>% xml_text(.)),
               etudes=sapply(notice_temp_large_l, function(x) xml_find_first(x, xpath = "//etudes") %>% xml_text(.)))]

# Sauvegarde du tableau en csv
fwrite(DOLQ1_6, "resultat/dolq1_6.csv")
saveRDS(notice_temp_large_l, "resultat/tomes_liste_xls.RDS")

# Exportation du CSV dans OpenRefine pour corrections sommaires
