import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_dice_demo/src/utils/constants.dart';
import 'package:roll_dice_demo/src/utils/custom_dialog.dart';
import 'package:roll_dice_demo/src/utils/dialog_status.dart';
import 'package:roll_dice_demo/src/widgets/custom_button.dart';

import '../home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CustomDialogs customDialogs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.context.read<HomePageBloc>().add(HomePageInitial());
    });
  }

  @override
  Widget build(BuildContext context) {
    customDialogs = CustomDialogs(context);

    return BlocListener<HomePageBloc, HomePageState>(
      listenWhen: (previous, current) => previous.dialogStatus != current.dialogStatus,
      listener: (context, state) async {
        switch (state.dialogStatus) {
          case DialogStatus.unknown:
            break;

          case DialogStatus.loading:
            customDialogs.showLoadingDialog(message: state.loadingMessage);
            break;

          case DialogStatus.success:
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            bool isSuccess = await customDialogs.showTimerAlertDialog(
                title: 'Success', message: 'Your score is submitted successfully', positiveButtonText: 'Dismiss');
            if (isSuccess) {
              this.context.read<HomePageBloc>().add(LogOut());
            }
            break;

          case DialogStatus.logout:
            Navigator.of(context).pushReplacementNamed(ConstantStrings.route_login);
            break;

          case DialogStatus.error:
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            customDialogs.showAlertDialog(
                title: state.errorTitle, message: state.errorBody, positiveButtonText: 'Dismiss');
            break;
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            title:
                Text('Roll & Dice', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  this.context.read<HomePageBloc>().add(LogOut());
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: BlocBuilder<HomePageBloc, HomePageState>(
              buildWhen: (previous, current) =>
                  previous.attemptRemaining != current.attemptRemaining ||
                  previous.currentAttemptPoint != current.currentAttemptPoint ||
                  previous.score != current.score,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, size: 22),
                        SizedBox(width: 5),
                        Text('Suraj Pawar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Attempts remaining - ",
                            style: TextStyle(
                                color: Theme.of(context).accentColor, fontSize: 16.0, fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                text: '${state.attemptRemaining}',
                                style: TextStyle(color: Theme.of(context).focusColor),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Text.rich(
                          TextSpan(
                            text: "Score - ",
                            style: TextStyle(
                                color: Theme.of(context).accentColor, fontSize: 16.0, fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                text: '${state.score}',
                                style: TextStyle(color: Theme.of(context).focusColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: state.currentAttemptPoint > 0 && state.currentAttemptPoint <= 6
                            ? Image.asset(
                                'lib/assets/dice${state.currentAttemptPoint}.png',
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                              )
                            : Center(
                                child: Text('Please roll the dice',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Center(
                        child: CustomButton(
                            enabled: true,
                            onTap: () {
                              context.read<HomePageBloc>().add(DiceRolled());
                            },
                            text: 'Roll the Dice'))
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
