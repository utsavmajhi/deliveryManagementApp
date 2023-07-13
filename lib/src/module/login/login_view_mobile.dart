import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import '../../widgets/custom_text_field.dart';
import 'bloc/login_bloc.dart';

class LoginViewMobile extends StatefulWidget {
  const LoginViewMobile({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginViewMobile());
  }

  @override
  State<LoginViewMobile> createState() => _LoginViewMobileState();
}

class _LoginViewMobileState extends State<LoginViewMobile> {
  String username = "";
  String password = "";

  bool get validForm {
    return username.isNotEmpty && password.isNotEmpty;
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
          Text(
            "Please enter your credentials",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.green,
        body: BlocProvider(
      create: (context) => LoginBloc(
          userPool: RepositoryProvider.of(context),
          authenticationBloc: BlocProvider.of(context)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    buildSingleChildScrollView(context),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    ));
  }

  Widget buildSingleChildScrollView(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        switch (state.status) {
          case LoginStatus.failure:
            _showSnackBar(context, "Error logging in");
            break;
          default:
            break;
        }
      },
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  _buildUsernameTextField(),
                  _buildPasswordTextField(),
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 200,
                        height: 40,
                        child: _buildLoginButton(context)),
                  )
                ],
              ),
            ),
            Positioned(
              top: -40,
              left: 0,
              right: 0,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.teal,
                child: CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(
                    'assets/images/dummypro.png',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state.status == LoginStatus.loadingLogin) {
        return const Center(child: CircularProgressIndicator());
      }

      if (validForm) {
        return ElevatedButton(
            onPressed: () => _loginUser(context, username, password),
            child: const Text("Login"));
      }

      return Container();
    });
  }

  Widget _buildPasswordTextField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return CustomTextField(
        onValueChange: (pwd) => {
          setState(() {
            password = pwd;
          })
        },
        label: "Password",
        obscureText: true,
      );
    });
  }

  Widget _buildUsernameTextField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return CustomTextField(
        label: "Username",
        onValueChange: (val) => {
          setState(() {
            username = val;
          })
        },
        textInputType: TextInputType.text,
      );
    });
  }

  _loginUser(BuildContext context, String userName, String password) async {
    Logger logger = Logger('LoginViewMobile');
    context.read<LoginBloc>().add(LoginUser(userName, password));
    logger.info('username: $userName\nPassword: **********');
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
