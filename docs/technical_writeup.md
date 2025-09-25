# API Documentation
- `localhost:8000/search`
    Parameters:
    - `query` (required): Food name to search
    - `page`: page number
    - `page_size`: page size
    The backend automatically handles `page` and `page_size` to continuously serve results.
- `localhost:8000/foods/{fdc_id}`
    Parameters:
    - `fdc_id` (required): food database id number
- `localhost:8000/docs`
    This can be accessed through a browser to view and test the top two endpoints

# Writeup
## Summary of the solution
This solution is pretty straightforward, it serves as an interface over the USDA api. You search for a food, the server then queries USDA for foods matching the name, then it returns a list of foods found in the USDA to the user. The user then can click on a food and view details such as calories, protein, carbs, etc. This solution works when deployed and run on a local machine, it does not support being run from one machine and accessed from another.
## Challenges faced and solutions implemented
The main challenge here was time. With less than a day to complete the assignment, a lot of shortcuts were used. For example, instead of utilizing nginx's proxy system, this solution just uses localhost for communication between the front and back end. This solution works if and only if the application is accessed from the same machine it runs.
Another issue I ran into with this project was that the template was incomplete in its setup. The reason I have the user install flutter and run a build command was because automatically building doesn't come out of the box with this template. Additionally, the flutter packages the template used were not kept up to date, so I had to go in and make sure of that as well.
## Potential improvements for production deployment
There are a lot of improvements that could be made to make this app production-stable. First, I would make sure the nginx container is actually proxying the traffic to where it's intended to go. This can be fixed by appending an '/api' to the beginning of each of the backend's endpoints and configuring nginx to route to those containers.
Another thing that would be done is to make sure that the front end code, specifically the component that's responsible for searching, is portable.
On the note of architecture, I think this is a bad one. I don't have confidence that a Docker Compose app could be used in a real production capacity. I could be wrong, but I just don't think this architecture is as scalable as it should be. Realistically, the backend would be a serverless implementation on the cloud and the app would be fully cloud-native.
There of course is the note of unit testing, which is non-existent in this solution. Realistically, unit testing should be done to ensure the app is robust.