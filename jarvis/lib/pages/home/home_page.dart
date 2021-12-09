import 'package:flutter/material.dart';
import 'package:jarvisadmin/pages/carrinho/carrinho_controller.dart';
import 'package:jarvisadmin/pages/carrinho/carrinho_page.dart';
import 'package:jarvisadmin/pages/home/home_controller.dart';
import 'package:jarvis_core/core/model/categoria_model.dart';
import 'package:jarvis_core/core/model/promocao_model.dart';
import 'package:jarvis_core/core/model/usuario_model.dart';
import 'package:jarvis_core/widgets/mp_app_bar.dart';
import 'package:jarvis_core/widgets/mp_button_icon.dart';
import 'package:jarvis_core/widgets/mp_loading.dart';
import 'package:jarvis_core/widgets/mp_logo.dart';
import 'package:jarvisadmin/pages/pedidos_realizados/pedidos_realizados.dart';
import 'package:provider/provider.dart';

import 'widgets/categorias.dart';
import 'widgets/promocoes.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = HomeController();

  Future<List<PromocaoModel>> futurePromocoes;
  Future<List<CategoriaModel>> futureCategorias;

  @override
  void initState() {
    futurePromocoes = _controller.getPromocoes();
    futureCategorias = _controller.getCategorias();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPAppBar(
        title: MPLogo(
          fontSize: 24,
        ),
        withLeading: false,
        actions: [
          MPButtonIcon(
            iconData: Icons.shopping_cart,
            onTap: () {
              final usuario = Provider.of<UsuarioModel>(context, listen: false);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Provider.value(
                    value: Provider.of<CarrinhoController>(context),
                    child: CarrinhoPage(usuario),
                  ),
                ),
              );
            },
          ),
          MPButtonIcon(
            iconData: Icons.room_service_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PedidosRealizadosPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            children: [
              FutureBuilder<List<PromocaoModel>>(
                future: futurePromocoes,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Promocoes(snapshot.data);
                  } else {
                    return Center(
                      child: MPLoading(),
                    );
                  }
                },
              ),
              SizedBox(height: 24),
              FutureBuilder<List<CategoriaModel>>(
                future: futureCategorias,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Categorias(snapshot.data);
                  } else {
                    return Center(
                      child: MPLoading(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
