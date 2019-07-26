# remove everything in our workspace
rm(list = ls())

# Set our working directory
setwd("~/Desktop")

#load in the statnet package:
library(statnet)

# set the seed
set.seed(12345)

###############################################
################# Example 1 ###################
###############################################

# set the number of nodes
num_nodes <- 10

# generate a random sociomatrix
my_sociomatrix <- matrix(round(runif(num_nodes*num_nodes)), # edge values
                         nrow = num_nodes, #nrow must be same as ncol
                         ncol = num_nodes)

# make sure the diagonal is zeros
diag(my_sociomatrix) <- 0

# turn our sociomatrix into a network object
net <- as.network(x = my_sociomatrix, # the network object
                  directed = TRUE, # specify whether the network is directed
                  loops = FALSE, # do we allow self ties (should not allow them)
                  matrix.type = "adjacency" # the type of input
                  )

# ways to set vertex names
network.vertex.names(net) <- LETTERS[1:10]
network.vertex.names(net) <- c("Susan","Rachel","Angela","Carly","Stephanie","Tom","Mike","Tony","Matt","Steven")

# create node level covariates
# Create the variable
gender <- c(rep("Female",num_nodes/2),rep("Male",num_nodes/2))
# Take a look at our variable
print(gender)
# Add it to the network object
set.vertex.attribute(net, # the name of the network object
                     "Gender", # the name we want to reference the variable by in that object
                     gender # the value we are giving that variable
                     )

age <- round(rnorm(num_nodes,20,3))
set.vertex.attribute(net,"Age",age)

# take a look at a summary
summary.network(net, # the network we want to look at
                print.adj = FALSE # if TRUE then this will print out the whole adjacency matrix.
                )

# color nodes
node_colors <- rep("",num_nodes)
for(i in 1:num_nodes){
  if(get.node.attr(net,"Gender")[i] == "Female"){
    node_colors[i] <- "lightblue"
  }else{
    node_colors[i] <- "maroon"
  }
}
print(node_colors)

# plot the network
pdf("Network_Plot_1.pdf", # name of pdf (need to include .pdf)
    width = 10, # width of resulting pdf in inches
    height = 10 # height of resulting pdf in inches
)
plot.network(net, # our network object
             vertex.col = node_colors, # color nodes by gender
             vertex.cex = (age)/5, # size nodes by their age
             displaylabels = T, # show the node names
             label.pos = 5 # display the names directly over nodes
)
dev.off() # finishes plotting and finalizes pdf

###############################################
################# Example 2 ###################
###############################################

# set number of nodes and edges
num_nodes <- 40
num_edges <- 80

# generate node names
node_names <- rep("",num_nodes)
for(i in 1:num_nodes){
    node_names[i] <- paste("person",i,sep = "_")
}
print(node_names)

# create a blank edgelist
edgelist <- matrix("",nrow= num_edges,ncol = 2)

# add in edges
for(i in 1:num_edges){
    edgelist[i,] <- sample(x= node_names, # the names we want to sample from
                           size = 2, # sender and receiver
                           replace = FALSE # we do not allow self edges
    )
}
print(edgelist)

# initialize network
net2 <- network.initialize(num_nodes)

# set names
network.vertex.names(net2) <- node_names

# fill in edges
net2[as.matrix(edgelist)] <- 1

# set vertex attribute
income <- round(rnorm(num_nodes,mean = 50000,sd = 20000))
set.vertex.attribute(net2,"Income",income)

# summarize network
summary.network(net2,print.adj = FALSE)

# set edge weights
edge_weights <- round(runif(num_edges,min = 1,max = 5))
set.edge.value(net2,"trust",edge_weights)

# get adjacency matrix
adjacency_matrix_2 <- net2[,]

# get num nodes
num_nodes <- length(net2$val)

# node colors
node_colors <- rep("",num_nodes)

maximum <- max(get.node.attr(net2,"Income"))
for(i in 1:num_nodes){
    #' Calculate the intensity of the node color depending on the person's
    #' relative income.
    intensity <- round((get.node.attr(net2,"Income")[i]/maximum)*255)
    node_colors[i] <- rgb(red = 51, # the proportion of red
                          green = 51, # the proportion of green
                          blue = 153, # the proportion of blue
                          alpha = intensity, # the intensity of the color
                          max = 255 # the maximum possible intensity
    )
}

