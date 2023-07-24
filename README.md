# Òkè point

Share location in realtime.

## Overview

The Òkè point softwares(mobile&web) is built from ground up using google flutter sdk. Since, flutter renders everywhere we're targeting related to ui i.e web & mobile. We'll be using it in large scale for this purpose of implementing the ui as it does not have any limitations.

**This document will help us create a well-structured flutter codebase that is easy to read, maintain and scale by using consistent folder structure, separating UI code and business logic, and also efficiently controlling our app state using Riverpod and ensuring our code is as well testable**.

### Why Òkè point?

Base on a terrible event that happened to me late June, 2023. See tweet [here](https://twitter.com/edeme_kong/status/1680590934835179522). I decided to make this app which will help mildly counter this sort of events not to go wildfire or repeat itself.

This is a personal project however,cc & contributions are welcome. I will be posting weekly log here on my [YT channel](https://www.youtube.com/@flutterfairy/playlists) & my [Twitter(X) handle](https://twitter.com/edeme_kong).

### What is Òkè point?

Òkè point(SharePoint) is a realtime IO location tracker software(web&mobile), which will help it users share their locations, attached with their current mode(emergency) to their loved once and modes professionals(Police, legal help etc).

## Getting Started(Dev)

To be able to contributor to this project, you should do this:

- Install flutter, git and any code editor of your choice
- Fork & star the repo
- Clone to your machine
- Make your first contribution either by fixing a bug or writing a new feature!

To launch this project. Run from Run & Debug tab on your VScode or run on terminal `flutter run`

### Pattern(MVC):

In this project, we’ll be using the model-view-controller(MVC) pattern as an approach to enable us separate concerns and promote a modular scalable codebase.

In our use case controllers will be states i.e where we write our business logics.
MODEL => CONTROLLER <=> VIEW

### Folder Structure

lib|
---data| `// data layer. models, repositories, service and states`
---UI| `// ui layer. components, screens and theme`
---constants| `// reusable app constants`
---utils| `// reusable extentions getters/methods, app validations etc`
---configs| `// flavors & environment configs`
test| `// widget testable test codes & cases`

### State Management(Riverpod):

With Riverpod, we can create Providers that are scoped to different parts of our app and can easily read, update and disposed of it anywhere in the app.

If you a Provider user, then Riverpod will be easy for you as it uses almost the same principles of accessing data from top level scopes anywhere in an app.

### Navigation(GoRounter)

To suitably tackle how web routing works, and as well as the mobile side of things. I decided to go with go_router because of it ability to sustainably tackle this problem with the navigation 2.0 api.
