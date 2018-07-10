import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TagInfo extends StatefulWidget {
  @override
  TagInfoPageState createState() => TagInfoPageState();
}

class TagInfoPageState extends State<TagInfo> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String _dogName;
  String _phoneNumber;
  String _shippingAddress;
  String _contactNumber;
  String _wood;
  String _design;
  String _size;

  bool _formWasEdited = false;

  final _UsNumberTextInputFormatter _phoneNumberFormatter = new _UsNumberTextInputFormatter();

  String _validatePhoneNumber(String value) {
    _formWasEdited = true;
    final RegExp phoneExp = new RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
    if (!phoneExp.hasMatch(value))
      return '(###) ###-#### - Enter a US phone number.';
    return null;
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _performSave;

    }
  }

  void _performSave() async {
    final snackbar = SnackBar(content: Text('Saved!'));
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Add Tag Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              new ListTile(
                leading:  const Icon(Icons.pets),
                title: TextFormField(
                  decoration: InputDecoration(labelText: 'Dog\'s Name'),
                  onSaved: (val) => _dogName = val,
                )
              ),
              new ListTile(
                leading:  const Icon(Icons.phone),
                title: TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  onSaved: (val) => _phoneNumber = val,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhoneNumber,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    _phoneNumberFormatter
                  ]
                )
              ),
              new ListTile(
                leading: const Icon(Icons.local_shipping),
                title: TextFormField(
                  decoration: InputDecoration(labelText: 'Shipping Address'),
                  onSaved: (val) => _shippingAddress = val,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.phone_iphone),
                title: TextFormField(
                  decoration: InputDecoration(labelText: 'Contact Number'),
                  onSaved: (val) => _contactNumber = val,
                ),
              ),
              DropdownButton(
                hint: Text('Pick a wood'),
                items: [
                   DropdownMenuItem (value: 'Avocado', child: Text('Avocado') ),
                   DropdownMenuItem (value: 'Sugar Gum', child: Text('Sugar Gum') ),
                   DropdownMenuItem (value: 'Black Acacia', child: Text('Black Acacia') ),
                   DropdownMenuItem (value: 'Red Gum', child: Text('Red Gum') )
                ],
                value: _wood,
                onChanged: (String newValue) {
                  setState(() { _wood = newValue; });
                }
              ),
              DropdownButton(
                hint: Text('Pick a design'),
                items: [
                   DropdownMenuItem (value: 'Adventure Awaits', child: Text('Adventure Awaits') ),
                   DropdownMenuItem (value: 'Pawsitive Vibes', child: Text('Pawsitive Vibes') ),
                   DropdownMenuItem (value: 'Loved', child: Text('Loved') ),
                   DropdownMenuItem (value: 'Dog Life', child: Text('Dog Life') )
                ],
                value: _design,
                onChanged: (String newValue) {
                  setState(() { _design = newValue; });
                }
              ),
              DropdownButton(
                hint: Text('Pick a size'),
                items: [
                   DropdownMenuItem (value: 'Large', child: Text('Large') ),
                   DropdownMenuItem (value: 'Small', child: Text('Small') ),
                ],
                value: _size,
                onChanged: (String newValue) {
                  setState(() { _size = newValue; });
                }
              ),
              RaisedButton(
                onPressed: _submit,
                child: Text('Get Tag!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Format incoming numeric text to fit the format of (###) ###-#### ##...
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1)
        selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3)
        selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6)
        selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10)
        selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}