# plot network
pdf("Network_Plot_2.pdf", # name of pdf (need to include .pdf)
    width = 20, # width of resulting pdf in inches
    height = 20 # height of resulting pdf in inches
)
plot.network(net2,
             vertex.col = node_colors, # color nodes by gender
             vertex.cex = 3, # set node size to a fixed value
             displaylabels = T, # show the node names
             label.pos = 5, # display the names directly over nodes
             label.col = "yellow", # the color of node lables
             edge.lwd = get.edge.value(net2,"trust") # edge width based on trust
)
dev.off() # finishes plotting and finalizes pdf

###############################################
################# Example 3 ###################
###############################################

# simulate network
num_nodes <- 100
edge_values <- round(runif(n = num_nodes*num_nodes , min = 1, max = 100)) *
    round(runif(n = num_nodes*num_nodes, min = 0, max = .51))
my_sociomatrix2 <- matrix(edge_values, nrow = 100, ncol = 100)
diag(my_sociomatrix2) <- 0

# create network object
net3 <- as.network(x = my_sociomatrix2, # the network object
                   directed = TRUE, # specify whether the network is directed
                   loops = FALSE, # do we allow self ties (should not allow them)
                   matrix.type = "adjacency" # the type of input
)

# set attributes
size <- round(rnorm(num_nodes,100,10))
set.vertex.attribute(net3,"Size",size)
set.edge.value(net3,"Weight",edge_values)

# summarize
summary.network(net3,print.adj = FALSE)

# plot the network
pdf("Network_Plot_3.pdf", # name of pdf (need to include .pdf)
    width = 20, # width of resulting pdf in inches
    height = 20 # height of resulting pdf in inches
)
plot.network(net3,
             vertex.col = "purple", #just one color
             displaylabels = F, # no node names
             edge.lwd = log(get.edge.value(net3,"Weight")) # edge width
)
dev.off() # finishes plotting and finalizes pdf

###############################################
################# Example 4 ###################
###############################################

# create the messed-up network data
num_nodes <- 100
install.packages("randomNames",dependencies = T)
library(randomNames)
node_names <- randomNames(num_nodes,name.order = "first.last",name.sep = "_")
length(unique(node_names)) == num_nodes
relational_information <- matrix(NA,nrow = num_nodes,ncol = num_nodes)

max_receivers <- 0
for(i in 1:num_nodes){
    num_receivers <- min(rpois(n = 1, lambda =2),num_nodes)
    # If there are any recievers for this sender
    if(num_receivers > 0){
        receivers <- sample(x = node_names[-i], size = num_receivers, replace = F)
        relational_information[i,1:num_receivers] <- receivers
    }
    # Keep track on the maximum number of receivers
    if(num_receivers > max_receivers){
        max_receivers <- num_receivers
    }
}

relational_information <- cbind(node_names,relational_information[,1:max_receivers])
head(relational_information)

ages <- round(rnorm(n = num_nodes, mean = 40, sd = 5))
genders <- sample(c("Male","Female"),size = num_nodes, replace = T)
node_level_data <- cbind(node_names,ages,genders)

node_level_data <- node_level_data[sample(x = 1:num_nodes, size = num_nodes-10),]

write.table(x = node_level_data,
            file = "node_level_data.csv",
            sep = ",",
            row.names = F)
write.table(x = relational_information,
            file = "relational_information.csv",
            sep = ",",
            row.names = F)
node_level_data <- cbind(node_names,ages,genders)


# read in data
rm(list = ls())
edge_matrix <- read.csv(file = "relational_information.csv",
                        sep = ",",
                        stringsAsFactors = F, # Always include this argument!
                        header = T)
node_covariates <- read.csv(file = "node_level_data.csv",
                            sep = ",",
                            stringsAsFactors = F, # Always include this argument!
                            header = T)

nrow(edge_matrix) == nrow(node_covariates)

