import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jarvis_core/core/model/pedido_model.dart';

class PedidosFinalizadosControler {
  final Stream<QuerySnapshot> _pedidosFinalizadosStream =
      FirebaseFirestore.instance.collection('pedidos_finalizados').snapshots();

  Stream<QuerySnapshot> get pedidosFinalizadosStream =>
      _pedidosFinalizadosStream;

  List<PedidoModel> getPedidosFinalizadosFromDocs(
      List<QueryDocumentSnapshot> docs) {
    return List.generate(docs.length, (i) {
      final pedidoDoc = docs[i];
      return PedidoModel.fromJson(pedidoDoc.id, pedidoDoc.data());
    });
  }
}
