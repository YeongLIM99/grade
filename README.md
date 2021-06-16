# **Predict Your Grade**

## **About**

Predict your grade is a small **web application** that helps to **gain insight about the average grade of a student** based on several factors that is taken into considerations. This is a group project for **WIE2003 Introduction to Data Science course**.

## **Feature of the application**

1. Dataset Exploration
2. Grade Prediction

## **Possible stakeholders**

1. Teachers
2. Parents
3. Students

## **Programming language used**

For this project, we had used **R** programming language entirely as it is being taught in the course.

### **Packages used**

Throughout the project, we had use several packages as follows:

1. dplyr (A package helps us on the data manipulation process.)
2. ggplot2 (Chart visualisation package.)
3. randomForest (A package that contains random forest model.)
4. rsconnect (A package that helps us connect to the live server on the web.)
5. shiny (A package that helps us to develop shiny app (UI and Server).)
6. shinydashboard (UI package.)

## **Link to the web application**
https://limweiyeong99.shinyapps.io/grade/

## **Link to the presentation slide**
https://rpubs.com/JiaSoon/studentsperformance

## **Link to the report in markdown format**
https://rpubs.com/YeongLim/grade

## **Web application development process**


### 1. **Problem and Objective Definition**
i.   What are the factors that can affect grade of students?

ii.  How much do these factors affect grade of the students?

iii. What is the relationship between these factors?

### 2. **Data Acquisition**

We need to find a data set to solve the problem and achieve the objective as stated. Luckily, we had located a related data set that can be used throughout this project. The link for the dataset is under the section *Link to the dataset*. The dataset does contain a lot of usable features.

#### **Data Dictionary**

Information regarding this can view at the dataset website.

### 3. **Data Cleaning**
We rename some of the column names to more appropriate names, where we check for null value and duplicate as well. Some columns which are not interact with what we plan for the project are removed.

### 4. **Exploratory Data Analysis**
Some graphs such as pie chart, and histogram being plotted to show relationship for the column variables to the Average.result, where we removed some of the columns here as well.

### 5. **Feature Extraction**

Due to the large amount of features available in the dataset, we had extracted several common factors for the prediction purpose.

The following features are extracted:

1. Age
2. Time.from.home.to.school
3. Number.of.past.class.failures
4. Extra.educational.support
5. Family.educational.support
6. Extra.paid.class
7. Extra.curiccular.activity
8. Attended.nursery.school
9. Aims.for.higher.education
10. Internet.access
11. In.romantic.relationship
12. Average.result

### 6. **Building Prediction Model**

Since the average result is a type of **continuous variable**, therefore it is clearly to use **supervised learning regression model**. There are several regression model can be used for our prediction. We choose **Random Forest Regression model** to predict the average result. Random Forest Regression model is an ensemblem learning with multiple decision tree. It has the advantages on dealing with non-linearlity.

The dataset obtained from the feature extraction is splitted into two, which used for training (70%) and testing (30%). Based on our testing set result, the prediction model has a **root mean square error (rmse) between 3 to 4**, which is relatively moderate.


### 7. **Application Development**

After selecting the prediction model, we are moving to the quick prototype process using R shiny. The features on the web application is the same as planned. After we see the success of quick prototype, we use additional packages to beautify the web application, so that it looks attractive instead of black and white. The link for the end product is under the section *Link to the web application*.


## **Project Experience**

Throughout this project, we had learnt a lot on the development of the data product through regular Data Science process. There are a lot of **challanges** faced throughout the project period as follow:

1. Defining a good question for the project.
2. Inexperience in selecting prediction model.
3. Communication due to the online learning environment.
4. Lack of experience in R programming language.

We always tried the best to solve the above challanges as those are the big road blocks faced during the project period. At the end of the day, We are able to develop a data product as a group before the deadline of the submission. We are feeling great for the outcome of the project.

With the experience on the challanges above, we are more confidence in creating data product following Data Science process in this Covid-19 pandemic era.

## **Contributors**

1. Lim Wei Yeong (Project leader)
2. Ng Phoon Ken
3. Gan Jia Soon
4. Ng Zi Xiang

## **Link to the dataset**

Student Performance DataSet [Data Set Link](https://archive.ics.uci.edu/ml/datasets/student+performance)
