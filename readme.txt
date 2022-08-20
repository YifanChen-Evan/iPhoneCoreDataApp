Readme

------------------------------------------
For Models:

This is an Apple application about "Los Angles Lakers" team of NBA, which can provide some basic information about 17 players and support user to add or delete players. It contains 3 entities and 2 tables.


------------------------------------------
For Elements:

In XML file (players.xml), it contains the name, starting team, position, date of birth, number, photo, height, weight, introduction, as well as links to NBA profile and social media accounts for each of the 17 players. I can generate the initial Core Data content from the players.xml file.


------------------------------------------
For Entities:

It contains 3 entities (Player, Collect and NBA).

-"Player" used to save player data.

-"Collect" used to create favourites function.

-"NBA" used to create an NBA Game List, which can be edited by user to update NBA Game time, score or something like that.


------------------------------------------
For Layout:

This application includes 7 screens.

-First screen (Players Table): It's a TableViewController and uses Core Data. I use the custom style to show the names, birthday, position, number and photos of each player. In addition, I create expandable sections based on positions, which works well for classification and finding players. There are six sections, such as Center-Forward, Forward, Forward-Center, Forward-Guard, Guard and Guard-Forward. I also set their width and height of each cell. Apart from that, I create a favourites feature, which allows user to add favourite athletes to their favourites.

-Second Screen (Player Details): It's a ViewController. I use a UIView as a container to put all information, including From, Position, D.O.B, Num, Height and Weight. In addition, when you click "Intro" button, you will see a Wikipedia introduction on selected player. Besides, there is a favourites button.

-Third Screen (Player Text Introduction): It's a ViewController. I use UIView to create a music player box. And I set a background image for "Play Music" button. When you click the image, it can play an uplifting music. A TextView is used to display Wikipedia introduction on selected player. Apart from that, there are two button "Profile" and "Social Media" can take you to see some website information.

-Fourth Screen (Player Websites): It's a ViewController. It includes a WebKit View to display associated website.

-Fifth Screen (Add/Edit Player):  It's a ViewController. It allows user to input/edit the player's personal information and save it to Players Table. At the same time, it also supports user to select a photo from the gallery as the player's image.

-Sixth Screen (Favourites Table):  It's a TableViewController and uses Core Data. When user clicks the favourites button at the top right of Players Table screen, it will jump to this screen. It can show all players who user likes. At the same time, a delete operation is also available in this screen, which will remove the player from the favourites.

-Seventh Screen (NBA Game List):  It's a ViewController and uses Core Data. Its main purpose is to provide user with an area where NBA Game information can be recorded. User can click on the upper right corner of the screen to create a new game information. When clicking on an existing game, it can also be edited and deleted.


------------------------------------------
For Personal Technical Contributions:

I set a launch screen to display NBA logo and "Los Angles Lakers" team logo, which can tell user what this is an application.

I create a XMLPlayerParser.swift to generate the initial Core Data content.

I create 3 entities for this application.

I create an expandable section table to show players' list, which can more flexible and organized.

I make a favourites feature. This personalisation function provides convenience for users to use. The favourites feature in the table is consistent with the favourites feature on the selected player's detail screen. User can click any of the two favourite buttons to favourite the player.

I make a NBA Game List to allow user to add/update some recent game information, such as game date, opponent and score. This feature provides user with more freedom of operation space. User can add new items, modify or delete existing items.

I create a position option in DetailsViewController.swift, which can allow user to choose a position for player without having to enter it manually.

I create a date picker in DetailsViewController.swift, which allows user to select a specific date without having to enter it manually.

I set a rounded corner style and add a border for buttons.

I make a music player, which can make user more relaxed and happy when they are reading the introduction in the Third Screen. It mainly consists of UIView, Button and Label. I pick an image as the background of "Play" button. Besides, I set the UIView using rounded corner style, adding a border and shadow effect.

I link buttons with website like NBA Profile and Social Media (Instagram, Facebook), which can provide more information about selected player.
