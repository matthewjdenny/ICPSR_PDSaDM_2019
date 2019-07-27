#### Performant Programming in R ####


### Efficient Programming ###

# Always clean out your environment and set your working directory:
rm(list = ls())
setwd("~/Desktop")

# Lets look at how much slower things get when we use growing data
# structures than when we use pre-allocation:

# In this example, I am going to construct a vector of length 100,000 one
# element at a time. The first way will use a growing data structure, the second
# will use a pre-allocated one. Note that we are also going to use the
# system.time function here to time how long it takes. If you want to time
# something that spans multiple lines, use {} inside of the () so that it knows
# you are timing multiple lines of code:

# First, lets try a growing data structure:
system.time({
    vect <- NULL
    for (i in 1:100000) {
        vect <- c(vect,i)
    }
})

# Now, lets try a pre-allocated data structure:
system.time({
    vect <- rep(0, 100000)
    for (i in 1:100000) {
        vect[i] <- i
    }
})


# Now we are going to cover the speedup from using the builtin functions in R
# vs. hand-coding your own implementation.

# Lets start by creating an example vector of length 100,000,000 to use in the
# example below:
vect <- 1:100000000

# First, we are going to take the sum of this vector using a for() loop:
system.time({
    # Initialize a "total" variable to 0:
    total <- 0
    # Increment the total with a for loop:
    for (i in 1:length(vect)) {
        total <- total + vect[i]
    }
    print(total)
})

# Sum over the same vector using the built in sum() function in R, which is
# coded in C:
system.time({
    # Note that becasue this vector is so large, we have to use
    # sum(as.numeric()) or we will get an error message:
    total <- sum(as.numeric(vect))
    print(total)
})

# For our next example, lets consider the case where we want to build a
# sociomatrix. We have a two column matrix as input. The first column records
# the index of the sender, the second column records the index of the recipient.
# We are going to form a sociomatrix (a matrix recording the number of times
# each actor sent something to each other actor), in the naive way, and then in
# a much faster way.

# Set the number of messages and actors:
messages <- 1000000
actors <- 5000

# Create some fake message data (sender recipient pairs):
fake_data <- data.frame(sender = round(runif(messages, min = 1, max = actors)),
                        recipient = round(runif(messages, min = 1, max = actors)))

# Now create a balnk sociomatrix in which to store our results
sociomatrix_1 <- matrix(0,
                        nrow = actors,
                        ncol = actors)

# First, we are going to try the slow way using a for() loop:
system.time({
    for (i in 1:messages) {
        sociomatrix_1[fake_data$sender[i],fake_data$recipient[i]] <-
            sociomatrix_1[fake_data$sender[i],fake_data$recipient[i]] + 1
    }
})

# Now, we are going to try the fast way using the table() function:
system.time({
    sociomatrix_2 <- as.matrix(as.data.frame.matrix(table(fake_data)))
})

# We can also test to see if we get the same result, using the all.equal()
# function. Note that before using this function, I turn each matrix into a
# numeric vector. This makes comparison easier.
all.equal(as.numeric(sociomatrix_1) , as.numeric(sociomatrix_2))


# For our final example, we are going to generate a very sparse two column
# dataset:

# Set the seed for replicability
set.seed(1234)
# Set the number of observations we want to work with:
numobs <- 10000000
# Observations we want to check:
vec <- rep(0,numobs)
# Only select 100 to check:
vec[sample(1:numobs,100)] <- 1
# Combine the two columns into a data.frame:
data <- cbind(1:numobs,
              vec)

# Sum only over the entries in the first column where the second column is equal
# to 1, using a for() loop:
system.time({
    total <- 0
    for (i in 1:numobs) {
        # Use a conditional to give ourselves periodic updates on our progress:
        if (i %% 1000000 == 0) {
            print(i)
        }
        # Only increment the sum if the condition is met
        if (data[i,2] == 1) {
            total <- total + data[i,1]
        }
    }
    print(total)
})

# Now we can instead sum over the subset of observations where the second column
# is equal to 1 using the subset function (coded in C). In many ways, this works
# just like using the which function to get the row indices, then subsetting the
# data manually with those indices:
system.time({
    dat <- subset(data, data[,2] == 1)
    total <- sum(dat[,1])
    print(total)
})
# So much faster!!!



### Parallelization ###

# Lets start with an example of parallelization using the foreach package in R:

# First we create some toy data:
num_cols <- 300
my_data <- matrix(rnorm(100000),
                  nrow = 100000,
                  ncol = num_cols)

# Define a function that we are going to run in parallel:
my_function <- function(col_number,
                        my_data){
    temp <- 0
    for (j in 1:nrow(my_data)) {
        if (my_data[j,col_number] > 0.1) {
            if (my_data[j,col_number] < 0.5) {
                temp <- temp + sum(my_data[j,])
            }
        }
    }

    return(temp)
}

# We will rely on a couple of packages here, so make sure you have them
# installed:
# install.packages(c("doParallel","foreach"), dependencies = TRUE)
library(doParallel)
library(foreach)

# First we need to register the number of cores you want to use:
cores <- 4

# Then we create a cluster:
cl <- makePSOCKcluster(cores)

# Next we register the cluster with DoParallel:
registerDoParallel(cl)

# Run analysis in serial
system.time({
    serial_results <- rep(0,num_cols)
    for (i in 1:num_cols) {
        if (i %% 10 == 0) {
            print(i)
        }
        serial_results[i] <- my_function(i, my_data)
    }
})

# Run analysis in parallel:
system.time({
    parallel_results <- foreach(i = 1:num_cols,.combine = rbind) %dopar% {
        cur_result <- my_function(i, my_data)
    }
})
stopCluster(cl)


