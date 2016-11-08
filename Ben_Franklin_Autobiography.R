library(NLP) # 
library(openNLP)
library(RWeka)
library(magrittr)

# Using this NLP tutorial: https://rpubs.com/lmullen/nlp-chapter
# basics of NLP analysis: http://www.vikparuchuri.com/blog/natural-language-processing-tutorial/

# Sentiment analysis

# BFA stands for Ben Franklin's Autobiography
# Use Project Guttenbern to download the text file of the 
bfaRawText <- readLines('Ben_Franklin_Autobiography_full_noTOC_noIntro.txt')
# The free version of Amazon EC2 has a RAM limited to 1GB. NLP can require
# large memory allocations. To avoid memory problems, we will limit the 
# analysis to first 790 lines which is the end of Chapter 2. 
bfaRawText790 <- bfaRawText[1:100]

bio <- as.String(bfaRawText790)
bio <- paste(bio, collapse = " ")
#bio <- as.String(bio)
word_ann <- Maxent_Word_Token_Annotator()
sent_ann <- Maxent_Sent_Token_Annotator()

bio_annotations <- annotate(bio, list(sent_ann, word_ann))
head(bio_annotations)
bio_doc <- AnnotatedPlainTextDocument(bio, bio_annotations)

person_ann <- Maxent_Entity_Annotator(kind = "person")
location_ann <- Maxent_Entity_Annotator(kind = "location")
organization_ann <- Maxent_Entity_Annotator(kind = "organization")

pipeline <- list(sent_ann,
                 word_ann,
                 person_ann,
                 location_ann,
                 organization_ann)
bio_annotations <- annotate(bio, pipeline)
bio_doc <- AnnotatedPlainTextDocument(bio, bio_annotations)

entities <- function(doc, kind) {
  s <- doc$content
  a <- annotations(doc)[[1]]
  if(hasArg(kind)) {
    k <- sapply(a$features, `[[`, "kind")
    s[a[k == kind]]
  } else {
    s[a[a$type == "entity"]]
  }
}

entities(bio_doc, kind = "person")
entities(bio_doc, kind = "location")
entities(bio_doc, kind = "organization")
