const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

var msgData;
var childNode;

exports.ambulanceNotifier = functions.firestore.document(
    "Active_Ambulance/{ambulancdID}"
).onCreate((snapshot, context) => {
    msgData = snapshot.data();
	
	childNode = msgData.Child_Nodes;

    admin.firestore().collection("User_Token").get().then((snapshots) => {
        var tokens = [];
		
        if (snapshots.empty) {
            console.log("No Devices");
        } else {
			console.log("Going In!!");
			// console.log(childNode[0]);
			
            for (var token of snapshots.docs) {
				
				temp_uid = token.id;
				console.log(temp_uid);
				for (var nodeUID of childNode) {
					// console.log(temp_uid);
					console.log(nodeUID);
	
					if (nodeUID==temp_uid){ 
						tokens.push(token.data().Token_Value);
						console.log("Matched!!!");
					}	
										// else{
										// 	// console.log("Not working");
										// 	// console.log(temp_uid);
										// }					
				}	
            }
			var message = {
				notification:{title:"Ambulance!",
				body:"An Ambulance is coming your way.Please clear the path"},
				data: {
				  score: '850',
				  time: '2:45'
				},
				tokens: tokens,	
			  };

			admin.messaging().sendMulticast(message)
  .then((response) => {
    // Response is a message ID string.
    console.log('Successfully sent message:', response);
  })
  .catch((error) => {
    console.log('Error sending message:', error);
  });
        }
    });
	return null;
});