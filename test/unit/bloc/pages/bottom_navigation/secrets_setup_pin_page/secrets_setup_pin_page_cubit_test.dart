import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/a_secrets_setup_pin_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/secrets_setup_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_loading_state.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/groups/wallet_group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../../utils/test_utils.dart';

Future<void> main() async {
  initLocator();

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'secrets': <String, dynamic>{
      '04b5440e-e398-4520-9f9b-f0eea2d816e6.snggle': 'BrQcp0cakbIn31EdbLCnfzdlUQfwXPj/w7uVoHB6hxkP/SA6Q2vhXQuBJ+TLASlz6FFHTW4OQCqvjQ19RkO+l8F5LSPkQLQcOyOPAaouuUQ8CrbomTzlRr/qz0AoEZB8AyiXvLOghxJoRPPJ6xwux7cTmgSWOKtOPh9sqzJA0dyWVhstI+nfMNnVlXOCgqEMPpwp61xSQ/CvRrFYqht44zJPfWkvBVPd5NBeGd2TtNFBFs9J',
      '04b5440e-e398-4520-9f9b-f0eea2d816e6': <String, dynamic>{
        'kira.snggle': 'lc1b8jyIefNGl5yUkFVnLas6XK5XYBn2Y4hDi1BVBu0wqkxMMRuuwGxdxk9ddMo1wQN+IucZ3qVZzCH9r4jQG8/gbet1JwdiMy4Je21jXrQ/jb8TodNwrZiAroZKsr1LYm7Cwh2tSP0zHY9h6Qe5zSeDHNXKtPFYPD0HNcKJ1TIyX+OdOoF7wJGCqGwMW785jDb+HWmZAtLYUeRqZLE6L4pxeGRMU2JcjzrSx6swEhfN2CrvPHnUtrcei+RTfb5+vX2R88zIjTqXaLvn1HIv6RDM1netGRzH/Wt8s5MuGTzF/dwyiAzQFAm3LpdtuPHivnoyCBhomSaqOK0YZ8EBfWbfV81jRLF/mIN1fBJvza4Wf9HO',
        'kira': <String, dynamic>{
          '4e66ba36-966e-49ed-b639-191388ce38de.snggle': 'AXRN5EO2mnHdhasGFuMNn+TkfJsytY+wNMCWsejh2Xy4gPwKBdDH/h7+OmMuK05GsLR9jO8dXGt4FpfpAX1okYMsgJW2HiONc27mokH3xFo2yAN8LP/z0fyLwV65ST/3NpENZ/1P+yVuVhBCy//91ZMzR1rjtZRvMROvml1WophQ4eCvKrfB/XIZJ4HK97wsUgc+dNppy1tW7r7PY/zIb8EuLqhfIgdXosbENVmOAWgylQdN',
          '3e7f3547-d78f-4dda-a916-3e9eabd4bfee.snggle': 'UAT9B0YwJ1bjxMeO1mXBB8P8qak1a4oxsiXpu2M773eZkqTcHMMl+O7kE2Icshxleb5NW0g0YX/w1fcxbNuoPevOOdhsUZcCemLqZn31P/ElcwxBiS0Cz0Cg9YdG9Tk/PUlC7Lu5rtaYvvtlJ8YAC3Csn5jvJD11+NNe/iSiRkCJBa6xjCbWl1MITQpCPstBzHC38qotIQGHdUN4zXZ8YdDMH9nlZreX2/0Q71KKV4T3A0pr',
        },
        'ethereum.snggle': 'lc1b8jyIefNGl5yUkFVnLas6XK5XYBn2Y4hDi1BVBu0wqkxMMRuuwGxdxk9ddMo1wQN+IucZ3qVZzCH9r4jQG8/gbet1JwdiMy4Je21jXrQ/jb8TodNwrZiAroZKsr1LYm7Cwh2tSP0zHY9h6Qe5zSeDHNXKtPFYPD0HNcKJ1TIyX+OdOoF7wJGCqGwMW785jDb+HWmZAtLYUeRqZLE6L4pxeGRMU2JcjzrSx6swEhfN2CrvPHnUtrcei+RTfb5+vX2R88zIjTqXaLvn1HIv6RDM1netGRzH/Wt8s5MuGTzF/dwyiAzQFAm3LpdtuPHivnoyCBhomSaqOK0YZ8EBfWbfV81jRLF/mIN1fBJvza4Wf9HO',
        'ethereum': <String, dynamic>{
          '4d02947e-c838-4a77-bef3-0ffbdb1c7525.snggle': 'R27kuBRqPzz8H+Wv4mMrJIms+O4BP75Q3bW5tDBJ8xcyOH4Wg+yu5sou+g6Zr61qRhBndPFsOj/JRKtxgs6lDT7mdsrlNdjN8MxFoUaGWUzII5tsmBZ7jeGxsUb9xxn+WSukrg3o2gEkJ2lm1e0O86qrHslTAO7Q8iMPrzlHanxoJxu8Y6uMsfGLlo2F9L3NzjyQHBjLurC0uracTsAFikkjCiCDb7GdHHlnQ9oDPUt01Mgr',
          'ef63ccfc-c3da-4212-9dc1-693a9e75e90b.snggle': '1qWOLzU0uvfdx+gpsQJZ+GyFc0q3azKRNT32FLoDxZO2DVsJBdIW9VbAHYAsvsVDK395KN8gFriYgA6XFeXIEzJLNEMqZnYkns2FRL1ZIcvEXQE4+rsJFUyX+f4k7aN3wiGq7Hnh7fYIg5eecgGUWYBFgEGFWMfBpevmqtjXQg8E2HDhlI7Euf/WInZ90pshKUIqYAApKkOuuf5FouEJFZP73D7ZprkE28MPlRKsiK06sSZo'
        }
      },
    },
  };

  Map<String, String> filledWalletsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    DatabaseParentKey.vaults.name:'L27Zi2cdyeFRM8YkfmUrOjQfp4VXBZ0hQyY+UolOfqxRKgAoEMLa739ozOibvsFVo8gfOhraL3bv4Qcv9ZWnmONA2myFVvkKsTwG7pkacbcN3epQ9lgQgrbsXmqKx4PI+pWpK3pTdHWVLIJx+rQ68/0lxQ5jGbLe2OcM7CUYxkTjmmb2/JTwzVLV49AlY+fb0o/+X5VVtUdMdsH/+6IxOwwsKuiqQHNdlTZGnVKPyca4UF7dWDP2kLbaVBdAC1basI3v/wDJZlr2TDunPHZNTeUhvNtLIKKT0UGpmqG6wzmswKSnIoLVrg9RKOuy02bkFFQNaBDF5ei4GCqD8aprgjqYKvmNf+xzwtYju0dTvi+NKu1OjCbG8c1xc/YTAQwfQsaXEg==',
    DatabaseParentKey.wallets.name:'QcUeC0TCDvlT/uRNmrFa8UCQbxu2OEuecsMqzkN/fdaomiZbD2OnM7c1UKMLZJIppQ6LEYAhQIghucx16LeugwHyXleNGNWxfmx3E5ykHAor5RknH9S1N8XLJ9OMvDdysruOAQGCb3ksl4T82MoPf+qXthDeioj22STrFAbgCYvMXvr5Fv9hIeeRkS/yQIqAYkcOioQ6jVReseY+YldMsStZuQJ7Uvvj4nEJ0c1bEBy6Xlwptu7vtxp1JflAEF/Eqob046Dr5S0wI/vZiWaogn6eQ9tc6hiWxDJEtp8kADUYvYkQwAZtZgw4s0mMoqWYUiiNZJ1nFv/0WYySZmoiZ0yzTn1/sck+dCMzcR8Yucq3UEKPlOnIXOOSbjQBDrNRO4lU1evmNpU2iyO1Pk0U/HYt3PZfxORwuY17FmyPfRVSGQDJRh9TcMDNjoiXLrAL3CB7JhIOPu+9sERlAgRLntf42WM2/+d4gwI+V6MCceXFXA8RcfRCt4qet/B3rXNz8ufemBmHWzznQwVnRqzu6kflMPy/4lIq9dJkNS3GsDEbjlfQeO/X8kVzHTRf2AfABQw+uvuH4y/ld0KhMiWmEsmRyqjTTi6+/o0tv9cdbSuD11Ir5VOTS+39i/9ZsDk9NafDBjZ37Q/oSIUGS0cPWD8Tw1BRFtBrE7amD7MuAwZ2T/efrYWGtnSFzTLjsT4MS6chcOM8lEAH4xLj/xj1OKrRQD9iub3ifMJLPOvTVtIbx1eG7MtC3scPZVkqyz/gGqwy8qh/aD1InQtrpxrDJ5XyNQ0vu299vdWgeNGVcXEKrf2Bnkl9x16IiXc4Bw9twFHhVUF4P3HeJnnJeQwHUFHSWw2KzRs0dR3g+y55bh2YFOUQ6LxtbaSZ2Suo9KURyMSZ+sLOSWpha2aKdJhiy2I3DZG517Wfgqs5DJ3SkBCv/2akuJ2bQoly7iRnUJno4EYSMYM6KjeP6x1xPaMerrPeD5BFQlA5B+zo2m5+ETfclB/bNo6KfK//INzhceJGK0LPGTJTkYhKv1QHeFWSVS75tzzkOeF8m6KzZ6Mkig2UqOs2Eg5JFhS7iy/Ske7/BAOf9q8r/tcgXLX+UtbEP6ON2wiNrMySgu0mOLKiKz789/WOmN90pDxhQdre0wPzM9gA6qgkrPYxxNegP56APM/ShgWrZ/i3ix6cUj/zFsqIBfHr9CnLbHZrrwmcTTlesHqi40GR0qIqrqXlc9WUffpzDHZxP9tiMeEjMnc4g1s/5fJmWYk79nUN+KFpGXSibq4xLYdz3nUmiOpoYb+Z1BdfAGkGr6ejp310fV4GXMk09laKCA7wUjaMJ+ppyUuTC5BSwXEfV48L2C7zSJlE8R9LmPFAEWaErH6wiuVrmjtVG6EZfoM9SDZ5qlcql7pfrBg36f1FavnFwPGruxXXAZTpORyIAMSXsC2kFNBEFoZScyzn2pvRzv+43Et+owCs9gLEgHaYrXt8uoX761TIqLWpuzVnWmUCu5RwSoXoQ62OO8uF6k1WZ1vI3ucACIrjvnmQ7Q==',
    DatabaseParentKey.walletGroups.name:'bML+d2UMGgMUiLyntJ6i3EFve8PIcXXzGlgeWUleS7rY4jtC6jnq1emIOcQD9JCcToGUlj1FG+xvcpWW5bL0AgbqTMBHxGNqOHA2SW/flyqfH9rMr1REEBVnsQrtFehx66RgPehQtl/UhjI5UUyEG26KLa50+iJJV9JFTz8QwUWvGnUozo/SxXtrlQtfV91RAmb13JA4m6X5eGg7YKxwzbNYV56Srp0Eu1XtnHk6wOITiesKIBkWgZn+LlB396QEg+/Vdh4fIts5uGnI6gI2GuYiCiAz+n6bLLExfGs3dlEtN/SA45VhIi+fPG8h77pbtTddbisZusq703e0mkzPPZ4oGqkE8nUXiOcHHkHySB5fDAgyr1iemJERh1VwxN0ax+gLoopEZpFzGHQPlrkSC3I8gGIrKT4HKy+Ds013BT363rf9',
  };
  // @formatter:on

  WalletGroupModel actualWalletGroupModel = WalletGroupModel(
    id: 'ethereum',
    name: 'Ethereum',
    pinnedBool: true,
    parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
  );

  late String testSessionUUID;
  late SecretsSetupPinPageCubit actualSecretsSetupPinPageCubit;

  group('Tests of [SecretsSetupPinPageCubit]', () {
    group('Tests of a successful password setting process', () {
      setUpAll(() {
        testSessionUUID = const Uuid().v4();
        TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);

        FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

        EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
          rootDirectory: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
          databaseParentKey: DatabaseParentKey.secrets,
        );

        SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);
        SecretsService actualSecretsService = SecretsService(secretsRepository: actualSecretsRepository);

        actualSecretsSetupPinPageCubit = SecretsSetupPinPageCubit(
          containerModels: <AContainerModel>[actualWalletGroupModel],
          secretsService: actualSecretsService,
        );
      });

      test('Should [emit SecretsSetupPinPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState.empty();

        expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
      });

      test('Should [emit SecretsSetupPinPageEnterPinState] with [FILLED basePinNumbers]', () async {
        // Act
        actualSecretsSetupPinPageCubit.updateBasePin(const <int>[1, 1, 1, 1]);

        // Assert
        ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState(basePinNumbers: <int>[1, 1, 1, 1]);

        expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
      });

      test('Should [emit SecretsSetupPinPageConfirmPinState] with [FILLED basePinNumbers] and [EMPTY confirmPinNumbers]', () async {
        // Act
        actualSecretsSetupPinPageCubit.setupBasePin();

        // Assert
        ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageConfirmPinState(
          basePinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[],
        );

        expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
      });

      test('Should [emit SecretsSetupPinPageConfirmPinState] with [FILLED basePinNumbers] and [FILLED confirmPinNumbers]', () async {
        // Act
        actualSecretsSetupPinPageCubit.updateConfirmPin(<int>[1, 1, 1, 1]);

        // Assert
        ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageConfirmPinState(
          basePinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[1, 1, 1, 1],
        );

        expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
      });

      test('Should [emit SecretsSetupPinPageLoadingState]', () async {
        // Act
        await actualSecretsSetupPinPageCubit.setupConfirmPin();

        // Assert
        ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageLoadingState();

        expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
      });
    });

    group('Tests of a password setting process with wrong confirm password provided', () {
      setUpAll(() {
        testSessionUUID = const Uuid().v4();
        TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);

        FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

        EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
          rootDirectory: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
          databaseParentKey: DatabaseParentKey.secrets,
        );

        SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);
        SecretsService actualSecretsService = SecretsService(secretsRepository: actualSecretsRepository);

        actualSecretsSetupPinPageCubit = SecretsSetupPinPageCubit(
          containerModels: <AContainerModel>[actualWalletGroupModel],
          secretsService: actualSecretsService,
        );
      });

      test('Should [emit SecretsSetupPinPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState.empty();

        expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
      });

      test('Should [emit SecretsSetupPinPageEnterPinState] with [FILLED basePinNumbers]', () async {
        // Act
        actualSecretsSetupPinPageCubit.updateBasePin(const <int>[1, 1, 1, 1]);

        // Assert
        ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState(basePinNumbers: <int>[1, 1, 1, 1]);

        expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
      });

      test('Should [emit SecretsSetupPinPageConfirmPinState] with [FILLED basePinNumbers] and [EMPTY confirmPinNumbers]', () async {
        // Act
        actualSecretsSetupPinPageCubit.setupBasePin();

        // Assert
        ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageConfirmPinState(
          basePinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[],
        );

        expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
      });

      test('Should [emit SecretsSetupPinPageConfirmPinState] with [FILLED basePinNumbers] and [FILLED confirmPinNumbers]', () async {
        // Act
        actualSecretsSetupPinPageCubit.updateConfirmPin(<int>[9, 9, 9, 9]);

        // Assert
        ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageConfirmPinState(
          basePinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[9, 9, 9, 9],
        );

        expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
      });

      test('Should [throw InvalidPasswordException] and [emit SecretsSetupPinPageInvalidPinState] if provided [password INVALID]', () async {
        try {
          // Act
          await actualSecretsSetupPinPageCubit.setupConfirmPin();
        } catch (actualException) {
          // Assert
          ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageInvalidPinState(
            basePinNumbers: <int>[1, 1, 1, 1],
            confirmPinNumbers: <int>[9, 9, 9, 9],
          );

          expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
          expect(actualException, isA<InvalidPasswordException>());
        }
      });

      test('Should [emit SecretsSetupPinPageEnterPinState] with [EMPTY pinNumbers] after resetting', () async {
        // Act
        actualSecretsSetupPinPageCubit.resetToBasePin();

        // Assert
        ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState.empty();

        expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
      });
    });
  });

  tearDownAll(() {
    TestUtils.testRootDirectory.delete(recursive: true);
  });
}
