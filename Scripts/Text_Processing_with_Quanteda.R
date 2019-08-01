# Text Processing and Analysis
# Developed by: Matthew J. Denny
# email: mdenny@psu.edu with questions or comments

# clear out environment
rm(list = ls())

# preliminaries, make sure we have the right packages downloaded
# install.packages("quanteda", dependencies = TRUE)
# install.packages("stringr", dependencies = TRUE)
# install.packages("RColorBrewer", dependencies = TRUE)

# load packages
require(stringr)
require(quanteda)


# set working directory (you will need to change this for your computer)
setwd("~/Box Sync/ICPSR_PDSaDM_2019/Data/Bill_Text")

# lets start with the basics of reading in some documents and generating a
# document term matrix:

# read in documents
documents <- rep("", length = 100)
# loop over documents
for (i in 1:100) {
    cat("currently working on bill:",i,"\n")
    # set the current bill number
    ind <- 97000 + i
    # get the text of the bill
    text <- readLines(paste("Bill_",ind,".txt", sep = ""))
    # collapse it together into a string and store it in a vector
    documents[i] <- paste0(text,collapse = " ")
}

# The common goal of most text preprocessing is to generate a document-term
# matrix, where each row represents a document, and each column represents the
# count of a vocabulary term in the current document.
doc_term_matrix <- quanteda::dfm(documents,
                                 tolower = TRUE,
                                 remove_numbers = TRUE,
                                 remove_punct = TRUE,
                                 remove_separators = TRUE,
                                 remove_twitter = FALSE,
                                 stem = FALSE)

# look at some of the vocabulary
head(doc_term_matrix@Dimnames$features, n = 100)

# get column sums
word_counts <- colSums(doc_term_matrix)

# order word counts
word_counts <- word_counts[order(word_counts, decreasing = TRUE)]

# top words
head(word_counts,n = 100)

# bottom words
tail(word_counts,n = 100)

# Now lets move on to working with a builtin corpus in quanteda and try some
# more advanced functionality

# Lets load in some example data:
corp <- quanteda::data_corpus_inaugural

summary(corp)

# Let's look at one document (Washington's first inaugural)
texts(corp)[1]

# Let's look at the contexts in which a couple of words have been used
#  kwic = "key words in context"

# set the line width a bit wider:
options(width=120)

# first we will try the word "humble":
kwic(corp, "humble", window=4)

# now lets try tombstones:
kwic(data_corpus_inaugural, "tombstones", window=4)

# set the line width back to its original value:
options(width=80)

# lets try another example with forming a document-term matrix:
doc_term_matrix <- quanteda::dfm(corp,
                                 tolower = TRUE,
                                 stem = FALSE,
                                 remove_punct = TRUE,
                                 remove = stopwords("english"),
                                 ngrams = 1)

# What kind of object is doc_term_matrix?
class(doc_term_matrix)

# How big is it? How sparse is it?
doc_term_matrix

# Let's look inside it a bit:
doc_term_matrix[1:5,1:5]

# What are the most frequent terms (now using quanteda's built-in functionality)?
topfeatures(doc_term_matrix,40)

# Besides "tombstones," what other words were never used in an inaugural before Trump?
unique_to_trump <- as.vector(colSums(doc_term_matrix) == doc_term_matrix["2017-Trump",])
colnames(doc_term_matrix)[unique_to_trump]

# We can also create some wordclouds
set.seed(100)
textplot_wordcloud(doc_term_matrix,
                   min_count = 100,
                   rotation = .25,
                   color = RColorBrewer::brewer.pal(8,"Dark2"))

set.seed(100)
textplot_wordcloud(doc_term_matrix["2017-Trump",],
                   min_count = 3,
                   random_order = FALSE,
                   rotation = .25,
                   color = RColorBrewer::brewer.pal(8,"Dark2"))


# We can also change the settings of our document term matrix generating
# function:
doc_term_matrix <- quanteda::dfm(corp,
                                 tolower = FALSE,
                                 stem = TRUE,
                                 remove_punct = FALSE,
                                 remove = stopwords("english"),
                                 ngrams = 1)

# How big is it now? How sparse is it now?
doc_term_matrix

# What are the most frequent terms?
topfeatures(doc_term_matrix,40)

# Or try adding longer n-grams
doc_term_matrix <- quanteda::dfm(corp,
                                 tolower = TRUE,
                                 stem = FALSE,
                                 remove_punct = TRUE,
                                 remove = stopwords("english"),
                                 ngrams = 2)

# How big is it now? How sparse is it now?
doc_term_matrix

# What are the most frequent terms?
topfeatures(doc_term_matrix,40)

