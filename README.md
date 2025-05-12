When accessing system resources or using system capabilities in an app, permission applications are required. This approach is used to protect users' personal data and information security. 
Objects of application permission protection can be divided into data, such as personal photo albums, contact lists, location information, etc.; and functions, such as the microphone, camera, etc.

##Overview

#Application Principles

Declaration in the configuration file.
The principle of minimum application: do not apply unless necessary, and apply only before use, without affecting the use of services that are not related to the permissions.

#Authorization Methods

Permission types are divided into system_grant (system authorization) and user_grant (user authorization).
System_grant (system authorization) is a permission type with a relatively low risk level and does not involve sensitive information of users and devices. The system will automatically authorize it during the installation of the program, for example, network permission.
User_grant (user authorization) is a permission type with a relatively high risk level and involves sensitive information of users and devices. When applying for this type of permission, a pop-up window is required to request user authorization processing.
Permission Groups and Sub-permissions
When applying for multiple permissions simultaneously, multiple pop-up windows will be displayed, which affects the user experience. To enhance the user experience, the system combines logically closely related user_grant permissions together to form a permission combination, so that only one pop-up window needs to be displayed.
Basic Concepts of the Permission Mechanism
The APL level of an application corresponds one-to-one to the APL level of a permission.
APL level of an application.

![image](https://github.com/user-attachments/assets/3ba942ba-e27f-45af-9e0c-02bab4342979)

#The APL level of permissions

![image](https://github.com/user-attachments/assets/085027d6-9aac-44a4-9211-733320b32e73)

##Applying for Application Permissions

![image](https://github.com/user-attachments/assets/d3a8ee25-d576-495f-8c15-ac52bf831f58)

##Declaring Permissions

#When declaring permissions, you need to make entries in the module.json configuration file.

![image](https://github.com/user-attachments/assets/3440d327-1e79-4066-bf54-1813f2fd15b6)

Note: When applying for user_grant permissions (i.e., permissions that require a pop-up window for authorization), reason and usedScene are mandatory fields. For low-risk permissions like network access, these fields are optional.

![image](https://github.com/user-attachments/assets/b5778e0f-3194-407a-ad41-8ffaba123f15)

##Requesting User Authorization

When applying for user_grant permissions (e.g., location access, calendar access), you must request explicit authorization from the user.

Implementation Steps:

Declare the permissions in module.json.

Check if the user has already granted the permissions.

If not granted, show a permission request dialog.

Handle the user's authorization result.

Practice Example: Requesting Location Permissions

Specify the permissions to request:

ohos.permission.LOCATION

ohos.permission.APPROXIMATELY_LOCATION

Configure these permissions in module.json.

![image](https://github.com/user-attachments/assets/04329336-dc66-45e4-9b1a-d126748df389)

##Summary


● Permissions are divided into system_grant (system authorization) and user_grant (user authorization). Among them, the permissions of user authorization have a higher risk level. Therefore, when applying, user confirmation is required through a pop-up window, and the authorization reason (reason) needs to be written in the configuration file.


● When an application applies for permissions, it needs to pay attention to the APL (Access Permission Level) of the permissions. The APL level of the application determines the scope of permissions that can be applied for, and it can only apply for permissions that match its own APL level.


