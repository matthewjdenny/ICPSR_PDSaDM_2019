###### R Programming: Assignment 1 #####


### Preliminaries ###
rm(list = ls())

# Set your working directory to the workshop repo location:
setwd("~/Box Sync/ISSR_Data_Management_Web_Scraping_2018/Data")

# Load in the data we will be using:
load("Example_Tweets.RData")

# This dataset comprises all tweets that mentioned either "Trump" or "POTUS"
# (President Of The United States) over a 5 minute period around noon on
# Thursday, May 18th, 2017. In this assignment, you will be asked to use 'for()'
# loops, 'if()' statments, and to write your own functions to count the number
# of tweets that meet a number of different conditions.

# In order for this to be interesting, we are going to introduce one more
# base R function that will allow us to search for words in a string. This
# function is called 'grepl()', and returns a logical (TRUE/FALSE) dependng on
# whether it finds a search pattern in the given string. Lets look at an
# example:
my_string <- "Hello, my name is Matt and programming is fun!"

# Lets see if this string containts the word "is":
grepl("is", my_string) # returns TRUE

# Now lets see if it contains the word "orange":
grepl("orange", my_string) # returns FALSE

# What about "matt"?
grepl("matt", my_string) # returns FALSE

# But the original string contained "matt", it was just captialized. To ignore
# the case of words, we can set an option in 'grepl()', which we will use in
# the rest of this assignment:
grepl("matt", my_string, ignore.case = TRUE) # returns TRUE




### Exercise 1 ###

# In this exercise, you are going to use a 'for()' loop and an 'if()' statment
# to count the number of tweets that contain the word "POTUS" (case insensitive)
# in the their main text. You can access the text field for a give tweet (in
# this case, the first row in the dataset), using the following line of code:
print(tweets$text[1])

# remember, we can use a variable to index the rows:
i <- 1
print(tweets$text[i])

# The last bit of example coe you will need is to put this inside of a 'grepl()'
# call:
i <- 1
grepl("POTUS", tweets$text[i], ignore.case = TRUE)

# Okay, so I will get you started here. Store the count of the number of tweets
# that mention "POTUS" in a variable:
POTUS_Tweets_Count <- 0

# Now loop over the dataset and use an if statment to check and see if the text
# field in each tweet contains the string "POTUS" and add 1 to the value of
# POTUS_Tweets_Count if 'grepl()' returns TRUE




### Exercise 2 ###

# Now try to find all tweets that contain both the term "Trump" (case
# insensitive) and "Comey" (also case insensitive). You can do this using
# nested if statments like this:
# if (tweet contains "Trump") {
#   if (tweet contains "Comey") {
#       increment count
#   }
# }




### Exercise 3 ###

# Write a function that returns the 'screen_name' of all users who have a
# specified number of 'statuses_count', 'followers_count', and
# 'favourites_count'. Do this only using 'for()' loops and 'if()' statements.
# Here is a template for the function:

find_users <- function(statuses,
                       followers,
                       favourites,
                       tweet_data) {

    # find all users that meet the above criteria:


    # use the 'unique()' function to make sure you only return a vector of
    # unique usernames:
    users <- unique(users)

}

# To create this program, it will be helpful to use the following trick. If we
# initialize users to NULL, then we can keep adding on usernames to it with the
# 'c()' operator as we find them, and the NULL will dissappear as soon as we
# find valid matches. For example:
users <- NULL

# Print it out:
print(users)

# Now concatenate a name onto the end:
users <- c(users, "Matt")

# Print it out:
print(users)

# And we see that the "NULL" has dissappeared. This is an easy way to make an
# expanding vector to store mataches in.

# Once you have created your function, use it to find the user that matches
# these stats:
find_users(statuses = 62585,
           followers = 287180,
           favourites = 173,
           tweet_data = tweets)





### Exercise 4 ###

