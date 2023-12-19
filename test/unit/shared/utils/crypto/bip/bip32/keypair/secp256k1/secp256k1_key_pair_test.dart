import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/derivation_path/derivation_path.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/derivation_path/derivation_path_element.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_key_pair.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_private_key.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_private_key.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_public_key.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';

void main() {
  group('Tests of Secp256k1KeyPair.fromPrivateKey() constructor', () {
    test('Should [return Secp256k1KeyPair] constructed from Secp256k1PrivateKey', () {
      // Arrange
      Secp256k1PrivateKey actualSecp256k1PrivateKey = Secp256k1PrivateKey(
        chainCodeBytes: base64Decode('UNH2aBl1uMkP+S/i5vZVK8tC2uODdICFW0hrpY8Zrbk='),
        ecdsaPrivateKey: ECDSAPrivateKey(
          Curves.generatorSecp256k1,
          BigInt.parse('15864759622800253937020257025334897817812874204769186060960403729801414344643'),
        ),
      );

      // Act
      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair.fromPrivateKey(actualSecp256k1PrivateKey);

      // Assert
      Secp256k1KeyPair expectedSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('UNH2aBl1uMkP+S/i5vZVK8tC2uODdICFW0hrpY8Zrbk='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('15864759622800253937020257025334897817812874204769186060960403729801414344643'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
              y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
              z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualSecp256k1KeyPair, expectedSecp256k1KeyPair);
    });
  });

  group('Tests of Secp256k1KeyPair.fromSeed() constructor', () {
    test('Should [return Secp256k1KeyPair] constructed from seed bytes', () {
      // Arrange
      Uint8List actualSeedBytes = Uint8List.fromList(base64Decode('vOpcfoyicjfmT27GUbfAZpelsKZzF4RVQnbulaDkAcx9/De0WH3T0xJntB9Aywcs1AVvk5iCFHxOHfyNuATRJQ=='));

      // Act
      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair.fromSeed(actualSeedBytes);

      // Assert
      Secp256k1KeyPair expectedSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('UNH2aBl1uMkP+S/i5vZVK8tC2uODdICFW0hrpY8Zrbk='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('15864759622800253937020257025334897817812874204769186060960403729801414344643'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
              y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
              z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualSecp256k1KeyPair, expectedSecp256k1KeyPair);
    });
  });

  group('Tests of Secp256k1KeyPair.derive() constructor', () {
    test("Should [return Secp256k1KeyPair] constructed from seed bytes and derivation path (m/44'/)", () {
      // Arrange
      Uint8List actualSeedBytes = Uint8List.fromList(base64Decode('vOpcfoyicjfmT27GUbfAZpelsKZzF4RVQnbulaDkAcx9/De0WH3T0xJntB9Aywcs1AVvk5iCFHxOHfyNuATRJQ=='));

      // Act
      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair.derive(actualSeedBytes, DerivationPath.parse("m/44'/"));

      // Assert
      Secp256k1KeyPair expectedSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('yvHaq6DAH1Kx1ytJxCbrpHnFZqBwe1FSVgM9l8enEw0='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('36375768703071903833290300339884378598912061906937805854924051497712124175743'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('74688234774356072803160835637486106848088540402632048283605672282533519773473'),
              y: BigInt.parse('29899734307341172494508787517139089066830131807139573684866257408293639053697'),
              z: BigInt.parse('58664740637174762933372407544137448664140185099333880581796730022195577346082'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualSecp256k1KeyPair, expectedSecp256k1KeyPair);
    });

    test("Should [return Secp256k1KeyPair] constructed from seed bytes and derivation path (m/44'/60'/)", () {
      // Arrange
      Uint8List actualSeedBytes = Uint8List.fromList(base64Decode('vOpcfoyicjfmT27GUbfAZpelsKZzF4RVQnbulaDkAcx9/De0WH3T0xJntB9Aywcs1AVvk5iCFHxOHfyNuATRJQ=='));

      // Act
      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair.derive(actualSeedBytes, DerivationPath.parse("m/44'/60'/"));

      // Assert
      Secp256k1KeyPair expectedSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('Y1E4i7TRX/op+0NLYam451skbuWKv28HIPslXqmqnG0='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('59966838747635183457735317790867089999353068256181760191721241031077299842948'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('108672368713256470994027581914488088244240652922440096572047431891835640643274'),
              y: BigInt.parse('104213857633386149774299360146104878475349794516935283393988183585614540168186'),
              z: BigInt.parse('37886220751952040869737060661944198399385159178681477731945457642902841530058'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualSecp256k1KeyPair, expectedSecp256k1KeyPair);
    });

    test("Should [return Secp256k1KeyPair] constructed from seed bytes and derivation path (m/44'/60'/0'/)", () {
      // Arrange
      Uint8List actualSeedBytes = Uint8List.fromList(base64Decode('vOpcfoyicjfmT27GUbfAZpelsKZzF4RVQnbulaDkAcx9/De0WH3T0xJntB9Aywcs1AVvk5iCFHxOHfyNuATRJQ=='));

      // Act
      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair.derive(actualSeedBytes, DerivationPath.parse("m/44'/60'/0'/"));

      // Assert
      Secp256k1KeyPair expectedSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('2Df9wvJMRkru1D/lqNCUIXhz/Vt+mkvzi9seYTSDizo='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('22462628459541239325260850920661093360005692756455176829639917594990638518594'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('81319019332320932433362828097302459572337478806236825399943010153005451037063'),
              y: BigInt.parse('63794373195066146887165912086276777534613881904622197777320299150546876896696'),
              z: BigInt.parse('25467929105773129418133646961698452503881743623998816965087828687771580185942'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualSecp256k1KeyPair, expectedSecp256k1KeyPair);
    });

    test("Should [return Secp256k1KeyPair] constructed from seed bytes and derivation path (m/44'/60'/0'/0/)", () {
      // Arrange
      Uint8List actualSeedBytes = Uint8List.fromList(base64Decode('vOpcfoyicjfmT27GUbfAZpelsKZzF4RVQnbulaDkAcx9/De0WH3T0xJntB9Aywcs1AVvk5iCFHxOHfyNuATRJQ=='));

      // Act
      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair.derive(actualSeedBytes, DerivationPath.parse("m/44'/60'/0'/0/"));

      // Assert
      Secp256k1KeyPair expectedSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('LcDHXkSn1EeaHTzVaNz1JkqoCYPeisGdXdAnuZRqoos='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('32405037406619257169020806751869005626609128200264942186906557925837934492411'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('69406173139425403727316018333460102697786066817923442037454361190346029769205'),
              y: BigInt.parse('113747115353909612735949161868128743593808411813989592834014876189137228540013'),
              z: BigInt.parse('90240975878409711996113703710395236480303039823237849025490815322950271364197'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualSecp256k1KeyPair, expectedSecp256k1KeyPair);
    });

    test("Should [return Secp256k1KeyPair] constructed from seed bytes and derivation path (m/44'/60'/0'/0/0)", () {
      // Arrange
      Uint8List actualSeedBytes = Uint8List.fromList(base64Decode('vOpcfoyicjfmT27GUbfAZpelsKZzF4RVQnbulaDkAcx9/De0WH3T0xJntB9Aywcs1AVvk5iCFHxOHfyNuATRJQ=='));

      // Act
      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair.derive(actualSeedBytes, DerivationPath.parse("m/44'/60'/0'/0/0"));

      // Assert
      Secp256k1KeyPair expectedSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('3Nc496KeA9MB45aJEvETVaTO3rV5+IJFm+0AvDvMqKM='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('42625087287231649916876391806832680744898456408978697066855170398773879465729'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('7225178390714844635669807002794796636799440710451703015973305285090780161876'),
              y: BigInt.parse('68333252361951790013656803372927170439449722831214808006235100331979553372493'),
              z: BigInt.parse('47351100067562191804252832311916141486584967477873992121089993895899337549817'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualSecp256k1KeyPair, expectedSecp256k1KeyPair);
    });

    test("Should [return Secp256k1KeyPair] constructed from seed bytes and derivation path (m/44'/60'/0'/0/1)", () {
      // Arrange
      Uint8List actualSeedBytes = Uint8List.fromList(base64Decode('vOpcfoyicjfmT27GUbfAZpelsKZzF4RVQnbulaDkAcx9/De0WH3T0xJntB9Aywcs1AVvk5iCFHxOHfyNuATRJQ=='));

      // Act
      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair.derive(actualSeedBytes, DerivationPath.parse("m/44'/60'/0'/0/1"));

      // Assert
      Secp256k1KeyPair expectedSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('znt9zxIhEIwNcbCgvHyKmnkn+Jj5NXDjhsV/sCx1IFM='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('82879626032458563147801090670605979689983111889352406768424493826293886365473'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('112660828676629577966707117754281647176712908715660659892442173851290278739613'),
              y: BigInt.parse('16311829185915820381492804766921076197135792706285131420874486139658299278403'),
              z: BigInt.parse('27236590126955446289339796455648297156556079156841816312454810395243212447157'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualSecp256k1KeyPair, expectedSecp256k1KeyPair);
    });
  });

  group('Tests of Secp256k1KeyPair.privateKey getter', () {
    test('Should [return Secp256k1PrivateKey] from Secp256k1KeyPair', () {
      // Arrange
      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('3Nc496KeA9MB45aJEvETVaTO3rV5+IJFm+0AvDvMqKM='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('42625087287231649916876391806832680744898456408978697066855170398773879465729'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('7225178390714844635669807002794796636799440710451703015973305285090780161876'),
              y: BigInt.parse('68333252361951790013656803372927170439449722831214808006235100331979553372493'),
              z: BigInt.parse('47351100067562191804252832311916141486584967477873992121089993895899337549817'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      // Act
      Secp256k1PrivateKey actualSecp256k1PrivateKey = actualSecp256k1KeyPair.privateKey;

      // Assert
      Secp256k1PrivateKey expectedSecp256k1PrivateKey = Secp256k1PrivateKey(
        chainCodeBytes: base64Decode('3Nc496KeA9MB45aJEvETVaTO3rV5+IJFm+0AvDvMqKM='),
        ecdsaPrivateKey: ECDSAPrivateKey(
          Curves.generatorSecp256k1,
          BigInt.parse('42625087287231649916876391806832680744898456408978697066855170398773879465729'),
        ),
      );

      expect(actualSecp256k1PrivateKey, expectedSecp256k1PrivateKey);
    });
  });

  group('Tests of Secp256k1KeyPair.publicKey getter', () {
    test('Should [return Secp256k1PublicKey] from Secp256k1KeyPair', () {
      // Arrange
      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('3Nc496KeA9MB45aJEvETVaTO3rV5+IJFm+0AvDvMqKM='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('42625087287231649916876391806832680744898456408978697066855170398773879465729'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('7225178390714844635669807002794796636799440710451703015973305285090780161876'),
              y: BigInt.parse('68333252361951790013656803372927170439449722831214808006235100331979553372493'),
              z: BigInt.parse('47351100067562191804252832311916141486584967477873992121089993895899337549817'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      // Act
      Secp256k1PublicKey actualSecp256k1PublicKey = actualSecp256k1KeyPair.publicKey;

      // Assert
      Secp256k1PublicKey expectedSecp256k1PublicKey = Secp256k1PublicKey(
        ecdsaPublicKey: ECDSAPublicKey(
          Curves.generatorSecp256k1,
          ECPoint(
            x: BigInt.parse('7225178390714844635669807002794796636799440710451703015973305285090780161876'),
            y: BigInt.parse('68333252361951790013656803372927170439449722831214808006235100331979553372493'),
            z: BigInt.parse('47351100067562191804252832311916141486584967477873992121089993895899337549817'),
            n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
            curve: Curves.curveSecp256k1,
          ),
        ),
      );

      expect(actualSecp256k1PublicKey, expectedSecp256k1PublicKey);
    });
  });

  group('Tests of Secp256k1KeyPair.buildChildKeyPair() ', () {
    test("Should [return Secp256k1KeyPair] constructed from Secp256k1KeyPair and DerivationPathElement (m/ -> m/44'/)", () {
      // Arrange
      DerivationPathElement actualDerivationPathElement = DerivationPathElement.parse("44'");

      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('UNH2aBl1uMkP+S/i5vZVK8tC2uODdICFW0hrpY8Zrbk='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('15864759622800253937020257025334897817812874204769186060960403729801414344643'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
              y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
              z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      // Act
      Secp256k1KeyPair actualSecp256k1KeyPairChild = actualSecp256k1KeyPair.buildChildKeyPair(actualDerivationPathElement);

      // Assert
      Secp256k1KeyPair expectedSecp256k1KeyPairChild = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('yvHaq6DAH1Kx1ytJxCbrpHnFZqBwe1FSVgM9l8enEw0='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('36375768703071903833290300339884378598912061906937805854924051497712124175743'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('74688234774356072803160835637486106848088540402632048283605672282533519773473'),
              y: BigInt.parse('29899734307341172494508787517139089066830131807139573684866257408293639053697'),
              z: BigInt.parse('58664740637174762933372407544137448664140185099333880581796730022195577346082'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualSecp256k1KeyPairChild, expectedSecp256k1KeyPairChild);
    });

    test("Should [return Secp256k1KeyPair] constructed from Secp256k1KeyPair and DerivationPathElement (m/44'/ -> m/44'/60'/)", () {
      // Arrange
      DerivationPathElement actualDerivationPathElement = DerivationPathElement.parse("60'");

      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('yvHaq6DAH1Kx1ytJxCbrpHnFZqBwe1FSVgM9l8enEw0='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('36375768703071903833290300339884378598912061906937805854924051497712124175743'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('74688234774356072803160835637486106848088540402632048283605672282533519773473'),
              y: BigInt.parse('29899734307341172494508787517139089066830131807139573684866257408293639053697'),
              z: BigInt.parse('58664740637174762933372407544137448664140185099333880581796730022195577346082'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      // Act
      Secp256k1KeyPair actualSecp256k1KeyPairChild = actualSecp256k1KeyPair.buildChildKeyPair(actualDerivationPathElement);

      // Assert
      Secp256k1KeyPair expectedSecp256k1KeyPairChild = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('Y1E4i7TRX/op+0NLYam451skbuWKv28HIPslXqmqnG0='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('59966838747635183457735317790867089999353068256181760191721241031077299842948'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('108672368713256470994027581914488088244240652922440096572047431891835640643274'),
              y: BigInt.parse('104213857633386149774299360146104878475349794516935283393988183585614540168186'),
              z: BigInt.parse('37886220751952040869737060661944198399385159178681477731945457642902841530058'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualSecp256k1KeyPairChild, expectedSecp256k1KeyPairChild);
    });

    test("Should [return Secp256k1KeyPair] constructed from Secp256k1KeyPair and DerivationPathElement (m/44'/60'/ -> m/44'/60'/0'/)", () {
      // Arrange
      DerivationPathElement actualDerivationPathElement = DerivationPathElement.parse("0'");

      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('Y1E4i7TRX/op+0NLYam451skbuWKv28HIPslXqmqnG0='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('59966838747635183457735317790867089999353068256181760191721241031077299842948'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('108672368713256470994027581914488088244240652922440096572047431891835640643274'),
              y: BigInt.parse('104213857633386149774299360146104878475349794516935283393988183585614540168186'),
              z: BigInt.parse('37886220751952040869737060661944198399385159178681477731945457642902841530058'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      // Act
      Secp256k1KeyPair actualSecp256k1KeyPairChild = actualSecp256k1KeyPair.buildChildKeyPair(actualDerivationPathElement);

      // Assert
      Secp256k1KeyPair expectedSecp256k1KeyPairChild = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('2Df9wvJMRkru1D/lqNCUIXhz/Vt+mkvzi9seYTSDizo='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('22462628459541239325260850920661093360005692756455176829639917594990638518594'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('81319019332320932433362828097302459572337478806236825399943010153005451037063'),
              y: BigInt.parse('63794373195066146887165912086276777534613881904622197777320299150546876896696'),
              z: BigInt.parse('25467929105773129418133646961698452503881743623998816965087828687771580185942'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualSecp256k1KeyPairChild, expectedSecp256k1KeyPairChild);
    });

    test("Should [return Secp256k1KeyPair] constructed from Secp256k1KeyPair and DerivationPathElement (m/44'/60'/0'/ -> m/44'/60'/0'/0/)", () {
      // Arrange
      DerivationPathElement actualDerivationPathElement = DerivationPathElement.parse('0');

      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('2Df9wvJMRkru1D/lqNCUIXhz/Vt+mkvzi9seYTSDizo='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('22462628459541239325260850920661093360005692756455176829639917594990638518594'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('81319019332320932433362828097302459572337478806236825399943010153005451037063'),
              y: BigInt.parse('63794373195066146887165912086276777534613881904622197777320299150546876896696'),
              z: BigInt.parse('25467929105773129418133646961698452503881743623998816965087828687771580185942'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      // Act
      Secp256k1KeyPair actualSecp256k1KeyPairChild = actualSecp256k1KeyPair.buildChildKeyPair(actualDerivationPathElement);

      // Assert
      Secp256k1KeyPair expectedSecp256k1KeyPairChild = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('LcDHXkSn1EeaHTzVaNz1JkqoCYPeisGdXdAnuZRqoos='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('32405037406619257169020806751869005626609128200264942186906557925837934492411'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('69406173139425403727316018333460102697786066817923442037454361190346029769205'),
              y: BigInt.parse('113747115353909612735949161868128743593808411813989592834014876189137228540013'),
              z: BigInt.parse('90240975878409711996113703710395236480303039823237849025490815322950271364197'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualSecp256k1KeyPairChild, expectedSecp256k1KeyPairChild);
    });

    test("Should [return Secp256k1KeyPair] constructed from Secp256k1KeyPair and DerivationPathElement (m/44'/60'/0'/0/ -> m/44'/60'/0'/0/0)", () {
      // Arrange
      DerivationPathElement actualDerivationPathElement = DerivationPathElement.parse('0');

      Secp256k1KeyPair actualSecp256k1KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('LcDHXkSn1EeaHTzVaNz1JkqoCYPeisGdXdAnuZRqoos='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('32405037406619257169020806751869005626609128200264942186906557925837934492411'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('69406173139425403727316018333460102697786066817923442037454361190346029769205'),
              y: BigInt.parse('113747115353909612735949161868128743593808411813989592834014876189137228540013'),
              z: BigInt.parse('90240975878409711996113703710395236480303039823237849025490815322950271364197'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      // Act
      Secp256k1KeyPair actualSecp256k1KeyPairChild = actualSecp256k1KeyPair.buildChildKeyPair(actualDerivationPathElement);

      // Assert
      Secp256k1KeyPair expectedSecp256k1KeyPairChild = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('3Nc496KeA9MB45aJEvETVaTO3rV5+IJFm+0AvDvMqKM='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('42625087287231649916876391806832680744898456408978697066855170398773879465729'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('7225178390714844635669807002794796636799440710451703015973305285090780161876'),
              y: BigInt.parse('68333252361951790013656803372927170439449722831214808006235100331979553372493'),
              z: BigInt.parse('47351100067562191804252832311916141486584967477873992121089993895899337549817'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualSecp256k1KeyPairChild, expectedSecp256k1KeyPairChild);
    });
  });
}
