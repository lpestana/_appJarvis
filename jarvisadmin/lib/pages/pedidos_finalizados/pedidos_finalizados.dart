import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jarvisadmin/pages/pedidos_finalizados/pedidos_finalizados_controller.dart';
import 'package:jarvisadmin/widgets/mp_empty.dart';
import 'package:jarvisadmin/widgets/mp_list_view.dart';
import 'package:jarvisadmin/widgets/mp_loading.dart';
import 'package:jarvis_core/core/model/produto_model.dart';
import 'package:jarvis_core/widgets/mp_app_bar.dart';

class PedidosFinalizadosPage extends StatefulWidget {
  PedidosFinalizadosPage({Key key}) : super(key: key);

  @override
  _PedidosPendentesPageState createState() => _PedidosPendentesPageState();
}

class _PedidosPendentesPageState extends State<PedidosFinalizadosPage> {
  final _controller = PedidosFinalizadosControler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPAppBar(
        title: Text(
          'Pedidos Finalizados',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _controller.pedidosFinalizadosStream,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final pedidos =
                  _controller.getPedidosFinalizadosFromDocs(snapshot.data.docs);
              if (pedidos == null || pedidos.length == 0) {
                return MPEmpty();
              }
              return MPListView(
                itemCount: pedidos.length,
                itemBuilder: (_, i) => ExpansionTile(
                  title: Text(
                    DateFormat("d MMM y 'as' HH:mm", 'pt_br').format(
                      DateFormat('yyyy-MM-dd HH:mm:ss').parse(
                        pedidos[i].dataPedido.toString(),
                      ),
                    ),
                  ),
                  subtitle: Text(
                    'Cliente: ${pedidos[i].nomeUsuario} / Mesa: ${pedidos[i].mesa}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Text(
                    'R\$ ${pedidos[i].valorPedido.toString()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  children: getProdutos(pedidos[i].produtos),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: MPLoading(),
              );
            } else {
              return MPEmpty();
            }
          }),
    );
  }
}

List<Widget> getProdutos(List<ProdutoModel> produtos) {
  if (produtos != null && produtos.isNotEmpty) {
    return produtos
        .map(
          (produto) => ListTile(
            leading: produto.urlImagem != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(produto.urlImagem),
                  )
                : Icon(Icons.add_box),
            title: Text(produto.nome),
            trailing: Text(produto.quantidade.toString()),
          ),
        )
        .toList();
  }
}
