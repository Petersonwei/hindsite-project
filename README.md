# HINDSITE (Developer Challenge)

For this challenge you will be creating highly simplified version of the Hindsite web app from scratch using Ruby on Rails. This is a functional challenge, so you don't need to worry about design too much. You should use Git as you build your solution. Note, this doesn't need to be hosted on any services such as AWS/Azure, just show us it running on your machine!

Your app is to have three models: users, organisations, and posts. Your database should closely resemble the following entity-relationship diagram:

<img width="609" alt="Screen Shot 2022-03-28 at 5 34 52 pm" src="https://user-images.githubusercontent.com/23489664/160348800-9dc08ba4-def9-46e1-9526-24858b850b59.png">


## How your app should work
The following illustrations should only serve as an example. You do not need to follow the designs presented below. You can split functionality out to other pages. Just make sure it is all there.

An unauthenticated user should first be prompted to log in, sign up, or reset their password:

<img width="426" alt="Screen Shot 2022-03-28 at 4 57 11 pm" src="https://user-images.githubusercontent.com/23489664/160342860-2d3a0d5c-4985-4de9-b593-e7e67373303b.png">


To have a user sign in to the application, we'll need a sign up page.

<img width="441" alt="Screen Shot 2022-03-28 at 5 41 08 pm" src="https://user-images.githubusercontent.com/23489664/160349839-c3ebb2e4-2cf7-4f20-b04f-e46c5cfa5e9c.png">


Once a user has signed up, the home page should be an overview of actions for that organisation: viewing posts, editing the organisation, or leaving the organisation.

<img width="321" alt="Screen Shot 2022-03-28 at 5 53 06 pm" src="https://user-images.githubusercontent.com/23489664/160351865-d49950f0-cff8-43aa-9c2b-c5ab4cc6e1e4.png">


Leaving an organisation should allow the user to belong to no organisation and can be invited to another organisation. The departed user's posts should be deleted.

Finally, the post page should show all posts that belong to the user and their fellow employees at their organisation.


## Optional exercises

Here are some optional exercises for you to do. We recommend that you try at least one of them. They are all mutually compatible, so you could do all of them. Some will require changes to the structure of the database.

1. Users details (easy)
Allow users to change their own name, email address, or password.

2. Modifying/Deleting Posts (easy)
Allow users to modify or delete existing posts.

3. Departed Employee Post Storage (easy)
Create a way for posts of a departed employee to be stored. Create a link on the "View Posts" route that would direct a user to a table of prior employees posts. You may need to make schema changes for this exercise. Bonus: If a departed employee re-joins the organisation, have a way for their past posts to be re-added to current posts.

4. Filtering posts (medium)
Allow users to filter which posts are visible based on employee or a date range or both.

5. Multiple organisations (tricky)
Extend organisation functionality to allow users to belong to more than one organisation. You will need to rethink the posts model. Posts currently belong to a user (who belongs to a single organisation). If there are multiple organisations involved, this falls apart, because you don't know which organisation the user posted to.

7. React frontend
Use React functional components to build the frontend on your Rails application.

7. Functional or Unit tests
Adding tests is a good idea. We don't mandate that you write any for this challenge, but feel free to go ahead and write some tests for your code.

8. Your own idea
Feel free to add a feature of your own devising.

You will be judged on the the appropriate use of database constraints, your choice of data types, working data validation, the general quality of your code, and how closely your solution matches this spec. Be a show off! Impress us with your strong command of relational databases and idiomatic code.
