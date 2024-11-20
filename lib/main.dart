import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // tema de la app y modo claro y oscuro
  bool darkMode = false;
  ThemeData themeData(bool darkMode) {
    return ThemeData(
      useMaterial3: true,
      brightness: darkMode ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: darkMode ? Brightness.dark : Brightness.light,
      ),
      cardTheme: CardTheme(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: themeData(darkMode),
      home: Dashboard(
        darkMode: darkMode,
        toggleTheme: () {
          setState(() {
            darkMode = !darkMode;
          });
        },
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  final bool darkMode;
  final VoidCallback toggleTheme;
  const Dashboard(
      {super.key, required this.darkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final colorsquema = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context).size;
    var axisCount;
    if (media.width < 600) {
      axisCount = 2;
      print(media.width);
    } else if (media.width < 730) {
      axisCount = 3;
    } else {
      axisCount = 4;
      print(media.width);
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            IconButton(
              icon: Icon(darkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: toggleTheme,
            )
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(children: [
              Expanded(
                child: cuerpo(axisCount, context, colorsquema),
              ),
              SafeArea(
                child: BottomNavigationBar(
                  backgroundColor: colorsquema.secondary,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard, color: Colors.white),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.stacked_bar_chart, color: Colors.white),
                      label: 'Estadísticas',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings, color: Colors.white),
                      label: 'Configuración',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person, color: Colors.white),
                      label: 'Perfil',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.call, color: Colors.white),
                      label: 'Contactos',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.logout, color: Colors.white),
                      label: 'Cerrar Sesión',
                    )
                  ],
                ),
              )
            ]);
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    backgroundColor: colorsquema.primary,
                    extended: constraints.maxWidth >= 900,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home, color: Colors.white),
                        label:
                            Text('Home', style: TextStyle(color: Colors.white)),
                      ),
                      NavigationRailDestination(
                        icon:
                            Icon(Icons.stacked_bar_chart, color: Colors.white),
                        label: Text('Estadísticas',
                            style: TextStyle(color: Colors.white)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings, color: Colors.white),
                        label: Text('Configuración',
                            style: TextStyle(color: Colors.white)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person, color: Colors.white),
                        label: Text('Perfil',
                            style: TextStyle(color: Colors.white)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.call, color: Colors.white),
                        label: Text('Contactos',
                            style: TextStyle(color: Colors.white)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.logout, color: Colors.white),
                        label: Text('Cerrar Sesión',
                            style: TextStyle(color: Colors.white)),
                      )
                    ],
                    selectedIndex: null,
                  ),
                ),
                Expanded(child: cuerpo(axisCount, context, colorsquema))
              ],
            );
          }
        }));
  }

  //Cuerpo de la app
  SingleChildScrollView cuerpo(
      axisCount, BuildContext context, ColorScheme colorsquema) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        GridView.count(
            crossAxisCount: axisCount,
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              tarjeta(context, 'Productos en stock ', '200', Icons.store,
                  colorsquema.primary),
              tarjeta(context, 'Clientes', '100', Icons.people, Colors.green),
              tarjeta(context, 'Ventas del mes', '300', Icons.shopping_cart,
                  colorsquema.secondary),
              tarjeta(context, 'Pedidos recientes', '100',
                  Icons.shopping_basket, colorsquema.tertiary),
              tarjeta(context, 'Pedidos cancelados', '100',
                  Icons.remove_shopping_cart, colorsquema.error),
            ]),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Pedidos Pendientes'),
        ]),
        const SizedBox(height: 20),
        PedidosPendientes(context),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Productos Vendidos Recientes'),
            // ListaReciente(context),
          ],
        ),
        ListaReciente(context),
        const SizedBox(height: 20),
        staticCard(context),
        const SizedBox(
          height: 10,
        ),
        SfCircularChart(
          title: ChartTitle(text: 'Ventas del mes'),
          legend: Legend(isVisible: true),
          series: <CircularSeries<_PieData, String>>[
            PieSeries<_PieData, String>(
              explode: true,
              explodeIndex: 0,
              dataSource: PieData.pieData,
              xValueMapper: (_PieData data, _) => data.xData,
              yValueMapper: (_PieData data, _) => data.yData,
              dataLabelMapper: (_PieData data, _) => data.text,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              radius: '100',
            ),
          ],
          palette: const [
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.yellow,
          ],
        )
      ]),
    );
  }

  // tarjetars
  Widget tarjeta(BuildContext context, String titulo, String value,
      IconData icono, Color color) {
    return Card(
      child: Container(
        // constraints: const BoxConstraints(maxWidth: 5),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  icono,
                  color: color,
                  size: 24,
                ),
                Text(value,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            SizedBox(height: 20),
            Text(
              titulo,
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
      ),
    );
  }
}

class PieData {
  static List<_PieData> pieData = [
    _PieData('Producto1', 200, 'Producto1'),
    _PieData('Producto2', 250, 'Producto2'),
    _PieData('Producto3', 300, 'Producto3'),
    _PieData('Producto4', 350, 'Producto1'),
  ];
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  String? text;
}

// widget lista pedidos
Widget ListaReciente(BuildContext context) {
  return Card(
    child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5, // cantidad de items
        itemBuilder: (context, index) {
          return ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Pedido $index'),
              subtitle: Text('Cliente $index'),
              trailing: Text(
                  '\$${(index + 1) * 100}') //Icon(Icons.arrow_forward_ios),
              );
        }),
  );
}

// widget lista pedidos pendientes
Widget PedidosPendientes(BuildContext context) {
  return Card(
    child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5, // cantidad de items
        itemBuilder: (context, index) {
          return ListTile(
              leading: //CircleAvatar(
                  // backgroundColor: Theme.of(context).colorScheme.primary,),
                  Icon(Icons.access_time),
              title: Text('Pedido $index'),
              subtitle: Text('Cliente $index'),
              trailing: Text(
                  '\$${(index + 1) * 100}') //Icon(Icons.arrow_forward_ios),
              );
        }),
  );
}

Widget staticCard(BuildContext context) {
  return Card(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              statiRow('Ventas totales', '200'),
              statiRow('Clientes', '100'),
              statiRow('Ventas', '300'),
              statiRow('Pedidos', '500'),
            ],
          )));
}

//
Widget statiRow(String label, String value) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          label,
        ),
        Text(
          value,
        )
      ]));
}
