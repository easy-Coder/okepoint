# òkè point
Share location.


# Code Structure
## Objective:
This document will help us create a well-structured Flutter code-base that is easy to read, maintain and scale by using consistent folder structure, separating UI code and business logic, efficiently controlling our state with a given state management solution and ensuring our code is as well testable and documented.
A well-structured code-base will reduce complexity, improve our workflow and allow faster iteration and bug fixing.

## Architectural Pattern(MVC):
In our app, we’ll be using the Model-View-Controller (MVC) architectural pattern approach as it will enable us to separate our concerns and promote a modular and scalable codebase.

In our use case Controllers will be State(Where we write our business Logics).
MODEL   =>  CONTROLLER(state)   <=> VIEW


## State Management(Riverpod):
We’ll use Riverpod as a State Management solution because of its vast power to handle and control states.
It is based on the Provider pattern, which allows us to provide a value to a widget and its descendants. With Riverpod, you can create Providers that are scoped to different parts of our app and that can be easily accessed and updated anywhere in our app.
