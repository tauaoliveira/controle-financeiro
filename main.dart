import 'package:flutter/material.dart';

void main() {
  runApp(FinanceApp());
}

class FinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle Financeiro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: FinanceHomePage(),
    );
  }
}

class FinanceHomePage extends StatefulWidget {
  @override
  _FinanceHomePageState createState() => _FinanceHomePageState();
}

class _FinanceHomePageState extends State<FinanceHomePage> {
  double ganhosTotais = 4000;
  double gastosTotais = 1500;

  void adicionarGanho(double valor) {
    setState(() {
      ganhosTotais += valor;
    });
  }

  void adicionarGasto(double valor) {
    setState(() {
      gastosTotais += valor;
    });
  }

  void abrirDialogoAdicionar(bool isGanho) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isGanho ? 'Adicionar Ganho' : 'Adicionar Gasto'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Digite o valor'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final valor = double.tryParse(controller.text);
              if (valor != null) {
                isGanho ? adicionarGanho(valor) : adicionarGasto(valor);
              }
              Navigator.pop(context);
            },
            child: Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final restante = ganhosTotais - gastosTotais;
    final percentual = (gastosTotais / ganhosTotais).clamp(0.0, 1.0);
    final corBarra = Color.lerp(Colors.green, Colors.red, percentual);

    return Scaffold(
      appBar: AppBar(
        title: Text('Controle Financeiro'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Ganhos previstos: R\$ ${ganhosTotais.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Gastos até hoje: R\$ ${gastosTotais.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Saldo disponível: R\$ ${restante.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: percentual,
              color: corBarra,
              backgroundColor: Colors.grey[300],
              minHeight: 20,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => abrirDialogoAdicionar(true),
                  icon: Icon(Icons.add),
                  label: Text('Ganho'),
                ),
                ElevatedButton.icon(
                  onPressed: () => abrirDialogoAdicionar(false),
                  icon: Icon(Icons.remove),
                  label: Text('Gasto'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