# function to process data
Process_Node_and_Relational_Data <- function(node_level_data,
                                             relational_data,
                                             node_id_column = 1
){
    #get our node ids
    node_ids <- node_level_data[,node_id_column]
    #remove any missing or blank entries
    to_remove <- which(node_ids == "" | is.na(node_ids))
    if(length(to_remove) > 0){
        node_ids <- node_ids[-to_remove]
        node_level_data <- node_level_data[-to_remove,]
    }
    # Allocate a blank edgelist to return
    edgelist <- NULL
    # Loop over rows to check them
    for(i in 1:length(relational_data[,1])){
        # Check to see if the sender is in the dataset
        if(length(which(node_ids == relational_data[i,1]) > 0)){
            #' If we have a valid sender, check to see if there is a valid reciever
            #' and add them to the dataset if they are valid as well for each
            #' receiver
            for(j in 2:ncol(relational_data)){
                if(!is.na(relational_data[i,j])){
                    if(length(which(node_ids == relational_data[i,j]) > 0)){
                        edge <- c(relational_data[i,1],relational_data[i,j])
                        edgelist <- rbind(edgelist,edge)
                    }
                }
            }
        }
    }
    # Give column names to edgelist
    colnames(edgelist) <- c("sender","receiver")
    # Return cleaned data as a list object
    return(list(node_level_data = node_level_data,
                edgelist = edgelist,
                num_nodes = length(node_level_data[,1]),
                node_names = node_ids))
}

# run the function to clean the data
Clean_Data <- Process_Node_and_Relational_Data(node_level_data = node_covariates,
                                               relational_data = edge_matrix,
                                               node_id_column = 1)

# generate a network object
net4 <- network.initialize(Clean_Data$num_nodes)
network.vertex.names(net4) <- Clean_Data$node_names
net4[as.matrix(Clean_Data$edgelist)] <- 1
set.vertex.attribute(net4,"Age",Clean_Data$node_level_data$ages)
set.vertex.attribute(net4,"Gender",Clean_Data$node_level_data$genders)
summary.network(net4,print.adj = FALSE)

# get node colors
node_colors <- rep("",Clean_Data$num_nodes)
for(i in 1:Clean_Data$num_nodes){
    if(get.node.attr(net4,"Gender")[i] == "Female"){
        node_colors[i] <- "yellow"
    }else{
        node_colors[i] <- "green"
    }
}

# plot the network
pdf("Network_Plot_4.pdf", # name of pdf (need to include .pdf)
        width = 20, # width of resulting pdf in inches
        height = 20 # height of resulting pdf in inches
    )
plot.network(net4,
             vertex.col = node_colors, #just one color
             displaylabels = F, # no node names
             mode = "kamadakawai", # another layour algorithm
             displayisolates = F # remove isolate nodes from plot
)
dev.off() # finishes plotting and finalizes pdf


# function to check network data integrity
Check_Network_Integrity <- function(network_object, # the network object we created
                                    n_edges_to_check = 10 # defaults to 10 edges
){
    # Make sure we are providing a network object to the function.
    if(class(network_object) != "network"){
        stop("You must provide this function with an object of class network!")
    }
    # Get network information and edges
    num_nodes <- length(network_object$val)
    edgelist <- as.matrix(network_object, matrix.type = "edgelist")
    names <- get.vertex.attribute(network_object,"vertex.names")
    # Make sure we do not ask for more edges than are in our network
    if(n_edges_to_check > length(edgelist[,1])){
        n_edges_to_check <- length(edgelist[,1])
    }
    # Select a sample of edges
    edges_to_check <- sample(x = 1:length(edgelist[,1]),
                             size = n_edges_to_check,
                             replace = F)
    #print out the edges to check.
    cat("Check source data file to make sure that the following edges exist:\n\n")
    for(i in 1:n_edges_to_check){
        cat(names[edgelist[edges_to_check[i],1]],"-->",names[edgelist[edges_to_check[i],2]], "\n")
    }
    cat("\nIf any of these edges do not match your source data files, there was likely a problem reading in your data and you should revisit the process.\n")
}

# run the function
Check_Network_Integrity(net4)
