# Team 45's Edflix Project
Welcome to Team 45's Edflix project.

## What are we doing?
In semester 1, we interpreted and elicited requirements of a system, to satisfy a client brief, using an Agile approach.
We formulated user stories, acceptance criteria, estimations, and prioritisation, as a team. 

In semester 2, we are now developing a web application. We are using Ruby and Sinatra, with SQLite relational database backing, using Sequel, and then testing the web application using RSpec.

## How to clone our repository?
If you want to clone our repository, please follow these steps below:
1. Once you are in Team 45's Project repository, click on the blue "Clone" button next to the download button.
  - You can git clone using HTTPS or SSH key.
2. Click on the button next to the link, to copy the url

3. Go to your codio terminal and type "git clone <LINK>". For example:
  - If you are using HTTPS:
```console
git clone https://git.shefcompsci.org.uk/com1001-2022-23/team45/project.git
```
  - If you are using the SSH key:
```console
git clone git@git.shefcompsci.org.uk:com1001-2022-23/team45/project.git
```

## How to run our web application?
**Commands to run in the terminal:**
1. This will redirect you into our project folder.
```console
cd project
```

2. The following command will download the gems needed to run our web application.
```console
sudo bundle install
```

3. After the gems have been installed successfully, run the following command to run our web application:
```console
sinatra
``` 
This will provide you with a link. Click on the link, and our web application will appear in a new tab.
You will be directed to the main home page. You can sign up for an account as a learner but admin, moderator, manager and learner accounts have already been created, in compliance with the assignment brief.

| Username      | Password      | Email                    |
| ------------- | ------------- | -------------------------|
| admin1        | admin1        | admin1@admin.com         |
| learner1      | learner1      | learner1@learner.com     |
| learner2      | learner2      | learner2@learner.com     |
| manager1      | manager1      | manager1@manager.com     |
| manager2      | manager2      | manager2@manager.com     |
| moderator1    | moderator1    | moderator1@moderator.com |
| moderator2    | moderator2    | moderator2@moderator.com |


  * Click on the "Get Started" button and it will bring you to the sign up page or click on the "Sign in" button at the top right corner of the page.
  * Sign in with the given credentials to access their respective dashboards.
  * Do not forget to sign out at the end!

4. Use Ctrl-C to stop the web application.

## How to run the tests?
**To run all tests and generate coverage report:**
1. Make sure you are in the project directory

2. You can check by using the following command:
```console
pwd
```
3. If you are not, run the following command:
```console
cd project
```
1. Go to the spec directory
```console
cd spec
```
4. Run the command 
```console
rspec *
```


**To run End to End tests:**
1. Go to project
```console
cd project
```
2. Go to the spec folder
```console
cd spec
```
3. Go to the features folder
```console
cd features
```
4. Run file
```console
rspec <file name>
```


**To run unit tests:**
1. Go to project
```console
cd project
```
2. Go to the spec folder
```console
cd spec
```
3. Go to the unit folder
```console
cd unit
```
4. Run file
```console
rspec <file name>
```