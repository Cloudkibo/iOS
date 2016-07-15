## Contacts Management in Kibo App ##

Each device has to maintain local copy of data of user in sqlite database. We do this so that data is shown to user even when offline. We synchronise local database with server database at the time of installation of application.



**Adding a friend**

Your friend's phone number must be in your phone's address book in order for you to start a chat with them in KiboApp.

If you cannot see your friend in WhatsApp, please follow these steps:

1- Ensure that your friend has KiboApp installed on their phone.

2- Double check that your friend's phone number is  entered correctly in your phone's address book.



- Enter the number same as you would if you were to make a phone call to that person.


- If this is an international phone number, do not use any exit codes or leading 0s. Start all international phone numbers with a + sign, followed by the country code.

3- Open KiboApp and open the Favorites list. It will show Contacts which are on KiboApp

Contacts in your phone's address book that have KiboApp will be displayed in the Favorites list (Contacts tab on Android). In KiboApp, you can only start a chat with these contacts.

If you still do not see your friend in your KiboApp list, it is possible that your friend does not have KiboApp.



**Contacts in Database on Server**

On server side, our data is stored in Mongodb database. At the time of installation, we use Facebook AccountKit to authenticate phone number using SMS. It asks user to select country code from a list, enter mobile number and display name. After verification, contact details are stored on server in "accounts" table. Here is an example:

"phone":"+14258909414"
"country_prefix":"1"
"national_number":"4258909414"
"display_name":"jawaid"

For contacts, we have a mongodb collection called contactslist. 

**Contacts in Kibo Application Database**

Kibo application expose functions like :

Invite contact
Load contacts from server
Store/load contacts to and from sqlite database
Do proper synchronization to update data on both sides

In sqlite database, we have the replica table of contactslist table of server. One other table that we have on iOS local database is to store contacts from user's address book (shown in Contacts tab). This table has following fields:

name
phone
kiboContact (Yes/No)

Here is a basic flow diagram for Contacts Management:

![Contacts Design diagram](images/contactsDesign.png)

**Inviting new Contact**
From our Addressbook, some of contacts might not be Kibo users i.e. they have not registered themselves on Kibo App. In order to communicate with them using Kibo App, they should register on Kibo App. There are two ways for inviting any contact to Kibo App:

1- Inviting through Email
2- Inviting through SMS


- Inviting through Email


For each contact, we will store primary email address (if available) in local database. We will show the list of those users which are not on Kibo App and we have their email address saved in address book.

User can select one or more contacts from the list and email invitations will be send to selected user. User will be displayed a pre-written message:

Hey,

I just downloaded Kibo App on my iPhone. It is a smartphone messenger with added features. 

It provides integrated and unified voice, video, and data communication.

It is available for both Android and iPhone and there is no PIN or username to remember.



User can modify and make changes to this message. There is a functionality for sending invites to multiple contacts in one go.

- Inviting through SMS

For each contact, we store phone number in our local database. We will show the list of those users which are not on Kibo App. We show a list with their Names and Phone numbers.

User can select one or more contacts from the list and SMS invitations will be send to selected user. User will be displayed same pre-written message shown above. This message is editable.
