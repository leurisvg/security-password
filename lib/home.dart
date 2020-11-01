import 'package:flutter/material.dart';

const _animationDuration = Duration(milliseconds: 150);

List<PasswordRequirement> _passwordsRequirements = [
  PasswordRequirement(title: 'One lowercase character'),
  PasswordRequirement(title: 'One uppercase character'),
  PasswordRequirement(title: 'One number'),
  PasswordRequirement(title: 'One special character'),
  PasswordRequirement(title: '8 characters minimum'),
];

final RegExp _uppercase = new RegExp(r"([A-Z])");
final RegExp _lowercase = new RegExp(r"([a-z])");
final RegExp _digits = new RegExp(r"(\d)");
final RegExp _specialCharacters = new RegExp(r"[^A-Za-z0-9]");

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FocusNode _inputFocus;
  bool _obscure = true;
  int _securityLevel = 0;
  String _passwordStrong = 'Week';
  List<bool> _passwordRequirementsApplied = [false, false, false, false, false];

  @override
  void initState() {
    _inputFocus = FocusNode();
    _inputFocus.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _inputFocus.dispose();
    super.dispose();
  }

  Color _securityIndicatorColor(int index, int securityLevel, Color greyColor) {
    if (securityLevel > index) {
      if (securityLevel == _passwordRequirementsApplied.length) {
        return Colors.green;
      }
      return Colors.red;
    } else {
      return greyColor;
    }
  }

  void _onChanged(String value) {
    final _hasUppercase = _uppercase.hasMatch(value);
    final _hasLowercase = _lowercase.hasMatch(value);
    final _hasDigits = _digits.hasMatch(value);
    final _hasSpecialCharacters = _specialCharacters.hasMatch(value);
    final _hasMinimumCharacters = value.length >= 8 ? true : false;

    _passwordRequirementsApplied = [];
    _securityLevel = 0;
    _passwordRequirementsApplied.addAll([_hasLowercase, _hasUppercase, _hasDigits, _hasSpecialCharacters, _hasMinimumCharacters]);

    for (int i = 0; i < _passwordRequirementsApplied.length; i++) {
      if (_passwordRequirementsApplied[i]) {
        _securityLevel++;
      }

      _passwordsRequirements[i].requirementActive = _passwordRequirementsApplied[i];
    }

    if (_securityLevel == _passwordRequirementsApplied.length) {
      _passwordStrong = 'Good';
    } else {
      _passwordStrong = 'Week';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set your\npassword',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Enter the password you would like to use with your account',
                    style: TextStyle(fontSize: 17, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    onChanged: _onChanged,
                    cursorColor: Color(0xff19adc6),
                    focusNode: _inputFocus,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                        color: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: _obscure ? Icon(Icons.visibility_off, color: Colors.grey[400]) : Icon(Icons.visibility, color: Colors.grey[400]),
                      ),
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      labelStyle: TextStyle(color: _inputFocus.hasFocus ? Color(0xff19adc6) : Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Color(0xff19adc6),
                        ),
                      ),
                    ),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: List.generate(_passwordRequirementsApplied.length, (index) {
                          return _SecurityIndicator(
                            index: index,
                            securityLevel: _securityLevel,
                            securityIndicatorColor: _securityIndicatorColor,
                            passwordSecuritiesApplied: _passwordRequirementsApplied,
                          );
                        }),
                      ),
                      const SizedBox(height: 5),
                      AnimatedDefaultTextStyle(
                        duration: _animationDuration,
                        style: TextStyle(color: _securityIndicatorColor(0, _securityLevel, Colors.grey[400]), fontWeight: FontWeight.w600),
                        child: Text(_passwordStrong),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ...List.generate(_passwordsRequirements.length, (index) {
                    return _PasswordRequirementLabel(
                      label: _passwordsRequirements[index].title,
                      requirementActive: _passwordsRequirements[index].requirementActive,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _securityLevel == _passwordRequirementsApplied.length ? () {} : null,
          elevation: 0.0,
          highlightElevation: 0.0,
          backgroundColor: _securityLevel == _passwordRequirementsApplied.length ? Color(0xff19adc6) : Colors.grey[400],
          child: Icon(Icons.arrow_forward, size: 30),
        ),
      ),
    );
  }
}

class _SecurityIndicator extends StatelessWidget {
  final int index;
  final int securityLevel;
  final List<bool> passwordSecuritiesApplied;
  final Color Function(int, int, Color) securityIndicatorColor;

  const _SecurityIndicator({
    @required this.index,
    @required this.securityLevel,
    @required this.securityIndicatorColor,
    @required this.passwordSecuritiesApplied,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: _animationDuration,
        height: 6,
        decoration: BoxDecoration(
          color: this.securityIndicatorColor(index, securityLevel, Colors.grey[300]),
          border: Border(
            right: index == passwordSecuritiesApplied.length - 1
                ? BorderSide.none
                : BorderSide(
                    width: 2,
                    style: BorderStyle.solid,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}

class _PasswordRequirementLabel extends StatelessWidget {
  final String label;
  final bool requirementActive;

  const _PasswordRequirementLabel({@required this.label, @required this.requirementActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          AnimatedOpacity(
            duration: _animationDuration,
            opacity: requirementActive ? 1.0 : 0.0,
            child: Icon(Icons.check, size: 20, color: Colors.green),
          ),
          const SizedBox(width: 5),
          AnimatedDefaultTextStyle(
            duration: _animationDuration,
            style: TextStyle(color: requirementActive ? Colors.grey[600] : Colors.grey[400], fontWeight: FontWeight.w500),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}

class PasswordRequirement {
  final String title;
  bool requirementActive;

  PasswordRequirement({
    @required this.title,
    this.requirementActive = false,
  });
}
