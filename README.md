# geo_chat

Imperial College London 2nd Year project.

GeoChat is a location based social network iOS application. Users can see
messages left by other users if they are within a set (user-adjustable) radius
to the location the message was left. Users can also start conversations with
other users by responding to these messages and can also upvote them to increase
their ranking. There is also a map view where users can browse messages left 
around the world. Lastly there is a user tab where users can see stats about 
their popularity.

The converstaion messages are stored in the device using a sqlite 3 database, 
but the messages left at locations are stored in a server. Server code is not
included here, only front-end code.
