import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_dice_demo/src/screen/home_page/home_page.dart';
import 'package:roll_dice_demo/src/screen/leaderboard/bloc/leaderboard_bloc.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<LeaderboardBloc>().add(LoadInitialLeaderboard());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text('Leaderboard', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),
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
      body: Container(
        child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
          buildWhen: (previous, current) => previous.userList != current.userList,
          builder: (context, state) {
            return state.userList.length == 0
                ? Text('No Data found')
                : ListView.builder(
                    itemCount: state.userList.length,
                    itemBuilder: (context, int index) {
                      return ListTile(
                        title: Text(state.userList[index].userName ?? ""),
                        subtitle: Text('${state.userList[index].score}'),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
