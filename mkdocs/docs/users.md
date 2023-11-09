---
description: Create users, reset passwords, access the admin interface.
---

# User Management

For now, **Tube Archivist** is *mostly* a single user application. You can create multiple users with different names and passwords, they will share the same videos and and channels. You can configure some permissions and some configurations are on a per user basis. *More is on the roadmap*.

## Superuser
The first user gets created with the environment variables **TA_USERNAME** and **TA_PASSWORD** from your docker-compose file. That first user will automatically have *superuser* privileges.

## Admin Interface
When logged in from your *superuser* account, you are able to access the admin interface from the settings page or at `/admin/`. This interface holds all functionality for user management.

## Create additional users
From the admin interface when you click on *Accounts* you will get a list of all users. From there you can create additional users by clicking on *Add Account*, provide a name and confirm password and click on *Save* to create the user.

## Read Only User
To create a user with limited permissions, remove the **Is Staff** and **Superuser status** permissons. This will make this user a *read only* user, meaning among others, this user will not be able to add anything to the download queue, delete anything, etc.

!!! note "Minimally Tested"
	This is mostly meant as a *kids mode* or similar, this will most likely not hold against a sophisticated attacker.

## Changing users
You can delete or change permissions and password of a user by clicking on the username from the *Accounts* list page and follow the interface from there. Changing the password of the *superuser* here will overwrite the password originally set with the environment variables.

## Reset
Delete all user configurations by deleting the file `cache/db.sqlite3` and restart the container. This will create the superuser again from the environment variables.

!!! note "BE AWARE"
	Future improvements here will most likely require such a reset.
