// lib/models/v2ray_node.dart

enum ProtocolType { vmess, vless, trojan, hysteria2, tuic }
enum SecurityLayer { none, tls, reality, xtls }

class V2RayNode {
  final String id;
  final String remark;
  final ProtocolType protocol;
  final String address;
  final int port;
  final String uuidOrPassword;

  final SecurityLayer security;
  final String? sni;
  final String? realityPublicKey;
  final String? realityShortId;
  
  final bool fragmentEnabled;
  final bool muxEnabled;
  final int muxConcurrency;
  final String? fallbackNodeId;

  int? lastPingMs;
  bool isBlockedByDPI;

  V2RayNode({
    required this.id,
    required this.remark,
    required this.protocol,
    required this.address,
    required this.port,
    required this.uuidOrPassword,
    this.security = SecurityLayer.reality,
    this.sni,
    this.realityPublicKey,
    this.realityShortId,
    this.fragmentEnabled = true,
    this.muxEnabled = true,
    this.muxConcurrency = 8,
    this.fallbackNodeId,
    this.lastPingMs,
    this.isBlockedByDPI = false,
  });

  factory V2RayNode.fromJson(Map<String, dynamic> j) => V2RayNode(
        id: j['id'] ?? '',
        remark: j['remark'] ?? '',
        protocol: ProtocolType.values.firstWhere(
            (e) => e.name == j['protocol'], orElse: () => ProtocolType.vless),
        address: j['address'] ?? '',
        port: j['port'] ?? 0,
        uuidOrPassword: j['uuidOrPassword'] ?? '',
        security: SecurityLayer.values.firstWhere(
            (e) => e.name == j['security'], orElse: () => SecurityLayer.reality),
        sni: j['sni'],
        realityPublicKey: j['realityPublicKey'],
        realityShortId: j['realityShortId'],
        fragmentEnabled: j['fragmentEnabled'] ?? true,
        muxEnabled: j['muxEnabled'] ?? true,
        muxConcurrency: j['muxConcurrency'] ?? 8,
        fallbackNodeId: j['fallbackNodeId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'remark': remark,
        'protocol': protocol.name,
        'address': address,
        'port': port,
        'uuidOrPassword': uuidOrPassword,
        'security': security.name,
        'sni': sni,
        'realityPublicKey': realityPublicKey,
        'realityShortId': realityShortId,
        'fragmentEnabled': fragmentEnabled,
        'muxEnabled': muxEnabled,
        'muxConcurrency': muxConcurrency,
        'fallbackNodeId': fallbackNodeId,
      };
}
