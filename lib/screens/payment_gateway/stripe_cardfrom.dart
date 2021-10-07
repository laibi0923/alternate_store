

import 'package:alternate_store/widgets/set_cachednetworkimage.dart';
import 'package:awesome_card/credit_card.dart';
import 'package:awesome_card/style/card_background.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';

// import '../../models/card.dart';
// import 'card_cvc_form_field.dart';
// import 'card_expiry_form_field.dart';
// import 'card_number_form_field.dart';

/// Basic form to add or edit a credit card, with complete validation.
class CustomizeCardForm extends StatefulWidget {
  CustomizeCardForm(
      {Key? key,
      formKey,
      card,
      this.cardNumberDecoration,
      this.cardNumberTextStyle,
      this.cardExpiryDecoration,
      this.cardExpiryTextStyle,
      this.cardCvcDecoration,
      this.cardCvcTextStyle,
      this.cardNumberErrorText,
      this.cardExpiryErrorText,
      this.cardCvcErrorText,
      this.cardDecoration,
      this.postalCodeDecoration,
      this.postalCodeTextStyle,
      this.postalCodeErrorText,
      this.displayAnimatedCard = !kIsWeb && false})
      : card = card ?? StripeCard(),
        formKey = formKey ?? GlobalKey(),
        super(key: key);

  final GlobalKey<FormState> formKey;
  final StripeCard card;
  final bool displayAnimatedCard;
  final InputDecoration? cardNumberDecoration;
  final TextStyle? cardNumberTextStyle;
  final InputDecoration? cardExpiryDecoration;
  final TextStyle? cardExpiryTextStyle;
  final InputDecoration? cardCvcDecoration;
  final TextStyle? cardCvcTextStyle;
  final InputDecoration? postalCodeDecoration;
  final TextStyle? postalCodeTextStyle;
  final String? cardNumberErrorText;
  final String? postalCodeErrorText;
  final String? cardExpiryErrorText;
  final String? cardCvcErrorText;
  final Decoration? cardDecoration;

  @override
  _CustomizeCardFormState createState() => _CustomizeCardFormState();
}

class _CustomizeCardFormState extends State<CustomizeCardForm> {
  final StripeCard _validationModel = StripeCard();
  bool cvcHasFocus = false;

  @override
  Widget build(BuildContext context) {
    var cardExpiry = 'MM/YY';
    if (_validationModel.expMonth != null) {
      cardExpiry = "${_validationModel.expMonth}/${_validationModel.expYear ?? 'YY'}";
    }

    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        _getCreditCardView(cardExpiry),

        _buildCardIcon(),

        Form(
          key: widget.formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[

                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    initialValue: _validationModel.postalCode ?? widget.card.postalCode,
                    onChanged: (text) => setState(() => _validationModel.postalCode = text),
                    onSaved: (text) => widget.card.postalCode = text,
                    autofillHints: [AutofillHints.name],
                    validator: (text) => _validationModel.isPostalCodeValid()
                        ? null
                        : widget.postalCodeErrorText ?? 'Invalid postal code',
                    style: widget.postalCodeTextStyle ?? TextStyle(color: Colors.black),
                    decoration: widget.postalCodeDecoration ??
                        InputDecoration(border: OutlineInputBorder(), labelText: 'Postal code'),
                  ),
                ),


                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: CardNumberFormField(
                    initialValue: _validationModel.number ?? widget.card.number,
                    onChanged: (number) {
                      setState(() {
                        _validationModel.number = number;
                      });
                    },
                    validator: (text) => _validationModel.validateNumber()
                        ? null
                        : widget.cardNumberErrorText ?? CardNumberFormField.defaultErrorText,
                    textStyle: widget.cardNumberTextStyle ?? CardNumberFormField.defaultTextStyle,
                    onSaved: (text) => widget.card.number = text,
                    decoration: widget.cardNumberDecoration ?? CardNumberFormField.defaultDecoration,
                  ),
                ),

