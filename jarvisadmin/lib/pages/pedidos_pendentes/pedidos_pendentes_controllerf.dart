import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jarvis_core/core/model/pedido_model.dart';

class PedidosPendentesControlerf {
  CollectionReference pedidosPendentesRef =
      FirebaseFirestore.instance.collection('pedidos_pendentes');

  CollectionReference pedidosProducaoRef =
      FirebaseFirestore.instance.collection('pedidos_producao');
 
  final Stream<QuerySnapshot> _pedidosPendentesStream =
      FirebaseFirestore.instance
          .collection('pedidos_pendentes')
          .orderBy('dataPedido') //Ordena pedidos de acordo com a mesa.
          .snapshots();

  Stream<QuerySnapshot> get pedidosPendentesStream => _pedidosPendentesStream;

   List<PedidoModel> getPedidosFromDocs(List<QueryDocumentSnapshot> docs) {
    return List.generate(docs.length, (i) {
      final pedidoDoc = docs[i];
      return PedidoModel.fromJson(pedidoDoc.id, pedidoDoc.data());
    });
  }

    List<PedidoModel> getPedidosFromDocsf(List<QueryDocumentSnapshot> docs) {
    return List.generate(docs.length, (i) {
      final pedidoDoc = docs[i];
      return PedidoModel.fromJson(pedidoDoc.id, pedidoDoc.data());
    });
  }

  Future<void> produzirPedido(PedidoModel pedido) async {
    await pedidosProducaoRef.doc(pedido.id).set(pedido.toJson());
    await pedidosPendentesRef.doc(pedido.id).delete();
  }
  
}
