
## EdFlix - Online Course Collection Platform

**EdFlix** is a web platform designed to help users discover and manage online courses. It provides a rich set of features to enhance the learning experience by allowing users to browse, review, and suggest courses. It also offers tools for administrators and trusted course providers to manage content and user accounts.

### Key Features:
- **Course Management**: Users can browse courses, view ratings, and suggest new courses. Administrators and moderators can evaluate and add or update courses based on user demand.
- **User Reviews and Ratings**: Learners can write reviews and rate courses to help others make informed decisions.
- **Personalized Recommendations**: Based on the user’s academic background and learning history, the system recommends relevant courses.
- **Account Management**: Administrators can manage user accounts, including the ability to suspend or restore user access.
- **Trusted Course Provider Management**: Trusted course providers can add and update their course information, including course images and links.
- **Password Reset**: Users can request a password reset via email, with secure time-limited links (1 hour validity).
- **Course Tagging and Filters**: Users can sort and filter courses based on duration, ratings, or by category using course tags.
- **AI Course Recommendations**: Users can enter search queries and receive AI-powered course suggestions tailored to their needs.

### Tech Stack:
- **Frontend**: The application uses Bootstrap to create a responsive and intuitive user interface for course browsing, reviewing, and recommending.
- **Backend**: Built using Sinatra, a lightweight web framework for handling server requests and business logic.
- **Database**: SQLite is used for data storage, managing user information, course data, reviews, and ratings.
- **User Authentication**: Session-based authentication ensures secure user login and session management.
- **Email Service**: Integrated with SendGrid to handle email-based password resets securely.

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
You will be directed to the main home page. You can sign up for an account as a learner but admin, moderator, manager and learner accounts have already been created.

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

