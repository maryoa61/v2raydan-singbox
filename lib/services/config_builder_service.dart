// lib/services/config_builder_service.dart
import '../models/v2ray_node.dart';

class ConfigBuilderService {
  static Map<String, dynamic> buildConfig(V2RayNode node) {
    return {
      "log": {"level": "info"},
      "inbounds": [
        {"type": "tun", "inet4_address": ["172.19.0.1/30"], "auto_route": true, "strict_route": true}
      ],
      "outbounds": [_buildOutbound(node), {"type": "direct", "tag": "direct"}],
      "route": {
        "rules": [{"port": 53, "outbound": "direct"}],
        "auto_detect_interface": true
      }
    };
  }

  static Map<String, dynamic> _buildOutbound(V2RayNode node) {
    final Map<String, dynamic> out = {
      "tag": "proxy-out",
      "server": node.address,
      "server_port": node.port,
    };

    switch (node.protocol) {
      case ProtocolType.vless:
        out["type"] = "vless";
        out["uuid"] = node.uuidOrPassword;
        out["tls"] = _buildTls(node);
        break;
      case ProtocolType.trojan:
        out["type"] = "trojan";
        out["password"] = node.uuidOrPassword;
        out["tls"] = {"enabled": true, "server_name": node.sni ?? node.address};
        break;
      case ProtocolType.hysteria2:
        out["type"] = "hysteria2";
        out["password"] = node.uuidOrPassword;
        out["tls"] = {"enabled": true, "server_name": node.sni ?? node.address};
        break;
      case ProtocolType.tuic:
        out["type"] = "tuic";
        out["uuid"] = node.uuidOrPassword;
        out["tls"] = {"enabled": true, "server_name": node.sni ?? node.address};
        break;
      case ProtocolType.vmess:
        out["type"] = "vmess";
        out["uuid"] = node.uuidOrPassword;
        break;
    }
    return out;
  }

  static Map<String, dynamic> _buildTls(V2RayNode node) {
    final tls = {"enabled": true, "server_name": node.sni ?? node.address};
    if (node.security == SecurityLayer.reality) {
      tls["reality"] = {
        "public_key": node.realityPublicKey,
        "short_id": node.realityShortId
      };
    }
    return tls;
  }
}
