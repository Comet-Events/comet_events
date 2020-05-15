# Comet Event Dev Documentation

Hai! This markdown document is intended for the purpose of assisting developers on the Comet Event team. It includes documentation on how to utilize the **ViewModelWidget** & **UserViewModelWidget** (state management), as well as an explanation and guide to **Git Flow**, this project's Git workflow. 

# State Management

*Skip to* **ViewModelWidget & UserViewModelWidget** *to get to the important stuff*
Code to display a button, and code to fetch data from a backend do not belong in the same place. Aside from keeping track of the app state, our state management system serves as a way to split UI and logic components of our app. It is quite difficult to do this in Flutter without ending up with logic and UI code scattered on the same file. Widgets like **FutureBuilder** and **StreamBuilder** may work for  smaller projects, but can be hard to handle when scaling an application, and only keep track of the state of a single **Future/Stream** process, rather than the entire screen. Handling the rebuilding of the widget when a variable changes increases in difficulty the more variables a screen is keeping track of, and is considered 'logic', which goes against our ideology of separating UI and logic.

To solve this, our state management system makes it possible for each widget (can be from a small button to an entire screen) to have **its own corresponding view model**. This **view model** holds all the logic and variables (variables tied to logic) for its widget. From functions that fetch external data, to functions that interact with phone features and user settings, all logic for a screen or widget resides in these **view models**. 

## ViewModelWidget & UserViewModelWidget

The **ViewModelWidget** and **UserViewModelWidget** are custom widgets designed with this state management system in mind. *They are the widgets that tie the logic and UI together.* These widgets are placed in a position in the widget tree whose children require functions and logic to operate (usually at the top of the screen widget). If the whole screen is dependent on the view state/logic, then these widgets will **probably** need to be **the first thing that you'll add after the 'return' statement.**

### Simple Example of 'ViewModelWidget'

    // HomeScreen widget
    @override
    Widget build(BuildContext context) {
	    return ViewModelWidget<HomeModel>(
		    builder: (context, model, child) {
			    // 'model' refers to the view model instance.
			    // you can access all the variables and functions
			    // in this view model. If the data changes, the UI 	  
			    // will automatically rebuild by itself. magic!
				return Text("Results from database: " + model.result);
				// 'result' is a variable from our model
			}
		);
	}
	    
	    

### Simple Example of 'ViewModelWidget' that checks for ViewState

Each view model has its own 'state' variable of type **ViewState**. 'state' changes depending on what's going on in the model. For example, if the model is fetching data, then 'state' will probably be set to **ViewState.Busy**. When fetching data is done, 'state' will be set to **ViewState.Idle**. When the 'state' variable changes, the widget is rebuilt (UI updates).

    // HomeScreen widget
    @override
    Widget build(BuildContext context) {
	    return ViewModelWidget<HomeModel>(
		    builder: (context, model, child) {
			    switch(model.state) {
				    case ViewState.Busy:
					    // return a loading thing idk
					case ViewState.NoConnection:
						// return a message saying check ur internet,
						// with a try again button
					case ViewState.Idle:
						// return the regular UI code.
						// expect to have all the variables and
						// functions you need ready to be used! 
						// (ex: model.eventArray, model.fetchStuff())
			    }
			}
		);
	}

### Simple Example of 'UserViewModelWidget' + Explaination

**UserViewModelWidget** is an enhanced version of **ViewModelWidget** that I made specifically to work parallel with the Firebase Authentication service. This widget provides an extra 'user' variable, which is a FirebaseUser variable that holds all the data for the currently logged in user. It is a stream, and when the variable updates (ie. when the user signs in/out, etc.), the UI automatically rebuilds, like magic. It's so fking convenient omg y'all gonna love this:

    // HomeScreen widget
    @override
    Widget build(BuildContext context) {
	    return UserViewModelWidget<HomeModel>(
		    builder: (context, model, user, child) {
			    if(user == null) // send them to the login screen
			    else {
					return Text("Welcome " + user.displayName);
					// or the rest of your screen widget
				}
			}
		);
	}

## Development Guide ["Frontend + UI" team]

When working on the UI side of a screen, a developer on the Frontend team should create a UI for three different **base** view states*: 

 - **ViewState.Busy** *when the view is loading/processing/buffering*
 - **ViewState.Idle** *when the view has finished loading and is in a normal state*
 - **ViewState.NoConnection** *when internet connection has been cut (if the view does not depend on internet connection, then you really don't need to design a UI for this scenario.)*

After creating a new feature branch for your feature (*refer to Git Flow portion of the documentation*) you should follow these steps:
![Here's a flow chart of the steps](https://i.ibb.co/By4PMYW/Screen-Shot-2020-05-12-at-7-05-16-PM.png)

*Based on the needs of the view/screen, you can ask the **view model** developer ["Backend + Middleware" team] to create an extra view state (ex: ViewState.SpecialState). The same works vice versa, where the **view model** developer may request a UI for an extra view state that may be necessary. However, this is only necessary in specific scenarios for complex screens.

#### **View Model Request
View model requests should be made in the GitHub under the **Issues** tab. Create a new issue by selecting the **Issues** tab, then selecting the green **New Issue** button. You'll be presented with a text editor. 

1. Give your issue a 'view model request' tag by clicking the **Labels** button on the right of the text editor, then selecting the right label.
2. (Optional) You can assign this request to a specific person on the team by clicking **Assignees** on top of **Labels**, and choosing a person.
3. Give the issue a title. For consistency, lets make the title format `<NameOfWidget/Screen> view model request`
4. For the content of the request, **copy the following**, then change/add the variables and functions to what you need. When you are done, feel free to click the **preview** tab (right next to the **write** tab) to see how it will look.

```
### <This is a description of the screen/widget you're working on. These functions/variables are just dummy text, so change them to what you need>:

## Variables
- `model.anArray`: String[]
This variable should have an array of results from an api

## Functions
- [ ] `model.loginEmailPassword(String email, String password)` -> `Future<bool>`
This function is supposed to log the person in with a generic email and password. Return whether the process was successful or not (boolean).

- [ ] `model.loginGoogleAuth()` -> `Future<bool>`
This function is supposed to log the person with Google Auth (a popup that makes them sign into their gmail). Return whether the process was successful or not (boolean).

```



# Git Flow

Git Flow is our git workflow. This is how we'll manage to keep things organized while working on this project. 


## How It Works

I could explain git flow in my own words, but I found this resource to explain it so well, that it would honestly just be better to read this. This is quite a long web page, so these links take you to the parts of the page that are important.

#### I'd recommend you thoroughly read these categories
- [The Main Branches](https://nvie.com/posts/a-successful-git-branching-model/#the-main-branches)
- [Feature Branches](https://nvie.com/posts/a-successful-git-branching-model/#feature-branches)

You can skim through the rest, (stuff about hotfixes, releases, etc) are not too necessary for now, although it would be good to read them.

### ⚠️ [Important] Other Resources

- [gitflow](https://github.com/nvie/gitflow) *is a command line tool that makes using Git Flow SOOO much easier. Please install the tool from this [link](https://github.com/nvie/gitflow/wiki/Installation)

- [This](https://www.youtube.com/watch?v=BYrt6luynCI&t=155s) *is a YouTube tutorial that explains how to use this tool. Please watch it (x1.25/1.5 speed is best cuz i* 🥱).