                Row(
                  children: [

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin: const EdgeInsets.only(top: 8),
                        child: CardExpiryFormField(
                          initialMonth: _validationModel.expMonth ?? widget.card.expMonth,
                          initialYear: _validationModel.expYear ?? widget.card.expYear,
                          onChanged: (int? month, int? year) {
                            setState(() {
                              _validationModel.expMonth = month;
                              _validationModel.expYear = year;
                            });
                          },
                          onSaved: (int? month, int? year) {
                            widget.card.expMonth = month;
                            widget.card.expYear = year;
                          },
                          validator: (text) => _validationModel.validateDate()
                              ? null
                              : widget.cardExpiryErrorText ?? CardExpiryFormField.defaultErrorText,
                          textStyle: widget.cardExpiryTextStyle ?? CardExpiryFormField.defaultTextStyle,
                          decoration: widget.cardExpiryDecoration ?? CardExpiryFormField.defaultDecoration,
                        )
                      ),
                    ),

                    Container(width: 10,),

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin: const EdgeInsets.only(top: 8),
                        child: Focus(
                          onFocusChange: (value) => setState(() => cvcHasFocus = value),
                          child: CardCvcFormField(
                            initialValue: _validationModel.cvc ?? widget.card.cvc,
                            onChanged: (text) => setState(() => _validationModel.cvc = text),
                            onSaved: (text) => widget.card.cvc = text,
                            validator: (text) => _validationModel.validateCVC()
                                ? null
                                : widget.cardCvcErrorText ?? CardCvcFormField.defaultErrorText,
                            textStyle: widget.cardCvcTextStyle ?? CardCvcFormField.defaultTextStyle,
                            decoration: widget.cardCvcDecoration ?? CardCvcFormField.defaultDecoration,
                          ),
                        ),
                      ),
                    ),


                  ],
                ),

                // Container(
                //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                //   margin: const EdgeInsets.only(top: 8),
                //   child: TextFormField(
                //     keyboardType: TextInputType.number,
                //     textInputAction: TextInputAction.done,
                //     initialValue: _validationModel.postalCode ?? widget.card.postalCode,
                //     onChanged: (text) => setState(() => _validationModel.postalCode = text),
                //     onSaved: (text) => widget.card.postalCode = text,
                //     autofillHints: [AutofillHints.postalCode],
                //     validator: (text) => _validationModel.isPostalCodeValid()
                //         ? null
                //         : widget.postalCodeErrorText ?? 'Invalid postal code',
                //     style: widget.postalCodeTextStyle ?? TextStyle(color: Colors.black),
                //     decoration: widget.postalCodeDecoration ??
                //         InputDecoration(border: OutlineInputBorder(), labelText: 'Postal code'),
                //   ),
                // ),


                



              ],
            ),
          ),
        ),
      ]);
  }

  Widget _getCreditCardView(String cardExpiry) {

    if (!widget.displayAnimatedCard) {
      return Padding(padding: EdgeInsets.zero);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: CreditCard(
        height: 220,
        cardNumber: _validationModel.number ?? '',
        cardExpiry: cardExpiry,
        cvv: _validationModel.cvc ?? '',
        frontBackground: widget.cardDecoration != null
            ? Container(
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: widget.cardDecoration,
              )
            : XCardBackgrounds.black,
        backBackground: XCardBackgrounds.white,
        showBackSide: cvcHasFocus,
        showShadow: true,
      ),
    );
  }
}


Widget _buildCardIcon(){
  return Row(
    children: [
      Container(
        height: 50,
        padding: const EdgeInsets.only(left: 20, right: 20),
        margin: const EdgeInsets.only(top: 16),
        child: setCachedNetworkImage(
          'https://logodix.com/logo/797210.png',
          BoxFit.cover
        ),
      )
    ],
  );
}


class XCardBackgrounds {
  XCardBackgrounds._();

  static Widget black = Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: const Color(0xff212121),
  );

  static Widget white = Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: const Color(0xffF9F9FA),
  );
}

