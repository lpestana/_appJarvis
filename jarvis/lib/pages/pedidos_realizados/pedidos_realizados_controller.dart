import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jarvis_core/core/model/pedido_model.dart';

class PedidosRealizadosController {
  CollectionReference pedidosPendentesRef =
      FirebaseFirestore.instance.collection('pedidos_pendentes');

  CollectionReference pedidosCanceladosRef =
      FirebaseFirestore.instance.collection('pedidos_cancelados');

  final Stream<QuerySnapshot> _pedidosPendentesStream =
      FirebaseFirestore.instance
          .collection('pedidos_pendentes')
          //.where('usuarioId', isEqualTo: 'oXDoA10OgGcdv3Z95NflJ7yt9XB3')
          .where('usuarioId', isEqualTo: '1wS0cli7iNhffe2OdIXPeoZTyMt1')
          .orderBy('dataPedido') //Ordena pedidos de acordo com a mesa.
          .snapshots();

  Stream<QuerySnapshot> get pedidosPendentesStream => _pedidosPendentesStream;

  List<PedidoModel> getPedidosFromDocs(List<QueryDocumentSnapshot> docs) {
    return List.generate(docs.length, (i) {
      final pedidoDoc = docs[i];
      return PedidoModel.fromJson(pedidoDoc.id, pedidoDoc.data());
    });
  }

  Future<void> exluirPedido(PedidoModel pedido) async {
    await pedidosCanceladosRef.doc(pedido.id).set(pedido.toJson());
    await pedidosPendentesRef.doc(pedido.id).delete();
  }
}
