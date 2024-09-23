import 'package:flutter/material.dart';
import 'package:opensovereignchess_app/chessboard/chessboard.dart';

enum BottomTab {
  home,
  tools,
  settings;

  String get label {
    return switch (this) {
      BottomTab.home => 'Home',
      BottomTab.tools => 'Tools',
      BottomTab.settings => 'Settings',
    };
  }

  IconData get icon {
    return switch (this) {
      BottomTab.home => Icons.home_outlined,
      BottomTab.tools => Icons.handyman_outlined,
      BottomTab.settings => Icons.settings_outlined,
    };
  }
}

class BottomNavScaffold extends StatelessWidget {
  const BottomNavScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const _TestView(),
      bottomNavigationBar: NavigationBar(
        destinations: [
          for (final tab in BottomTab.values)
            NavigationDestination(
              icon: Icon(tab.icon),
              label: tab.label,
            )
        ],
      ),
    );
  }
}

class _TestView extends StatelessWidget {
  const _TestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Chessboard(
        size: MediaQuery.sizeOf(context).width,
        //fen: '16/16/16/16/16/16/2wpapspbppprpopypgpcpnpvp2/2wpapspbppprpopypgpcpnpvp2/16/2bpnpop11/16/16/16/16/16/16',
        fen: 'aqabvrvnbrbnbbbqbkbbbnbrynyrsbsq/aranvpvpbpbpbpbpbpbpbpbpypypsnsr/nbnp12opob/nqnp12opoq/crcp12rprr/cncp12rprn/gbgp12pppb/gqgp12pppq/yqyp12vpvq/ybyp12vpvb/onop12npnn/orop12npnr/rqrp12cpcq/rbrp12cpcb/srsnppppwpwpwpwpwpwpwpwpgpgpanar/sqsbprpnwrwnwbwqwkwbwnwrgngrabaq',
      ),
    );
  }
}