# Now lets try to redo one of our earlier examples managing multiple datasets:
read_in_dataset <- function(filename, # the name of the file we want to read in.
                            has_header, # option for whether file includes a header.
                            columns_to_keep) { # number of columns to keep in dataset.

    # Assumes a .csv file, but could be modified ot deal with other file types:
    temp <- read.csv(filename,
                     stringsAsFactors = F,
                     header = has_header)


    # lets set some column names using 'paste()' for fun:
    colnames(temp) <-  paste("Bill",1:ncol(temp), sep = "_")

    # If columns_to_keep was NULL, set it to the number of columns in the dataset.
    if (is.null(columns_to_keep)) {
        columns_to_keep <- ncol(temp)
    }
    temp <- temp[,1:columns_to_keep]

    return(temp)

}

# Now lets define a function for extracting cosponsorship information from a
# dataset and putting it in a cosponsorship matrix:
generate_cosponsorship_matrix <- function(raw_data) {

    # Get the number of legislators:
    num_legislators <- nrow(raw_data)

    # Create a sociomatrix:
    sociomatrix <- matrix(0,
                          ncol = num_legislators,
                          nrow = num_legislators)

    # Loop through bills (columns)
    for (j in 1:ncol(raw_data)) {

        # If there are a lot of bills, then we may want to check in with the
        # user periodically to let them know about progress:
        if (j %% 1000 == 0) {
            cat("Working on bill",j,"of",ncol(raw_data),"\n")
        }

        # Find out who the bill sponsor is (coded as a 1):
        for (i in 1:nrow(raw_data)) {
            if (raw_data[i,j] == 1) {
                sponsor <- i
            }
        }

        # Find all of the cosponsors:
        for (i in 1:nrow(raw_data)) {
            if (raw_data[i,j] == 2) {
                sociomatrix[i,sponsor] <- sociomatrix[i,sponsor] + 1
            }
        }
    }

    return(sociomatrix)
}


# Now we define a function that calls these two functions to do everything:
preprocess_data <- function(filenames,
                            has_header = FALSE,
                            columns_to_keep = NULL) {

    # Create a list object to store the raw and preprocessed data:
    data_list <- vector(mode = "list",
                        length = length(filenames))

    # Loop over files and load/preprocess them
    for (i in 1:length(filenames)) {
        cat("Reading in file",i,"\n")
        data_list[[i]]$raw_data <- read_in_dataset(filenames[i],
                                                   has_header,
                                                   columns_to_keep)

        cat("Preprocessing file",i,"\n")
        data_list[[i]]$sociomatrix <- generate_cosponsorship_matrix(data_list[[i]]$raw_data)
    }

    # Give list entries some basic names:
    names(data_list) <-  paste("Dataset",1:length(filenames), sep = "_")

    # Now just return everything
    return(data_list)
}

# Here we ar going to go one step further, and try this in parallel:

wrapper_function <- function(filename,
                             has_header,
                             columns_to_keep,
                             fun1,
                             fun2) {
    # Create a blank list object
    data_list <- list()

    # Load in the data and save it to the list object:
    data_list$raw_data <- fun1(filename,
                               has_header,
                               columns_to_keep)
    # Preprocess the data:
    data_list$sociomatrix <- fun2(data_list$raw_data)

    # Return the list object:
    return(data_list)
}

preprocess_parallel <- function(filenames,
                                cores = 1,
                                has_header = FALSE,
                                columns_to_keep = NULL,
                                fun1 = read_in_dataset,
                                fun2 = generate_cosponsorship_matrix) {

    # Create a cluster instance:
    cl <- parallel::makeCluster(getOption("cl.cores", cores))

    # Run our function on the cluster:
    data_list <- parallel::clusterApplyLB(cl = cl,
                                          x = filenames,
                                          fun = wrapper_function,
                                          has_header = has_header,
                                          columns_to_keep = columns_to_keep,
                                          fun1 = fun1,
                                          fun2 = fun2)

    # Stop the cluster when we are done:
    parallel::stopCluster(cl)

    # Give list entries some basic names:
    names(data_list) <-  paste("Dataset",1:length(filenames), sep = "_")

    # Now just return everything:
    return(data_list)
}

# Lets try it out!
setwd("~/Box Sync/ICPSR_PDSaDM_2019/Data/Senate_Cosponsorship")
filenames <- list.files()

# Time the standard way of doing it:
system.time({
    serial_data <- preprocess_data(filenames,
                                   columns_to_keep = 200)
})

# Now try it out in parallel on 4 cores:
system.time({
    parallel_data <- preprocess_parallel(filenames,
                                         cores = 4,
                                         columns_to_keep = 200)
})





### Handling Big Data ###

# Start by setting the seed so our results are reproducible
set.seed(12345)

# Next create some big fake sparse (lots of zeros) data:
big_data <- matrix(round(rnorm(10000000) * runif(10000000, min = 0,max = 0.2)),
                   nrow = 1000000,
                   ncol = 100)

# Find out how many entries are just zeros:
length(which(big_data == 0))

# Now lets represent this as a simple triplet matrix:
install.packages("slam", dependencies = TRUE)
library(slam)

# Now we can use this function provided by slam to transform our dense matrix
# into a sparse matrix:
sparse_big_data <- slam::as.simple_triplet_matrix(big_data)

# Lets check the value at this index in the matrix object:
big_data[1436,1]

# Now we can try the same thing for the sparse matrix object:
as.matrix(sparse_big_data[1436,1])

# Now lets see what happens when we save the data as a .csv vs. as an .RData
# file:

# install.packages("rio", dependencies = TRUE)
library(rio)
setwd("~/Desktop")

# Try saving in both formats and look at the file sizes:
export(big_data, file = "Data.csv")
save(big_data, file = "Data.RData")


