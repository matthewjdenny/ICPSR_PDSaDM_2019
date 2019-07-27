# ICPSR Short Course: Practical Data Science and Data Management (Summer 2019)

Hi! This is the course website for the ICPSR summer program short course on Practical Data Science and Data Management at the Univeristy of Michigan this summer. You can check out the official course webpage/ blurb [here](https://www.icpsr.umich.edu/icpsrweb/sumprog/courses/0275). This website will be updated over the course of this week with a full syllabus and links to all workshop materials.

You can email me at <matthewjdenny@gmail.com> with any questions. There are lots of additional materials available on my website at: <http://www.mjdenny.com/teaching.html>, but you will only need to look at the stuff linked to from this page in oder to be successful in this course. To download all of the materials associated with this course, you will want to start by downloading a GUI client for Git. 

* For Windows: <https://windows.github.com/>
* For Mac: <https://mac.github.com/>
* For Linux, you may have to rely on the command line, although <https://git-scm.com/downloads/guis> has some options (depending on your distro).

You will then want to `clone` this repo onto your computer using either the 

    https://github.com/matthewjdenny/ICPSR_PDSaDM_2019.git

link and your client or by clicking the "Clone in Desktop" button on the right hand side of the page. If you want to directly edit the files posted here and track your changes, you can copy individual files into another directory and create your own Git repo with the files in it. If you are not sure what any of the above meant, don't worry!  We will go over using Github at the beginning of the first workshop, so there is no need to spend too much time trying to figure Github out. If you are skipping the first two days, then just check out this  [**[Github pictorial]**](http://www.mjdenny.com/Data_Science_Tools.html). Welcome to the workshop!


* **Description:**  In this two day short course, participants will be introduced to core data science and data management concepts and techniques using the R programming language. This course is intended to arm you with the tools you will need to go from data collection up until the point at which you perform your analysis. Some topics we will cover include web scraping, using the Twitter API, the basics of working with large datasets, generating publication quality plots, and tools for working with text, network and panel data. This workshop will be taught using R, but will assume no previous experience managing data, or programming in R.

* **Goals:**  By the end of the workshop, participants should possess the basic skills necessary to perform most data management tasks they are likely to encounter over the course of a research project intended for publication as a scholarly journal article. Participants will also know how to collect large amounts of text data from the internet, and analyze those data. Additionally, we will cover the basics of working with large datasets, generating high quality plots, and working with network data.

* **Prerequisites:** No previous experience with R is required, and a number of tutorial resources will be provided before the beginning of the course. However, participants are expected to have some very basic experience working with data using software such as Stata, SAS, SPSS or Excel. Again, I want to stress that this course will be taught for people with minimal experience, so if you have significant experience working in R, then you will probably find that this course moves a bit slow for you.

### Schedule

This is a draft outline of the workshop schedule, it will likely change over the course of the workshop depending on how fast we end up going.

#### Before the workshop
Please download R and RStudio before the workshop. I provide dicrections below, as well as a screen-cast tutorial. If you have never used R before, you may want to look through some of the introductory examples listed below: 

* If you are using a Windows computer, start by downloading and installing RTools. It is very important that you do this first. If you already have R installed on your computer, download RTools and then reinstall R. You can download RTools here: <https://cran.r-project.org/bin/windows/Rtools/index.html> You will want to get "RTools35.exe" (or the newest stable version). You will also want to check the box to edit your system PATH variable while you are installing RTools. You can see an example ofhos this might look (although you shuld expect the screen to have a different path variable on your computer) by looking at the top picture in this post: <https://github.com/stan-dev/rstan/wiki/Install-Rtools-for-Windows>. Again, you will need to do this before installing R on a windows computer.
* Download R: <https://cran.r-project.org/>. Right at the top of the page, you will see links to download the latest version of R (currently 3.6.1, but there may be a newer version by the time you download it).
* Download RStudio: <https://www.rstudio.com/products/rstudio/download/>. Not that as a researcher, you can select the free license.
* This section of Quick R provides a basic overview of the R interface. You can navigate between pages by clicking on the links on the top left -- <http://www.statmethods.net/interface/index.html>. I still end up finding useful examples here, but do not find the website to be in the most conversational form. This is a useful starting point for basic example code, particularly for plotting and statistical tests.
* A nice place to start learning R interactively is [Swirl](http://swirlstats.com/). Note that this is probably the best "teach yourself" option for just messing around with code, but you will want to actually get R installed on your computer to do serious work. 

To make things easier, I have created a video tutorial that will walk you through installing R and RStudio on your computer. You can check it out by clicking on the video below:

[![Downloading and Installing R and RStudio](https://img.youtube.com/vi/0FWXWnPuxrs/0.jpg)](https://www.youtube.com/watch?v=0FWXWnPuxrs "Click on this screenshot to watch the video! ")


#### Monday 7/29/19

1. **9:00-10:00** We will go over high level materials including downloading and installing R, setting up RStudio and Github, and good project management habits. Follow-up materials: [**[R Power User Tutorial]**](http://www.mjdenny.com/Data_Science_Tools.html) 
2. **10:00-10:10** Break
3. **10:10-12:00** Introduction to R programming. [**[Basic R Programming]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Basic_R_Programming.R), [**[Basic Datastructures]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Basic_Datastructures.R)
4. **12:00-1:00** Lunch
5. **1:00-3:00** More R programming: [**[Looping and Conditionals]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Looping_and_Conditional_Statements.R), [**[Data I/O and R Packages]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Data_IO_and_Packages.R)
6. **3:00-3:10** Break.
7. **3:10-5:00** Functions  [**[Functions]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Functions.R), [**[Additional Functions]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Additional_Functions.R).
8. Overview of materials for today: [**[R Tutorial]**](http://www.mjdenny.com/R_Tutorial.html) 
9. **Homework** First Homework assignment. [**[Script Here]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/R_Programming_Assignment_1.R)


#### Tuesday 7/30/19

1. **9:00-10:00** Managing multiple datasets. [**[Script]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Managing_Multiple_Datasets.R) 
2. **10:00-10:10** Break.
3. **10:10-12:00** Managing multiple datasets [**[Script]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Managing_Multiple_Datasets.R), Performant Programming [**[Script]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Performant_Programming.R) 
4. **12:00-1:00** Lunch  
5. **1:00-2:00** Performant Programming (continued) [**[Script]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Performant_Programming.R) 
6. **2:00-3:00** Mini unit: Long and Wide Data  [**[Script Here]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Long_and_Wide_Data.R).
7. **3:00-3:10** Break. 
8. **3:10-4:00** Mini unit: Dealing with Messy Data  [**[Script Here]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Dealing_with_Messy_Data.R).
9. **3:10-5:00** Mini unit: basic plotting  [**[Script Here]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Basic_Plotting.R).
10. **Homework** Second Homework assignment. [**[Script Here]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Cleaning_Data_Assignment_2.R)

#### Wednesday 7/31/19

1. **9:00-10:00** Mini unit: producing publication quality plots and graphics (As time permits)  [**[Script Here]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Publication_Quality_Plots.R).
2. **10:00-10:10** Break
3. **10:00-12:00** Introduction to text processing in R [**[Script]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Working_with_Text_Data.R), [**[Tutorial]**](http://www.mjdenny.com/Text_Processing_In_R.html).  
4. **12:00-1:00** Lunch
5. **1:00-3:00** Basic web scraping in R:  [**[Script]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Basic_Web_Scraping.R). 
6. **3:00-3:10** Break
7. **3:10-5:00** Advanced web scraping [**[Script]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Advanced_Web_Scraping.R)
8. Time and interest permitting, we can go over some advanced topics including dealing with XML data.

#### Thursday 8/1/19

1. **9:00-11:00** Scraping Twitter:  [**[Script]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Scraping_Twitter.R), [**[Helpful Tutorial]**](https://github.com/SMAPPNYU/smappR), [**[StreamR Github]**](https://github.com/pablobarbera/streamR).
2. **11:00-11:10** Break
3. **11:10-12:00** Text processing using Quanteda. [**[Script]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Text_Processing_with_Quanteda.R)
4. **12:00-1:00** Lunch
5. **1:00-2:00** Text processing using Quanteda. [**[Script]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Text_Processing_with_Quanteda.R) 
6. **2:00-2:10** Break.
7. **2:10-4:00** Mini unit: social network data management  [**[Script]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Preparing_Network_Data_in_R.R), [**[Online Tutorial]**](http://www.mjdenny.com/Preparing_Network_Data_In_R.html) 
7. **4:00-4:10** Break.
8. **4:10-5:00** Synthesis exercise: [**[Script]**](https://github.com/matthewjdenny/ICPSR_PDSaDM_2019/blob/master/Scripts/Scraping_Example.R).
9. Time and interest permitting, we can cover advanced topics in text processing.

## Resources

* A nice place to start learning R interactively is [Swirl](http://swirlstats.com/).
* Quick-R has a bunch of easy to read tutorials for doing all sorts of basic things -- <http://www.statmethods.net/>.
* Hadley Wickham wrote a book that covers a bunch of advanced functionality in R, titled **Advanced R** -- which is available online for free here -- <http://adv-r.had.co.nz/>.
* Hadley Wickham has an R package `rvest` for web scraping that is detailed in this [blog post](https://blog.rstudio.org/2014/11/24/rvest-easy-web-scraping-with-r/).
* A blog post by Charles Dimaggio that I have referred to in the past: [blog post](http://www.columbia.edu/~cjd11/charles_dimaggio/DIRE/styled-4/styled-6/code-13/).
* Another blog post by Zev Ross that I have referred to in the past: [blog post](http://zevross.com/blog/2015/05/19/scrape-website-data-with-the-new-r-package-rvest/).
