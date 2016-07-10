## Contacts Management in Kibo App ##

Each device has to maintain local copy of data of user in sqlite database. We do this so that data is shown to user even when offline. We synchronise local database with server database at the time of installation of application.

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
