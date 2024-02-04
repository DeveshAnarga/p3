// *****PLEASE ENTER YOUR DETAILS BELOW*****
// T3-mns-mongo.mongodb.js

//Student ID: 32818866
//Student Name: Devesh Gurusinghe
//Unit Code: FIT2094
//Applied Class No: 1 (Monday 11-1)

//Comments for your marker:

// ===================================================================================
// Do not modify or remove any of the comments in this document (items marked with //)
// ===================================================================================

//Use (connect to) your database - you MUST update xyz001
//with your authcate username

use("dgur0007");

// 3(b)
// PLEASE PLACE REQUIRED MONGODB COMMAND TO CREATE THE COLLECTION HERE
// YOU MAY PICK ANY COLLECTION NAME
// ENSURE that your query is formatted and has a semicolon
// (;) at the end of this answer

// Drop collection
db.appointmentCollection.drop();

// Create collection and insert documents
db.createCollection("appointmentCollection");
var appointmentDocuments = [
    /* Array of JSON documents from 3(a) */
];
db.appointmentCollection.insertMany(appointmentDocuments);

// List all documents you added
db.appointmentCollection.find();


// 3(c)
// PLEASE PLACE REQUIRED MONGODB COMMAND/S FOR THIS PART HERE
// ENSURE that your query is formatted and has a semicolon
// (;) at the end of this answer

db.appointmentCollection.find({
    $or: [
        { items: { $elemMatch: { id: { $exists: true } } } },
        { item_totalcost: { $gt: 50 } },
    ],
});

// 3(d)
// PLEASE PLACE REQUIRED MONGODB COMMAND/S FOR THIS PART HERE
// ENSURE that your query is formatted and has a semicolon
// (;) at the end of this answer
db.appointmentCollection.updateMany(
    { "items.id": 1 },
    { $set: { "items.$.desc": "Paper points" } }
);

// Illustrate/confirm changes made
db.appointmentCollection.find({ "items.id": 1 });


// 3(e)
// PLEASE PLACE REQUIRED MONGODB COMMAND/S FOR THIS PART HERE
// ENSURE that your query is formatted and has a semicolon
// (;) at the end of this answer
db.appointmentCollection.update(
    { _id: 20 },
    {
        $push: {
            items: {
                $each: [
                    {
                        id: 3,
                        desc: "EDTA Cleansing Gel 17%",
                        standardcost: 8,
                        quantity: 1,
                    },
                    {
                        id: 4,
                        desc: "Irrigation Solution 2% Chlorhexidine",
                        standardcost: 9,
                        quantity: 1,
                    },
                    {
                        id: 8,
                        desc: "Irrigation Needle and Syringe",
                        standardcost: 2,
                        quantity: 2,
                    },
                ],
            },
        },
    }
);

// Illustrate/confirm changes made
db.appointmentCollection.find({ _id: 20 });
