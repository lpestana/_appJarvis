import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jarvis_core/core/model/pedido_model.dart';

class PedidosProducaoControler {

  CollectionReference pedidosProducaoRef =
      FirebaseFirestore.instance.collection('pedidos_producao');

  CollectionReference pedidosFinalizadosRef =
      FirebaseFirestore.instance.collection('pedidos_finalizados');

  final Stream<QuerySnapshot> _pedidosProducaoStream =
      FirebaseFirestore.instance
          .collection('pedidos_producao')
          .orderBy('mesa') //Ordena pedidos de acordo com a mesa.
          .snapshots();

  Stream<QuerySnapshot> get pedidosProducaoStream => _pedidosProducaoStream;

  List<PedidoModel> getPedidosFromDocs(List<QueryDocumentSnapshot> docs) {
    return List.generate(docs.length, (i) {
      final pedidoDoc = docs[i];
      return PedidoModel.fromJson(pedidoDoc.id, pedidoDoc.data());
    });
  }

  Future<void> finalizarPedido(PedidoModel pedido) async {
    await pedidosFinalizadosRef.doc(pedido.id).set(pedido.toJson());
    await pedidosProducaoRef.doc(pedido.id).delete();
  }

}