# I am going to give you less direction in this final exercise. You should write
# a function that takes an input term and returns the number of unique users
# that included the term in atleast one tweet, and their average number of
# followers. Remember that there may be multiple tweets by the same account, so
# you will need to find the unique users, and then get their average number of
# followers. Return these two values in a numeric vector of the form:
# c(number_of_users,average_followers)










################################################################################
#' Answer Code Below -- Spoiler ALERT!
################################################################################









### Exercise 1 ###

# Variable to store tweet count:
POTUS_Tweets_Count <- 0

# Loop over all tweets
for (i in 1:nrow(tweets)) {
    # If "POTUS: is contained in the text field for the current tweet:
    if (grepl("POTUS", tweets$text[i], ignore.case = TRUE)) {
        POTUS_Tweets_Count <- POTUS_Tweets_Count + 1
    }
}

# Make a nice little 'cat()' statment to tell ourselves the answer:
cat(POTUS_Tweets_Count,"out of",nrow(tweets),
    "tweets contain the term POTUS.\n")

# You should get:
POTUS_Tweets_Count == 1267


### Exercise 2 ###

# Variable to store tweet count:
Trump_Comey_Tweets_Count <- 0

# Loop over all tweets
for (i in 1:nrow(tweets)) {
    # If "Trump" is contained in the text field for the current tweet:
    if (grepl("Trump", tweets$text[i], ignore.case = TRUE)) {
        if (grepl("Comey", tweets$text[i], ignore.case = TRUE)) {
            Trump_Comey_Tweets_Count <- Trump_Comey_Tweets_Count + 1
        }
    }
}

# Make a nice little 'cat()' statment to tell ourselves the answer:
cat(Trump_Comey_Tweets_Count,"out of",nrow(tweets),
    "tweets contain the term POTUS.\n")

# You should get:
Trump_Comey_Tweets_Count == 576


### Exercise 3 ###

# Define our function:
find_users <- function(statuses,
                       followers,
                       favourites,
                       tweet_data) {
    # Initialize variable to store users
    users <- NULL

    # Loop over tweets
    for (i in 1:nrow(tweet_data)) {
        # If statement (combining multiple conditions):
        if (tweet_data$statuses_count[i] == statuses &
            tweet_data$followers_count[i] == followers &
            tweet_data$favourites_count[i] == favourites) {

            # Add this user to the list:
            users <- c(users, tweet_data$screen_name[i])
        }
    }

    # Get the unique users:
    users <- unique(users)

    # Return our answer:
    return(users)
}

# Run our function:
user <- find_users(statuses = 62585,
                   followers = 287180,
                   favourites = 173,
                   tweet_data = tweets)

# Check our answer:
user == "BrookingsInst"




### Exercise 4 ###

# First, I am going to illustrate this with a function using only 'for()' loops
# and 'if()' statements:
get_average_followers <- function(key_term,
                                  tweets) {
    # Hold the usernames associated with the tweets containing the key term
    users <- NULL

    # First we find all tweets that contain the term:
    for (i in 1:nrow(tweets)) {
        if (grepl(key_term, tweets$text[i], ignore.case = TRUE)) {
            users <- c(users,tweets$screen_name[i])
        }
    }

    # Get the unique users
    users <- unique(users)

    # Now go through and find the first time that user pops up in the dataset.
    # Then record the number of followers. Do this for each unique user:
    followers <- rep(0, length(users))

    # Loop over each unique user:
    for (i in 1:length(users)) {
        # Use the 'which()' function to find the first tweet by that user
        index <- which(tweets$screen_name == users[i])[1] # add the [1] to get
        # the first row index that matches the condition.

        followers[i] <- tweets$followers_count[index]
    }

    # Now return the desired values:
    to_return <- c(length(users),
                   mean(followers))

    return(to_return)
}

# Lets try it out:
results <- get_average_followers("fake news",
                                 tweets)

# Check our work
results[1] == 57 # number of unique users
round(results[2],3) == 3764.088 # average number of followers (rounded to 3
# significant digits)
