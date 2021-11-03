const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const stripe = require('stripe')(functions.config().stripe.testkey);

exports.stripePayment = functions.https.onRequest(async (req, res) => {

    const paymentMethod = await stripe.paymentMethod.create({
        type: 'card',
        card:{
            number: req.query.number,
            exp_month: req.query.exp_month,
            exp_year: req.query.exp_year,
            cvc: req.query.cvc
        }
    })

    const paymentIntent = await stripe.paymentIntents.create({
        amount: req.query.amount,
        currency: req.query.currency,
        payment_method_type: ['card']
        // billing_details: req.query.billing_details 
    }, function(err, paymentIntent){
        if(err != null){
            console.log(err);
        } else {
            res.json({paymentIntent: paymentIntent.client_secret})
        }
    })

    const paymentIntent = await stripe.paymentIntents.confirm(
        'pi_3Jj5XFDvGyhPlIEQ0AbEszz1',
        {payment_method: 'pm_card_visa'}
      );


})