import 'package:flutter/material.dart';
import 'package:jarvisadmin/pages/categoria/lista_categoria_page.dart';
import 'package:jarvisadmin/pages/pedidos_finalizados/pedidos_finalizados.dart';
import 'package:jarvisadmin/pages/pedidos_pendentes/pedidos_pendentes.dart';
import 'package:jarvisadmin/pages/produto/lista_produto_page.dart';
import 'package:jarvisadmin/pages/promocao/lista_promocao_page.dart';
import 'package:jarvis_core/core/model/usuario_model.dart';
import 'package:jarvis_core/widgets/mp_app_bar.dart';
import 'package:jarvis_core/widgets/mp_logo_admin.dart';

class HomePage extends StatelessWidget {
  const HomePage(
    this.usuario, {
    Key key,
  }) : super(key: key);

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPAppBar(
        title: MPLogoAdmin(
          fontSize: 28,
        ),
        withLeading: false,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(24),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _Button(
              text: 'Categorias',
              iconData: Icons.category,
              page: ListaCategoriaPage(),
            ),
            _Button(
              text: 'Produtos',
              iconData: Icons.fastfood,
              page: ListaProdutoPage(),
            ),
            _Button(
              text: 'Promoções',
              iconData: Icons.campaign,
              page: ListaPromocaoPage(),
            ),
            _Button(
              text: 'Pedidos Pendentes',
              iconData: Icons.pending,
              page: PedidosPendentesPage(),
            ),
            _Button(
              text: 'Pedidos Finalizados',
              iconData: Icons.flag,
              page: PedidosFinalizadosPage(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  _Button({
    this.page,
    this.iconData,
    this.text,
  });

  final Widget page;
  final IconData iconData;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
        child: Container(
          width: 150,
          height: 120,
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Icon(
                iconData,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 8),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
